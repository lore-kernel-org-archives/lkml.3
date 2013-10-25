Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JYUcB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 16:32:01 -0400
Received: from ozlabs.org ([203.10.76.45]:37150 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349Ab3JYUcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 16:32:00 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, benh@kernel.crashing.org,
        anton@samba.org, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au
Subject: Re: perf events ring buffer memory barrier on powerpc
In-reply-to: <20131025173749.GG19466@laptop.lan>
References: <12083.1382486094@ale.ozlabs.ibm.com> <20131023141948.GB3566@localhost.localdomain> <20131025173749.GG19466@laptop.lan>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Fri, 25 Oct 2013 19:37:49 +0200."
X-Mailer: MH-E 8.2; nmh 1.5; GNU Emacs 23.4.1
Date: Sat, 26 Oct 2013 07:31:59 +1100
Message-ID: <24406.1382733119@ale.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would argue for:
> 
>   READ ->data_tail			READ ->data_head
>   smp_rmb()	(A)			smp_rmb()	(C)
>   WRITE $data				READ $data
>   smp_wmb()	(B)			smp_mb()	(D)
>   STORE ->data_head			WRITE ->data_tail
> 
> Where A pairs with D, and B pairs with C.
> 
> I don't think A needs to be a full barrier because we won't in fact
> write data until we see the store from userspace. So we simply don't
> issue the data WRITE until we observe it.
> 
> OTOH, D needs to be a full barrier since it separates the data READ from
> the tail WRITE.
> 
> For B a WMB is sufficient since it separates two WRITEs, and for C an
> RMB is sufficient since it separates two READs.

FWIW the testing Victor did confirms WMB is good enough on powerpc.

Thanks,
Mikey

> 
> ---
>  kernel/events/ring_buffer.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index cd55144270b5..c91274ef4e23 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -87,10 +87,31 @@ static void perf_output_put_handle(struct perf_output_handle *handle)
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
> +	 *   smp_rmb()	(A)			smp_rmb()	(C)
> +	 *   WRITE $data			READ $data
> +	 *   smp_wmb()	(B)			smp_mb()	(D)
> +	 *   STORE ->data_head			WRITE ->data_tail
> +	 * 
> +	 * Where A pairs with D, and B pairs with C.
> +	 * 
> +	 * I don't think A needs to be a full barrier because we won't in fact
> +	 * write data until we see the store from userspace. So we simply don't
> +	 * issue the data WRITE until we observe it.
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
> @@ -154,6 +175,8 @@ int perf_output_begin(struct perf_output_handle *handle,
>  		 * Userspace could choose to issue a mb() before updating the
>  		 * tail pointer. So that all reads will be completed before the
>  		 * write is issued.
> +		 *
> +		 * See perf_output_put_handle().
>  		 */
>  		tail = ACCESS_ONCE(rb->user_page->data_tail);
>  		smp_rmb();
> 
