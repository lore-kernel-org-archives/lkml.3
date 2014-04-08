Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaDHOih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:38:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51265 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaDHOid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:38:33 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-a9-534409e7e671
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: kishon@ti.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        sylvester.nawrocki@gmail.com, robh+dt@kernel.org, inki.dae@samsung.com,
        rahul.sharma@samsung.com, grant.likely@linaro.org,
        kgene.kim@samsung.com, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCHv2 2/3] drm: exynos: hdmi: use hdmiphy as PHY
Date: Tue, 08 Apr 2014 16:37:35 +0200
Message-id: <1396967856-27470-3-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
References: <1396967856-27470-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jAd3nnC7BBo8/mFvMP3KO1eLK1/ds
	Fgf+7GC0mHR/AotF74KrbBYXnvawWZxtesNucXnXHDaLng1bWS1mnN/HZDFl0WFWi9a9R9gt
	5n3eyWSxfsZrFot57S9ZHfg9ds66y+6xaVUnm8eda3vYPO53H2fy6NuyitHj+I3tTB6fN8kF
	sEdx2aSk5mSWpRbp2yVwZdxofMlYsF2w4t/sdSwNjBf4uhg5OCQETCRenU7uYuQEMsUkLtxb
	z9bFyMUhJLCIUaK9/xAjhNPFJNHz5zYLSBUbUMOxJZ/BEiICCxkltp6cAuYwC3QwSZx/sosZ
	pEpYwEZi0sUOsA4WAVWJdf8PMoLYvAIeEg++9bBB7FOU6H42AczmFPCU+PPmISvISUJANfM2
	Jkxg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzh0n0nvYFzVYHGIUYCDUYmHV+GQ
	U7AQa2JZcWXuIUYJDmYlEd6KY87BQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5ak
	ZqemFqQWwWSZODilGhhjomc0TPnE+kBvWaauFuO6ffP+v1dP999R1bzUrMRlYen6C3KLYg53
	hEsprj/z3Mzl2Xq9JdP2nCzk61r4q/GsQMdDhiiV0r5/5uXpf1uKLSOeh2xxTBGV2+Xm/Wyu
	x1trz5Jn7m0MejlMqa17+YTXlecz8RU9U5Hhs3E4GPa5+v7J0p/7nJVYijMSDbWYi4oTAULR
	kp1ZAgAA
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
index 9a6d652..ef1cdd0 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -36,6 +36,7 @@
 #include <linux/i2c.h>
 #include <linux/of_gpio.h>
 #include <linux/hdmi.h>
+#include <linux/phy/phy.h>
 
 #include <drm/exynos_drm.h>
 
@@ -74,8 +75,8 @@ struct hdmi_resources {
 	struct clk			*sclk_hdmi;
 	struct clk			*sclk_pixel;
 	struct clk			*sclk_hdmiphy;
-	struct clk			*hdmiphy;
 	struct clk			*mout_hdmi;
+	struct phy			*hdmiphy;
 	struct regulator_bulk_data	*regul_bulk;
 	int				regul_count;
 };
@@ -1854,7 +1855,7 @@ static void hdmi_poweron(struct exynos_drm_display *display)
 	if (regulator_bulk_enable(res->regul_count, res->regul_bulk))
 		DRM_DEBUG_KMS("failed to enable regulator bulk\n");
 
-	clk_prepare_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	clk_prepare_enable(res->hdmi);
 	clk_prepare_enable(res->sclk_hdmi);
 
@@ -1881,7 +1882,7 @@ static void hdmi_poweroff(struct exynos_drm_display *display)
 
 	clk_disable_unprepare(res->sclk_hdmi);
 	clk_disable_unprepare(res->hdmi);
-	clk_disable_unprepare(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 
 	pm_runtime_put_sync(hdata->dev);
@@ -1977,9 +1978,9 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
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
 	res->mout_hdmi = devm_clk_get(dev, "mout_hdmi");
-- 
1.7.9.5

