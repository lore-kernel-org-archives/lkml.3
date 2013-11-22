Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3KVNrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:47:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45854 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3KVNrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:47:12 -0500
Date: Fri, 22 Nov 2013 14:46:30 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Subject: Re: [RFC] Control dependencies
Message-ID: <20131122134630.GQ3866@twins.programming.kicks-ass.net>
References: <20131121161733.GH10022@twins.programming.kicks-ass.net>
 <20131121180237.GX4138@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121180237.GX4138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 10:02:37AM -0800, Paul E. McKenney wrote:
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> 
> My patch does not cover this file.  Wouldn't hurt for them to be
> separate.

Oh sure, but I wanted to present the RFC with at least one working
example to illustrate why I even bother and to aid in discussion.

> > @@ -62,18 +62,18 @@ static void perf_output_put_handle(struc
> >  	 *   kernel				user
> >  	 *
> >  	 *   READ ->data_tail			READ ->data_head
> > -	 *   smp_mb()	(A)			smp_rmb()	(C)
> > +	 *   barrier()	(A)			smp_rmb()	(C)
> 
> We need a conditional for this to work.  I know that the required
> conditional is there in the code, but we need it explicitly in this
> example as well.

Agreed, I skimped on that because I didn't quite know how to write that
best.

How about the below version?

---
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -61,19 +61,20 @@ static void perf_output_put_handle(struc
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
@@ -81,7 +82,7 @@ static void perf_output_put_handle(struc
 	 *
 	 * See perf_output_begin().
 	 */
-	smp_wmb();
+	smp_wmb(); /* B, matches C */
 	rb->user_page->data_head = head;
 
 	/*
@@ -144,17 +145,26 @@ int perf_output_begin(struct perf_output
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
