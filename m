Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaBTLlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:41:15 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52942 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbaBTLkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:40:49 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v8 01/14] mfd: omap-usb-host: Get clocks based on hardware revision
Date: Thu, 20 Feb 2014 13:39:56 +0200
Message-ID: <1392896409-5101-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all revisions have all the clocks so get the necessary clocks
based on hardware revision.

This should avoid un-necessary clk_get failure messages that were
observed earlier.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 0c3c9a0..c63bfdf 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -665,22 +665,43 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		goto err_mem;
 	}
 
-	need_logic_fck = false;
+	/* Set all clocks as invalid to begin with */
+	omap->ehci_logic_fck = ERR_PTR(-ENODEV);
+	omap->init_60m_fclk = ERR_PTR(-ENODEV);
+	omap->utmi_p1_gfclk = ERR_PTR(-ENODEV);
+	omap->utmi_p2_gfclk = ERR_PTR(-ENODEV);
+	omap->xclk60mhsp1_ck = ERR_PTR(-ENODEV);
+	omap->xclk60mhsp2_ck = ERR_PTR(-ENODEV);
+
 	for (i = 0; i < omap->nports; i++) {
-		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
-			is_ehci_hsic_mode(i))
-				need_logic_fck |= true;
+		omap->utmi_clk[i] = ERR_PTR(-ENODEV);
+		omap->hsic480m_clk[i] = ERR_PTR(-ENODEV);
+		omap->hsic60m_clk[i] = ERR_PTR(-ENODEV);
 	}
 
-	omap->ehci_logic_fck = ERR_PTR(-EINVAL);
-	if (need_logic_fck) {
-		omap->ehci_logic_fck = devm_clk_get(dev, "ehci_logic_fck");
-		if (IS_ERR(omap->ehci_logic_fck)) {
-			ret = PTR_ERR(omap->ehci_logic_fck);
-			dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
+	/* for OMAP3 i.e. USBHS REV1 */
+	if (omap->usbhs_rev == OMAP_USBHS_REV1) {
+		need_logic_fck = false;
+		for (i = 0; i < omap->nports; i++) {
+			if (is_ehci_phy_mode(pdata->port_mode[i]) ||
+			    is_ehci_tll_mode(pdata->port_mode[i]) ||
+			    is_ehci_hsic_mode(pdata->port_mode[i]))
+
+				need_logic_fck |= true;
+		}
+
+		if (need_logic_fck) {
+			omap->ehci_logic_fck = devm_clk_get(dev,
+							    "ehci_logic_fck");
+			if (IS_ERR(omap->ehci_logic_fck)) {
+				ret = PTR_ERR(omap->ehci_logic_fck);
+				dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
+			}
 		}
+		goto initialize;
 	}
 
+	/* for OMAP4+ i.e. USBHS REV2+ */
 	omap->utmi_p1_gfclk = devm_clk_get(dev, "utmi_p1_gfclk");
 	if (IS_ERR(omap->utmi_p1_gfclk)) {
 		ret = PTR_ERR(omap->utmi_p1_gfclk);
@@ -748,7 +769,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
-		/* for OMAP3, clk_set_parent fails */
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->xclk60mhsp1_ck);
 		if (ret != 0)
@@ -776,6 +796,7 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 					ret);
 	}
 
+initialize:
 	omap_usbhs_init(dev);
 
 	if (dev->of_node) {
-- 
1.8.3.2

