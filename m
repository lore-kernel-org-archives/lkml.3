Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3JYRiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:38:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40481 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3JYRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:38:10 -0400
Date: Fri, 25 Oct 2013 19:37:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Michael Neuling <mikey@neuling.org>, benh@kernel.crashing.org,
        anton@samba.org, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131025173749.GG19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com>
 <20131023141948.GB3566@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023141948.GB3566@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 03:19:51PM +0100, Frederic Weisbecker wrote:
> On Wed, Oct 23, 2013 at 10:54:54AM +1100, Michael Neuling wrote:
> > Frederic,
> > 
> > The comment says atomic_dec_and_test() but the code is
> > local_dec_and_test().
> > 
> > On powerpc, local_dec_and_test() doesn't have a memory barrier but
> > atomic_dec_and_test() does.  Is the comment wrong, or is
> > local_dec_and_test() suppose to imply a memory barrier too and we have
> > it wrongly implemented in powerpc?

My bad; I converted from atomic to local without actually thinking it
seems. Your implementation of the local primitives is fine.

> > diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> > index cd55144..95768c6 100644
> > --- a/kernel/events/ring_buffer.c
> > +++ b/kernel/events/ring_buffer.c
> > @@ -87,10 +87,10 @@ again:
> >  		goto out;
> >  
> >  	/*
> > -	 * Publish the known good head. Rely on the full barrier implied
> > -	 * by atomic_dec_and_test() order the rb->head read and this
> > -	 * write.
> > +	 * Publish the known good head. We need a memory barrier to order the
> > +	 * order the rb->head read and this write.
> >  	 */
> > +	smp_mb ();
> >  	rb->user_page->data_head = head;
> >  
> >  	/*

Right; so that would indeed be what the comment suggests it should be.
However I think the comment is now actively wrong too :-)

Since on the kernel side the buffer is strictly per-cpu, we don't need
memory barriers there.

> I think we want this ordering:
> 
>     Kernel                             User
> 
>    READ rb->user_page->data_tail       READ rb->user_page->data_head
>    smp_mb()                            smp_mb()
>    WRITE rb data                       READ rb  data
>    smp_mb()                            smp_mb()
>    rb->user_page->data_head            WRITE rb->user_page->data_tail
> 

I would argue for:

  READ ->data_tail			READ ->data_head
  smp_rmb()	(A)			smp_rmb()	(C)
  WRITE $data				READ $data
  smp_wmb()	(B)			smp_mb()	(D)
  STORE ->data_head			WRITE ->data_tail

Where A pairs with D, and B pairs with C.

I don't think A needs to be a full barrier because we won't in fact
write data until we see the store from userspace. So we simply don't
issue the data WRITE until we observe it.

OTOH, D needs to be a full barrier since it separates the data READ from
the tail WRITE.

For B a WMB is sufficient since it separates two WRITEs, and for C an
RMB is sufficient since it separates two READs.

---
 kernel/events/ring_buffer.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index cd55144270b5..c91274ef4e23 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -87,10 +87,31 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
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
@@ -154,6 +175,8 @@ int perf_output_begin(struct perf_output_handle *handle,
 		 * Userspace could choose to issue a mb() before updating the
 		 * tail pointer. So that all reads will be completed before the
 		 * write is issued.
+		 *
+		 * See perf_output_put_handle().
 		 */
 		tail = ACCESS_ONCE(rb->user_page->data_tail);
 		smp_rmb();
