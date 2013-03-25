Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3CYB1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:27:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756098Ab3CYBQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:06 -0400
Message-Id: <20130325010529.933837586@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Kees Cook <keescook@chromium.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 057/104] drm/i915: bounds check execbuffer relocation count
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -907,15 +907,20 @@ validate_exec_list(struct drm_i915_gem_e
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


