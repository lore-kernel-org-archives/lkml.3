Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab3BSSvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54208 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933970Ab3BSSvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:02 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 17/81] drm/radeon: fix backend map setup on 1 RB sumo boards
Date: Tue, 19 Feb 2013 15:48:40 -0300
Message-Id: <1361299784-8830-18-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f7eb97300832f4fe5fe916c5d84cd2e25169330e upstream.

Need to adjust the backend map depending on which
RB is enabled.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=892233

Reported-by: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/evergreen.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index c490d16..4170e1e 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1861,9 +1861,20 @@ static void evergreen_gpu_init(struct radeon_device *rdev)
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
-	tmp = gb_addr_config & NUM_PIPES_MASK;
-	tmp = r6xx_remap_render_backend(rdev, tmp, rdev->config.evergreen.max_backends,
-					EVERGREEN_MAX_BACKENDS, disabled_rb_mask);
+	if ((rdev->config.evergreen.max_backends == 1) &&
+	    (rdev->flags & RADEON_IS_IGP)) {
+		if ((disabled_rb_mask & 3) == 1) {
+			/* RB0 disabled, RB1 enabled */
+			tmp = 0x11111111;
+		} else {
+			/* RB1 disabled, RB0 enabled */
+			tmp = 0x00000000;
+		}
+	} else {
+		tmp = gb_addr_config & NUM_PIPES_MASK;
+		tmp = r6xx_remap_render_backend(rdev, tmp, rdev->config.evergreen.max_backends,
+						EVERGREEN_MAX_BACKENDS, disabled_rb_mask);
+	}
 	WREG32(GB_BACKEND_MAP, tmp);
 
 	WREG32(CGTS_SYS_TCC_DISABLE, 0);
-- 
1.7.9.5

