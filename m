Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbaHEPc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:32:26 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:26902
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755618AbaHEPcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:32:23 -0400
X-WSS-ID: 0N9UB5B-08-R0X-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "David Airlie" <airlied@linux.ie>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>,
        Alexander Deucher <alexdeucher@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <John.Bridgman@amd.com>,
        "Joerg Roedel" <joro@8bytes.org>, <Andrew.Lewycky@amd.com>,
        <deathsimple@vodafone.de>, <michel.daenzer@amd.com>,
        Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH v3 04/23] drm/radeon: adding synchronization for GRBM GFX
Date: Tue, 5 Aug 2014 18:30:32 +0300
Message-ID: <1407252651-3539-5-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(86362001)(104166001)(31966008)(50986999)(81342001)(81542001)(102836001)(85306004)(50226001)(4396001)(62966002)(77982001)(79102001)(83072002)(76482001)(92566001)(88136002)(97736001)(68736004)(92726001)(89996001)(77096002)(85852003)(107046002)(105586002)(229853001)(33646002)(106466001)(19580395003)(21056001)(101416001)(95666004)(44976005)(84676001)(48376002)(87286001)(50466002)(77156001)(36756003)(76176999)(47776003)(64706001)(46102001)(83322001)(99396002)(19580405001)(80022001)(87936001)(74662001)(74502001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
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
index d54d3d7..0096538 100644
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
@@ -6036,6 +6050,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 	u32 i, j, k;
 	u32 mask;
 
+	mutex_lock(&rdev->grbm_idx_mutex);
 	for (i = 0; i < rdev->config.cik.max_shader_engines; i++) {
 		for (j = 0; j < rdev->config.cik.max_sh_per_se; j++) {
 			cik_select_se_sh(rdev, i, j);
@@ -6047,6 +6062,7 @@ static void cik_wait_for_rlc_serdes(struct radeon_device *rdev)
 		}
 	}
 	cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
+	mutex_unlock(&rdev->grbm_idx_mutex);
 
 	mask = SE_MASTER_BUSY_MASK | GC_MASTER_BUSY | TC0_MASTER_BUSY | TC1_MASTER_BUSY;
 	for (k = 0; k < rdev->usec_timeout; k++) {
@@ -6181,10 +6197,12 @@ static int cik_rlc_resume(struct radeon_device *rdev)
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
@@ -6251,11 +6269,13 @@ static void cik_enable_cgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		tmp2 = BPM_ADDR_MASK | CGCG_OVERRIDE_0 | CGLS_ENABLE;
 		WREG32(RLC_SERDES_WR_CTRL, tmp2);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6297,11 +6317,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
 		tmp = cik_halt_rlc(rdev);
 
+		mutex_lock(&rdev->grbm_idx_mutex);
 		cik_select_se_sh(rdev, 0xffffffff, 0xffffffff);
 		WREG32(RLC_SERDES_WR_CU_MASTER_MASK, 0xffffffff);
 		WREG32(RLC_SERDES_WR_NONCU_MASTER_MASK, 0xffffffff);
 		data = BPM_ADDR_MASK | MGCG_OVERRIDE_0;
 		WREG32(RLC_SERDES_WR_CTRL, data);
+		mutex_unlock(&rdev->grbm_idx_mutex);
 
 		cik_update_rlc(rdev, tmp);
 
@@ -6345,11 +6367,13 @@ static void cik_enable_mgcg(struct radeon_device *rdev, bool enable)
 
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
@@ -6778,10 +6802,12 @@ static u32 cik_get_cu_active_bitmap(struct radeon_device *rdev, u32 se, u32 sh)
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
index 75bcc04..e420557 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -2374,6 +2374,8 @@ struct radeon_device {
 	struct radeon_atcs		atcs;
 	/* srbm instance registers */
 	struct mutex			srbm_mutex;
+	/* GRBM index mutex. Protects concurrents access to GRBM index */
+	struct mutex			grbm_idx_mutex;
 	/* clock, powergating flags */
 	u32 cg_flags;
 	u32 pg_flags;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 827bcd1..b80100d 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1298,6 +1298,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	mutex_init(&rdev->pm.mutex);
 	mutex_init(&rdev->gpu_clock_mutex);
 	mutex_init(&rdev->srbm_mutex);
+	mutex_init(&rdev->grbm_idx_mutex);
 	init_rwsem(&rdev->pm.mclk_lock);
 	init_rwsem(&rdev->exclusive_lock);
 	init_waitqueue_head(&rdev->irq.vblank_queue);
-- 
1.9.1

