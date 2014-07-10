Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaGJVzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:55:07 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64953 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbaGJVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:55:03 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Evgeny Pinchuk <evgeny.pinchuk@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 34/83] drm/radeon: adding synchronization for GRBM GFX
Date: Fri, 11 Jul 2014 00:53:50 +0300
Message-Id: <1405029279-6894-6-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
References: <1405029279-6894-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeny Pinchuk <evgeny.pinchuk@amd.com>

Implementing a lock for selecting and accessing shader engines and arrays.
This lock will make sure that drm/radeon and hsa/radeon are not colliding when
accessing shader engines and arrays with GRBM_GFX_INDEX register.

Signed-off-by: Evgeny Pinchuk <evgeny.pinchuk@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c           | 26 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h        |  2 ++
 drivers/gpu/drm/radeon/radeon_device.c |  1 +
 drivers/gpu/drm/radeon/radeon_kfd.c    | 23 +++++++++++++++++++++++
 include/linux/radeon_kfd.h             |  4 ++++
 5 files changed, 56 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 6f4999a..fc560b0 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1566,6 +1566,8 @@ static const u32 godavari_golden_registers[] =
 
 static void cik_init_golden_registers(struct radeon_device *rdev)
 {
+	/* Some of the registers might be dependant on GRBM_GFX_INDEX */
+	mutex_lock(&rdev->grbm_idx_mutex);
 	switch (rdev->family) {
 	case CHIP_BONAIRE:
 		radeon_program_register_sequence(rdev,
@@ -1640,6 +1642,7 @@ static void cik_init_golden_registers(struct radeon_device *rdev)
 	default:
 		break;
 	}
+	mutex_unlock(&rdev->grbm_idx_mutex);
 }
 
 /**
@@ -3421,6 +3424,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 	u32 disabled_rbs = 0;
 	u32 enabled_rbs = 0;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < se_num; i++) {
 		for (j = 0; j < sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
@@ -3432,6 +3436,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	mask = 1;
 	for (i = 0; i < max_rb_num_per_se * se_num; i++) {
@@ -3442,6 +3447,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 
 	rdev->config.cik.backend_enable_mask = enabled_rbs;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < se_num; i++) {
 		cik_select_se_sh(rdev, i, 0xffffffff);
 		data = 0;
@@ -3469,6 +3475,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 		WREG32(PA_SC_RASTER_CONFIG, data);
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 }
 
 /**
@@ -3686,6 +3693,12 @@ static void cik_gpu_init(struct radeon_device *rdev)
 	/* set HW defaults for 3D engine */
 	WREG32(CP_MEQ_THRESHOLDS, MEQ1_START(0x30) | MEQ2_START(0x60));
 
+	mutex_lock(&rdev->grbm_idx_mutex);
+	/*
+	 * making sure that the following register writes will be broadcasted
+	 * to all the shaders
+	 */
+	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 	WREG32(SX_DEBUG_1, 0x20);
 
 	WREG32(TA_CNTL_AUX, 0x00010000);
@@ -3741,6 +3754,7 @@ static void cik_gpu_init(struct radeon_device *rdev)
 
 	WREG32(PA_CL_ENHANCE, CLIP_VTX_REORDER_ENA | NUM_CLIP_SEQ(3));
 	WREG32(PA_SC_ENHANCE, ENABLE_PA_SC_OUT_OF_ORDER);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	udelay(50);
 }
@@ -6040,6 +6054,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 	u32 i, j, k;
 	u32 mask;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < rdev->config.cik.max_shader_engines; i++) {
 		for (j = 0; j < rdev->config.cik.max_sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
@@ -6051,6 +6066,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	mask = SE_MASTER_BUSY_MASK | GC_MASTER_BUSY | TC0_MASTER_BUSY | TC1_MASTER_BUSY;
 	for (k = 0; k < rdev->usec_timeout; k++) {
@@ -6185,10 +6201,12 @@ static int cik_rlc_resume(struct radeon_device *rdev)
 	WREG32(RLC_LB_CNTR_INIT, 0);
 	WREG32(RLC_LB_CNTR_MAX, 0x00008000);
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 	WREG32(RLC_LB_INIT_CU_MASK, 0xffffffff);
 	WREG32(RLC_LB_PARAMS, 0x00600408);
 	WREG32(RLC_LB_CNTL, 0x80000004);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	WREG32(RLC_MC_CNTL, 0);
 	WREG32(RLC_UCODE_CNTL, 0);
@@ -6255,11 +6273,13 @@ static void cik_enable_cgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		tmp2 = BPM_ADDR_MASK | CGCG_OVERRIDE_0 | CGLS_ENABLE;
 		WREG32(RLC_SERDES_WR_CTRL, tmp2);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6301,11 +6321,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		data = BPM_ADDR_MASK | MGCG_OVERRIDE_0;
 		WREG32(RLC_SERDES_WR_CTRL, data);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6349,11 +6371,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		data = BPM_ADDR_MASK | MGCG_OVERRIDE_1;
 		WREG32(RLC_SERDES_WR_CTRL, data);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 	}
@@ -6786,10 +6810,12 @@ static u32 cik_get_cu_active_bitmap(struct radeon_device *rdev, u32 se, u32 sh)
 	u32 mask = 0, tmp, tmp1;
 	int i;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	cik_select_se_sh(rdev, se, sh);
 	tmp = RREG32(CC_GC_SHADER_ARRAY_CONFIG);
 	tmp1 = RREG32(GC_USER_SHADER_ARRAY_CONFIG);
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	tmp &= 0xffff0000;
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 90f66bb..94b38a7 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2334,6 +2334,8 @@ struct radeon_device {
 	struct radeon_atcs		atcs;
 	/* srbm instance registers */
 	struct mutex			srbm_mutex;
+	/* GRBM index mutex. Protects concurrents access to GRBM index */
+	struct mutex			grbm_idx_mutex;
 	/* clock, powergating flags */
 	u32 cg_flags;
 	u32 pg_flags;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 98538d2..1b8b8b7 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1258,6 +1258,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	mutex_init(&rdev->pm.mutex);
 	mutex_init(&rdev->gpu_clock_mutex);
 	mutex_init(&rdev->srbm_mutex);
+	mutex_init(&rdev->grbm_idx_mutex);
 	init_rwsem(&rdev->pm.mclk_lock);
 	init_rwsem(&rdev->exclusive_lock);
 	init_waitqueue_head(&rdev->irq.vblank_queue);
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index 121e67b..6dba170 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -47,6 +47,9 @@ static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd);
 static void lock_srbm_gfx_cntl(struct kgd_dev *kgd);
 static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd);
 
+static void lock_grbm_gfx_idx(struct kgd_dev *kgd);
+static void unlock_grbm_gfx_idx(struct kgd_dev *kgd);
+
 
 static const struct kfd2kgd_calls kfd2kgd = {
 	.allocate_mem = allocate_mem,
@@ -59,6 +62,8 @@ static const struct kfd2kgd_calls kfd2kgd = {
 	.get_gpu_clock_counter = get_gpu_clock_counter,
 	.lock_srbm_gfx_cntl = lock_srbm_gfx_cntl,
 	.unlock_srbm_gfx_cntl = unlock_srbm_gfx_cntl,
+	.lock_grbm_gfx_idx = lock_grbm_gfx_idx,
+	.unlock_grbm_gfx_idx = unlock_grbm_gfx_idx,
 };
 
 static const struct kgd2kfd_calls *kgd2kfd;
@@ -278,6 +283,24 @@ static void unlock_srbm_gfx_cntl(struct kgd_dev *kgd)
 	mutex_unlock(&rdev->srbm_mutex);
 }
 
+static void lock_grbm_gfx_idx(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	mutex_lock(&rdev->grbm_idx_mutex);
+}
+
+static void unlock_grbm_gfx_idx(struct kgd_dev *kgd)
+{
+	struct radeon_device *rdev = (struct radeon_device *)kgd;
+
+	BUG_ON(kgd == NULL);
+
+	mutex_unlock(&rdev->grbm_idx_mutex);
+}
+
 static uint64_t get_gpu_clock_counter(struct kgd_dev *kgd)
 {
 	struct radeon_device *rdev = (struct radeon_device *)kgd;
diff --git a/include/linux/radeon_kfd.h b/include/linux/radeon_kfd.h
index fcb6c7a..4c7e923 100644
--- a/include/linux/radeon_kfd.h
+++ b/include/linux/radeon_kfd.h
@@ -89,6 +89,10 @@ struct kfd2kgd_calls {
 	/* SRBM_GFX_CNTL mutex */
 	void (*lock_srbm_gfx_cntl)(struct kgd_dev *kgd);
 	void (*unlock_srbm_gfx_cntl)(struct kgd_dev *kgd);
+
+	/* GRBM_GFX_INDEX mutex */
+	void (*lock_grbm_gfx_idx)(struct kgd_dev *kgd);
+	void (*unlock_grbm_gfx_idx)(struct kgd_dev *kgd);
 };
 
 bool kgd2kfd_init(unsigned interface_version,
-- 
1.9.1

