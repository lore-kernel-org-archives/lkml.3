Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3BSSvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933985Ab3BSSvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:06 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 18/81] drm/radeon: protect against div by 0 in backend setup
Date: Tue, 19 Feb 2013 15:48:41 -0300
Message-Id: <1361299784-8830-19-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Tiihonen <mikko.tiihonen@iki.fi>

commit f689e3acbd2e48cc4101e0af454193f81af4baaf upstream.

Make sure at least one RB is enabled in
r6xx_remap_render_backend() to avoid an division by
zero in some corner cases.

See:
https://bugzilla.redhat.com/show_bug.cgi?id=892233

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/r600.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index bff6272..0c7476d 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1383,12 +1383,15 @@ u32 r6xx_remap_render_backend(struct radeon_device *rdev,
 			      u32 disabled_rb_mask)
 {
 	u32 rendering_pipe_num, rb_num_width, req_rb_num;
-	u32 pipe_rb_ratio, pipe_rb_remain;
+	u32 pipe_rb_ratio, pipe_rb_remain, tmp;
 	u32 data = 0, mask = 1 << (max_rb_num - 1);
 	unsigned i, j;
 
 	/* mask out the RBs that don't exist on that asic */
-	disabled_rb_mask |= (0xff << max_rb_num) & 0xff;
+	tmp = disabled_rb_mask | ((0xff << max_rb_num) & 0xff);
+	/* make sure at least one RB is available */
+	if ((tmp & 0xff) != 0xff)
+		disabled_rb_mask = tmp;
 
 	rendering_pipe_num = 1 << tiling_pipe_num;
 	req_rb_num = total_max_rb_num - r600_count_pipe_bits(disabled_rb_mask);
-- 
1.7.9.5

