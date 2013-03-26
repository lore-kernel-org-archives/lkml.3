Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903Ab3CZPum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:50:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53833 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965082Ab3CZPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 070/150] drm/i915: bounds check execbuffer relocation count
Date: Tue, 26 Mar 2013 15:19:29 +0000
Message-Id: <1364311249-14454-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 3118a4f652c7b12c752f3222af0447008f9b2368 upstream.

It is possible to wrap the counter used to allocate the buffer for
relocation copies. This could lead to heap writing overflows.

CVE-2013-0913

v3: collapse test, improve comment
v2: move check into validate_exec_list

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Pinkie Pie
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index fadd6d6..0f27a1f 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -941,15 +941,20 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
 		   int count)
 {
 	int i;
+	int relocs_total = 0;
+	int relocs_max = INT_MAX / sizeof(struct drm_i915_gem_relocation_entry);
 
 	for (i = 0; i < count; i++) {
 		char __user *ptr = (char __user *)(uintptr_t)exec[i].relocs_ptr;
 		int length; /* limited by fault_in_pages_readable() */
 
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
1.8.1.2

