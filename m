Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaAOWfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:35:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaAOVyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 120/166] drm/radeon: expose render backend mask to the userspace
Date: Wed, 15 Jan 2014 13:52:14 -0800
Message-Id: <1389822780-4729-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>

commit 439a1cfffe2c1a06e5a6394ccd5d18a8e89b15d3 upstream.

This will allow userspace to correctly program the PA_SC_RASTER_CONFIG
register, so it can be considered a fix.

Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ kamal: backport to 3.8 (SI only, no CIK in 3.8; context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon.h     | 2 +-
 drivers/gpu/drm/radeon/radeon_kms.c | 7 +++++++
 drivers/gpu/drm/radeon/si.c         | 2 ++
 include/uapi/drm/radeon_drm.h       | 2 ++
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index aa2d2e2..b2cfbf1 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1418,7 +1418,7 @@ struct si_asic {
 	unsigned sc_earlyz_tile_fifo_size;
 
 	unsigned num_tile_pipes;
-	unsigned num_backends_per_se;
+	unsigned backend_enable_mask;
 	unsigned backend_disable_mask_per_asic;
 	unsigned backend_map;
 	unsigned num_texture_channel_caches;
diff --git a/drivers/gpu/drm/radeon/radeon_kms.c b/drivers/gpu/drm/radeon/radeon_kms.c
index 799ce63..2e9209c 100644
--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -384,6 +384,13 @@ int radeon_info_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	case RADEON_INFO_SI_CP_DMA_COMPUTE:
 		value = 1;
 		break;
+	case RADEON_INFO_SI_BACKEND_ENABLED_MASK:
+		if (rdev->family >= CHIP_TAHITI) {
+			value = rdev->config.si.backend_enable_mask;
+		} else {
+			DRM_DEBUG_KMS("BACKEND_ENABLED_MASK is si+ only!\n");
+		}
+		break;
 	default:
 		DRM_DEBUG_KMS("Invalid request %d\n", info->request);
 		return -EINVAL;
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 0746272..c2c14d6 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1500,6 +1500,8 @@ static void si_setup_rb(struct radeon_device *rdev,
 		mask <<= 1;
 	}
 
+	rdev->config.si.backend_enable_mask = enabled_rbs;
+
 	for (i = 0; i < se_num; i++) {
 		si_select_se_sh(rdev, i, 0xffffffff);
 		data = 0;
diff --git a/include/uapi/drm/radeon_drm.h b/include/uapi/drm/radeon_drm.h
index 59c1b31..753b4e1 100644
--- a/include/uapi/drm/radeon_drm.h
+++ b/include/uapi/drm/radeon_drm.h
@@ -974,6 +974,8 @@ struct drm_radeon_cs {
 #define RADEON_INFO_MAX_SH_PER_SE	0x13
 /* query if CP DMA is supported on the compute ring */
 #define RADEON_INFO_SI_CP_DMA_COMPUTE	0x17
+/* query the number of render backends */
+#define RADEON_INFO_SI_BACKEND_ENABLED_MASK	0x19
 
 
 struct drm_radeon_info {
-- 
1.8.3.2

