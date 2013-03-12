Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3CLKpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:45:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50388 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3CLKpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:45:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <balbi@ti.com>, <b-cousson@ti.com>,
        <mark.rutland@arm.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <rogerq@ti.com>
Subject: [PATCH 04/12] USB: ehci-omap: Remove PHY reset handling code
Date: Tue, 12 Mar 2013 12:44:42 +0200
Message-ID: <1363085090-24676-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363085090-24676-1-git-send-email-rogerq@ti.com>
References: <1363085090-24676-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset GPIO handling for the PHY must be done in the PHY
driver. We use the PHY helpers instead to reset the PHY.

Signed-off-by: Roger Quadros <rogerq@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/host/ehci-omap.c |   72 ++++++------------------------------------
 1 files changed, 10 insertions(+), 62 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index 6b8b7e5..0bbfdc1 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -86,79 +86,27 @@ static inline u32 ehci_read(void __iomem *base, u32 reg)
 	return __raw_readl(base + reg);
 }
 
-
-static void omap_ehci_soft_phy_reset(struct usb_hcd *hcd, u8 port)
-{
-	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
-	unsigned reg = 0;
-
-	reg = ULPI_FUNC_CTRL_RESET
-		/* FUNCTION_CTRL_SET register */
-		| (ULPI_SET(ULPI_FUNC_CTRL) << EHCI_INSNREG05_ULPI_REGADD_SHIFT)
-		/* Write */
-		| (2 << EHCI_INSNREG05_ULPI_OPSEL_SHIFT)
-		/* PORTn */
-		| ((port + 1) << EHCI_INSNREG05_ULPI_PORTSEL_SHIFT)
-		/* start ULPI access*/
-		| (1 << EHCI_INSNREG05_ULPI_CONTROL_SHIFT);
-
-	ehci_write(hcd->regs, EHCI_INSNREG05_ULPI, reg);
-
-	/* Wait for ULPI access completion */
-	while ((ehci_read(hcd->regs, EHCI_INSNREG05_ULPI)
-			& (1 << EHCI_INSNREG05_ULPI_CONTROL_SHIFT))) {
-		cpu_relax();
-
-		if (time_after(jiffies, timeout)) {
-			dev_dbg(hcd->self.controller,
-					"phy reset operation timed out\n");
-			break;
-		}
-	}
-}
-
 static int omap_ehci_init(struct usb_hcd *hcd)
 {
-	struct ehci_hcd		*ehci = hcd_to_ehci(hcd);
-	int			rc;
-	struct usbhs_omap_platform_data	*pdata;
-
-	pdata = hcd->self.controller->platform_data;
+	struct ehci_hcd	*ehci = hcd_to_ehci(hcd);
+	struct omap_hcd	*omap = (struct omap_hcd *)ehci->priv;
+	int rc, i;
 
 	/* Hold PHYs in reset while initializing EHCI controller */
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[0], 0);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[1], 0);
-
-		/* Hold the PHY in RESET for enough time till DIR is high */
-		udelay(10);
+	for (i = 0; i < omap->nports; i++) {
+		if (omap->phy[i])
+			usb_phy_shutdown(omap->phy[i]);
 	}
 
-	/* Soft reset the PHY using PHY reset command over ULPI */
-	if (pdata->port_mode[0] == OMAP_EHCI_PORT_MODE_PHY)
-		omap_ehci_soft_phy_reset(hcd, 0);
-	if (pdata->port_mode[1] == OMAP_EHCI_PORT_MODE_PHY)
-		omap_ehci_soft_phy_reset(hcd, 1);
-
 	/* we know this is the memory we want, no need to ioremap again */
 	ehci->caps = hcd->regs;
 
 	rc = ehci_setup(hcd);
 
-	if (pdata->phy_reset) {
-		/* Hold the PHY in RESET for enough time till
-		 * PHY is settled and ready
-		 */
-		udelay(10);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[0], 1);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_set_value_cansleep(pdata->reset_gpio_port[1], 1);
+	/* Bring PHYs out of reset */
+	for (i = 0; i < omap->nports; i++) {
+		if (omap->phy[i])
+			usb_phy_init(omap->phy[i]);
 	}
 
 	return rc;
-- 
1.7.4.1

