Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab3CZPtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:49:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53859 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965111Ab3CZPWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 075/150] drm/radeon: fix backend map setup on 1 RB trinity boards
Date: Tue, 26 Mar 2013 15:19:34 +0000
Message-Id: <1364311249-14454-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8f612b23a17dce86fef75407e698de6243cc99a1 upstream.

Need to adjust the backend map depending on which RB is
enabled.  This is the trinity equivalent of:
f7eb97300832f4fe5fe916c5d84cd2e25169330e

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=57919

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/ni.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 6a0664d..c3abd25 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -612,11 +612,22 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
-	tmp = gb_addr_config & NUM_PIPES_MASK;
-	tmp = r6xx_remap_render_backend(rdev, tmp,
-					rdev->config.cayman.max_backends_per_se *
-					rdev->config.cayman.max_shader_engines,
-					CAYMAN_MAX_BACKENDS, disabled_rb_mask);
+	if ((rdev->config.cayman.max_backends_per_se == 1) &&
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
+		tmp = r6xx_remap_render_backend(rdev, tmp,
+						rdev->config.cayman.max_backends_per_se *
+						rdev->config.cayman.max_shader_engines,
+						CAYMAN_MAX_BACKENDS, disabled_rb_mask);
+	}
 	WREG32(GB_BACKEND_MAP, tmp);
 
 	cgts_tcc_disable = 0xffff0000;
-- 
1.8.1.2

