Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbaLWKlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:41:24 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17968 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869AbaLWKkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:31 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:48 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH nouveau 09/11] drm: export some variable and functions to resue the PM functions
Date: Tue, 23 Dec 2014 18:40:02 +0800
Message-ID: <1419331204-26679-10-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some checks in the suspend/resume functions to distinguish
the dGPU and mobile GPU and exports some variables/functions so that the
nouveau platform device can reuse them.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
 drm/nouveau_drm.c | 16 +++++++++++-----
 drm/nouveau_drm.h |  2 ++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drm/nouveau_drm.c b/drm/nouveau_drm.c
index afb93bb72f97..0ed99ef80211 100644
--- a/drm/nouveau_drm.c
+++ b/drm/nouveau_drm.c
@@ -72,6 +72,7 @@ module_param_named(modeset, nouveau_modeset, int, 0400);
 
 MODULE_PARM_DESC(runpm, "disable (0), force enable (1), optimus only default (-1)");
 int nouveau_runtime_pm = -1;
+EXPORT_SYMBOL(nouveau_runtime_pm);
 module_param_named(runpm, nouveau_runtime_pm, int, 0400);
 
 static struct drm_driver driver_stub;
@@ -543,7 +544,7 @@ nouveau_drm_remove(struct pci_dev *pdev)
 	nouveau_drm_device_remove(dev);
 }
 
-static int
+int
 nouveau_do_suspend(struct drm_device *dev, bool runtime)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
@@ -559,8 +560,10 @@ nouveau_do_suspend(struct drm_device *dev, bool runtime)
 			return ret;
 	}
 
-	NV_INFO(drm, "evicting buffers...\n");
-	ttm_bo_evict_mm(&drm->ttm.bdev, TTM_PL_VRAM);
+	if (dev->pdev) {
+		NV_INFO(drm, "evicting buffers...\n");
+		ttm_bo_evict_mm(&drm->ttm.bdev, TTM_PL_VRAM);
+	}
 
 	NV_INFO(drm, "waiting for kernel channels to go idle...\n");
 	if (drm->cechan) {
@@ -612,8 +615,9 @@ fail_display:
 	}
 	return ret;
 }
+EXPORT_SYMBOL(nouveau_do_suspend);
 
-static int
+int
 nouveau_do_resume(struct drm_device *dev, bool runtime)
 {
 	struct nouveau_drm *drm = nouveau_drm(dev);
@@ -635,7 +639,8 @@ nouveau_do_resume(struct drm_device *dev, bool runtime)
 		nvif_client_resume(&cli->base);
 	}
 
-	nouveau_run_vbios_init(dev);
+	if (dev->pdev)
+		nouveau_run_vbios_init(dev);
 
 	if (dev->mode_config.num_crtc) {
 		NV_INFO(drm, "resuming display...\n");
@@ -646,6 +651,7 @@ nouveau_do_resume(struct drm_device *dev, bool runtime)
 
 	return 0;
 }
+EXPORT_SYMBOL(nouveau_do_resume);
 
 int
 nouveau_pmops_suspend(struct device *dev)
diff --git a/drm/nouveau_drm.h b/drm/nouveau_drm.h
index 8ae36f265fb8..897d295dd1e3 100644
--- a/drm/nouveau_drm.h
+++ b/drm/nouveau_drm.h
@@ -177,6 +177,8 @@ nouveau_drm(struct drm_device *dev)
 
 int nouveau_pmops_suspend(struct device *);
 int nouveau_pmops_resume(struct device *);
+int nouveau_do_suspend(struct drm_device *dev, bool runtime);
+int nouveau_do_resume(struct drm_device *dev, bool runtime);
 
 #define nouveau_platform_device_create(p, u)                                   \
 	nouveau_platform_device_create_(p, sizeof(**u), (void **)u)
-- 
1.9.1

