Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3CKT1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:27:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41330 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab3CKT1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:27:19 -0400
Date: Mon, 11 Mar 2013 12:27:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/i915: bounds check execbuffer relocations
Message-ID: <20130311192716.GA18244@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to wrap the counter used to allocate the buffer for
relocation copies. This could lead to heap writing overflows.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Pinkie Pie
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 752e399..62eaa99 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -585,7 +585,8 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	struct drm_i915_gem_object *obj;
 	bool need_relocs;
 	int *reloc_offset;
-	int i, total, ret;
+	int ret;
+	unsigned int i, total;
 	int count = args->buffer_count;
 
 	/* We may process another execbuffer during the unlock... */
@@ -600,8 +601,13 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	mutex_unlock(&dev->struct_mutex);
 
 	total = 0;
-	for (i = 0; i < count; i++)
+	for (i = 0; i < count; i++) {
+		if (exec[i].relocation_count > UINT_MAX - total) {
+			mutex_lock(&dev->struct_mutex);
+			return -ENOMEM;
+		}
 		total += exec[i].relocation_count;
+	}
 
 	reloc_offset = drm_malloc_ab(count, sizeof(*reloc_offset));
 	reloc = drm_malloc_ab(total, sizeof(*reloc));
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
