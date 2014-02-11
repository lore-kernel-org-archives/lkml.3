Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaBKG6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 01:58:34 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36347 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaBKG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 01:56:12 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 05/11] watchdog: xilinx: Allocate private structure per device
Date: Tue, 11 Feb 2014 07:55:48 +0100
Message-Id: <bdd7c2c78dd491d02d1c1ae8a59b92b7a1a17ec6.1392101734.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
In-Reply-To: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
References: <f298edd222c57b0ce1ebad3ae50c3f715406c631.1392101734.git.michal.simek@xilinx.com>
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9527-1392101768-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9527-1392101768-0001

Only one watchdog could be used by this driver.
Create driver private data structure and move there
all variables for one instance.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
---

Changes in v2: None

 drivers/watchdog/of_xilinx_wdt.c | 97 +++++++++++++++++++++++-----------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
index 1f7ad91..d28bd3f 100644
--- a/drivers/watchdog/of_xilinx_wdt.c
+++ b/drivers/watchdog/of_xilinx_wdt.c
@@ -47,30 +47,27 @@
 struct xwdt_device {
 	void __iomem *base;
 	u32 wdt_interval;
+	spinlock_t spinlock;
+	struct watchdog_device xilinx_wdt_wdd;
 };

-static struct xwdt_device xdev;
-
-static  u32 timeout;
-
-static  DEFINE_SPINLOCK(spinlock);
-
 static int xilinx_wdt_start(struct watchdog_device *wdd)
 {
 	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);

-	spin_lock(&spinlock);
+	spin_lock(&xdev->spinlock);

 	/* Clean previous status and enable the watchdog timer */
-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);
 	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);

 	iowrite32((control_status_reg | XWT_CSR0_EWDT1_MASK),
-				xdev.base + XWT_TWCSR0_OFFSET);
+		  xdev->base + XWT_TWCSR0_OFFSET);

-	iowrite32(XWT_CSRX_EWDT2_MASK, xdev.base + XWT_TWCSR1_OFFSET);
+	iowrite32(XWT_CSRX_EWDT2_MASK, xdev->base + XWT_TWCSR1_OFFSET);

-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);

 	return 0;
 }
@@ -78,17 +75,18 @@ static int xilinx_wdt_start(struct watchdog_device *wdd)
 static int xilinx_wdt_stop(struct watchdog_device *wdd)
 {
 	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);

-	spin_lock(&spinlock);
+	spin_lock(&xdev->spinlock);

-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);

 	iowrite32((control_status_reg & ~XWT_CSR0_EWDT1_MASK),
-				xdev.base + XWT_TWCSR0_OFFSET);
+		  xdev->base + XWT_TWCSR0_OFFSET);

-	iowrite32(0, xdev.base + XWT_TWCSR1_OFFSET);
+	iowrite32(0, xdev->base + XWT_TWCSR1_OFFSET);

-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);
 	pr_info("Stopped!\n");

 	return 0;
@@ -97,14 +95,15 @@ static int xilinx_wdt_stop(struct watchdog_device *wdd)
 static int xilinx_wdt_keepalive(struct watchdog_device *wdd)
 {
 	u32 control_status_reg;
+	struct xwdt_device *xdev = watchdog_get_drvdata(wdd);

-	spin_lock(&spinlock);
+	spin_lock(&xdev->spinlock);

-	control_status_reg = ioread32(xdev.base + XWT_TWCSR0_OFFSET);
+	control_status_reg = ioread32(xdev->base + XWT_TWCSR0_OFFSET);
 	control_status_reg |= (XWT_CSR0_WRS_MASK | XWT_CSR0_WDS_MASK);
-	iowrite32(control_status_reg, xdev.base + XWT_TWCSR0_OFFSET);
+	iowrite32(control_status_reg, xdev->base + XWT_TWCSR0_OFFSET);

-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);

 	return 0;
 }
@@ -123,29 +122,24 @@ static const struct watchdog_ops xilinx_wdt_ops = {
 	.ping = xilinx_wdt_keepalive,
 };

-static struct watchdog_device xilinx_wdt_wdd = {
-	.info = &xilinx_wdt_ident,
-	.ops = &xilinx_wdt_ops,
-};
-
-static u32 xwdt_selftest(void)
+static u32 xwdt_selftest(struct xwdt_device *xdev)
 {
 	int i;
 	u32 timer_value1;
 	u32 timer_value2;

-	spin_lock(&spinlock);
+	spin_lock(&xdev->spinlock);

-	timer_value1 = ioread32(xdev.base + XWT_TBR_OFFSET);
-	timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+	timer_value1 = ioread32(xdev->base + XWT_TBR_OFFSET);
+	timer_value2 = ioread32(xdev->base + XWT_TBR_OFFSET);

 	for (i = 0;
 		((i <= XWT_MAX_SELFTEST_LOOP_COUNT) &&
 			(timer_value2 == timer_value1)); i++) {
-		timer_value2 = ioread32(xdev.base + XWT_TBR_OFFSET);
+		timer_value2 = ioread32(xdev->base + XWT_TBR_OFFSET);
 	}

-	spin_unlock(&spinlock);
+	spin_unlock(&xdev->spinlock);

 	if (timer_value2 != timer_value1)
 		return ~XWT_TIMER_FAILED;
@@ -159,12 +153,23 @@ static int xwdt_probe(struct platform_device *pdev)
 	u32 *tmptr;
 	u32 *pfreq;
 	struct resource *res;
+	struct xwdt_device *xdev;
 	bool no_timeout = false;
+	struct watchdog_device *xilinx_wdt_wdd;
+
+	xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
+	if (!xdev)
+		return -ENOMEM;
+
+	xilinx_wdt_wdd = &xdev->xilinx_wdt_wdd;
+	xilinx_wdt_wdd->info = &xilinx_wdt_ident;
+	xilinx_wdt_wdd->ops = &xilinx_wdt_ops;
+	xilinx_wdt_wdd->parent = &pdev->dev;

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	xdev.base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(xdev.base))
-		return PTR_ERR(xdev.base);
+	xdev->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xdev->base))
+		return PTR_ERR(xdev->base);

 	pfreq = (u32 *)of_get_property(pdev->dev.of_node,
 					"clock-frequency", NULL);
@@ -180,14 +185,14 @@ static int xwdt_probe(struct platform_device *pdev)
 		pr_warn("Parameter \"xlnx,wdt-interval\" not found in device tree!\n");
 		no_timeout = true;
 	} else {
-		xdev.wdt_interval = *tmptr;
+		xdev->wdt_interval = *tmptr;
 	}

 	tmptr = (u32 *)of_get_property(pdev->dev.of_node,
 					"xlnx,wdt-enable-once", NULL);
 	if (tmptr == NULL) {
 		pr_warn("Parameter \"xlnx,wdt-enable-once\" not found in device tree!\n");
-		watchdog_set_nowayout(&xilinx_wdt_wdd, true);
+		watchdog_set_nowayout(xilinx_wdt_wdd, true);
 	}

 /*
@@ -195,29 +200,37 @@ static int xwdt_probe(struct platform_device *pdev)
  *  ignored (interrupt), reset is only generated at second wdt overflow
  */
 	if (!no_timeout)
-		timeout = 2 * ((1<<xdev.wdt_interval) / *pfreq);
+		xilinx_wdt_wdd->timeout = 2 * ((1 << xdev->wdt_interval) /
+					  *pfreq);
+
+	spin_lock_init(&xdev->spinlock);
+	watchdog_set_drvdata(xilinx_wdt_wdd, xdev);

-	rc = xwdt_selftest();
+	rc = xwdt_selftest(xdev);
 	if (rc == XWT_TIMER_FAILED) {
 		pr_err("SelfTest routine error!\n");
 		return rc;
 	}

-	rc = watchdog_register_device(&xilinx_wdt_wdd);
+	rc = watchdog_register_device(xilinx_wdt_wdd);
 	if (rc) {
 		pr_err("cannot register watchdog (err=%d)\n", rc);
 		return rc;
 	}

 	dev_info(&pdev->dev, "Xilinx Watchdog Timer at %p with timeout %ds\n",
-		 xdev.base, timeout);
+		 xdev->base, xilinx_wdt_wdd->timeout);
+
+	platform_set_drvdata(pdev, xdev);

 	return 0;
 }

-static int xwdt_remove(struct platform_device *dev)
+static int xwdt_remove(struct platform_device *pdev)
 {
-	watchdog_unregister_device(&xilinx_wdt_wdd);
+	struct xwdt_device *xdev = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&xdev->xilinx_wdt_wdd);

 	return 0;
 }
--
1.8.2.3


--=_mimegpg-monstr-desktop-9527-1392101768-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlL5yYgACgkQykllyylKDCGe4gCfXkpTxCzxUhxf3v06EEo8BnoH
XUUAn25Vxf7IfUu0MljeulDA/613Srfw
=S8QG
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9527-1392101768-0001--
