Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab3J1N07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:26:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50504 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3J1N06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:26:58 -0400
Date: Mon, 28 Oct 2013 14:26:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131028132634.GO19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com>
 <20131023141948.GB3566@localhost.localdomain>
 <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 02:38:29PM +0200, Victor Kaplansky wrote:
> > 2013/10/25 Peter Zijlstra <peterz@infradead.org>:
> > > On Wed, Oct 23, 2013 at 03:19:51PM +0100, Frederic Weisbecker wrote:
> > > I would argue for
> > >
> > >   READ ->data_tail                      READ ->data_head
> > >   smp_rmb()     (A)                     smp_rmb()       (C)
> > >   WRITE $data                           READ $data
> > >   smp_wmb()     (B)                     smp_mb()        (D)
> > >   STORE ->data_head                     WRITE ->data_tail
> > >
> > > Where A pairs with D, and B pairs with C.
> > >
> > > I don't think A needs to be a full barrier because we won't in fact
> > > write data until we see the store from userspace. So we simply don't
> > > issue the data WRITE until we observe it.
> > >
> > > OTOH, D needs to be a full barrier since it separates the data READ from
> > > the tail WRITE.
> > >
> > > For B a WMB is sufficient since it separates two WRITEs, and for C an
> > > RMB is sufficient since it separates two READs.

<snip>

> I think you have a point :) IMO, memory barrier (A) is superfluous.
> At producer side we need to ensure that "WRITE $data" is not committed
> to memory before "READ ->data_tail" had seen a new value and if the
> old one indicated that there is no enough space for a new entry. All
> this is already guaranteed by control flow dependancy on single CPU -
> writes will not be committed to the memory if read value of
> "data_tail" doesn't specify enough free space in the ring buffer.
> 
> Likewise, on consumer side, we can make use of natural data dependency and
> memory ordering guarantee for single CPU and try to replace "smp_mb" by
> a more light-weight "smp_rmb":
> 
> READ ->data_tail                      READ ->data_head
> // ...                                smp_rmb()       (C)
> WRITE $data                           READ $data
> smp_wmb()     (B)                     smp_rmb()       (D)
> 						  READ $header_size
> STORE ->data_head                     WRITE ->data_tail = $old_data_tail +
> $header_size
> 
> We ensure that all $data is read before "data_tail" is written by
> doing "READ $header_size" after all other data is read and we rely on
> natural data dependancy between "data_tail" write and "header_size"
> read.

I'm not entirely sure I get the $header_size trickery; need to think
more on that. But yes, I did consider the other one. However, I had
trouble having no pairing barrier for (D).

ISTR something like Alpha being able to miss the update (for a long
while) if you don't issue the RMB.

Lets add Paul and Oleg to the thread; this is getting far more 'fun'
that it should be ;-)

For completeness; below the patch as I had queued it.
---
Subject: perf: Fix perf ring buffer memory ordering
From: Peter Zijlstra <peterz@infradead.org>
Date: Mon Oct 28 13:55:29 CET 2013

The PPC64 people noticed a missing memory barrier and crufty old
comments in the perf ring buffer code. So update all the comments and
add the missing barrier.

When the architecture implements local_t using atomic_long_t there
will be double barriers issued; but short of introducing more
conditional barrier primitives this is the best we can do.

Cc: anton@samba.org
Cc: benh@kernel.crashing.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: michael@ellerman.id.au
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reported-by: Victor Kaplansky <victork@il.ibm.com>
Tested-by: Victor Kaplansky <victork@il.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20131025173749.GG19466@laptop.lan
---
 include/uapi/linux/perf_event.h |   12 +++++++-----
 kernel/events/ring_buffer.c     |   29 ++++++++++++++++++++++++++---
 2 files changed, 33 insertions(+), 8 deletions(-)

Index: linux-2.6/include/uapi/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/perf_event.h
+++ linux-2.6/include/uapi/linux/perf_event.h
@@ -479,13 +479,15 @@ struct perf_event_mmap_page {
 	/*
 	 * Control data for the mmap() data buffer.
 	 *
-	 * User-space reading the @data_head value should issue an rmb(), on
-	 * SMP capable platforms, after reading this value -- see
-	 * perf_event_wakeup().
+	 * User-space reading the @data_head value should issue an smp_rmb(),
+	 * after reading this value.
 	 *
 	 * When the mapping is PROT_WRITE the @data_tail value should be
-	 * written by userspace to reflect the last read data. In this case
-	 * the kernel will not over-write unread data.
+	 * written by userspace to reflect the last read data, after issueing
+	 * an smp_mb() to separate the data read from the ->data_tail store.
+	 * In this case the kernel will not over-write unread data.
+	 *
+	 * See perf_output_put_handle() for the data ordering.
 	 */
 	__u64   data_head;		/* head in the data section */
 	__u64	data_tail;		/* user-space written tail */
Index: linux-2.6/kernel/events/ring_buffer.c
===================================================================
--- linux-2.6.orig/kernel/events/ring_buffer.c
+++ linux-2.6/kernel/events/ring_buffer.c
@@ -87,10 +87,31 @@ static void perf_output_put_handle(struc
 		goto out;
 
 	/*
-	 * Publish the known good head. Rely on the full barrier implied
-	 * by atomic_dec_and_test() order the rb->head read and this
-	 * write.
+	 * Since the mmap() consumer (userspace) can run on a different CPU:
+	 *
+	 *   kernel				user
+	 *
+	 *   READ ->data_tail			READ ->data_head
+	 *   smp_rmb()	(A)			smp_rmb()	(C)
+	 *   WRITE $data			READ $data
+	 *   smp_wmb()	(B)			smp_mb()	(D)
+	 *   STORE ->data_head			WRITE ->data_tail
+	 *
+	 * Where A pairs with D, and B pairs with C.
+	 *
+	 * I don't think A needs to be a full barrier because we won't in fact
+	 * write data until we see the store from userspace. So we simply don't
+	 * issue the data WRITE until we observe it.
+	 *
+	 * OTOH, D needs to be a full barrier since it separates the data READ
+	 * from the tail WRITE.
+	 *
+	 * For B a WMB is sufficient since it separates two WRITEs, and for C
+	 * an RMB is sufficient since it separates two READs.
+	 *
+	 * See perf_output_begin().
 	 */
+	smp_wmb();
 	rb->user_page->data_head = head;
 
 	/*
@@ -154,6 +175,8 @@ int perf_output_begin(struct perf_output
 		 * Userspace could choose to issue a mb() before updating the
 		 * tail pointer. So that all reads will be completed before the
 		 * write is issued.
+		 *
+		 * See perf_output_put_handle().
 		 */
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
 		smp_rmb();
