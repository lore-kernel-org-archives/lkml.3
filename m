Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbaIXQqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:46:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:49482 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbaIXQqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:46:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="scan'208";a="604749282"
From: Vinod Koul <vinod.koul@intel.com>
To: linux-kernel@vger.kernel.org
Cc: subhransu.s.prusty@intel.com, vinod.koul@intel.com,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 06/27] drm/radeon: use pm_runtime_last_busy_and_autosuspend helper
Date: Wed, 24 Sep 2014 21:44:56 +0530
Message-Id: <1411575342-31048-7-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
coding the same code

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/gpu/drm/radeon/radeon_connectors.c |   15 +++++----------
 drivers/gpu/drm/radeon/radeon_drv.c        |    5 ++---
 drivers/gpu/drm/radeon/radeon_kms.c        |    6 ++----
 3 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 300c4b3..b48cf9d 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -852,8 +852,7 @@ radeon_lvds_detect(struct drm_connector *connector, bool force)
 	/* check acpi lid status ??? */
 
 	radeon_connector_update_scratch_regs(connector, ret);
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 	return ret;
 }
 
@@ -1025,8 +1024,7 @@ radeon_vga_detect(struct drm_connector *connector, bool force)
 	radeon_connector_update_scratch_regs(connector, ret);
 
 out:
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 
 	return ret;
 }
@@ -1103,8 +1101,7 @@ radeon_tv_detect(struct drm_connector *connector, bool force)
 	if (ret == connector_status_connected)
 		ret = radeon_connector_analog_encoder_conflict_solve(connector, encoder, ret, false);
 	radeon_connector_update_scratch_regs(connector, ret);
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 	return ret;
 }
 
@@ -1321,8 +1318,7 @@ out:
 	radeon_connector_update_scratch_regs(connector, ret);
 
 exit:
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 
 	return ret;
 }
@@ -1638,8 +1634,7 @@ radeon_dp_detect(struct drm_connector *connector, bool force)
 
 	radeon_connector_update_scratch_regs(connector, ret);
 out:
-	pm_runtime_mark_last_busy(connector->dev->dev);
-	pm_runtime_put_autosuspend(connector->dev->dev);
+	pm_runtime_last_busy_and_autosuspend(connector->dev->dev);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 092d067..548d129 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -503,9 +503,8 @@ long radeon_drm_ioctl(struct file *filp,
 		return ret;
 
 	ret = drm_ioctl(filp, cmd, arg);
-	
-	pm_runtime_mark_last_busy(dev->dev);
-	pm_runtime_put_autosuspend(dev->dev);
+
+	pm_runtime_last_busy_and_autosuspend(dev->dev);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index eb7164d..80f061d 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -147,8 +147,7 @@ int radeon_driver_load_kms(struct drm_device *dev, unsigned long flags)
 		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
 		pm_runtime_set_active(dev->dev);
 		pm_runtime_allow(dev->dev);
-		pm_runtime_mark_last_busy(dev->dev);
-		pm_runtime_put_autosuspend(dev->dev);
+		pm_runtime_last_busy_and_autosuspend(dev->dev);
 	}
 
 out:
@@ -632,8 +631,7 @@ int radeon_driver_open_kms(struct drm_device *dev, struct drm_file *file_priv)
 		file_priv->driver_priv = fpriv;
 	}
 
-	pm_runtime_mark_last_busy(dev->dev);
-	pm_runtime_put_autosuspend(dev->dev);
+	pm_runtime_last_busy_and_autosuspend(dev->dev);
 	return 0;
 }
 
-- 
1.7.0.4

