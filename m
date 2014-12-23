Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaLWKkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:40 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12488 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbaLWKkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:54 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 11/11] platform: add PM runtime suspend/resume support
Date: Tue, 23 Dec 2014 18:40:04 +0800
Message-ID: <1419331204-26679-12-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runtime suspend/resume flow is almost the same as the suspend/resume
except the the arguments passed to nouveau_do_{suspend,resume}.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/nouveau_platform.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
index 51bfce59c498..c71c62081b9c 100644
--- a/drm/nouveau_platform.c
+++ b/drm/nouveau_platform.c
@@ -177,6 +177,9 @@ static int nouveau_platform_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_unref;
 
+	if (nouveau_runtime_pm != 0)
+		pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
 err_unref:
@@ -197,6 +200,9 @@ static int nouveau_platform_remove(struct platform_device *pdev)
 	struct nouveau_device *device = nvkm_device(&drm->device);
 	struct nouveau_platform_gpu *gpu = nv_device_to_platform(device)->gpu;
 
+	if (nouveau_runtime_pm != 0)
+		pm_runtime_disable(&pdev->dev);
+
 	nouveau_drm_device_remove(drm_dev);
 
 	return nouveau_platform_power_down(gpu);
@@ -265,9 +271,73 @@ nouveau_platform_pmops_resume(struct device *dev)
 	return 0;
 }
 
+static int
+nouveau_platform_pmops_runtime_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct drm_device *drm_dev = platform_get_drvdata(pdev);
+	struct nouveau_drm *drm = nouveau_drm(drm_dev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct nouveau_platform_gpu *gpu = nv_device_to_platform(device)->gpu;
+	int ret;
+
+	ret = nouveau_do_suspend(drm_dev, true);
+	if (ret) {
+		dev_err(dev, "failed to suspend drm device (err:%d)\n", ret);
+		return ret;
+	}
+
+	ret = nouveau_platform_power_down(gpu);
+	if (ret) {
+		dev_err(dev, "failed to power down gpu (err:%d)\n", ret);
+		return ret;
+	}
+
+	drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
+	return ret;
+}
+
+static int
+nouveau_platform_pmops_runtime_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct drm_device *drm_dev = platform_get_drvdata(pdev);
+	struct nouveau_drm *drm = nouveau_drm(drm_dev);
+	struct nouveau_device *device = nvkm_device(&drm->device);
+	struct nouveau_platform_gpu *gpu = nv_device_to_platform(device)->gpu;
+	int ret;
+
+	ret = nouveau_platform_power_up(gpu);
+	if (ret) {
+		dev_err(dev, "failed to power up gpu\n");
+		return ret;
+	}
+
+	ret = nouveau_do_resume(drm_dev, true);
+	if (ret) {
+		dev_err(dev, "failed to resume\n");
+		return ret;
+	}
+
+	drm_dev->switch_power_state = DRM_SWITCH_POWER_ON;
+	return ret;
+}
+
+static int
+nouveau_platform_pmops_runtime_idle(struct device *dev)
+{
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_autosuspend(dev);
+
+	return 1;
+}
+
 static const struct dev_pm_ops nouveau_platform_pm_ops = {
 	.suspend = nouveau_platform_pmops_suspend,
 	.resume = nouveau_platform_pmops_resume,
+	.runtime_suspend = nouveau_platform_pmops_runtime_suspend,
+	.runtime_resume = nouveau_platform_pmops_runtime_resume,
+	.runtime_idle = nouveau_platform_pmops_runtime_idle,
 };
 
 struct platform_driver nouveau_platform_driver = {
-- 
1.9.1

