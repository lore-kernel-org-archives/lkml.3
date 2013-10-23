Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab3JWHkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:40:06 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:48501 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3JWHkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:40:03 -0400
In-Reply-To: <12083.1382486094@ale.ozlabs.ibm.com>
References: <12083.1382486094@ale.ozlabs.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
X-KeepSent: D776C320:26C485FF-43257C0D:00264F32;
 type=4; name=$KeepSent
To: Michael Neuling <mikey@neuling.org>
Cc: anton@samba.org, benh@kernel.crashing.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        michael@ellerman.id.au
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFD776C320.26C485FF-ON43257C0D.00264F32-43257C0D.002A1BA7@il.ibm.com>
From: Victor Kaplansky <VICTORK@il.ibm.com>
Date: Wed, 23 Oct 2013 10:39:55 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5|July 31, 2013) at
 23/10/2013 10:39:45
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102307-2966-0000-0000-0000091FAE07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See below.

Michael Neuling <mikey@neuling.org> wrote on 10/23/2013 02:54:54 AM:

>
> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> index cd55144..95768c6 100644
> --- a/kernel/events/ring_buffer.c
> +++ b/kernel/events/ring_buffer.c
> @@ -87,10 +87,10 @@ again:
>        goto out;
>
>     /*
> -    * Publish the known good head. Rely on the full barrier implied
> -    * by atomic_dec_and_test() order the rb->head read and this
> -    * write.
> +    * Publish the known good head. We need a memory barrier to order the
> +    * order the rb->head read and this write.
>      */
> +   smp_mb ();
>     rb->user_page->data_head = head;
>
>     /*

1. As far as I understand, smp_mb() is superfluous in this case, smp_wmb()
should be enough.
   (same for the space between the name of function and open
parenthesis :-) )

2. Again, as far as I understand from ./Documentation/atomic_ops.txt, it is
mistake in architecture independent
   code to rely on memory barriers in atomic operations, all the more so in
"local" operations.

3. The solution above is sub-optimal on architectures where memory barrier
is part of "local", since we are going to execute
   two consecutive barriers. So, maybe, it would be better to use
smp_mb__after_atomic_dec().

4. I'm not sure, but I think there is another, unrelated potential problem
in function perf_output_put_handle()
   - the write to "data_head" -

kernel/events/ring_buffer.c:

 77         /*
 78          * Publish the known good head. Rely on the full barrier
implied
 79          * by atomic_dec_and_test() order the rb->head read and this
 80          * write.
 81          */
 82         rb->user_page->data_head = head;

As data_head is 64-bit wide, the update should be done by an atomic64_set
().

Regards,
-- Victor

