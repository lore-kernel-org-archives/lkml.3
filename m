Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbaKMWEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:04:23 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61378 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaKMWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:04:22 -0500
Date: Thu, 13 Nov 2014 17:04:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH percpu/for-3.19 1/2] percpu_ref: remove unnecessary
 ACCESS_ONCE() in percpu_ref_tryget_live()
Message-ID: <20141113220419.GD2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ref_is_percpu() needs ACCESS_ONCE() on @ref->percpu_count_ptr
because the value is tested for !__PERCPU_REF_ATOMIC, which may be set
asynchronously, and then used as a pointer.  If the compiler generates
a separate fetch when using it as a pointer, __PERCPU_REF_ATOMIC may
be set in between contaminating the pointer value.

percpu_ref_tryget_live() also uses ACCESS_ONCE() to test
__PERCPU_REF_DEAD; however, there's no reason for this.  I just copied
ACCESS_ONCE() usage blindly from __ref_is_percpu().  All it does is
confusing people trying to understand what's going on.

This patch removes the unnecessary ACCESS_ONCE() usage from
percpu_ref_tryget_live() and adds a comment explaining why
__ref_is_percpu() needs it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <kmo@daterainc.com>
---
 include/linux/percpu-refcount.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -128,7 +128,17 @@ static inline void percpu_ref_kill(struc
 static inline bool __ref_is_percpu(struct percpu_ref *ref,
 					  unsigned long __percpu **percpu_countp)
 {
-	unsigned long percpu_ptr = ACCESS_ONCE(ref->percpu_count_ptr);
+	unsigned long percpu_ptr;
+
+	/*
+	 * The value of @ref->percpu_count_ptr is tested for
+	 * !__PERCPU_REF_ATOMIC, which may be set asynchronously, and then
+	 * used as a pointer.  If the compiler generates a separate fetch
+	 * when using it as a pointer, __PERCPU_REF_ATOMIC may be set in
+	 * between contaminating the pointer value.  Make sure that the
+	 * value is fetched once.
+	 */
+	percpu_ptr = ACCESS_ONCE(ref->percpu_count_ptr);
 
 	/* paired with smp_store_release() in percpu_ref_reinit() */
 	smp_read_barrier_depends();
@@ -215,7 +225,7 @@ static inline bool percpu_ref_tryget_liv
 	if (__ref_is_percpu(ref, &percpu_count)) {
 		this_cpu_inc(*percpu_count);
 		ret = true;
-	} else if (!(ACCESS_ONCE(ref->percpu_count_ptr) & __PERCPU_REF_DEAD)) {
+	} else if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD)) {
 		ret = atomic_long_inc_not_zero(&ref->count);
 	}
 
