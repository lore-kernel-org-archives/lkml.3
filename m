Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3JNP16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:27:58 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49824 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756969Ab3JNP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 09/13] usb: phy: msm: Remove unused pclk_src_name
Date: Mon, 14 Oct 2013 18:24:36 +0300
Message-Id: <1381764280-28420-10-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

There are no references to 'pclk_src_name' in plaform code,
so it is unused.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |   26 +-------------------------
 include/linux/usb/msm_hsusb.h |    5 -----
 2 files changed, 1 insertion(+), 30 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 4a23cfa..c1020d9 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -464,9 +464,6 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	if (!IS_ERR(motg->core_clk))
 		clk_disable_unprepare(motg->core_clk);
 
-	if (!IS_ERR(motg->pclk_src))
-		clk_disable_unprepare(motg->pclk_src);
-
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
 		msm_hsusb_ldo_set_mode(motg, 0);
@@ -496,9 +493,6 @@ static int msm_otg_resume(struct msm_otg *motg)
 	if (!atomic_read(&motg->in_lpm))
 		return 0;
 
-	if (!IS_ERR(motg->pclk_src))
-		clk_prepare_enable(motg->pclk_src);
-
 	clk_prepare_enable(motg->pclk);
 	clk_prepare_enable(motg->clk);
 	if (!IS_ERR(motg->core_clk))
@@ -1394,17 +1388,8 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * If USB Core is running its protocol engine based on CORE CLK,
 	 * CORE CLK  must be running at >55Mhz for correct HSUSB
 	 * operation and USB core cannot tolerate frequency changes on
-	 * CORE CLK. For such USB cores, vote for maximum clk frequency
-	 * on pclk source
+	 * CORE CLK.
 	 */
-	 motg->pclk_src = ERR_PTR(-ENOENT);
-	 if (motg->pdata->pclk_src_name) {
-		motg->pclk_src = devm_clk_get(&pdev->dev,
-					motg->pdata->pclk_src_name);
-		if (IS_ERR(motg->pclk_src))
-			return PTR_ERR(motg->pclk_src);
-	}
-
 	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
 	if (IS_ERR(motg->pclk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
@@ -1450,10 +1435,6 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	}
 
 	clk_set_rate(motg->clk, 60000000);
-	if (!IS_ERR(motg->pclk_src)) {
-		clk_set_rate(motg->pclk_src, INT_MAX);
-		clk_prepare_enable(motg->pclk_src);
-	}
 
 	clk_prepare_enable(motg->clk);
 	clk_prepare_enable(motg->pclk);
@@ -1529,8 +1510,6 @@ disable_clks:
 	clk_disable_unprepare(motg->clk);
 	if (!IS_ERR(motg->core_clk))
 		clk_disable_unprepare(motg->core_clk);
-	if (!IS_ERR(motg->pclk_src))
-		clk_disable_unprepare(motg->pclk_src);
 	return ret;
 }
 
@@ -1575,9 +1554,6 @@ static int msm_otg_remove(struct platform_device *pdev)
 	clk_disable_unprepare(motg->clk);
 	if (!IS_ERR(motg->core_clk))
 		clk_disable_unprepare(motg->core_clk);
-	if (!IS_ERR(motg->pclk_src))
-		clk_disable_unprepare(motg->pclk_src);
-
 	msm_hsusb_ldo_init(motg, 0);
 
 	pm_runtime_set_suspended(&pdev->dev);
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 72c5830..262ed80 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -106,8 +106,6 @@ enum usb_chg_type {
  * @power_budget: VBUS power budget in mA (0 will be treated as 500mA).
  * @mode: Supported mode (OTG/peripheral/host).
  * @otg_control: OTG switch controlled by user/Id pin
- * @pclk_src_name: pclk is derived from ebi1_usb_clk in case of 7x27 and 8k
- *              dfab_usb_hs_clk in case of 8660 and 8960.
  */
 struct msm_otg_platform_data {
 	int *phy_init_seq;
@@ -117,7 +115,6 @@ struct msm_otg_platform_data {
 	enum otg_control_type otg_control;
 	enum msm_usb_phy_type phy_type;
 	void (*setup_gpio)(enum usb_otg_state state);
-	char *pclk_src_name;
 	int (*link_clk_reset)(struct clk *link_clk, bool assert);
 	int (*phy_clk_reset)(struct clk *phy_clk);
 };
@@ -129,7 +126,6 @@ struct msm_otg_platform_data {
  * @irq: IRQ number assigned for HSUSB controller.
  * @clk: clock struct of usb_hs_clk.
  * @pclk: clock struct of usb_hs_pclk.
- * @pclk_src: pclk source for voting.
  * @phy_reset_clk: clock struct of usb_phy_clk.
  * @core_clk: clock struct of usb_hs_core_clk.
  * @regs: ioremapped register base address.
@@ -150,7 +146,6 @@ struct msm_otg {
 	int irq;
 	struct clk *clk;
 	struct clk *pclk;
-	struct clk *pclk_src;
 	struct clk *phy_reset_clk;
 	struct clk *core_clk;
 	void __iomem *regs;
-- 
1.7.9.5

