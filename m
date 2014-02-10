Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaBJMGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:06:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaBJMF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:05:57 -0500
Date: Mon, 10 Feb 2014 13:05:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210120541.GK9987@twins.programming.kicks-ass.net>
References: <1391721423.23421.3898.camel@triegel.csb>
 <20140206221117.GJ4250@linux.vnet.ibm.com>
 <1391730288.23421.4102.camel@triegel.csb>
 <20140207042051.GL4250@linux.vnet.ibm.com>
 <20140207074405.GM5002@laptop.programming.kicks-ass.net>
 <20140207165028.GO4250@linux.vnet.ibm.com>
 <20140207165548.GR5976@mudshark.cambridge.arm.com>
 <20140207180216.GP4250@linux.vnet.ibm.com>
 <20140210114813.GJ9987@twins.programming.kicks-ass.net>
 <20140210114929.GF17766@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210114929.GF17766@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:49:29AM +0000, Will Deacon wrote:
> On Mon, Feb 10, 2014 at 11:48:13AM +0000, Peter Zijlstra wrote:
> > On Fri, Feb 07, 2014 at 10:02:16AM -0800, Paul E. McKenney wrote:
> > > As near as I can tell, compiler writers hate the idea of prohibiting
> > > speculative-store optimizations because it requires them to introduce
> > > both control and data dependency tracking into their compilers.  Many of
> > > them seem to hate dependency tracking with a purple passion.  At least,
> > > such a hatred would go a long way towards explaining the incomplete
> > > and high-overhead implementations of memory_order_consume, the long
> > > and successful use of idioms based on the memory_order_consume pattern
> > > notwithstanding [*].  ;-)
> > 
> > Just tell them that because the hardware provides control dependencies
> > we actually use and rely on them.
> 
> s/control/address/ ?

Nope, control.

Since stores cannot be speculated and thus require linear control flow
history we can use it to order LOAD -> STORE when the LOAD is required
for the control flow decision and the STORE depends on the control flow
path.

Also see commit 18c03c61444a211237f3d4782353cb38dba795df to
Documentation/memory-barriers.txt

---
commit c7f2e3cd6c1f4932ccc4135d050eae3f7c7aef63
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Mon Nov 25 11:49:10 2013 +0100

    perf: Optimize ring-buffer write by depending on control dependencies
    
    Remove a full barrier from the ring-buffer write path by relying on
    a control dependency to order a LOAD -> STORE scenario.
    
    Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-8alv40z6ikk57jzbaobnxrjl@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index e8b168af135b..146a5792b1d2 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -61,19 +61,20 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	 *
 	 *   kernel				user
 	 *
-	 *   READ ->data_tail			READ ->data_head
-	 *   smp_mb()	(A)			smp_rmb()	(C)
-	 *   WRITE $data			READ $data
-	 *   smp_wmb()	(B)			smp_mb()	(D)
-	 *   STORE ->data_head			WRITE ->data_tail
+	 *   if (LOAD ->data_tail) {		LOAD ->data_head
+	 *			(A)		smp_rmb()	(C)
+	 *	STORE $data			LOAD $data
+	 *	smp_wmb()	(B)		smp_mb()	(D)
+	 *	STORE ->data_head		STORE ->data_tail
+	 *   }
 	 *
 	 * Where A pairs with D, and B pairs with C.
 	 *
-	 * I don't think A needs to be a full barrier because we won't in fact
-	 * write data until we see the store from userspace. So we simply don't
-	 * issue the data WRITE until we observe it. Be conservative for now.
+	 * In our case (A) is a control dependency that separates the load of
+	 * the ->data_tail and the stores of $data. In case ->data_tail
+	 * indicates there is no room in the buffer to store $data we do not.
 	 *
-	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * D needs to be a full barrier since it separates the data READ
 	 * from the tail WRITE.
 	 *
 	 * For B a WMB is sufficient since it separates two WRITEs, and for C
@@ -81,7 +82,7 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
 	 *
 	 * See perf_output_begin().
 	 */
-	smp_wmb();
+	smp_wmb(); /* B, matches C */
 	rb->user_page->data_head = head;
 
 	/*
@@ -144,17 +145,26 @@ int perf_output_begin(struct perf_output_handle *handle,
 		if (!rb->overwrite &&
 		    unlikely(CIRC_SPACE(head, tail, perf_data_size(rb)) < size))
 			goto fail;
+
+		/*
+		 * The above forms a control dependency barrier separating the
+		 * @tail load above from the data stores below. Since the @tail
+		 * load is required to compute the branch to fail below.
+		 *
+		 * A, matches D; the full memory barrier userspace SHOULD issue
+		 * after reading the data and before storing the new tail
+		 * position.
+		 *
+		 * See perf_output_put_handle().
+		 */
+
 		head += size;
 	} while (local_cmpxchg(&rb->head, offset, head) != offset);
 
 	/*
-	 * Separate the userpage->tail read from the data stores below.
-	 * Matches the MB userspace SHOULD issue after reading the data
-	 * and before storing the new tail position.
-	 *
-	 * See perf_output_put_handle().
+	 * We rely on the implied barrier() by local_cmpxchg() to ensure
+	 * none of the data stores below can be lifted up by the compiler.
 	 */
-	smp_mb();
 
 	if (unlikely(head - local_read(&rb->wakeup) > rb->watermark))
 		local_add(rb->watermark, &rb->wakeup);
