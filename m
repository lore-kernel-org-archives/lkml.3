Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575Ab3BHBSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:18:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab3BHA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:57:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 08/34] drm/radeon: protect against div by 0 in backend setup
Date: Thu,  7 Feb 2013 16:57:04 -0800
Message-Id: <20130208004628.850396678@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.375461662@linuxfoundation.org>
References: <20130208004627.375461662@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Tiihonen <mikko.tiihonen@iki.fi>

commit f689e3acbd2e48cc4101e0af454193f81af4baaf upstream.

Make sure at least one RB is enabled in
r6xx_remap_render_backend() to avoid an division by
zero in some corner cases.

See:
https://bugzilla.redhat.com/show_bug.cgi?id=892233

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1382,12 +1382,15 @@ u32 r6xx_remap_render_backend(struct rad
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


