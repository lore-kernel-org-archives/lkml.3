Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaIXVCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:02:08 -0400
Received: from mail-by2on0129.outbound.protection.outlook.com ([207.46.100.129]:52991
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750891AbaIXVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:02:05 -0400
X-WSS-ID: 0NCFB20-08-8F2-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 04/23] drm/radeon: adding synchronization for GRBM GFX
Date: Wed, 24 Sep 2014 23:45:18 +0300
Message-ID: <1411591537-31636-5-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(77156001)(92726001)(104166001)(107046002)(64706001)(86362001)(77982003)(20776003)(47776003)(81342003)(92566001)(93916002)(33646002)(46102003)(74502003)(74662003)(99396003)(68736004)(90102001)(229853001)(81542003)(79102003)(80022003)(62966002)(97736003)(85852003)(77096002)(50466002)(88136002)(95666004)(83072002)(89996001)(76176999)(50986999)(85306004)(48376002)(31966008)(101416001)(4396001)(10300001)(102836001)(50226001)(84676001)(83322001)(19580395003)(19580405001)(87286001)(36756003)(87936001)(76482002)(106466001)(120916001)(44976005)(105586002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR02MB195;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR02MB195;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementing a lock for selecting and accessing shader engines and arrays.
This lock will make sure that radeon and amdkfd are not colliding when
accessing shader engines and arrays with GRBM_GFX_INDEX register.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c           | 26 ++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h        |  2 ++
 drivers/gpu/drm/radeon/radeon_device.c |  1 +
 3 files changed, 29 insertions(+)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index e789988..69b9027 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -1563,6 +1563,8 @@ static const u32 godavari_golden_registers[] =
 
 static void cik_init_golden_registers(struct radeon_device *rdev)
 {
+	/* Some of the registers might be dependant on GRBM_GFX_INDEX */
+	mutex_lock(&rdev->grbm_idx_mutex);
 	switch (rdev->family) {
 	case CHIP_BONAIRE:
 		radeon_program_register_sequence(rdev,
@@ -1637,6 +1639,7 @@ static void cik_init_golden_registers(struct radeon_device *rdev)
 	default:
 		break;
 	}
+	mutex_unlock(&rdev->grbm_idx_mutex);
 }
 
 /**
@@ -3419,6 +3422,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 	u32 disabled_rbs = 0;
 	u32 enabled_rbs = 0;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < se_num; i++) {
 		for (j = 0; j < sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
@@ -3430,6 +3434,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	mask = 1;
 	for (i = 0; i < max_rb_num_per_se * se_num; i++) {
@@ -3440,6 +3445,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 
 	rdev->config.cik.backend_enable_mask = enabled_rbs;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < se_num; i++) {
 		cik_select_se_sh(rdev, i, 0xffffffff);
 		data = 0;
@@ -3467,6 +3473,7 @@ static void cik_setup_rb(struct radeon_device *rdev,
 		WREG32(PA_SC_RASTER_CONFIG, data);
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 }
 
 /**
@@ -3684,6 +3691,12 @@ static void cik_gpu_init(struct radeon_device *rdev)
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
@@ -3739,6 +3752,7 @@ static void cik_gpu_init(struct radeon_device *rdev)
 
 	WREG32(PA_CL_ENHANCE, CLIP_VTX_REORDER_ENA | NUM_CLIP_SEQ(3));
 	WREG32(PA_SC_ENHANCE, ENABLE_PA_SC_OUT_OF_ORDER);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	udelay(50);
 }
@@ -6062,6 +6076,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 	u32 i, j, k;
 	u32 mask;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < rdev->config.cik.max_shader_engines; i++) {
 		for (j = 0; j < rdev->config.cik.max_sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
@@ -6073,6 +6088,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	mask = SE_MASTER_BUSY_MASK | GC_MASTER_BUSY | TC0_MASTER_BUSY | TC1_MASTER_BUSY;
 	for (k = 0; k < rdev->usec_timeout; k++) {
@@ -6207,10 +6223,12 @@ static int cik_rlc_resume(struct radeon_device *rdev)
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
@@ -6277,11 +6295,13 @@ static void cik_enable_cgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		tmp2 = BPM_ADDR_MASK | CGCG_OVERRIDE_0 | CGLS_ENABLE;
 		WREG32(RLC_SERDES_WR_CTRL, tmp2);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6323,11 +6343,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		data = BPM_ADDR_MASK | MGCG_OVERRIDE_0;
 		WREG32(RLC_SERDES_WR_CTRL, data);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6371,11 +6393,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
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
@@ -6804,10 +6828,12 @@ static u32 cik_get_cu_active_bitmap(struct radeon_device *rdev, u32 se, u32 sh)
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
index 67d249a..c30f1fd 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2386,6 +2386,8 @@ struct radeon_device {
 	struct radeon_atcs		atcs;
 	/* srbm instance registers */
 	struct mutex			srbm_mutex;
+	/* GRBM index mutex. Protects concurrents access to GRBM index */
+	struct mutex			grbm_idx_mutex;
 	/* clock, powergating flags */
 	u32 cg_flags;
 	u32 pg_flags;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index da3035f..eca614e 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1299,6 +1299,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	mutex_init(&rdev->pm.mutex);
 	mutex_init(&rdev->gpu_clock_mutex);
 	mutex_init(&rdev->srbm_mutex);
+	mutex_init(&rdev->grbm_idx_mutex);
 	init_rwsem(&rdev->pm.mclk_lock);
 	init_rwsem(&rdev->exclusive_lock);
 	init_waitqueue_head(&rdev->irq.vblank_queue);
-- 
1.9.1

