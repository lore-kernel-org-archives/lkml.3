Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3DKU2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:28:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16423 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab3DKU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:19 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=_2PlUJ0Vr4cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=uisAH6iWxKgA:10 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=taGs_qngAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=zv9_9hqRWm8A:10 a=n7Cch7CHiCMA:10 a=jeBq3FmKZ4MA:10 a=NpHWqo7U_sM8BGfC:21 a=zIF5abib79ysJ3Z6:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.038998196@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 042/171 ] drm/i915: bounds check execbuffer relocation count
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0042-drm-i915-bounds-check-execbuffer-relocation-count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3118a4f652c7b12c752f3222af0447008f9b2368 ]

It is possible to wrap the counter used to allocate the buffer for
relocation copies. This could lead to heap writing overflows.

CVE-2013-0913

v3: collapse test, improve comment
v2: move check into validate_exec_list

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Pinkie Pie
Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index cdf46b5..c26a8f8 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -910,15 +910,20 @@ validate_exec_list(struct drm_i915_gem_exec_object2 *exec,
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
1.7.10.4


