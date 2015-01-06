Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbbAFPXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:23:52 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33322 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbbAFPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:23:50 -0500
Date: Tue, 6 Jan 2015 10:23:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <kmo@daterainc.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 percpu/for-3.20] percpu_ref: remove unnecessary
 ACCESS_ONCE() in percpu_ref_tryget_live()
Message-ID: <20150106152347.GD3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__ref_is_percpu() needs the implied ACCESS_ONCE() in
lockless_dereference() on @ref->percpu_count_ptr because the value is
tested for !__PERCPU_REF_ATOMIC, which may be set asynchronously, and
then used as a pointer.  If the compiler generates a separate fetch
when using it as a pointer, __PERCPU_REF_ATOMIC may be set in between
contaminating the pointer value.

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
 include/linux/percpu-refcount.h |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -128,8 +128,22 @@ static inline void percpu_ref_kill(struc
 static inline bool __ref_is_percpu(struct percpu_ref *ref,
 					  unsigned long __percpu **percpu_countp)
 {
-	/* paired with smp_store_release() in percpu_ref_reinit() */
-	unsigned long percpu_ptr = lockless_dereference(ref->percpu_count_ptr);
+	unsigned long percpu_ptr;
+
+	/*
+	 * The value of @ref->percpu_count_ptr is tested for
+	 * !__PERCPU_REF_ATOMIC, which may be set asynchronously, and then
+	 * used as a pointer.  If the compiler generates a separate fetch
+	 * when using it as a pointer, __PERCPU_REF_ATOMIC may be set in
+	 * between contaminating the pointer value, meaning that
+	 * ACCESS_ONCE() is required when fetching it.
+	 *
+	 * Also, we need a data dependency barrier to be paired with
+	 * smp_store_release() in __percpu_ref_switch_to_percpu().
+	 *
+	 * Use lockless deref which contains both.
+	 */
+	percpu_ptr = lockless_dereference(ref->percpu_count_ptr);
 
 	/*
 	 * Theoretically, the following could test just ATOMIC; however,
@@ -233,7 +247,7 @@ static inline bool percpu_ref_tryget_liv
 	if (__ref_is_percpu(ref, &percpu_count)) {
 		this_cpu_inc(*percpu_count);
 		ret = true;
-	} else if (!(ACCESS_ONCE(ref->percpu_count_ptr) & __PERCPU_REF_DEAD)) {
+	} else if (!(ref->percpu_count_ptr & __PERCPU_REF_DEAD)) {
 		ret = atomic_long_inc_not_zero(&ref->count);
 	}
 
