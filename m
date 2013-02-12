Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3BLC7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 21:59:11 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:40650 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3BLC7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 21:59:09 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, rusty@rustcorp.com.au,
        hpa@linux.intel.com, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, grant.likely@secretlab.ca, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, akpm@linux-foundation.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH v2] driver core: add wait event for deferred probe
Date: Tue, 12 Feb 2013 10:58:35 +0800
Message-Id: <1360637915-11212-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_initcalls() could call all driver initialization code in kernel_init
thread. It means that probe() function will be also called from that
time. After this, kernel could access console & release __init section
in the same thread.

But if device probe fails and moves into deferred probe list, a new
thread is created to reinvoke probe. If the device is serial console,
kernel has to open console failure & release __init section before
reinvoking failure. Because there's no synchronization mechanism.
Now add wait event to synchronize after do_initcalls().

Changelog:
v2: add comments on wait_for_device_probe().

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 drivers/base/dd.c |    8 +++++---
 init/main.c       |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 65631015..23db672 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -53,6 +53,9 @@ static LIST_HEAD(deferred_probe_pending_list);
 static LIST_HEAD(deferred_probe_active_list);
 static struct workqueue_struct *deferred_wq;
 
+static atomic_t probe_count = ATOMIC_INIT(0);
+static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
+
 /**
  * deferred_probe_work_func() - Retry probing devices in the active list.
  */
@@ -77,6 +80,7 @@ static void deferred_probe_work_func(struct work_struct *work)
 		private = list_first_entry(&deferred_probe_active_list,
 					typeof(*dev->p), deferred_probe);
 		dev = private->device;
+		atomic_dec(&probe_count);
 		list_del_init(&private->deferred_probe);
 
 		get_device(dev);
@@ -257,9 +261,6 @@ int device_bind_driver(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_bind_driver);
 
-static atomic_t probe_count = ATOMIC_INIT(0);
-static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
-
 static int really_probe(struct device *dev, struct device_driver *drv)
 {
 	int ret = 0;
@@ -308,6 +309,7 @@ probe_failed:
 		/* Driver requested deferred probing */
 		dev_info(dev, "Driver %s requests probe deferral\n", drv->name);
 		driver_deferred_probe_add(dev);
+		atomic_inc(&probe_count);
 	} else if (ret != -ENODEV && ret != -ENXIO) {
 		/* driver matched but the probe failed */
 		printk(KERN_WARNING
diff --git a/init/main.c b/init/main.c
index 63534a1..141a6a4 100644
--- a/init/main.c
+++ b/init/main.c
@@ -786,6 +786,8 @@ static void __init do_basic_setup(void)
 	do_ctors();
 	usermodehelper_enable();
 	do_initcalls();
+	/* wait all deferred probe finished & prepare to drop __init section */
+	wait_for_device_probe();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
1.7.10.4

