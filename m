Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3ITUNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:13:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab3ITUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:13:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 50/93] drm/radeon: fix resume on some rs4xx boards (v2)
Date: Fri, 20 Sep 2013 13:08:45 -0700
Message-Id: <1379707768-1804-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/rs400.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index 233a9b9..b8074a8 100644
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
1.8.1.2

