Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab3CLAby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:31:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48630 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3CLAbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:31:53 -0400
Date: Mon, 11 Mar 2013 17:31:45 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        Julien Tinnes <jln@google.com>, marcheu@chromium.org
Subject: [PATCH v3] drm/i915: bounds check execbuffer relocation count
Message-ID: <20130312003145.GA28993@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to wrap the counter used to allocate the buffer for
relocation copies. This could lead to heap writing overflows.

CVE-2013-0913

v3: collapse test, improve comment
v2: move check into validate_exec_list

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Pinkie Pie
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index b3a40ee..094ba41 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -732,6 +732,8 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		   int count)
 {
 	int i;
+	int relocs_total = 0;
+	int relocs_max = INT_MAX / sizeof(struct drm_i915_gem_relocation_entry);
 
 	for (i = 0; i < count; i++) {
 		char __user *ptr = (char __user *)(uintptr_t)exec[i].relocs_ptr;
@@ -740,10 +742,13 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		if (exec[i].flags & __EXEC_OBJECT_UNKNOWN_FLAGS)
 			return -EINVAL;
 
-		/* First check for malicious input causing overflow */
-		if (exec[i].relocation_count >
-		    INT_MAX / sizeof(struct drm_i915_gem_relocation_entry))
+		/* First check for malicious input causing overflow in
+		 * the worst case where we need to allocate the entire
+		 * relocation tree as a single array.
+		 */
+		if (exec[i].relocation_count > relocs_max - relocs_total)
 			return -EINVAL;
+		relocs_total += exec[i].relocation_count;
 
 		length = exec[i].relocation_count *
 			sizeof(struct drm_i915_gem_relocation_entry);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
