Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3BEWcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:32:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab3BEWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:08:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@fwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 09/93] drm/i915: Invalidate the relocation presumed_offsets along the slow path
Date: Tue,  5 Feb 2013 20:05:58 -0200
Message-Id: <1360102042-10732-10-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 262b6d363fcff16359c93bd58c297f961f6e6273 upstream.

In the slow path, we are forced to copy the relocations prior to
acquiring the struct mutex in order to handle pagefaults. We forgo
copying the new offsets back into the relocation entries in order to
prevent a recursive locking bug should we trigger a pagefault whilst
holding the mutex for the reservations of the execbuffer. Therefore, we
need to reset the presumed_offsets just in case the objects are rebound
back into their old locations after relocating for this exexbuffer - if
that were to happen we would assume the relocations were valid and leave
the actual pointers to the kernels dangling, instant hang.

Fixes regression from commit bcf50e2775bbc3101932d8e4ab8c7902aa4163b4
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Sun Nov 21 22:07:12 2010 +0000

    drm/i915: Handle pagefaults in execbuffer user relocations

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=55984
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@fwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 3debf95..fadd6d6 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -749,6 +749,8 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 	total = 0;
 	for (i = 0; i < count; i++) {
 		struct drm_i915_gem_relocation_entry __user *user_relocs;
+		u64 invalid_offset = (u64)-1;
+		int j;
 
 		user_relocs = (void __user *)(uintptr_t)exec[i].relocs_ptr;
 
@@ -759,6 +761,25 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 			goto err;
 		}
 
+		/* As we do not update the known relocation offsets after
+		 * relocating (due to the complexities in lock handling),
+		 * we need to mark them as invalid now so that we force the
+		 * relocation processing next time. Just in case the target
+		 * object is evicted and then rebound into its old
+		 * presumed_offset before the next execbuffer - if that
+		 * happened we would make the mistake of assuming that the
+		 * relocations were valid.
+		 */
+		for (j = 0; j < exec[i].relocation_count; j++) {
+			if (copy_to_user(&user_relocs[j].presumed_offset,
+					 &invalid_offset,
+					 sizeof(invalid_offset))) {
+				ret = -EFAULT;
+				mutex_lock(&dev->struct_mutex);
+				goto err;
+			}
+		}
+
 		reloc_offset[i] = total;
 		total += exec[i].relocation_count;
 	}
-- 
1.7.9.5

