Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaKVOWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:22:47 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:36763 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaKVOWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:22:46 -0500
Date: Sat, 22 Nov 2014 09:22:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH percpu/for-3.18-fixes] percpu-ref: fix DEAD flag
 contamination of percpu pointer
Message-ID: <20141122142242.GB26007@htj.dyndns.org>
References: <995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While decoupling ATOMIC and DEAD flags, f47ad4578461 ("percpu_ref:
decouple switching to percpu mode and reinit") updated
__ref_is_percpu() so that it only tests ATOMIC flag to determine
whether the ref is in percpu mode or not; however, while DEAD implies
ATOMIC, the two flags are set separately during percpu_ref_kill() and
if __ref_is_percpu() races percpu_ref_kill(), it may see DEAD w/o
ATOMIC.  Because __ref_is_percpu() returns @ref->percpu_count_ptr
value verbatim as the percpu pointer after testing ATOMIC, the pointer
may now be contaminated with the DEAD flag.

This can be fixed by clearing the flag bits before returning the
pointer which was the fix proposed by Shaohua; however, as DEAD
implies ATOMIC, we can just test for both flags at once and avoid the
explicit masking.

Update __ref_is_percpu() so that it tests that both ATOMIC and DEAD
are clear before returning @ref->percpu_count_ptr as the percpu
pointer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Shaohua Li <shli@kernel.org>
Link: http://lkml.kernel.org/r/995deb699f5b873c45d667df4add3b06f73c2c25.1416638887.git.shli@kernel.org
Fixes: f47ad4578461 ("percpu_ref: decouple switching to percpu mode and reinit")
---
Hello, Shaohua.

That was a nasty one.  I think this fix is slightly better.  Can you
please confirm that this fixes the issues you're seeing too?

Thanks.

 include/linux/percpu-refcount.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index d5c89e0..51ce60c 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -133,7 +133,13 @@ static inline bool __ref_is_percpu(struct percpu_ref *ref,
 	/* paired with smp_store_release() in percpu_ref_reinit() */
 	smp_read_barrier_depends();
 
-	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC))
+	/*
+	 * Theoretically, the following could test just ATOMIC; however,
+	 * then we'd have to mask off DEAD separately as DEAD may be
+	 * visible without ATOMIC if we race with percpu_ref_kill().  DEAD
+	 * implies ATOMIC anyway.  Test them together.
+	 */
+	if (unlikely(percpu_ptr & __PERCPU_REF_ATOMIC_DEAD))
 		return false;
 
 	*percpu_countp = (unsigned long __percpu *)percpu_ptr;
