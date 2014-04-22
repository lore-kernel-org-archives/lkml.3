Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbaDVJZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:25:16 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53541 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbaDVJVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:41 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 12/19] usb: phy: msm: Use reset framework for LINK and PHY resets
Date: Tue, 22 Apr 2014 12:20:31 +0300
Message-Id: <1398158438-21579-13-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 29 +++++++++++++++++++++--------
 include/linux/usb/msm_hsusb.h |  3 +++
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 7619b3f..d47d940 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -32,6 +32,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/reset.h>

 #include <linux/usb.h>
 #include <linux/usb/otg.h>
@@ -235,12 +236,15 @@ static void ulpi_init(struct msm_otg *motg)

 static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 {
-	int ret = 0;
+	int ret;

-	if (!motg->pdata->link_clk_reset)
-		return ret;
+	if (motg->pdata->link_clk_reset)
+		ret = motg->pdata->link_clk_reset(motg->clk, assert);
+	else if (assert)
+		ret = reset_control_assert(motg->link_rst);
+	else
+		ret = reset_control_deassert(motg->link_rst);

-	ret = motg->pdata->link_clk_reset(motg->clk, assert);
 	if (ret)
 		dev_err(motg->phy.dev, "usb link clk reset %s failed\n",
 			assert ? "assert" : "deassert");
@@ -250,12 +254,13 @@ static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)

 static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 {
-	int ret = 0;
+	int ret;

-	if (!motg->pdata->phy_clk_reset)
-		return ret;
+	if (motg->pdata->phy_clk_reset)
+		ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
+	else
+		ret = reset_control_reset(motg->phy_rst);

-	ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
 	if (ret)
 		dev_err(motg->phy.dev, "usb phy clk reset failed\n");

@@ -1374,6 +1379,14 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	id = of_match_device(msm_otg_dt_match, &pdev->dev);
 	pdata->phy_type = (int) id->data;

+	motg->link_rst = devm_reset_control_get(&pdev->dev, "link");
+	if (IS_ERR(motg->link_rst))
+		return PTR_ERR(motg->link_rst);
+
+	motg->phy_rst = devm_reset_control_get(&pdev->dev, "phy");
+	if (IS_ERR(motg->phy_rst))
+		return PTR_ERR(motg->phy_rst);
+
 	pdata->mode = of_usb_get_dr_mode(node);
 	if (pdata->mode == USB_DR_MODE_UNKNOWN)
 		pdata->mode = USB_DR_MODE_OTG;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index bd68299..4e5d916 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -165,6 +165,9 @@ struct msm_otg {
 	struct regulator *v3p3;
 	struct regulator *v1p8;
 	struct regulator *vddcx;
+
+	struct reset_control *phy_rst;
+	struct reset_control *link_rst;
 };

 #endif
--
1.8.3.2

