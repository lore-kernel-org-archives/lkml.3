Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbaKLDi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:38:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaKLBa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George Cherian <george.cherian@ti.com>, Roger Quadros <rogerq@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 209/319] Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts in prepare/complete"
Date: Wed, 12 Nov 2014 10:15:47 +0900
Message-Id: <20141112011027.456745815@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-omap.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -599,7 +599,7 @@ static int dwc3_omap_prepare(struct devi
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
 
-	dwc3_omap_write_irqmisc_set(omap, 0x00);
+	dwc3_omap_disable_irqs(omap);
 
 	return 0;
 }
@@ -607,19 +607,8 @@ static int dwc3_omap_prepare(struct devi
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


