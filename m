Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaGUMr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:47:58 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:57726 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbaGUMr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:47:57 -0400
Message-ID: <53CD0BD4.4050007@gmail.com>
Date: Mon, 21 Jul 2014 20:47:16 +0800
From: pp <mnipxh@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: jslaby@suse.cz, gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
        xinhuix.pan@intel.com
Subject: [PATCH] tty/tty_io.c: make a check before reuse cdev
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reuse the cdev may cause panic. After we unregister the tty device, we may use tty_hangup() o
other similar function to send a signal(SIGHUP) to process which has opend our device. But that
not succeed if the process couldn't get the signal. for example, a process forked
but his parent quited never get SIGHUP.

Here is our scence.
tty driver register its device and init the cdevs, then process "A" open one cdev.
tty driver unregister its device and cdev_del the cdevs, call tty_hangup to (S)send signal SIGHUP to process A.
But that step(S) fails.
tty driver register its device and (D)init the cdevs again.
What will happen is that when process "A" close the cdev, cd_forget() get panic as there is list_del_init(&inode->i_devices);
When we init the cdevs in step(D), the list head was initialized by INIT_LIST_HEAD(&cdev->list);
So check the kobj ref-count before init cdev, and use a bool array to detect if it's ok to unregister the cvdes.
Because most tty driver don't check the ret code of tty_register_device(). and they may still call tty_unregister_device().

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
---
 drivers/tty/tty_io.c       |   17 +++++++++++++++--
 include/linux/tty_driver.h |    1 +
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3411071..7e79281 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -3080,6 +3080,10 @@ struct class *tty_class;
 static int tty_cdev_add(struct tty_driver *driver, dev_t dev,
 		unsigned int index, unsigned int count)
 {
+	if (atomic_read(&driver->cdevs[index].kobj.kref.refcount)) {
+		WARN(1, "init a still in-used cdev!");
+		return -EBUSY;
+	}
 	/* init here, since reused cdevs cause crashes */
 	cdev_init(&driver->cdevs[index], &tty_fops);
 	driver->cdevs[index].owner = driver->owner;
@@ -3185,12 +3189,15 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 	if (retval)
 		goto error;
 
+	driver->cdevsb[index] = 1;
 	return dev;
 
 error:
 	put_device(dev);
 	if (cdev)
 		cdev_del(&driver->cdevs[index]);
+
+	driver->cdevsb[index] = 0;
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(tty_register_device_attr);
@@ -3208,6 +3215,8 @@ EXPORT_SYMBOL_GPL(tty_register_device_attr);
 
 void tty_unregister_device(struct tty_driver *driver, unsigned index)
 {
+	if (driver->cdevsb[index] == 0)
+		return;
 	device_destroy(tty_class,
 		MKDEV(driver->major, driver->minor_start) + index);
 	if (!(driver->flags & TTY_DRIVER_DYNAMIC_ALLOC))
@@ -3265,14 +3274,17 @@ struct tty_driver *__tty_alloc_driver(unsigned int lines, struct module *owner,
 		cdevs = lines;
 	}
 
-	driver->cdevs = kcalloc(cdevs, sizeof(*driver->cdevs), GFP_KERNEL);
-	if (!driver->cdevs) {
+	driver->cdevs  = kcalloc(cdevs, sizeof(*driver->cdevs), GFP_KERNEL);
+	driver->cdevsb = kcalloc(cdevs, sizeof(bool), GFP_KERNEL);
+	if (!driver->cdevs || !driver->cdevsb) {
 		err = -ENOMEM;
 		goto err_free_all;
 	}
 
 	return driver;
 err_free_all:
+	kfree(driver->cdevs);
+	kfree(driver->cdevsb);
 	kfree(driver->ports);
 	kfree(driver->ttys);
 	kfree(driver->termios);
@@ -3307,6 +3319,7 @@ static void destruct_tty_driver(struct kref *kref)
 			cdev_del(&driver->cdevs[0]);
 	}
 	kfree(driver->cdevs);
+	kfree(driver->cdevsb);
 	kfree(driver->ports);
 	kfree(driver->termios);
 	kfree(driver->ttys);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 756a609..7294f1b 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -291,6 +291,7 @@ struct tty_driver {
 	int	magic;		/* magic number for this structure */
 	struct kref kref;	/* Reference management */
 	struct cdev *cdevs;
+	bool	*cdevsb;
 	struct module	*owner;
 	const char	*driver_name;
 	const char	*name;
-- 
1.7.9.5

