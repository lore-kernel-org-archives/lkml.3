Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaCYSCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:02:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55615 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaCYRRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:17:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 17/81] drm/vmwgfx: Fix possible integer overflow
Date: Tue, 25 Mar 2014 10:15:30 -0700
Message-Id: <1395767794-5012-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellstrom <thellstrom@vmware.com>

commit b055211d941eb6cb7b285be580cf6e51a01d2f44 upstream.

Reported-by: Brian Paul <brianp@vmware.com>
Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h b/drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h
index 8369c3b..ef33850 100644
--- a/drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h
+++ b/drivers/gpu/drm/vmwgfx/svga3d_surfacedefs.h
@@ -38,8 +38,11 @@
 
 #define DIV_ROUND_UP(x, y)  (((x) + (y) - 1) / (y))
 #define max_t(type, x, y)  ((x) > (y) ? (x) : (y))
+#define min_t(type, x, y)  ((x) < (y) ? (x) : (y))
 #define surf_size_struct SVGA3dSize
 #define u32 uint32
+#define u64 uint64_t
+#define U32_MAX ((u32)~0U)
 
 #endif /* __KERNEL__ */
 
@@ -704,8 +707,8 @@ static const struct svga3d_surface_desc svga3d_surface_descs[] = {
 
 static inline u32 clamped_umul32(u32 a, u32 b)
 {
-	uint64_t tmp = (uint64_t) a*b;
-	return (tmp > (uint64_t) ((u32) -1)) ? (u32) -1 : tmp;
+	u64 tmp = (u64) a*b;
+	return (tmp > (u64) U32_MAX) ? U32_MAX : tmp;
 }
 
 static inline const struct svga3d_surface_desc *
@@ -834,7 +837,7 @@ svga3dsurface_get_serialized_size(SVGA3dSurfaceFormat format,
 				  bool cubemap)
 {
 	const struct svga3d_surface_desc *desc = svga3dsurface_get_desc(format);
-	u32 total_size = 0;
+	u64 total_size = 0;
 	u32 mip;
 
 	for (mip = 0; mip < num_mip_levels; mip++) {
@@ -847,7 +850,7 @@ svga3dsurface_get_serialized_size(SVGA3dSurfaceFormat format,
 	if (cubemap)
 		total_size *= SVGA3D_MAX_SURFACE_FACES;
 
-	return total_size;
+	return (u32) min_t(u64, total_size, (u64) U32_MAX);
 }
 
 
-- 
1.8.3.2

