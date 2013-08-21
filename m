Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3HUUYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:24:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35256 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3HUUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:24:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 1/2] w1: remove race with sysfs file creation
Date: Wed, 21 Aug 2013 13:24:32 -0700
Message-Id: <1377116673-31216-1-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W1 slave sysfs files are created _after_ userspace is notified that the
device has been added to the system.  Fix that race by moving the
creation/remove of the files to the bus notifier that is there for doing
this type of thing.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/w1.c | 111 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 38 deletions(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 0459df84..3c798db0 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -587,6 +587,73 @@ end:
 	return err;
 }
 
+/*
+ * Handle sysfs file creation and removal here, before userspace is told that
+ * the device is added / removed from the system
+ */
+static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
+			 void *data)
+{
+	struct device *dev = data;
+	struct w1_slave *sl;
+	int err;
+
+	/*
+	 * Only care about slave devices at the moment.  Yes, we should use a
+	 * separate "type" for this, but for now, look at the release function
+	 * to know which type it is...
+	 */
+	if (dev->release != w1_slave_release)
+		return 0;
+
+	sl = dev_to_w1_slave(dev);
+
+	switch (action) {
+	case BUS_NOTIFY_ADD_DEVICE:
+		/* Create our sysfs files before userspace is told about it */
+		/* Create "name" entry */
+		err = device_create_file(&sl->dev, &w1_slave_attr_name);
+		if (err < 0) {
+			dev_err(&sl->dev,
+				"sysfs file creation for [%s] failed. err=%d\n",
+				dev_name(&sl->dev), err);
+			return err;
+		}
+
+		/* Create "id" entry */
+		err = device_create_file(&sl->dev, &w1_slave_attr_id);
+		if (err < 0) {
+			dev_err(&sl->dev,
+				"sysfs file creation for [%s] failed. err=%d\n",
+				dev_name(&sl->dev), err);
+			return err;
+		}
+
+		/* if the family driver needs to initialize something... */
+		if (sl->family->fops && sl->family->fops->add_slave &&
+		    ((err = sl->family->fops->add_slave(sl)) < 0)) {
+			dev_err(&sl->dev,
+				"sysfs file creation for [%s] failed. err=%d\n",
+				dev_name(&sl->dev), err);
+			return err;
+		}
+
+		break;
+	case BUS_NOTIFY_DEL_DEVICE:
+		/* Remove our sysfs files */
+		if (sl->family->fops && sl->family->fops->remove_slave)
+			sl->family->fops->remove_slave(sl);
+		device_remove_file(&sl->dev, &w1_slave_attr_id);
+		device_remove_file(&sl->dev, &w1_slave_attr_name);
+		break;
+	}
+	return 0;
+}
+
+static struct notifier_block w1_bus_nb = {
+	.notifier_call = w1_bus_notify,
+};
+
 static int __w1_attach_slave_device(struct w1_slave *sl)
 {
 	int err;
@@ -615,44 +682,13 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 		return err;
 	}
 
-	/* Create "name" entry */
-	err = device_create_file(&sl->dev, &w1_slave_attr_name);
-	if (err < 0) {
-		dev_err(&sl->dev,
-			"sysfs file creation for [%s] failed. err=%d\n",
-			dev_name(&sl->dev), err);
-		goto out_unreg;
-	}
-
-	/* Create "id" entry */
-	err = device_create_file(&sl->dev, &w1_slave_attr_id);
-	if (err < 0) {
-		dev_err(&sl->dev,
-			"sysfs file creation for [%s] failed. err=%d\n",
-			dev_name(&sl->dev), err);
-		goto out_rem1;
-	}
 
-	/* if the family driver needs to initialize something... */
-	if (sl->family->fops && sl->family->fops->add_slave &&
-	    ((err = sl->family->fops->add_slave(sl)) < 0)) {
-		dev_err(&sl->dev,
-			"sysfs file creation for [%s] failed. err=%d\n",
-			dev_name(&sl->dev), err);
-		goto out_rem2;
-	}
+	dev_set_uevent_suppress(&sl->dev, false);
+	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);
 
 	list_add_tail(&sl->w1_slave_entry, &sl->master->slist);
 
 	return 0;
-
-out_rem2:
-	device_remove_file(&sl->dev, &w1_slave_attr_id);
-out_rem1:
-	device_remove_file(&sl->dev, &w1_slave_attr_name);
-out_unreg:
-	device_unregister(&sl->dev);
-	return err;
 }
 
 static int w1_attach_slave_device(struct w1_master *dev, struct w1_reg_num *rn)
@@ -723,16 +759,11 @@ void w1_slave_detach(struct w1_slave *sl)
 
 	list_del(&sl->w1_slave_entry);
 
-	if (sl->family->fops && sl->family->fops->remove_slave)
-		sl->family->fops->remove_slave(sl);
-
 	memset(&msg, 0, sizeof(msg));
 	memcpy(msg.id.id, &sl->reg_num, sizeof(msg.id));
 	msg.type = W1_SLAVE_REMOVE;
 	w1_netlink_send(sl->master, &msg);
 
-	device_remove_file(&sl->dev, &w1_slave_attr_id);
-	device_remove_file(&sl->dev, &w1_slave_attr_name);
 	device_unregister(&sl->dev);
 
 	wait_for_completion(&sl->released);
@@ -1017,6 +1048,10 @@ static int __init w1_init(void)
 		goto err_out_exit_init;
 	}
 
+	retval = bus_register_notifier(&w1_bus_type, &w1_bus_nb);
+	if (retval)
+		goto err_out_bus_unregister;
+
 	retval = driver_register(&w1_master_driver);
 	if (retval) {
 		printk(KERN_ERR
-- 
1.8.3.rc0.20.gb99dd2e

