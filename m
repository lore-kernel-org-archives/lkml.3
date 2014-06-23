Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbaFWIwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:52:54 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55532 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 037/111] drm/i915: Only copy back the modified fields to userspace from execbuffer
Date: Mon, 23 Jun 2014 10:31:12 +0200
Message-Id: <f1daac894b130d348c81bd5e9206edde8354e528.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9aab8bff7aa3bee567213ad3c1fdfb217bb980a2 upstream.

We only want to modifiy a single field in the userspace view of the
execbuffer command buffer, so explicitly change that rather than copy
everything back again.

This serves two purposes:

1. The single fields are much cheaper to copy (constant size so the
copy uses special case code) and much smaller than the whole array.

2. We modify the array for internal use that need to be masked from
the user.

Note: We need this backported since without it the next bugfix will
blow up when userspace recycles batchbuffers and relocations.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 54 ++++++++++++++++++------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index bf345777ae9f..c08287f8bbf4 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -674,9 +674,9 @@ i915_gem_execbuffer_relocate_slow(struct drm_device *dev,
 		 * relocations were valid.
 		 */
 		for (j = 0; j < exec[i].relocation_count; j++) {
-			if (copy_to_user(&user_relocs[j].presumed_offset,
-					 &invalid_offset,
-					 sizeof(invalid_offset))) {
+			if (__copy_to_user(&user_relocs[j].presumed_offset,
+					   &invalid_offset,
+					   sizeof(invalid_offset))) {
 				ret = -EFAULT;
 				mutex_lock(&dev->struct_mutex);
 				goto err;
@@ -1211,18 +1211,21 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 	ret = i915_gem_do_execbuffer(dev, data, file, &exec2, exec2_list,
 				     &dev_priv->gtt.base);
 	if (!ret) {
+		struct drm_i915_gem_exec_object __user *user_exec_list =
+			to_user_ptr(args->buffers_ptr);
+
 		/* Copy the new buffer offsets back to the user's exec list. */
-		for (i = 0; i < args->buffer_count; i++)
-			exec_list[i].offset = exec2_list[i].offset;
-		/* ... and back out to userspace */
-		ret = copy_to_user(to_user_ptr(args->buffers_ptr),
-				   exec_list,
-				   sizeof(*exec_list) * args->buffer_count);
-		if (ret) {
-			ret = -EFAULT;
-			DRM_DEBUG("failed to copy %d exec entries "
-				  "back to user (%d)\n",
-				  args->buffer_count, ret);
+		for (i = 0; i < args->buffer_count; i++) {
+			ret = __copy_to_user(&user_exec_list[i].offset,
+					     &exec2_list[i].offset,
+					     sizeof(user_exec_list[i].offset));
+			if (ret) {
+				ret = -EFAULT;
+				DRM_DEBUG("failed to copy %d exec entries "
+					  "back to user (%d)\n",
+					  args->buffer_count, ret);
+				break;
+			}
 		}
 	}
 
@@ -1270,14 +1273,21 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
 				     &dev_priv->gtt.base);
 	if (!ret) {
 		/* Copy the new buffer offsets back to the user's exec list. */
-		ret = copy_to_user(to_user_ptr(args->buffers_ptr),
-				   exec2_list,
-				   sizeof(*exec2_list) * args->buffer_count);
-		if (ret) {
-			ret = -EFAULT;
-			DRM_DEBUG("failed to copy %d exec entries "
-				  "back to user (%d)\n",
-				  args->buffer_count, ret);
+		struct drm_i915_gem_exec_object2 *user_exec_list =
+				   to_user_ptr(args->buffers_ptr);
+		int i;
+
+		for (i = 0; i < args->buffer_count; i++) {
+			ret = __copy_to_user(&user_exec_list[i].offset,
+					     &exec2_list[i].offset,
+					     sizeof(user_exec_list[i].offset));
+			if (ret) {
+				ret = -EFAULT;
+				DRM_DEBUG("failed to copy %d exec entries "
+					  "back to user\n",
+					  args->buffer_count);
+				break;
+			}
 		}
 	}
 
-- 
2.0.0

