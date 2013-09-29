Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3I2T3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:29:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab3I2T31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Daniel Tobias <dan.g.tob@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 45/71] drm/radeon: fix resume on some rs4xx boards (v2)
Date: Sun, 29 Sep 2013 12:27:57 -0700
Message-Id: <20130929192646.563544347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rs400.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -174,10 +174,13 @@ int rs400_gart_enable(struct radeon_devi
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


