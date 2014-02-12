Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaBLNfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:35:20 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:63003 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaBLNfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:35:14 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 01/11] watchdog: xilinx: Convert driver to the watchdog framework
Date: Wed, 12 Feb 2014 14:34:32 +0100
Message-Id: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392212059.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
In-Reply-To: <cover.1392212059.git.michal.simek@xilinx.com>
References: <cover.1392212059.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-11835-1392212107-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-11835-1392212107-0001

- Remove uneeded headers, fops functions
- Use xilinx_wdt prefix in start/stop/keepalive functions
  and in new structures

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v3: None
Changes in v2: None

 drivers/watchdog/Kconfig         |   1 +
 drivers/watchdog/of_xilinx_wdt.c | 204 ++++++---------------------------------
 2 files changed, 33 insertions(+), 172 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 4c4c566..9db5d3c 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1025,6 +1025,7 @@ config M54xx_WATCHDOG
 config XILINX_WATCHDOG
 	tristate "Xilinx Watchdog timer"
 	depends on MICROBLAZE
+	select WATCHDOG_CORE
 	---help---
 	  Watchdog driver for the xps_timebase_wdt ip core.

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index fb57103..8c2814e 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -1,6 +1,7 @@
 /*
  * Watchdog Device Driver for Xilinx axi/xps_timebase_wdt
  *
+ * (C) Copyright 2013 - 2014 Xilinx, Inc.
  * (C) Copyright 2011 (Alejandro Cabrera <aldaya@gmail.com>)
  *
  * This program is free software; you can redistribute it and/or
@@ -14,13 +15,10 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/miscdevice.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/watchdog.h>
 #include <linux/io.h>
-#include <linux/uaccess.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -48,22 +46,18 @@
 struct xwdt_device {
 	struct resource  res;
 	void __iomem *base;
-	u32 nowayout;
 	u32 wdt_interval;
-	u32 boot_status;
 };

 static struct xwdt_device xdev;

 static  u32 timeout;
 static  u32 control_status_reg;
-static  u8  expect_close;
 static  u8  no_timeout;
-static unsigned long driver_open;

 static  DEFINE_SPINLOCK(spinlock);

-static void xwdt_start(void)
+static int xilinx_wdt_start(struct watchdog_device *wdd)
 {
 	spin_lock(&spinlock);

@@ -77,9 +71,11 @@ static void xwdt_start(void)
 	iowrite32(XWT_CSRX_EWDT2_MASK, xdev.base + XWT_TWCSR1_OFFSET);

 	spin_unlock(&spinlock);
+
+	return 0;
 }

-static void xwdt_stop(void)
+static int xilinx_wdt_stop(struct watchdog_device *wdd)
 {
 	spin_lock(&spinlock);

@@ -92,9 +88,11 @@ static void xwdt_stop(void)

 	spin_unlock(&spinlock);
 	pr_info("Stopped!\n");
+
+	return 0;
 }

-static void xwdt_keepalive(void)
+static int xilinx_wdt_keepalive(struct watchdog_device *wdd)
 {
 	spin_lock(&spinlock);

@@ -103,23 +101,28 @@ static void xwdt_keepalive(void)
 	iowrite32(control_status_reg, xdev.base + XWT_TWCSR0_OFFSET);

 	spin_unlock(&spinlock);
-}

-static void xwdt_get_status(int *status)
-{
-	int new_status;
+	return 0;
+}

-	spin_lock(&spinlock);
+static const struct watchdog_info xilinx_wdt_ident = {
+	.options =  WDIOF_MAGICCLOSE |
+		    WDIOF_KEEPALIVEPING,
+	.firmware_version =	1,
+	.identity =	WATCHDOG_NAME,
+};

-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
-	new_status = ((control_status_reg &
-			(XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK)) != 0);
-	spin_unlock(&spinlock);
+static const struct watchdog_ops xilinx_wdt_ops = {
+	.owner = THIS_MODULE,
+	.start = xilinx_wdt_start,
+	.stop = xilinx_wdt_stop,
+	.ping = xilinx_wdt_keepalive,
+};

-	*status = 0;
-	if (new_status & 1)
-		*status |= WDIOF_CARDRESET;
-}
+static struct watchdog_device xilinx_wdt_wdd = {
+	.info = &xilinx_wdt_ident,
+	.ops = &xilinx_wdt_ops,
+};

 static u32 xwdt_selftest(void)
 {
@@ -146,139 +149,6 @@ static u32 xwdt_selftest(void)
 		return XWT_TIMER_FAILED;
 }

-static int xwdt_open(struct inode *inode, struct file *file)
-{
-	/* Only one process can handle the wdt at a time */
-	if (test_and_set_bit(0, &driver_open))
-		return -EBUSY;
-
-	/* Make sure that the module are always loaded...*/
-	if (xdev.nowayout)
-		__module_get(THIS_MODULE);
-
-	xwdt_start();
-	pr_info("Started...\n");
-
-	return nonseekable_open(inode, file);
-}
-
-static int xwdt_release(struct inode *inode, struct file *file)
-{
-	if (expect_close == 42) {
-		xwdt_stop();
-	} else {
-		pr_crit("Unexpected close, not stopping watchdog!\n");
-		xwdt_keepalive();
-	}
-
-	clear_bit(0, &driver_open);
-	expect_close = 0;
-	return 0;
-}
-
-/*
- *      xwdt_write:
- *      @file: file handle to the watchdog
- *      @buf: buffer to write (unused as data does not matter here
- *      @count: count of bytes
- *      @ppos: pointer to the position to write. No seeks allowed
- *
- *      A write to a watchdog device is defined as a keepalive signal. Any
- *      write of data will do, as we don't define content meaning.
- */
-static ssize_t xwdt_write(struct file *file, const char __user *buf,
-						size_t len, loff_t *ppos)
-{
-	if (len) {
-		if (!xdev.nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, buf + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		xwdt_keepalive();
-	}
-	return len;
-}
-
-static const struct watchdog_info ident = {
-	.options =  WDIOF_MAGICCLOSE |
-		    WDIOF_KEEPALIVEPING,
-	.firmware_version =	1,
-	.identity =	WATCHDOG_NAME,
-};
-
-/*
- *      xwdt_ioctl:
- *      @file: file handle to the device
- *      @cmd: watchdog command
- *      @arg: argument pointer
- *
- *      The watchdog API defines a common set of functions for all watchdogs
- *      according to their available features.
- */
-static long xwdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	int status;
-
-	union {
-		struct watchdog_info __user *ident;
-		int __user *i;
-	} uarg;
-
-	uarg.i = (int __user *)arg;
-
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(uarg.ident, &ident,
-					sizeof(ident)) ? -EFAULT : 0;
-
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(xdev.boot_status, uarg.i);
-
-	case WDIOC_GETSTATUS:
-		xwdt_get_status(&status);
-		return put_user(status, uarg.i);
-
-	case WDIOC_KEEPALIVE:
-		xwdt_keepalive();
-		return 0;
-
-	case WDIOC_GETTIMEOUT:
-		if (no_timeout)
-			return -ENOTTY;
-		else
-			return put_user(timeout, uarg.i);
-
-	default:
-		return -ENOTTY;
-	}
-}
-
-static const struct file_operations xwdt_fops = {
-	.owner      = THIS_MODULE,
-	.llseek     = no_llseek,
-	.write      = xwdt_write,
-	.open       = xwdt_open,
-	.release    = xwdt_release,
-	.unlocked_ioctl = xwdt_ioctl,
-};
-
-static struct miscdevice xwdt_miscdev = {
-	.minor      = WATCHDOG_MINOR,
-	.name       = "watchdog",
-	.fops       = &xwdt_fops,
-};
-
 static int xwdt_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -314,7 +184,7 @@ static int xwdt_probe(struct platform_device *pdev)
 					"xlnx,wdt-enable-once", NULL);
 	if (tmptr == NULL) {
 		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
-		xdev.nowayout = WATCHDOG_NOWAYOUT;
+		watchdog_set_nowayout(&xilinx_wdt_wdd, true);
 	}

 /*
@@ -344,24 +214,14 @@ static int xwdt_probe(struct platform_device *pdev)
 		goto unmap_io;
 	}

-	xwdt_get_status(&xdev.boot_status);
-
-	rc = misc_register(&xwdt_miscdev);
+	rc = watchdog_register_device(&xilinx_wdt_wdd);
 	if (rc) {
-		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
-		       xwdt_miscdev.minor, rc);
+		pr_err("cannot register watchdog (err=%d)\n", rc);
 		goto unmap_io;
 	}

-	if (no_timeout)
-		pr_info("driver loaded (timeout=? sec, nowayout=%d)\n",
-			xdev.nowayout);
-	else
-		pr_info("driver loaded (timeout=%d sec, nowayout=%d)\n",
-			timeout, xdev.nowayout);
-
-	expect_close = 0;
-	clear_bit(0, &driver_open);
+	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds\n",
+		 xdev.base, timeout);

 	return 0;

@@ -375,7 +235,7 @@ err_out:

 static int xwdt_remove(struct platform_device *dev)
 {
-	misc_deregister(&xwdt_miscdev);
+	watchdog_unregister_device(&xilinx_wdt_wdd);
 	iounmap(xdev.base);
 	release_mem_region(xdev.res.start, resource_size(&xdev.res));

--
1.8.2.3


--=_mimegpg-monstr-desktop-11835-1392212107-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL7eIsACgkQykllyylKDCFG9wCcDYazMbqAAPjY7bbNB+gDIwKR
13IAn3SVXpsMnZe7EvY3fmlG2WWO9KCx
=4Ivj
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-11835-1392212107-0001--
