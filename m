Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3CKVXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:23:38 -0400
Received: from smtp.outflux.net ([198.145.64.163]:53002 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab3CKVXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:23:36 -0400
Date: Mon, 11 Mar 2013 14:23:29 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, jln@google.com, marcheu@chromium.org
Subject: [PATCH v2] drm/i915: bounds check execbuffer relocation count
Message-ID: <20130311212329.GA21629@www.outflux.net>
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
v2:
 - move check into validate_exec_list
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 752e399..72d7841 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -732,6 +732,7 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		   int count)
 {
 	int i;
+	int total = 0;
 
 	for (i = 0; i < count; i++) {
 		char __user *ptr = (char __user *)(uintptr_t)exec[i].relocs_ptr;
@@ -744,6 +745,9 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		if (exec[i].relocation_count >
 		    INT_MAX / sizeof(struct drm_i915_gem_relocation_entry))
 			return -EINVAL;
+		if (exec[i].relocation_count > INT_MAX - total)
+			return -ENOMEM;
+		total += exec[i].relocation_count;
 
 		length = exec[i].relocation_count *
 			sizeof(struct drm_i915_gem_relocation_entry);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
