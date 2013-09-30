Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3I3KXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:23:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43684 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635Ab3I3KND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 069/104] drm/radeon: fix resume on some rs4xx boards (v2)
Date: Mon, 30 Sep 2013 11:10:46 +0100
Message-Id: <1380535881-9239-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit acf88deb8ddbb73acd1c3fa32fde51af9153227f upstream.

Setting MC_MISC_CNTL.GART_INDEX_REG_EN causes hangs on
some boards on resume.  The systems seem to work fine
without touching this bit so leave it as is.

v2: read-modify-write the GART_INDEX_REG_EN bit.
I suspect the problem is that we are losing the other
settings in the register.

fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=52952

Reported-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Daniel Tobias <dan.g.tob@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/rs400.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 9ada7ed..a56f440 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -174,10 +174,13 @@ int rs400_gart_enable(struct radeon_device *rdev)
 	/* FIXME: according to doc we should set HIDE_MMCFG_BAR=0,
 	 * AGPMODE30=0 & AGP30ENHANCED=0 in NB_CNTL */
 	if ((rdev->family == CHIP_RS690) || (rdev->family == CHIP_RS740)) {
-		WREG32_MC(RS480_MC_MISC_CNTL,
-			  (RS480_GART_INDEX_REG_EN | RS690_BLOCK_GFX_D3_EN));
+		tmp = RREG32_MC(RS480_MC_MISC_CNTL);
+		tmp |= RS480_GART_INDEX_REG_EN | RS690_BLOCK_GFX_D3_EN;
+		WREG32_MC(RS480_MC_MISC_CNTL, tmp);
 	} else {
-		WREG32_MC(RS480_MC_MISC_CNTL, RS480_GART_INDEX_REG_EN);
+		tmp = RREG32_MC(RS480_MC_MISC_CNTL);
+		tmp |= RS480_GART_INDEX_REG_EN;
+		WREG32_MC(RS480_MC_MISC_CNTL, tmp);
 	}
 	/* Enable gart */
 	WREG32_MC(RS480_AGP_ADDRESS_SPACE_SIZE, (RS480_GART_EN | size_reg));
-- 
1.8.3.2

