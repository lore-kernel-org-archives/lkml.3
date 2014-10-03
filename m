Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaJCVfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:35:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaJCVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:35:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.16 092/357] drm/radeon: handle broken disabled rb mask gracefully (6xx/7xx) (v2)
Date: Fri,  3 Oct 2014 14:27:58 -0700
Message-Id: <20141003212936.253180158@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 0a5f6e9d60e71e4b6dbeabd97bc887d6b2b0f0c8 upstream.

This is a port of cedb655a3a7764c3fd946077944383c9e0e68dd4
to older asics.  Fixes a possible divide by 0 if the harvest
register is invalid.

v2: drop some additional harvest munging.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600.c  |   26 ++++++++------------------
 drivers/gpu/drm/radeon/rv770.c |   23 ++++++++---------------
 2 files changed, 16 insertions(+), 33 deletions(-)

--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1813,7 +1813,6 @@ static void r600_gpu_init(struct radeon_
 {
 	u32 tiling_config;
 	u32 ramcfg;
-	u32 cc_rb_backend_disable;
 	u32 cc_gc_shader_pipe_config;
 	u32 tmp;
 	int i, j;
@@ -1940,29 +1939,20 @@ static void r600_gpu_init(struct radeon_
 	}
 	tiling_config |= BANK_SWAPS(1);
 
-	cc_rb_backend_disable = RREG32(CC_RB_BACKEND_DISABLE) & 0x00ff0000;
-	tmp = R6XX_MAX_BACKENDS -
-		r600_count_pipe_bits((cc_rb_backend_disable >> 16) & R6XX_MAX_BACKENDS_MASK);
-	if (tmp < rdev->config.r600.max_backends) {
-		rdev->config.r600.max_backends = tmp;
-	}
-
 	cc_gc_shader_pipe_config = RREG32(CC_GC_SHADER_PIPE_CONFIG) & 0x00ffff00;
-	tmp = R6XX_MAX_PIPES -
-		r600_count_pipe_bits((cc_gc_shader_pipe_config >> 8) & R6XX_MAX_PIPES_MASK);
-	if (tmp < rdev->config.r600.max_pipes) {
-		rdev->config.r600.max_pipes = tmp;
-	}
-	tmp = R6XX_MAX_SIMDS -
-		r600_count_pipe_bits((cc_gc_shader_pipe_config >> 16) & R6XX_MAX_SIMDS_MASK);
-	if (tmp < rdev->config.r600.max_simds) {
-		rdev->config.r600.max_simds = tmp;
-	}
 	tmp = rdev->config.r600.max_simds -
 		r600_count_pipe_bits((cc_gc_shader_pipe_config >> 16) & R6XX_MAX_SIMDS_MASK);
 	rdev->config.r600.active_simds = tmp;
 
 	disabled_rb_mask = (RREG32(CC_RB_BACKEND_DISABLE) >> 16) & R6XX_MAX_BACKENDS_MASK;
+	tmp = 0;
+	for (i = 0; i < rdev->config.r600.max_backends; i++)
+		tmp |= (1 << i);
+	/* if all the backends are disabled, fix it up here */
+	if ((disabled_rb_mask & tmp) == tmp) {
+		for (i = 0; i < rdev->config.r600.max_backends; i++)
+			disabled_rb_mask &= ~(1 << i);
+	}
 	tmp = (tiling_config & PIPE_TILING__MASK) >> PIPE_TILING__SHIFT;
 	tmp = r6xx_remap_render_backend(rdev, tmp, rdev->config.r600.max_backends,
 					R6XX_MAX_BACKENDS, disabled_rb_mask);
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1178,7 +1178,6 @@ static void rv770_gpu_init(struct radeon
 	u32 hdp_host_path_cntl;
 	u32 sq_dyn_gpr_size_simd_ab_0;
 	u32 gb_tiling_config = 0;
-	u32 cc_rb_backend_disable = 0;
 	u32 cc_gc_shader_pipe_config = 0;
 	u32 mc_arb_ramcfg;
 	u32 db_debug4, tmp;
@@ -1312,21 +1311,7 @@ static void rv770_gpu_init(struct radeon
 		WREG32(SPI_CONFIG_CNTL, 0);
 	}
 
-	cc_rb_backend_disable = RREG32(CC_RB_BACKEND_DISABLE) & 0x00ff0000;
-	tmp = R7XX_MAX_BACKENDS - r600_count_pipe_bits(cc_rb_backend_disable >> 16);
-	if (tmp < rdev->config.rv770.max_backends) {
-		rdev->config.rv770.max_backends = tmp;
-	}
-
 	cc_gc_shader_pipe_config = RREG32(CC_GC_SHADER_PIPE_CONFIG) & 0xffffff00;
-	tmp = R7XX_MAX_PIPES - r600_count_pipe_bits((cc_gc_shader_pipe_config >> 8) & R7XX_MAX_PIPES_MASK);
-	if (tmp < rdev->config.rv770.max_pipes) {
-		rdev->config.rv770.max_pipes = tmp;
-	}
-	tmp = R7XX_MAX_SIMDS - r600_count_pipe_bits((cc_gc_shader_pipe_config >> 16) & R7XX_MAX_SIMDS_MASK);
-	if (tmp < rdev->config.rv770.max_simds) {
-		rdev->config.rv770.max_simds = tmp;
-	}
 	tmp = rdev->config.rv770.max_simds -
 		r600_count_pipe_bits((cc_gc_shader_pipe_config >> 16) & R7XX_MAX_SIMDS_MASK);
 	rdev->config.rv770.active_simds = tmp;
@@ -1349,6 +1334,14 @@ static void rv770_gpu_init(struct radeon
 	rdev->config.rv770.tiling_npipes = rdev->config.rv770.max_tile_pipes;
 
 	disabled_rb_mask = (RREG32(CC_RB_BACKEND_DISABLE) >> 16) & R7XX_MAX_BACKENDS_MASK;
+	tmp = 0;
+	for (i = 0; i < rdev->config.rv770.max_backends; i++)
+		tmp |= (1 << i);
+	/* if all the backends are disabled, fix it up here */
+	if ((disabled_rb_mask & tmp) == tmp) {
+		for (i = 0; i < rdev->config.rv770.max_backends; i++)
+			disabled_rb_mask &= ~(1 << i);
+	}
 	tmp = (gb_tiling_config & PIPE_TILING__MASK) >> PIPE_TILING__SHIFT;
 	tmp = r6xx_remap_render_backend(rdev, tmp, rdev->config.rv770.max_backends,
 					R7XX_MAX_BACKENDS, disabled_rb_mask);


