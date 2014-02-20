Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaBTLlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:41:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57953 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbaBTLk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:40:57 -0500
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <bcousson@baylibre.com>, <lee.jones@linaro.org>
CC: <balbi@ti.com>, <nm@ti.com>, <khilman@linaro.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH v8 02/14] mfd: omap-usb-host: Always fail on clk_get() error
Date: Thu, 20 Feb 2014 13:39:57 +0200
Message-ID: <1392896409-5101-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392896409-5101-1-git-send-email-rogerq@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Be more strict and always fail on clk_get() error.

For OMAP3 platforms, get the 120MHz EHCI clock by its proper name
'usbhost_120m_fck' instead of its alias 'ehci_logic_fck'.

CC: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c | 65 +++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index c63bfdf..865c276 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -692,10 +692,12 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 
 		if (need_logic_fck) {
 			omap->ehci_logic_fck = devm_clk_get(dev,
-							    "ehci_logic_fck");
+							    "usbhost_120m_fck");
 			if (IS_ERR(omap->ehci_logic_fck)) {
 				ret = PTR_ERR(omap->ehci_logic_fck);
-				dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
+				dev_err(dev, "usbhost_120m_fck failed:%d\n",
+					ret);
+				goto err_mem;
 			}
 		}
 		goto initialize;
@@ -749,51 +751,68 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 		 * them
 		 */
 		omap->utmi_clk[i] = devm_clk_get(dev, clkname);
-		if (IS_ERR(omap->utmi_clk[i]))
-			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
-				clkname, PTR_ERR(omap->utmi_clk[i]));
+		if (IS_ERR(omap->utmi_clk[i])) {
+			ret = PTR_ERR(omap->utmi_clk[i]);
+			dev_err(dev, "Failed to get clock : %s : %d\n",
+				clkname, ret);
+			goto err_mem;
+		}
 
 		snprintf(clkname, sizeof(clkname),
 				"usb_host_hs_hsic480m_p%d_clk", i + 1);
 		omap->hsic480m_clk[i] = devm_clk_get(dev, clkname);
-		if (IS_ERR(omap->hsic480m_clk[i]))
-			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
-				clkname, PTR_ERR(omap->hsic480m_clk[i]));
+		if (IS_ERR(omap->hsic480m_clk[i])) {
+			ret = PTR_ERR(omap->hsic480m_clk[i]);
+			dev_err(dev, "Failed to get clock : %s : %d\n",
+				clkname, ret);
+			goto err_mem;
+		}
 
 		snprintf(clkname, sizeof(clkname),
 				"usb_host_hs_hsic60m_p%d_clk", i + 1);
 		omap->hsic60m_clk[i] = devm_clk_get(dev, clkname);
-		if (IS_ERR(omap->hsic60m_clk[i]))
-			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
-				clkname, PTR_ERR(omap->hsic60m_clk[i]));
+		if (IS_ERR(omap->hsic60m_clk[i])) {
+			ret = PTR_ERR(omap->hsic60m_clk[i]);
+			dev_err(dev, "Failed to get clock : %s : %d\n",
+				clkname, ret);
+			goto err_mem;
+		}
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->xclk60mhsp1_ck);
-		if (ret != 0)
-			dev_dbg(dev, "xclk60mhsp1_ck set parent failed: %d\n",
-					ret);
+		if (ret != 0) {
+			dev_err(dev, "xclk60mhsp1_ck set parent failed: %d\n",
+				ret);
+			goto err_mem;
+		}
 	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
 		ret = clk_set_parent(omap->utmi_p1_gfclk,
 					omap->init_60m_fclk);
-		if (ret != 0)
-			dev_dbg(dev, "P0 init_60m_fclk set parent failed: %d\n",
-					ret);
+		if (ret != 0) {
+			dev_err(dev, "P0 init_60m_fclk set parent failed: %d\n",
+				ret);
+			goto err_mem;
+		}
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 					omap->xclk60mhsp2_ck);
-		if (ret != 0)
-			dev_dbg(dev, "xclk60mhsp2_ck set parent failed: %d\n",
-					ret);
+		if (ret != 0) {
+			dev_err(dev, "xclk60mhsp2_ck set parent failed: %d\n",
+				ret);
+			goto err_mem;
+		}
 	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
 		ret = clk_set_parent(omap->utmi_p2_gfclk,
 						omap->init_60m_fclk);
-		if (ret != 0)
-			dev_dbg(dev, "P1 init_60m_fclk set parent failed: %d\n",
-					ret);
+		if (ret != 0) {
+			dev_err(dev, "P1 init_60m_fclk set parent failed: %d\n",
+				ret);
+			goto err_mem;
+		}
 	}
 
 initialize:
-- 
1.8.3.2

