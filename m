Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab3AULGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:06:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59022 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab3AULGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:06:40 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>, <balbi@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <rogerq@ti.com>
Subject: [PATCH v9 06/22] mfd: omap-usb-tll: introduce and use mode_needs_tll()
Date: Mon, 21 Jan 2013 13:06:23 +0200
Message-ID: <1358766383-5541-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20130118150242.GF23505@n2100.arm.linux.org.uk>
References: <20130118150242.GF23505@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a handy macro to check if the port requires the
USB TLL module or not. Use it to Enable the TLL module and manage
the clocks.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index bf7355e..af67b96 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -95,6 +95,10 @@
 
 #define is_ehci_tll_mode(x)	(x == OMAP_EHCI_PORT_MODE_TLL)
 
+/* only PHY and UNUSED modes don't need TLL */
+#define omap_usb_mode_needs_tll(x)	((x) != OMAP_USBHS_PORT_MODE_UNUSED &&\
+					 (x) != OMAP_EHCI_PORT_MODE_PHY)
+
 struct usbtll_omap {
 	int					nch;	/* num. of channels */
 	struct usbhs_omap_platform_data		*pdata;
@@ -211,6 +215,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	unsigned long				flags;
 	int					ret = 0;
 	int					i, ver;
+	bool needs_tll;
 
 	dev_dbg(dev, "starting TI HSUSB TLL Controller\n");
 
@@ -278,12 +283,11 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 
 	spin_lock_irqsave(&tll->lock, flags);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]) ||
-	    is_ehci_tll_mode(pdata->port_mode[1]) ||
-	    is_ehci_tll_mode(pdata->port_mode[2]) ||
-	    is_ohci_port(pdata->port_mode[0]) ||
-	    is_ohci_port(pdata->port_mode[1]) ||
-	    is_ohci_port(pdata->port_mode[2])) {
+	needs_tll = false;
+	for (i = 0; i < tll->nch; i++)
+		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
+
+	if (needs_tll) {
 
 		/* Program Common TLL register */
 		reg = usbtll_read(base, OMAP_TLL_SHARED_CONF);
@@ -372,7 +376,7 @@ static int usbtll_runtime_resume(struct device *dev)
 	spin_lock_irqsave(&tll->lock, flags);
 
 	for (i = 0; i < tll->nch; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			int r;
 
 			if (IS_ERR(tll->ch_clk[i]))
@@ -408,7 +412,7 @@ static int usbtll_runtime_suspend(struct device *dev)
 	spin_lock_irqsave(&tll->lock, flags);
 
 	for (i = 0; i < tll->nch; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			if (!IS_ERR(tll->ch_clk[i]))
 				clk_disable(tll->ch_clk[i]);
 		}
-- 
1.7.4.1

