Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaGQNb2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:31:28 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:16920
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932139AbaGQNb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:31:26 -0400
X-WSS-ID: 0N8UYW8-08-6U1-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Jerome Glisse <j.glisse@gmail.com>,
        "Alex Deucher" <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Oded Gabbay" <oded.gabbay@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 02/25] drm/radeon: reduce number of free VMIDs and pipes in KV
Date: Thu, 17 Jul 2014 16:29:09 +0300
Message-ID: <1405603773-32688-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(74502001)(107046002)(102836001)(76176999)(48376002)(47776003)(50986999)(64706001)(20776003)(104166001)(62966002)(84676001)(21056001)(95666004)(74662001)(77096002)(4396001)(33646002)(85306003)(106466001)(87286001)(50226001)(229853001)(89996001)(87936001)(105586002)(77982001)(79102001)(50466002)(97736001)(80022001)(88136002)(77156001)(36756003)(101416001)(46102001)(76482001)(85852003)(19580405001)(81542001)(83322001)(19580395003)(68736004)(83072002)(99396002)(44976005)(92726001)(92566001)(86362001)(93916002)(81342001)(31966008);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR02MB036;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
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

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c | 48 ++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 4bfc2c0..0b53633 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4662,12 +4662,11 @@ static int cik_mec_init(struct radeon_device *rdev)
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
@@ -4809,28 +4808,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
 
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
@@ -5876,8 +5871,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
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
+	rdev->vm_manager.nvm = 8;
 	/* base offset of vram pages */
 	if (rdev->flags & RADEON_IS_IGP) {
 		u64 tmp = RREG32(MC_VM_FB_OFFSET);
-- 
1.9.1

