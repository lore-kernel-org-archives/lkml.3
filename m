Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaAFOat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:30:49 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49019 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAFOas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:30:48 -0500
Date: Mon, 6 Jan 2014 20:00:40 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 02/85] drivers: gpu: Mark function as static and remove
 unused function in ast_main.c
Message-ID: <e8cbf4c2d70d1ac3fa8ddba93b0579755f9fb4b6.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function ast_bo_unref() as static because it is not used outside
file ast_main.c and remove unused function ast_get_max_dclk() in
ast_main.c.

This eliminates the following warning in drm/ast/ast_main.c:
drivers/gpu/drm/ast/ast_main.c:192:10: warning: no previous prototype
for ‘ast_get_max_dclk’ [-Wmissing-prototypes]
drivers/gpu/drm/ast/ast_main.c:452:6: warning: no previous prototype for
‘ast_bo_unref’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/ast/ast_main.c |   49 +---------------------------------------
 1 file changed, 1 insertion(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/ast/ast_main.c b/drivers/gpu/drm/ast/ast_main.c
index af0b868..50535fd 100644
--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -189,53 +189,6 @@ static int ast_get_dram_info(struct drm_device *dev)
 	return 0;
 }
 
-uint32_t ast_get_max_dclk(struct drm_device *dev, int bpp)
-{
-	struct ast_private *ast = dev->dev_private;
-	uint32_t dclk, jreg;
-	uint32_t dram_bus_width, mclk, dram_bandwidth, actual_dram_bandwidth, dram_efficency = 500;
-
-	dram_bus_width = ast->dram_bus_width;
-	mclk = ast->mclk;
-
-	if (ast->chip == AST2100 ||
-	    ast->chip == AST1100 ||
-	    ast->chip == AST2200 ||
-	    ast->chip == AST2150 ||
-	    ast->dram_bus_width == 16)
-		dram_efficency = 600;
-	else if (ast->chip == AST2300)
-		dram_efficency = 400;
-
-	dram_bandwidth = mclk * dram_bus_width * 2 / 8;
-	actual_dram_bandwidth = dram_bandwidth * dram_efficency / 1000;
-
-	if (ast->chip == AST1180)
-		dclk = actual_dram_bandwidth / ((bpp + 1) / 8);
-	else {
-		jreg = ast_get_index_reg_mask(ast, AST_IO_CRTC_PORT, 0xd0, 0xff);
-		if ((jreg & 0x08) && (ast->chip == AST2000))
-			dclk = actual_dram_bandwidth / ((bpp + 1 + 16) / 8);
-		else if ((jreg & 0x08) && (bpp == 8))
-			dclk = actual_dram_bandwidth / ((bpp + 1 + 24) / 8);
-		else
-			dclk = actual_dram_bandwidth / ((bpp + 1) / 8);
-	}
-
-	if (ast->chip == AST2100 ||
-	    ast->chip == AST2200 ||
-	    ast->chip == AST2300 ||
-	    ast->chip == AST1180) {
-		if (dclk > 200)
-			dclk = 200;
-	} else {
-		if (dclk > 165)
-			dclk = 165;
-	}
-
-	return dclk;
-}
-
 static void ast_user_framebuffer_destroy(struct drm_framebuffer *fb)
 {
 	struct ast_framebuffer *ast_fb = to_ast_framebuffer(fb);
@@ -449,7 +402,7 @@ int ast_dumb_create(struct drm_file *file,
 	return 0;
 }
 
-void ast_bo_unref(struct ast_bo **bo)
+static void ast_bo_unref(struct ast_bo **bo)
 {
 	struct ttm_buffer_object *tbo;
 
-- 
1.7.9.5

