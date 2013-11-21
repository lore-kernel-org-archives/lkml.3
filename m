Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3KUQSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 11:18:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab3KUQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 11:18:06 -0500
Date: Thu, 21 Nov 2013 17:17:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: [RFC] Control dependencies
Message-ID: <20131121161733.GH10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Paul,

So on IRC you said you were going to post a patch to clarify/allow
control dependencies -- seeing you didn't get around to it, I thought
I'd take a stab at it.

The below is a patch to the perf code that uses one to get rid of a
pesky full memory barrier. Along with a patch to _the_ Document to
hopefully clarify the issue some. Although I feel there is far more to
say on this subject than I have attempted.

Since it now looks like smp_store_release() needs a full memory barrier
that approach isn't actually looking all that attractive for me anymore
(I'll not give up on those patches just yet), but I did want to put this
approach forward.

---
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -526,21 +526,27 @@ See also the subsection on "Cache Cohere
 CONTROL DEPENDENCIES
 --------------------
 
-A control dependency requires a full read memory barrier, not simply a data
-dependency barrier to make it work correctly.  Consider the following bit of
-code:
+Because CPUs do not allow store speculation -- this would result in values out
+of thin air -- store visibility depends on a linear branch history. Therefore
+we can rely on LOAD -> STORE control dependencies to order things.
 
-	q = &a;
-	if (p) {
-		<data dependency barrier>
-		q = &b;
+	if (x) {
+		y = 1;
+	}
+
+The store to y must happen after the read to x. However C11/C++11 does not
+(yet) prohibit STORE speculation, and therefore we should insert a compiler
+barrier to force our compiler to do as it is told, and the above example
+should read:
+
+	if (x) {
+		barrier();
+		y = 1;
 	}
-	x = *q;
 
-This will not have the desired effect because there is no actual data
-dependency, but rather a control dependency that the CPU may short-circuit by
-attempting to predict the outcome in advance.  In such a case what's actually
-required is:
+On the other hand, CPUs (and compilers) are allowed to aggressively speculate
+on loads, therefore we cannot rely on LOAD -> LOAD control dependencies such
+as:
 
 	q = &a;
 	if (p) {
@@ -549,6 +555,8 @@ attempting to predict the outcome in adv
 	}
 	x = *q;
 
+And the read barrier as per the above example is indeed required to ensure
+order.
 
 SMP BARRIER PAIRING
 -------------------
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -62,18 +62,18 @@ static void perf_output_put_handle(struc
 	 *   kernel				user
 	 *
 	 *   READ ->data_tail			READ ->data_head
-	 *   smp_mb()	(A)			smp_rmb()	(C)
+	 *   barrier()	(A)			smp_rmb()	(C)
 	 *   WRITE $data			READ $data
 	 *   smp_wmb()	(B)			smp_mb()	(D)
 	 *   STORE ->data_head			WRITE ->data_tail
 	 *
 	 * Where A pairs with D, and B pairs with C.
 	 *
-	 * I don't think A needs to be a full barrier because we won't in fact
-	 * write data until we see the store from userspace. So we simply don't
-	 * issue the data WRITE until we observe it. Be conservative for now.
+	 * In our case (A) is a control barrier that separates the loading of
+	 * the ->data_tail and the writing of $data. In case ->data_tail
+	 * indicates there is no room in the buffer to store $data we bail.
 	 *
-	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * D needs to be a full barrier since it separates the data READ
 	 * from the tail WRITE.
 	 *
 	 * For B a WMB is sufficient since it separates two WRITEs, and for C
@@ -148,13 +148,15 @@ int perf_output_begin(struct perf_output
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
 	/*
-	 * Separate the userpage->tail read from the data stores below.
+	 * Control barrier separating the @tail read above from the
+	 * data writes below.
+	 *
 	 * Matches the MB userspace SHOULD issue after reading the data
 	 * and before storing the new tail position.
 	 *
 	 * See perf_output_put_handle().
 	 */
-	smp_mb();
+	barrier();
 
 	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);

