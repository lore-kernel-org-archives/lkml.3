Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3JWOTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 10:19:55 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:55524 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3JWOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 10:19:53 -0400
Date: Wed, 23 Oct 2013 15:19:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michael Neuling <mikey@neuling.org>, Peter Zijlstra <peterz@infradead.org>
Cc: benh@kernel.crashing.org, anton@samba.org, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131023141948.GB3566@localhost.localdomain>
References: <12083.1382486094@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12083.1382486094@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 10:54:54AM +1100, Michael Neuling wrote:
> Frederic,
> 
> In the perf ring buffer code we have this in perf_output_get_handle():
> 
> 	if (!local_dec_and_test(&rb->nest))
> 		goto out;
> 
> 	/*
> 	 * Publish the known good head. Rely on the full barrier implied
> 	 * by atomic_dec_and_test() order the rb->head read and this
> 	 * write.
> 	 */
> 	rb->user_page->data_head = head;
> 
> The comment says atomic_dec_and_test() but the code is
> local_dec_and_test().
> 
> On powerpc, local_dec_and_test() doesn't have a memory barrier but
> atomic_dec_and_test() does.  Is the comment wrong, or is
> local_dec_and_test() suppose to imply a memory barrier too and we have
> it wrongly implemented in powerpc?
> 
> My guess is that local_dec_and_test() is correct but we to add an
> explicit memory barrier like below:
> 
> (Kudos to Victor Kaplansky for finding this)
> 
> Mikey
> 
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index cd55144..95768c6 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -87,10 +87,10 @@ again:
>  		goto out;
>  
>  	/*
> -	 * Publish the known good head. Rely on the full barrier implied
> -	 * by atomic_dec_and_test() order the rb->head read and this
> -	 * write.
> +	 * Publish the known good head. We need a memory barrier to order the
> +	 * order the rb->head read and this write.
>  	 */
> +	smp_mb ();
>  	rb->user_page->data_head = head;
>  
>  	/*


I'm adding Peter in Cc since he wrote that code.
I agree that local_dec_and_test() doesn't need to imply an smp barrier.
All it has to provide as a guarantee is the atomicity against local concurrent
operations (interrupts, preemption, ...).

Now I'm a bit confused about this barrier.

I think we want this ordering:

    Kernel                             User

   READ rb->user_page->data_tail       READ rb->user_page->data_head
   smp_mb()                            smp_mb()
   WRITE rb data                       READ rb  data
   smp_mb()                            smp_mb()
   rb->user_page->data_head            WRITE rb->user_page->data_tail

So yeah we want a berrier between the data published and the user data_head.
But this ordering concerns wider layout than just rb->head and rb->user_page->data_head

And BTW I can see an smp_rmb() after we read rb->user_page->data_tail. This is probably the
first kernel barrier in my above example. (not sure if rmb() alone is enough though).
