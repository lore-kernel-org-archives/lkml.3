Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaB0OT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:19:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49642 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaB0OTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:19:06 -0500
From: Roger Quadros <rogerq@ti.com>
To: <lee.jones@linaro.org>, <tony@atomide.com>, <bcousson@baylibre.com>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Tero Kristo <t-kristo@ti.com>
Subject: [PATCH v9 1/9] mfd: omap-usb-host: Get clocks based on hardware revision
Date: Thu, 27 Feb 2014 16:18:23 +0200
Message-ID: <1393510711-4697-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393510711-4697-1-git-send-email-rogerq@ti.com>
References: <1393510711-4697-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all revisions have all the clocks so get the necessary clocks
based on hardware revision.

This should avoid un-necessary clk_get failure messages that were
observed earlier.

Also remove the dummy USB host clocks from the OMAP3 clock data.
These are no longer expected by the driver.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Tero Kristo <t-kristo@ti.com>
Acked-by: Mike Turquette <mturquette@linaro.org> [OMAP3 CLK data]
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/cclock3xxx_data.c |  4 ----
 drivers/clk/ti/clk-3xxx.c             |  4 ----
 drivers/mfd/omap-usb-host.c           | 43 ++++++++++++++++++++++++++---------
 3 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
index 3b05aea..4299a55 100644
--- a/arch/arm/mach-omap2/cclock3xxx_data.c
+++ b/arch/arm/mach-omap2/cclock3xxx_data.c
@@ -3495,10 +3495,6 @@ static struct omap_clk omap3xxx_clks[] = {
 	CLK(NULL,	"dss_tv_fck",	&dss_tv_fck),
 	CLK(NULL,	"dss_96m_fck",	&dss_96m_fck),
 	CLK(NULL,	"dss2_alwon_fck",	&dss2_alwon_fck),
-	CLK(NULL,	"utmi_p1_gfclk",	&dummy_ck),
-	CLK(NULL,	"utmi_p2_gfclk",	&dummy_ck),
-	CLK(NULL,	"xclk60mhsp1_ck",	&dummy_ck),
-	CLK(NULL,	"xclk60mhsp2_ck",	&dummy_ck),
 	CLK(NULL,	"init_60m_fclk",	&dummy_ck),
 	CLK(NULL,	"gpt1_fck",	&gpt1_fck),
 	CLK(NULL,	"aes2_ick",	&aes2_ick),
diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
index d323023..0d1750a 100644
--- a/drivers/clk/ti/clk-3xxx.c
+++ b/drivers/clk/ti/clk-3xxx.c
@@ -130,10 +130,6 @@ static struct ti_dt_clk omap3xxx_clks[] = {
 	DT_CLK(NULL, "dss_tv_fck", "dss_tv_fck"),
 	DT_CLK(NULL, "dss_96m_fck", "dss_96m_fck"),
 	DT_CLK(NULL, "dss2_alwon_fck", "dss2_alwon_fck"),
-	DT_CLK(NULL, "utmi_p1_gfclk", "dummy_ck"),
-	DT_CLK(NULL, "utmi_p2_gfclk", "dummy_ck"),
-	DT_CLK(NULL, "xclk60mhsp1_ck", "dummy_ck"),
-	DT_CLK(NULL, "xclk60mhsp2_ck", "dummy_ck"),
 	DT_CLK(NULL, "init_60m_fclk", "dummy_ck"),
 	DT_CLK(NULL, "gpt1_fck", "gpt1_fck"),
 	DT_CLK(NULL, "aes2_ick", "aes2_ick"),
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

