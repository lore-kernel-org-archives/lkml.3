Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaKKLc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:32:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaKKLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:54 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Cherian <george.cherian@ti.com>, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 119/170] Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete"
Date: Tue, 11 Nov 2014 11:07:58 +0000
Message-Id: <1415704129-12709-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit b01ff5cb2fc99d45e4edc97077b6e17186570a16 upstream.

This reverts commit 02dae36aa649a66c5c6181157ddd806e7b4913fc.

That commit is bogus in two ways:

1) There's no way dwc3-omap's ->suspend() can cause any effect
	on xhci's ->suspend(). Linux device driver model guarantees
	that a parent's ->suspend() will only be called after all
	children are suspended. dwc3-omap is the parent of the
	parent of xhci.

2) When implementing Deep Sleep states where context is lost,
	USBOTGSS_IRQ0 register, well, looses context so we
	_must_ rewrite it otherwise core IRQs will never be
	reenabled and USB will appear to be dead.

Fixes: 02dae36 (usb: dwc3: dwc3-omap: Disable/Enable only
	wrapper interrupts in prepare/complete)
Cc: George Cherian <george.cherian@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 3536ad7f1346..0aa49e0fb4e0 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -599,7 +599,7 @@ static int dwc3_omap_prepare(struct device *dev)
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
 
-	dwc3_omap_write_irqmisc_set(omap, 0x00);
+	dwc3_omap_disable_irqs(omap);
 
 	return 0;
 }
@@ -607,19 +607,8 @@ static int dwc3_omap_prepare(struct device *dev)
 static void dwc3_omap_complete(struct device *dev)
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
-	u32			reg;
 
-	reg = (USBOTGSS_IRQMISC_OEVT |
-			USBOTGSS_IRQMISC_DRVVBUS_RISE |
-			USBOTGSS_IRQMISC_CHRGVBUS_RISE |
-			USBOTGSS_IRQMISC_DISCHRGVBUS_RISE |
-			USBOTGSS_IRQMISC_IDPULLUP_RISE |
-			USBOTGSS_IRQMISC_DRVVBUS_FALL |
-			USBOTGSS_IRQMISC_CHRGVBUS_FALL |
-			USBOTGSS_IRQMISC_DISCHRGVBUS_FALL |
-			USBOTGSS_IRQMISC_IDPULLUP_FALL);
-
-	dwc3_omap_write_irqmisc_set(omap, reg);
+	dwc3_omap_enable_irqs(omap);
 }
 
 static int dwc3_omap_suspend(struct device *dev)
-- 
2.1.0

