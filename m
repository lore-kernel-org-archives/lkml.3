Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab3CZWo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3CZWoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 63/98] drm/radeon: fix backend map setup on 1 RB trinity boards
Date: Tue, 26 Mar 2013 15:42:52 -0700
Message-Id: <20130326224249.049963945@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8f612b23a17dce86fef75407e698de6243cc99a1 upstream.

Need to adjust the backend map depending on which RB is
enabled.  This is the trinity equivalent of:
f7eb97300832f4fe5fe916c5d84cd2e25169330e

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=57919

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -623,11 +623,22 @@ static void cayman_gpu_init(struct radeo
 	WREG32(DMA_TILING_CONFIG + DMA0_REGISTER_OFFSET, gb_addr_config);
 	WREG32(DMA_TILING_CONFIG + DMA1_REGISTER_OFFSET, gb_addr_config);
 
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


