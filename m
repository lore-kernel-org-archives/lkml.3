Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3L3VRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 16:17:43 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40061 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254Ab3L3VPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 16:15:38 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 1/7] usb: phy: msm: Move mach dependent code to platform data
Date: Mon, 30 Dec 2013 13:15:27 -0800
Message-Id: <1388438133-431-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2.228.g8f9f19c
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This patch fix compilation error when driver is compiled
in multi-platform builds.

drivers/built-in.o: In function `msm_otg_link_clk_reset':
./drivers/usb/phy/phy-msm-usb.c:314: undefined reference to `clk_reset'
./drivers/usb/phy/phy-msm-usb.c:318: undefined reference to `clk_reset'

Use platform data supplied reset handlers and adjust error
messages reported when reset sequence fail.

This is an intermediate step before adding support for reset
framework and newer targets.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x30.c | 35 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/board-qsd8x50.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/usb/phy/phy-msm-usb.c     | 35 +++++++++++++++--------------------
 include/linux/usb/msm_hsusb.h     |  3 +++
 4 files changed, 88 insertions(+), 20 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index f9af5a4..46de789 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -30,6 +30,7 @@
 #include <asm/memory.h>
 #include <asm/setup.h>
 
+#include <mach/clk.h>
 #include <mach/msm_iomap.h>
 #include <mach/dma.h>
 
@@ -60,10 +61,44 @@ static int hsusb_phy_init_seq[] = {
 	-1
 };
 
+static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
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
+	.link_clk_reset		= hsusb_link_clk_reset,
+	.phy_clk_reset		= hsusb_phy_clk_reset,
 };
 
 struct msm_gpiomux_config msm_gpiomux_configs[GPIOMUX_NGPIOS] = {
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 5f933bc..9169ec3 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -31,6 +31,7 @@
 #include <mach/irqs.h>
 #include <mach/sirc.h>
 #include <mach/vreg.h>
+#include <mach/clk.h>
 #include <linux/platform_data/mmc-msm_sdcc.h>
 
 #include "devices.h"
@@ -81,10 +82,44 @@ static int hsusb_phy_init_seq[] = {
 	-1
 };
 
+static int hsusb_link_clk_reset(struct clk *link_clk, bool assert)
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
+	.link_clk_reset		= hsusb_link_clk_reset,
+	.phy_clk_reset		= hsusb_phy_clk_reset,
 };
 
 static struct platform_device *devices[] __initdata = {
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index e9d4cd9..9a47d44 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -40,8 +40,6 @@
 #include <linux/usb/msm_hsusb_hw.h>
 #include <linux/regulator/consumer.h>
 
-#include <mach/clk.h>
-
 #define MSM_USB_BASE	(motg->regs)
 #define DRIVER_NAME	"msm_otg"
 
@@ -308,33 +306,30 @@ static void ulpi_init(struct msm_otg *motg)
 
 static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 {
-	int ret;
+	int ret = 0;
+
+	if (!motg->pdata->link_clk_reset)
+		return ret;
+
+	ret = motg->pdata->link_clk_reset(motg->clk, assert);
+	if (ret)
+		dev_err(motg->phy.dev, "usb link clk reset %s failed\n",
+			assert ? "assert" : "deassert");
 
-	if (assert) {
-		ret = clk_reset(motg->clk, CLK_RESET_ASSERT);
-		if (ret)
-			dev_err(motg->phy.dev, "usb hs_clk assert failed\n");
-	} else {
-		ret = clk_reset(motg->clk, CLK_RESET_DEASSERT);
-		if (ret)
-			dev_err(motg->phy.dev, "usb hs_clk deassert failed\n");
-	}
 	return ret;
 }
 
 static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 {
-	int ret;
+	int ret = 0;
 
-	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_ASSERT);
-	if (ret) {
-		dev_err(motg->phy.dev, "usb phy clk assert failed\n");
+	if (!motg->pdata->phy_clk_reset)
 		return ret;
-	}
-	usleep_range(10000, 12000);
-	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_DEASSERT);
+
+	ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
 	if (ret)
-		dev_err(motg->phy.dev, "usb phy clk deassert failed\n");
+		dev_err(motg->phy.dev, "usb phy clk reset failed\n");
+
 	return ret;
 }
 
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 22a396c..3275483 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -20,6 +20,7 @@
 
 #include <linux/types.h>
 #include <linux/usb/otg.h>
+#include <linux/clk.h>
 
 /**
  * Supported USB modes
@@ -135,6 +136,8 @@ struct msm_otg_platform_data {
 	enum msm_usb_phy_type phy_type;
 	void (*setup_gpio)(enum usb_otg_state state);
 	char *pclk_src_name;
+	int (*link_clk_reset)(struct clk *link_clk, bool assert);
+	int (*phy_clk_reset)(struct clk *phy_clk);
 };
 
 /**
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

