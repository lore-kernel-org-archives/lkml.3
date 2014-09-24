Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914AbaIXVA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:00:56 -0400
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:23776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbaIXVAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:00:54 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 17:00:54 EDT
X-WSS-ID: 0NCFB18-08-8DK-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 01/23] drm/radeon: reduce number of free VMIDs and pipes in KV
Date: Wed, 24 Sep 2014 23:45:15 +0300
Message-ID: <1411591537-31636-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(95666004)(47776003)(229853001)(77096002)(92566001)(105586002)(92726001)(76482002)(106466001)(97736003)(120916001)(99396003)(107046002)(31966008)(36756003)(83072002)(64706001)(20776003)(104166001)(4396001)(77156001)(101416001)(19580395003)(81542003)(68736004)(48376002)(83322001)(90102001)(74502003)(77982003)(93916002)(89996001)(44976005)(33646002)(80022003)(50226001)(46102003)(102836001)(62966002)(85306004)(87936001)(21056001)(50466002)(79102003)(84676001)(76176999)(19580405001)(575784001)(74662003)(88136002)(81342003)(85852003)(50986999)(86362001)(10300001)(87286001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB204;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB204;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB123;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support HSA on KV, we need to limit the number of vmids and pipes
that are available for radeon's use with KV.

This patch reserves VMIDs 8-15 for amdkfd (so radeon can only use VMIDs
0-7) and also makes radeon thinks that KV has only a single MEC with a single
pipe in it

v3: Use define for static vmid allocation in radeon

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/cik.c  | 48 +++++++++++++++++++++----------------------
 drivers/gpu/drm/radeon/cikd.h |  2 ++
 2 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 0d761f7..1530e37 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4678,12 +4678,11 @@ static int cik_mec_init(struct radeon_device *rdev)
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
@@ -4825,28 +4824,24 @@ static int cik_cp_compute_resume(struct radeon_device *rdev)
 
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
@@ -5900,8 +5895,13 @@ int cik_ib_parse(struct radeon_device *rdev, struct radeon_ib *ib)
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

