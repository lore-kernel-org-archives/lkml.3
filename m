Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3CZXBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:01:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53069 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3CZWwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 41/72] drm/i915: bounds check execbuffer relocation count
Date: Tue, 26 Mar 2013 15:51:24 -0700
Message-Id: <20130326224923.931850868@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -957,15 +957,20 @@ validate_exec_list(struct drm_i915_gem_e
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


