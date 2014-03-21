Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966214AbaCUBBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:01:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965429AbaCUAEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 106/149] drm/radeon/cik: stop the sdma engines in the enable() function
Date: Thu, 20 Mar 2014 17:04:29 -0700
Message-Id: <20140321000440.636072157@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 07ae78c9798b79bad3d3adf983c94ba23fde54d4 upstream.

We always stop the rings when disabling the engines so just
call the stop functions directly from the sdma enable function.
This way the rings' status is set correctly on suspend so
there are no problems on resume.  Fixes resume failures that
result in acceleration getting disabled.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/cik_sdma.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/radeon/cik_sdma.c
+++ b/drivers/gpu/drm/radeon/cik_sdma.c
@@ -222,6 +222,11 @@ void cik_sdma_enable(struct radeon_devic
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
@@ -349,10 +354,6 @@ static int cik_sdma_load_microcode(struc
 	if (!rdev->sdma_fw)
 		return -EINVAL;
 
-	/* stop the gfx rings and rlc compute queues */
-	cik_sdma_gfx_stop(rdev);
-	cik_sdma_rlc_stop(rdev);
-
 	/* halt the MEs */
 	cik_sdma_enable(rdev, false);
 
@@ -421,9 +422,6 @@ int cik_sdma_resume(struct radeon_device
  */
 void cik_sdma_fini(struct radeon_device *rdev)
 {
-	/* stop the gfx rings and rlc compute queues */
-	cik_sdma_gfx_stop(rdev);
-	cik_sdma_rlc_stop(rdev);
 	/* halt the MEs */
 	cik_sdma_enable(rdev, false);
 	radeon_ring_fini(rdev, &rdev->ring[R600_RING_TYPE_DMA_INDEX]);


