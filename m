Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3GIPuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:50:06 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50710 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab3GIPsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:07 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v2 1/7] usb: phy: msm: Move mach depndend code to platform data
Date: Tue,  9 Jul 2013 18:47:07 +0300
Message-Id: <1373384833-18077-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This patch fix compilation error and is an intermediate step
before the addition of DeviceTree support for newer targets.
Fix suggested here: https://lkml.org/lkml/2013/6/19/381

Cc: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/mach-msm/board-msm7x30.c |   35 +++++++++++++++++++++++
 arch/arm/mach-msm/board-qsd8x50.c |   34 +++++++++++++++++++++++
 drivers/usb/phy/phy-msm-usb.c     |   55 ++++++++++---------------------------
 include/linux/usb/msm_hsusb.h     |    2 ++
 4 files changed, 85 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index db3d8c0..4df7daa 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -31,6 +31,7 @@
 #include <asm/setup.h>
 
 #include <mach/board.h>
+#include <mach/clk.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
 
@@ -61,10 +62,44 @@ static int hsusb_phy_init_seq[] = {
 	-1
 };
 
+static int hsusb_phy_link_clk_reset(struct clk *link_clk, bool assert)
+{
+	int ret;
+
+	if (assert) {
+		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
+		if (ret)
+			pr_err("usb hs_clk assert failed\n");
+	} else {
+		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
+		if (ret)
+			pr_err("usb hs_clk deassert failed\n");
+	}
+	return ret;
+}
+
+static int hsusb_phy_clk_reset(struct clk *phy_clk)
+{
+	int ret;
+
+	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
+	if (ret) {
+		pr_err("usb phy clk assert failed\n");
+		return ret;
+	}
+	usleep_range(10000, 12000);
+	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
+	if (ret)
+		pr_err("usb phy clk deassert failed\n");
+	return ret;
+}
+
 static struct msm_otg_platform_data msm_otg_pdata = {
 	.phy_init_seq		= hsusb_phy_init_seq,
 	.mode                   = USB_PERIPHERAL,
 	.otg_control		= OTG_PHY_CONTROL,
+	.phy_link_clk_reset	= hsusb_phy_link_clk_reset,
+	.phy_phy_clk_reset	= hsusb_phy_clk_reset,
 };
 
 struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index f14a73d..d3d92ab 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -82,10 +82,44 @@ static int hsusb_phy_init_seq[] = {
 	-1
 };
 
+static int hsusb_phy_link_clk_reset(struct clk *link_clk, bool assert)
+{
+	int ret;
+
+	if (assert) {
+		ret = clk_reset(link_clk, CLK_RESET_ASSERT);
+		if (ret)
+			pr_err("usb hs_clk assert failed\n");
+	} else {
+		ret = clk_reset(link_clk, CLK_RESET_DEASSERT);
+		if (ret)
+			pr_err("usb hs_clk deassert failed\n");
+	}
+	return ret;
+}
+
+static int hsusb_phy_clk_reset(struct clk *phy_clk)
+{
+	int ret;
+
+	ret = clk_reset(phy_clk, CLK_RESET_ASSERT);
+	if (ret) {
+		pr_err("usb phy clk assert failed\n");
+		return ret;
+	}
+	usleep_range(10000, 12000);
+	ret = clk_reset(phy_clk, CLK_RESET_DEASSERT);
+	if (ret)
+		pr_err("usb phy clk deassert failed\n");
+	return ret;
+}
+
 static struct msm_otg_platform_data msm_otg_pdata = {
 	.phy_init_seq		= hsusb_phy_init_seq,
 	.mode                   = USB_PERIPHERAL,
 	.otg_control		= OTG_PHY_CONTROL,
+	.phy_link_clk_reset	= hsusb_phy_link_clk_reset,
+	.phy_phy_clk_reset	= hsusb_phy_clk_reset,
 };
 
 static struct platform_device *devices[] __initdata = {
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index d08f334..ab1b880 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -40,8 +40,6 @@
 #include <linux/usb/msm_hsusb_hw.h>
 #include <linux/regulator/consumer.h>
 
-#include <mach/clk.h>
-
 #define MSM_USB_BASE	(motg->regs)
 #define DRIVER_NAME	"msm_otg"
 
@@ -306,51 +304,20 @@ static void ulpi_init(struct msm_otg *motg)
 	}
 }
 
-static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
-{
-	int ret;
-
-	if (assert) {
-		ret = clk_reset(motg->clk, CLK_RESET_ASSERT);
-		if (ret)
-			dev_err(motg->phy.dev, "usb hs_clk assert failed\n");
-	} else {
-		ret = clk_reset(motg->clk, CLK_RESET_DEASSERT);
-		if (ret)
-			dev_err(motg->phy.dev, "usb hs_clk deassert failed\n");
-	}
-	return ret;
-}
-
-static int msm_otg_phy_clk_reset(struct msm_otg *motg)
-{
-	int ret;
-
-	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_ASSERT);
-	if (ret) {
-		dev_err(motg->phy.dev, "usb phy clk assert failed\n");
-		return ret;
-	}
-	usleep_range(10000, 12000);
-	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_DEASSERT);
-	if (ret)
-		dev_err(motg->phy.dev, "usb phy clk deassert failed\n");
-	return ret;
-}
-
 static int msm_otg_phy_reset(struct msm_otg *motg)
 {
+	struct msm_otg_platform_data *pdata = motg->pdata;
 	u32 val;
 	int ret;
 	int retries;
 
-	ret = msm_otg_link_clk_reset(motg, 1);
+	ret = pdata->phy_link_clk_reset(motg->clk, true);
 	if (ret)
 		return ret;
-	ret = msm_otg_phy_clk_reset(motg);
+	ret = pdata->phy_clk_reset(motg->phy_reset_clk);
 	if (ret)
 		return ret;
-	ret = msm_otg_link_clk_reset(motg, 0);
+	ret = pdata->phy_link_clk_reset(motg->clk, false);
 	if (ret)
 		return ret;
 
@@ -362,7 +329,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 				ULPI_CLR(ULPI_FUNC_CTRL));
 		if (!ret)
 			break;
-		ret = msm_otg_phy_clk_reset(motg);
+		ret = pdata->phy_clk_reset(motg->phy_reset_clk);
 		if (ret)
 			return ret;
 	}
@@ -370,7 +337,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 		return -ETIMEDOUT;
 
 	/* This reset calibrates the phy, if the above write succeeded */
-	ret = msm_otg_phy_clk_reset(motg);
+	ret = pdata->phy_clk_reset(motg->phy_reset_clk);
 	if (ret)
 		return ret;
 
@@ -378,7 +345,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 		ret = ulpi_read(&motg->phy, ULPI_DEBUG);
 		if (ret != -ETIMEDOUT)
 			break;
-		ret = msm_otg_phy_clk_reset(motg);
+		ret = pdata->phy_clk_reset(motg->phy_reset_clk);
 		if (ret)
 			return ret;
 	}
@@ -1414,16 +1381,22 @@ static void msm_otg_debugfs_cleanup(void)
 static int __init msm_otg_probe(struct platform_device *pdev)
 {
 	int ret = 0;
+	struct msm_otg_platform_data *pdata = pdev->dev.platform_data;
 	struct resource *res;
 	struct msm_otg *motg;
 	struct usb_phy *phy;
 
 	dev_info(&pdev->dev, "msm_otg probe\n");
-	if (!pdev->dev.platform_data) {
+	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data given. Bailing out\n");
 		return -ENODEV;
 	}
 
+	if (!pdata->phy_clk_reset || !pdata->phy_link_clk_reset) {
+		dev_err(&pdev->dev, "No phy or link clock reset methods\n");
+		return -ENODEV;
+	}
+
 	motg = kzalloc(sizeof(struct msm_otg), GFP_KERNEL);
 	if (!motg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 22a396c..66081ed 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -135,6 +135,8 @@ struct msm_otg_platform_data {
 	enum msm_usb_phy_type phy_type;
 	void (*setup_gpio)(enum usb_otg_state state);
 	char *pclk_src_name;
+	int (*phy_link_clk_reset)(struct clk *link_clk, bool assert);
+	int (*phy_clk_reset)(struct clk *phy_clk);
 };
 
 /**
-- 
1.7.9.5

