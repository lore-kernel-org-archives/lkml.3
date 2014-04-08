Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaDHOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:38:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30726 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaDHOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:38:42 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-33-534409f1823a
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: kishon@ti.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        sylvester.nawrocki@gmail.com, robh+dt@kernel.org, inki.dae@samsung.com,
        rahul.sharma@samsung.com, grant.likely@linaro.org,
        kgene.kim@samsung.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 3/3] s5p-tv: hdmi: use hdmiphy as PHY
Date: Tue, 08 Apr 2014 16:37:36 +0200
Message-id: <1396967856-27470-4-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t9jAd2PnC7BBs1dehbzj5xjtbjy9T2b
	xYE/OxgtJt2fwGLRu+Aqm8WFpz1sFmeb3rBbXN41h82iZ8NWVosZ5/cxWUxZdJjVonXvEXaL
	eZ93Mlmsn/GaxWJe+0tWB36PnbPusntsWtXJ5nHn2h42j/vdx5k8+rasYvQ4fmM7k8fnTXIB
	7FFcNimpOZllqUX6dglcGTcW3WUsmCNcsbdhN1sDY6tAFyMnh4SAicTzltfMELaYxIV769m6
	GLk4hAQWMUpMbV0O5XQxSfy9e5UVpIoNqOPYks+MIAkRgYWMEltPTgFzmAU6mCTOP9kFNktY
	wFyi+/EcsA4WAVWJxssTWEBsXgEPiT87HzBB7FOU6H42gQ3E5hTwlPjz5iFQPQfQOg+JeRsT
	JjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHLzPpHYwrmywOMQowMGoxMN78rVz
	sBBrYllxZe4hRgkOZiUR3opjQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNT
	UwtSi2CyTBycUg2MuctUGKzOuj3Ye2OLt8Ln6FlTm83WxM6vCpTOtuv8rC9qI3CdUaROxPHr
	3Ff/N73sWlsxqeGluPaVX35znsVs2yu2qvBSZqz1p1U6ZZ5cxSzvI+/lce/n4nx4Kbv/kUnT
	GxPjp5cOlgpeXbwkLGA3W/jXty8Nlib8Y3r/okfrVMz3+I4Fxo8eK7EUZyQaajEXFScCAKOl
	ZV5aAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HDMIPHY (physical interface) is controlled by a single
bit in a power controller's regiter. It was implemented
as clock. It was a simple but effective hack.

This patch makes S5P-HDMI driver to control HDMIPHY via PHY interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 534722c..8013e52 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -32,6 +32,7 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/phy/phy.h>
 
 #include <media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
@@ -66,7 +67,7 @@ struct hdmi_resources {
 	struct clk *sclk_hdmi;
 	struct clk *sclk_pixel;
 	struct clk *sclk_hdmiphy;
-	struct clk *hdmiphy;
+	struct phy *hdmiphy;
 	struct regulator_bulk_data *regul_bulk;
 	int regul_count;
 };
@@ -586,7 +587,7 @@ static int hdmi_resource_poweron(struct hdmi_resources *res)
 	if (ret < 0)
 		return ret;
 	/* power-on hdmi physical interface */
-	clk_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	/* use VPP as parent clock; HDMIPHY is not working yet */
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	/* turn clocks on */
@@ -600,7 +601,7 @@ static void hdmi_resource_poweroff(struct hdmi_resources *res)
 	/* turn clocks off */
 	clk_disable(res->sclk_hdmi);
 	/* power-off hdmiphy */
-	clk_disable(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	/* turn HDMI power off */
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 }
@@ -784,7 +785,7 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 	/* kfree is NULL-safe */
 	kfree(res->regul_bulk);
 	if (!IS_ERR(res->hdmiphy))
-		clk_put(res->hdmiphy);
+		phy_put(res->hdmiphy);
 	if (!IS_ERR(res->sclk_hdmiphy))
 		clk_put(res->sclk_hdmiphy);
 	if (!IS_ERR(res->sclk_pixel))
@@ -835,7 +836,7 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = clk_get(dev, "hdmiphy");
+	res->hdmiphy = phy_get(dev, "hdmiphy");
 	if (IS_ERR(res->hdmiphy)) {
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
-- 
1.7.9.5

