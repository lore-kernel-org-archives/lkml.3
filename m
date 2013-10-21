Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3JUJYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:24:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39452 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614Ab3JUIvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Tobias" <dan.g.tob@gmail.com>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        "Ondrej Zary" <linux@rainbow-software.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.679141933@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 045/149] drm/radeon: fix resume on some rs4xx boards (v2)
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/rs400.c | 9 ++++++---
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

