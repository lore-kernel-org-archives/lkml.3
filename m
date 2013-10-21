Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JUOTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34144 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3JUOTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:25 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-82-526537ec3ec6
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 07/12] drm: exynos: hdmi: use hdmiphy as PHY
Date: Mon, 21 Oct 2013 16:18:26 +0200
Message-id: <1382365111-6533-8-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd035qlBBkeeSVnMP3KO1eLK1/ds
	FpPuT2Cx6F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLpxMusllMWXSY1eLwm3ZWixmTX7JZ
	rJ/xmsViXvtLVotjM5YwOvB73Lm2h83jfvdxJo++LasYPY7f2M7k8XmTXABrFJdNSmpOZllq
	kb5dAlfG62dHWQquCVRs6/7M0sD4m7eLkZNDQsBE4syBK4wQtpjEhXvr2boYuTiEBBYxSny5
	8ZQdwulikuhffZAFpIoNqOPYks9gHSICiRK/mu8ygxQxCxxiktjdMoUZJCEsYCWxYP8qJhCb
	RUBVonfaIzYQm1fAXeLHgzmsEOvkJZ7e7wOLcwp4SJx6uRZsqBBQzbtv81gmMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcqM+kdzCuarA4xCjAwajEwxvgkhIkxJpYVlyZe4hR
	goNZSYS3yjQ1SIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU1ILUIpgsEwen
	VAOjhI8N/zXlw58qXbwfzWt4y91obG0vp1/0QyozZ9aysPmffq9uPWSoyHmp8XiV7+IfPHkL
	2+5WebtM2KreKsgvExFlXBXZVvV7j47z/4w9Xx9ZXFp2SPhdAI/vvgqTU+dYn+9Z7SjgYKMh
	nMNiKFrjublvHbtW90Ij9XM9XQzvk7Le5Hzds0aJpTgj0VCLuag4EQCPkWofUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HDMIPHY (physical interface) is controlled by a single
bit in a power controller's regiter. It was implemented
as clock. It was a simple but effective hack.

This patch makes HDMI driver to control HDMIPHY via PHY interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index fcfa23a..e36588a 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -34,6 +34,7 @@
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_gpio.h>
+#include <linux/phy/phy.h>
 
 #include <drm/exynos_drm.h>
 
@@ -82,7 +83,7 @@ struct hdmi_resources {
 	struct clk			*sclk_hdmi;
 	struct clk			*sclk_pixel;
 	struct clk			*sclk_hdmiphy;
-	struct clk			*hdmiphy;
+	struct phy			*hdmiphy;
 	struct regulator_bulk_data	*regul_bulk;
 	int				regul_count;
 };
@@ -1685,7 +1686,7 @@ static void hdmi_poweron(struct hdmi_context *hdata)
 	if (regulator_bulk_enable(res->regul_count, res->regul_bulk))
 		DRM_DEBUG_KMS("failed to enable regulator bulk\n");
 
-	clk_prepare_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	clk_prepare_enable(res->hdmi);
 	clk_prepare_enable(res->sclk_hdmi);
 
@@ -1710,7 +1711,7 @@ static void hdmi_poweroff(struct hdmi_context *hdata)
 
 	clk_disable_unprepare(res->sclk_hdmi);
 	clk_disable_unprepare(res->hdmi);
-	clk_disable_unprepare(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 
 	mutex_lock(&hdata->hdmi_mutex);
@@ -1809,9 +1810,9 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
 		DRM_ERROR("failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = devm_clk_get(dev, "hdmiphy");
+	res->hdmiphy = devm_phy_get(dev, "hdmiphy");
 	if (IS_ERR(res->hdmiphy)) {
-		DRM_ERROR("failed to get clock 'hdmiphy'\n");
+		DRM_ERROR("failed to get phy 'hdmiphy'\n");
 		goto fail;
 	}
 
-- 
1.7.9.5

