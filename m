Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaHEPbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:31:43 -0400
Received: from mail-by2lp0243.outbound.protection.outlook.com ([207.46.163.243]:9831
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751885AbaHEPbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:31:40 -0400
X-WSS-ID: 0N9UB4N-08-QZ9-02
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
Subject: [PATCH v3 01/23] drm/radeon: reduce number of free VMIDs and pipes in KV
Date: Tue, 5 Aug 2014 18:30:29 +0300
Message-ID: <1407252651-3539-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
References: <1407252651-3539-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(86362001)(575784001)(104166001)(31966008)(50986999)(81342001)(81542001)(102836001)(85306004)(50226001)(4396001)(62966002)(77982001)(79102001)(83072002)(76482001)(92566001)(88136002)(97736001)(68736004)(92726001)(89996001)(77096002)(85852003)(107046002)(105586002)(229853001)(33646002)(106466001)(19580395003)(21056001)(101416001)(95666004)(44976005)(84676001)(48376002)(87286001)(50466002)(77156001)(36756003)(76176999)(47776003)(64706001)(46102001)(83322001)(99396002)(19580405001)(80022001)(87936001)(74662001)(74502001)(20776003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB038;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02945962BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support HSA on KV, we need to limit the number of vmids and pipes
that are available for radeon's use with KV.

This patch reserves VMIDs 8-15 for amdkfd (so radeon can only use VMIDs
0-7) and also makes radeon thinks that KV has only a single MEC with a single
pipe in it

(v3) Use define for static vmid allocation in radeon

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c  | 48 +++++++++++++++++++++----------------------
 drivers/gpu/drm/radeon/cikd.h |  2 ++
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index b625646..9571be8 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4660,12 +4660,11 @@ static int cik_mec_init(struct radeon_device *rdev)
 	/*
 	 * KV:    2 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 64 Queues total
 	 * CI/KB: 1 MEC, 4 Pipes/MEC, 8 Queues/Pipe - 32 Queues total
+	 * Nonetheless, we assign only 1 pipe because all other pipes will
+	 * be handled by KFD
 	 */
-	if (rdev->family == CHIP_KAVERI)
-		rdev->mec.num_mec = 2;
-	else
-		rdev->mec.num_mec = 1;
-	rdev->mec.num_pipe = 4;
+	rdev->mec.num_mec = 1;
+	rdev->mec.num_pipe = 1;
 	rdev->mec.num_queue = rdev->mec.num_mec * rdev->mec.num_pipe * 8;
 
 	if (rdev->mec.hpd_eop_obj == NULL) {
@@ -4807,28 +4806,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
 
 	/* init the pipes */
 	mutex_lock(&rdev->srbm_mutex);
-	for (i = 0; i < (rdev->mec.num_pipe * rdev->mec.num_mec); i++) {
-		int me = (i < 4) ? 1 : 2;
-		int pipe = (i < 4) ? i : (i - 4);
 
-		eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr + (i * MEC_HPD_SIZE * 2);
+	eop_gpu_addr = rdev->mec.hpd_eop_gpu_addr;
 
-		cik_srbm_select(rdev, me, pipe, 0, 0);
+	cik_srbm_select(rdev, 0, 0, 0, 0);
 
-		/* write the EOP addr */
-		WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
-		WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
+	/* write the EOP addr */
+	WREG32(CP_HPD_EOP_BASE_ADDR, eop_gpu_addr >> 8);
+	WREG32(CP_HPD_EOP_BASE_ADDR_HI, upper_32_bits(eop_gpu_addr) >> 8);
 
-		/* set the VMID assigned */
-		WREG32(CP_HPD_EOP_VMID, 0);
+	/* set the VMID assigned */
+	WREG32(CP_HPD_EOP_VMID, 0);
+
+	/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
+	tmp = RREG32(CP_HPD_EOP_CONTROL);
+	tmp &= ~EOP_SIZE_MASK;
+	tmp |= order_base_2(MEC_HPD_SIZE / 8);
+	WREG32(CP_HPD_EOP_CONTROL, tmp);
 
-		/* set the EOP size, register value is 2^(EOP_SIZE+1) dwords */
-		tmp = RREG32(CP_HPD_EOP_CONTROL);
-		tmp &= ~EOP_SIZE_MASK;
-		tmp |= order_base_2(MEC_HPD_SIZE / 8);
-		WREG32(CP_HPD_EOP_CONTROL, tmp);
-	}
-	cik_srbm_select(rdev, 0, 0, 0, 0);
 	mutex_unlock(&rdev->srbm_mutex);
 
 	/* init the queues.  Just two for now. */
@@ -5874,8 +5869,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
  */
 int cik_vm_init(struct radeon_device *rdev)
 {
-	/* number of VMs */
-	rdev->vm_manager.nvm = 16;
+	/*
+	 * number of VMs
+	 * VMID 0 is reserved for System
+	 * radeon graphics/compute will use VMIDs 1-7
+	 * amdkfd will use VMIDs 8-15
+	 */
+	rdev->vm_manager.nvm = RADEON_NUM_OF_VMIDS;
 	/* base offset of vram pages */
 	if (rdev->flags & RADEON_IS_IGP) {
 		u64 tmp = RREG32(MC_VM_FB_OFFSET);
diff --git a/drivers/gpu/drm/radeon/cikd.h b/drivers/gpu/drm/radeon/cikd.h
index 0c6e1b5..fae4d0c 100644
--- a/drivers/gpu/drm/radeon/cikd.h
+++ b/drivers/gpu/drm/radeon/cikd.h
@@ -30,6 +30,8 @@
 #define CIK_RB_BITMAP_WIDTH_PER_SH     2
 #define HAWAII_RB_BITMAP_WIDTH_PER_SH  4
 
+#define RADEON_NUM_OF_VMIDS	8
+
 /* DIDT IND registers */
 #define DIDT_SQ_CTRL0                                     0x0
 #       define DIDT_CTRL_EN                               (1 << 0)
-- 
1.9.1

