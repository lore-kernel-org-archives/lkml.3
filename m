Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3FYQaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:30:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:13953 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYQaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:30:20 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <shigekatsu.tateno@atmel.com>
Subject: [PATCH] staging: ozwpan: Convert printk to dev_dbg()
Date: Tue, 25 Jun 2013 17:30:02 +0100
Message-ID: <1372177802-11360-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert all debug messages from printk to dev_dbg() & add kernel config to
enable/disable these messages during compilation.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/Kbuild    |    2 +-
 drivers/staging/ozwpan/Kconfig   |    9 +++++++++
 drivers/staging/ozwpan/ozcdev.c  |    9 +++++----
 drivers/staging/ozwpan/oztrace.h |    9 +++++----
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ozwpan/Kbuild b/drivers/staging/ozwpan/Kbuild
index 1766a26..35a4278 100644
--- a/drivers/staging/ozwpan/Kbuild
+++ b/drivers/staging/ozwpan/Kbuild
@@ -15,4 +15,4 @@ ozwpan-y := \
 	ozurbparanoia.o \
 	oztrace.o
 
-
+ccflags-$(CONFIG_USB_WPAN_HCD_DEBUG) := -DDEBUG -DWANT_TRACE
diff --git a/drivers/staging/ozwpan/Kconfig b/drivers/staging/ozwpan/Kconfig
index 7904cae..ccee97c 100644
--- a/drivers/staging/ozwpan/Kconfig
+++ b/drivers/staging/ozwpan/Kconfig
@@ -7,3 +7,12 @@ config USB_WPAN_HCD
 
 	  To compile this driver a module, choose M here: the module
 	  will be called "ozwpan".
+
+if USB_WPAN_HCD
+
+config USB_WPAN_HCD_DEBUG
+	boolean "Debug support for USB over WiFi Host Controller"
+	help
+	  Say "yes" to enable debug messages.
+
+endif # USB_WPAN_HCD
diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 374fdc3..2fc944b 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -44,6 +44,7 @@ struct oz_serial_ctx {
  */
 static struct oz_cdev g_cdev;
 static struct class *g_oz_class;
+struct device *g_oz_wpan_dev;
 /*------------------------------------------------------------------------------
  * Context: process and softirq
  */
@@ -334,7 +335,6 @@ static const struct file_operations oz_fops = {
 int oz_cdev_register(void)
 {
 	int err;
-	struct device *dev;
 	memset(&g_cdev, 0, sizeof(g_cdev));
 	err = alloc_chrdev_region(&g_cdev.devnum, 0, 1, "ozwpan");
 	if (err < 0)
@@ -357,10 +357,11 @@ int oz_cdev_register(void)
 		err = PTR_ERR(g_oz_class);
 		goto out1;
 	}
-	dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL, "ozwpan");
-	if (IS_ERR(dev)) {
+	g_oz_wpan_dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL,
+								"ozwpan");
+	if (IS_ERR(g_oz_wpan_dev)) {
 		oz_trace("Failed to create sysfs entry for cdev\n");
-		err = PTR_ERR(dev);
+		err = PTR_ERR(g_oz_wpan_dev);
 		goto out1;
 	}
 	return 0;
diff --git a/drivers/staging/ozwpan/oztrace.h b/drivers/staging/ozwpan/oztrace.h
index 8293b24..8764f37 100644
--- a/drivers/staging/ozwpan/oztrace.h
+++ b/drivers/staging/ozwpan/oztrace.h
@@ -7,14 +7,15 @@
 #define _OZTRACE_H_
 #include "ozconfig.h"
 
-#define TRACE_PREFIX	KERN_ALERT "OZWPAN: "
+extern struct device *g_oz_wpan_dev;
 
 #ifdef WANT_TRACE
-#define oz_trace(...) printk(TRACE_PREFIX __VA_ARGS__)
+#define oz_trace(fmt, ...) dev_dbg(g_oz_wpan_dev, fmt, ##__VA_ARGS__);
 #ifdef WANT_VERBOSE_TRACE
 extern unsigned long trace_flags;
-#define oz_trace2(_flag, ...) \
-	do { if (trace_flags & _flag) printk(TRACE_PREFIX __VA_ARGS__); \
+#define oz_trace2(_flag, fmt, ...) \
+	do { if (trace_flags & _flag) \
+		dev_dbg(g_oz_wpan_dev, fmt, ##__VA_ARGS__); \
 	} while (0)
 #else
 #define oz_trace2(...)
-- 
1.7.9.5

