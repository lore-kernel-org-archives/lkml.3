Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbaLWKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:36 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18063 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbaLWKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 23 Dec 2014 02:35:24 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 10/11] platform: add suspend/resume support
Date: Tue, 23 Dec 2014 18:40:03 +0800
Message-ID: <1419331204-26679-11-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reuse most of the suspend/resume functions of the dGPU for nouveau
platform device. Only the power up/down sequences need to be handled
separately.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/nouveau_platform.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
index 527fe2358fc9..51bfce59c498 100644
--- a/drm/nouveau_platform.c
+++ b/drm/nouveau_platform.c
@@ -211,6 +211,65 @@ static const struct of_device_id nouveau_platform_match[] = {
 MODULE_DEVICE_TABLE(of, nouveau_platform_match);
 #endif
 
+static int
+nouveau_platform_pmops_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct drm_device *drm_dev = platform_get_drvdata(pdev);
+	struct nouveau_drm *drm = nouveau_drm(drm_dev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct nouveau_platform_gpu *gpu = nv_device_to_platform(device)->gpu;
+	int ret;
+
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
+	    drm_dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
+		return 0;
+
+	ret = nouveau_do_suspend(drm_dev, false);
+	if (ret)
+		return ret;
+
+	ret = nouveau_platform_power_down(gpu);
+	if (ret) {
+		dev_err(dev, "failed to power down gpu (err:%d)\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int
+nouveau_platform_pmops_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct drm_device *drm_dev = platform_get_drvdata(pdev);
+	struct nouveau_drm *drm = nouveau_drm(drm_dev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct nouveau_platform_gpu *gpu = nv_device_to_platform(device)->gpu;
+	int ret;
+
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF ||
+	    drm_dev->switch_power_state == DRM_SWITCH_POWER_DYNAMIC_OFF)
+		return 0;
+
+	ret = nouveau_platform_power_up(gpu);
+	if (ret) {
+		dev_err(dev, "failed to power up gpu\n");
+		return ret;
+	}
+
+	ret = nouveau_do_resume(drm_dev, false);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static const struct dev_pm_ops nouveau_platform_pm_ops = {
+	.suspend = nouveau_platform_pmops_suspend,
+	.resume = nouveau_platform_pmops_resume,
+};
+
 struct platform_driver nouveau_platform_driver = {
 	.driver = {
 		.name = "nouveau",
@@ -218,6 +277,7 @@ struct platform_driver nouveau_platform_driver = {
 	},
 	.probe = nouveau_platform_probe,
 	.remove = nouveau_platform_remove,
+	.driver.pm = &nouveau_platform_pm_ops,
 };
 
 module_platform_driver(nouveau_platform_driver);
-- 
1.9.1

