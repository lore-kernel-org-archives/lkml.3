Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab3BHBSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:18:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41828 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758277Ab3BHA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikko Tiihonen <mikko.tiihonen@iki.fi>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 07/34] drm/radeon: fix backend map setup on 1 RB sumo boards
Date: Thu,  7 Feb 2013 16:57:03 -0800
Message-Id: <20130208004628.662959785@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f7eb97300832f4fe5fe916c5d84cd2e25169330e upstream.

Need to adjust the backend map depending on which
RB is enabled.

Fixes:
https://bugzilla.redhat.com/show_bug.cgi?id=892233

Reported-by: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2045,9 +2045,20 @@ static void evergreen_gpu_init(struct ra
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


