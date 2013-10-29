Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3J2VXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:23:50 -0400
Received: from ozlabs.org ([203.10.76.45]:36478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3J2VXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:23:49 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
In-reply-to: <20131029103057.GN2490@laptop.programming.kicks-ass.net>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan> <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com> <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com> <20131028132634.GO19466@laptop.lan> <20131028163418.GD4126@linux.vnet.ibm.com> <20131028201735.GA15629@redhat.com> <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com> <20131029102131.GA16117@laptop.programming.kicks-ass.net> <20131029103057.GN2490@laptop.programming.kicks-ass.net>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Tue, 29 Oct 2013 11:30:57 +0100."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Wed, 30 Oct 2013 08:23:48 +1100
Message-ID: <12631.1383081828@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Oct 29, 2013 at 11:21:31AM +0100, Peter Zijlstra wrote:
> > On Mon, Oct 28, 2013 at 10:58:58PM +0200, Victor Kaplansky wrote:
> > > Oleg Nesterov <oleg@redhat.com> wrote on 10/28/2013 10:17:35 PM:
> > > 
> > > >       mb();   // XXXXXXXX: do we really need it? I think yes.
> > > 
> > > Oh, it is hard to argue with feelings. Also, it is easy to be on
> > > conservative side and put the barrier here just in case.
> > 
> > I'll make it a full mb for now and too am curious to see the end of this
> > discussion explaining things ;-)
> 
> That is, I've now got this queued:

Can we also CC stable@kernel.org?  This has been around for a while.

Mikey

> 
> ---
> Subject: perf: Fix perf ring buffer memory ordering
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Mon Oct 28 13:55:29 CET 2013
> 
> The PPC64 people noticed a missing memory barrier and crufty old
> comments in the perf ring buffer code. So update all the comments and
> add the missing barrier.
> 
> When the architecture implements local_t using atomic_long_t there
> will be double barriers issued; but short of introducing more
> conditional barrier primitives this is the best we can do.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: michael@ellerman.id.au
> Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Michael Neuling <mikey@neuling.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: anton@samba.org
> Cc: benh@kernel.crashing.org
> Reported-by: Victor Kaplansky <victork@il.ibm.com>
> Tested-by: Victor Kaplansky <victork@il.ibm.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/20131025173749.GG19466@laptop.lan
> ---
>  include/uapi/linux/perf_event.h |   12 +++++++-----
>  kernel/events/ring_buffer.c     |   31 +++++++++++++++++++++++++++----
>  2 files changed, 34 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/include/uapi/linux/perf_event.h
> ===================================================================
> --- linux-2.6.orig/include/uapi/linux/perf_event.h
> +++ linux-2.6/include/uapi/linux/perf_event.h
> @@ -479,13 +479,15 @@ struct perf_event_mmap_page {
>  	/*
>  	 * Control data for the mmap() data buffer.
>  	 *
> -	 * User-space reading the @data_head value should issue an rmb(), on
> -	 * SMP capable platforms, after reading this value -- see
> -	 * perf_event_wakeup().
> +	 * User-space reading the @data_head value should issue an smp_rmb(),
> +	 * after reading this value.
>  	 *
>  	 * When the mapping is PROT_WRITE the @data_tail value should be
> -	 * written by userspace to reflect the last read data. In this case
> -	 * the kernel will not over-write unread data.
> +	 * written by userspace to reflect the last read data, after issueing
> +	 * an smp_mb() to separate the data read from the ->data_tail store.
> +	 * In this case the kernel will not over-write unread data.
> +	 *
> +	 * See perf_output_put_handle() for the data ordering.
>  	 */
>  	__u64   data_head;		/* head in the data section */
>  	__u64	data_tail;		/* user-space written tail */
> Index: linux-2.6/kernel/events/ring_buffer.c
> ===================================================================
> --- linux-2.6.orig/kernel/events/ring_buffer.c
> +++ linux-2.6/kernel/events/ring_buffer.c
> @@ -87,10 +87,31 @@ static void perf_output_put_handle(struc
>  		goto out;
>  
>  	/*
> -	 * Publish the known good head. Rely on the full barrier implied
> -	 * by atomic_dec_and_test() order the rb->head read and this
> -	 * write.
> +	 * Since the mmap() consumer (userspace) can run on a different CPU:
> +	 *
> +	 *   kernel				user
> +	 *
> +	 *   READ ->data_tail			READ ->data_head
> +	 *   smp_mb()	(A)			smp_rmb()	(C)
> +	 *   WRITE $data			READ $data
> +	 *   smp_wmb()	(B)			smp_mb()	(D)
> +	 *   STORE ->data_head			WRITE ->data_tail
> +	 *
> +	 * Where A pairs with D, and B pairs with C.
> +	 *
> +	 * I don't think A needs to be a full barrier because we won't in fact
> +	 * write data until we see the store from userspace. So we simply don't
> +	 * issue the data WRITE until we observe it. Be conservative for now.
> +	 *
> +	 * OTOH, D needs to be a full barrier since it separates the data READ
> +	 * from the tail WRITE.
> +	 *
> +	 * For B a WMB is sufficient since it separates two WRITEs, and for C
> +	 * an RMB is sufficient since it separates two READs.
> +	 *
> +	 * See perf_output_begin().
>  	 */
> +	smp_wmb();
>  	rb->user_page->data_head = head;
>  
>  	/*
> @@ -154,9 +175,11 @@ int perf_output_begin(struct perf_output
>  		 * Userspace could choose to issue a mb() before updating the
>  		 * tail pointer. So that all reads will be completed before the
>  		 * write is issued.
> +		 *
> +		 * See perf_output_put_handle().
>  		 */
>  		tail = ACCESS_ONCE(rb->user_page->data_tail);
> -		smp_rmb();
> +		smp_mb();
>  		offset = head = local_read(&rb->head);
>  		head += size;
>  		if (unlikely(!perf_output_space(rb, tail, offset, head)))
> 
