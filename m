Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaGHTeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:34:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54778 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755592AbaGHTeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:34:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.3628672@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/125] drm/i915: Only copy back the modified fields
 to userspace from execbuffer
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: to_user_ptr() is open-coded]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 54 ++++++++++++++++++------------
 1 file changed, 32 insertions(+), 22 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -679,9 +679,9 @@ i915_gem_execbuffer_relocate_slow(struct
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
@@ -1325,19 +1325,21 @@ i915_gem_execbuffer(struct drm_device *d
 
 	ret = i915_gem_do_execbuffer(dev, data, file, &exec2, exec2_list);
 	if (!ret) {
+		struct drm_i915_gem_exec_object __user *user_exec_list =
+			(void __user *)(uintptr_t)args->buffers_ptr;
+
 		/* Copy the new buffer offsets back to the user's exec list. */
-		for (i = 0; i < args->buffer_count; i++)
-			exec_list[i].offset = exec2_list[i].offset;
-		/* ... and back out to userspace */
-		ret = copy_to_user((struct drm_i915_relocation_entry __user *)
-				   (uintptr_t) args->buffers_ptr,
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
 
@@ -1384,15 +1386,21 @@ i915_gem_execbuffer2(struct drm_device *
 	ret = i915_gem_do_execbuffer(dev, data, file, args, exec2_list);
 	if (!ret) {
 		/* Copy the new buffer offsets back to the user's exec list. */
-		ret = copy_to_user((struct drm_i915_relocation_entry __user *)
-				   (uintptr_t) args->buffers_ptr,
-				   exec2_list,
-				   sizeof(*exec2_list) * args->buffer_count);
-		if (ret) {
-			ret = -EFAULT;
-			DRM_DEBUG("failed to copy %d exec entries "
-				  "back to user (%d)\n",
-				  args->buffer_count, ret);
+		struct drm_i915_gem_exec_object2 __user *user_exec_list =
+			(void __user *)(uintptr_t)args->buffers_ptr;
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
 

