Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaDALoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:44:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaDALSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:08 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 096/144] drm/radeon/cik: stop the sdma engines in the enable() function
Date: Tue,  1 Apr 2014 12:15:00 +0100
Message-Id: <1396350948-29910-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 07ae78c9798b79bad3d3adf983c94ba23fde54d4 upstream.

We always stop the rings when disabling the engines so just
call the stop functions directly from the sdma enable function.
This way the rings' status is set correctly on suspend so
there are no problems on resume.  Fixes resume failures that
result in acceleration getting disabled.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.11:
  - affected code is in file cik.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 405bf0c..403aecb 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -3378,6 +3378,11 @@ static void cik_sdma_enable(struct radeon_device *rdev, bool enable)
 	u32 me_cntl, reg_offset;
 	int i;
 
+	if (enable == false) {
+		cik_sdma_gfx_stop(rdev);
+		cik_sdma_rlc_stop(rdev);
+	}
+
 	for (i = 0; i < 2; i++) {
 		if (i == 0)
 			reg_offset = SDMA0_REGISTER_OFFSET;
@@ -3505,10 +3510,6 @@ static int cik_sdma_load_microcode(struct radeon_device *rdev)
 	if (!rdev->sdma_fw)
 		return -EINVAL;
 
-	/* stop the gfx rings and rlc compute queues */
-	cik_sdma_gfx_stop(rdev);
-	cik_sdma_rlc_stop(rdev);
-
 	/* halt the MEs */
 	cik_sdma_enable(rdev, false);
 
@@ -3577,9 +3578,6 @@ static int cik_sdma_resume(struct radeon_device *rdev)
  */
 static void cik_sdma_fini(struct radeon_device *rdev)
 {
-	/* stop the gfx rings and rlc compute queues */
-	cik_sdma_gfx_stop(rdev);
-	cik_sdma_rlc_stop(rdev);
 	/* halt the MEs */
 	cik_sdma_enable(rdev, false);
 	radeon_ring_fini(rdev, &rdev->ring[R600_RING_TYPE_DMA_INDEX]);
-- 
1.9.1

