Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaFIWxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:53:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934296AbaFIWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 20/40] drm/i915: Only copy back the modified fields to userspace from execbuffer
Date: Mon,  9 Jun 2014 15:48:51 -0700
Message-Id: <20140609224839.845300849@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   54 +++++++++++++++++------------
 1 file changed, 32 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -635,9 +635,9 @@ i915_gem_execbuffer_relocate_slow(struct
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
@@ -1151,18 +1151,21 @@ i915_gem_execbuffer(struct drm_device *d
 
 	ret = i915_gem_do_execbuffer(dev, data, file, &exec2, exec2_list);
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
 
@@ -1208,14 +1211,21 @@ i915_gem_execbuffer2(struct drm_device *
 	ret = i915_gem_do_execbuffer(dev, data, file, args, exec2_list);
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
 


