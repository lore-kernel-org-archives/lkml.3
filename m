Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab3KHD7e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:59:34 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:46443 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753652Ab3KHD7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:59:31 -0500
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 22:59:31 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYaABK/CFHO+Ip3/2dsb2JhbABEJrhWhhIXc4IfAQUnExsBIxALISUPBSUkE4gRwS2QKWEDiGGJeYMyiVCFHoFegxU
X-IPAS-Result: AvYaABK/CFHO+Ip3/2dsb2JhbABEJrhWhhIXc4IfAQUnExsBIxALISUPBSUkE4gRwS2QKWEDiGGJeYMyiVCFHoFegxU
X-IronPort-AV: E=Sophos;i="4.84,565,1355115600"; 
   d="scan'208";a="37359027"
Date: Thu, 7 Nov 2013 18:50:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131107235001.GA30034@Krystal>
References: <20131101145634.GH19466@laptop.lan>
 <20131102173239.GB3947@linux.vnet.ibm.com>
 <20131103144017.GA25118@linux.vnet.ibm.com>
 <20131103151704.GJ19466@laptop.lan>
 <CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
 <20131103200124.GK19466@laptop.lan>
 <20131103224242.GF3947@linux.vnet.ibm.com>
 <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20131104112254.GK28601@twins.programming.kicks-ass.net>
X-Editor: vi
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:

[...]

Hi Peter,

Looking at this simplified version of perf's ring buffer
synchronization, I get concerned about the following issue:

> /*
>  * One important detail is that the kbuf part and the kbuf_writer() are
>  * strictly per cpu and we can thus rely on program order for those.
>  *
>  * Only the userspace consumer can possibly run on another cpu, and thus we
>  * need to ensure data consistency for those.
>  */
> 
> struct buffer {
>         u64 size;
>         u64 tail;
>         u64 head;
>         void *data;
> };
> 
> struct buffer *kbuf, *ubuf;
> 
> /*
>  * If there's space in the buffer; store the data @buf; otherwise
>  * discard it.
>  */
> void kbuf_write(int sz, void *buf)
> {
> 	u64 tail, head, offset;
> 
> 	do {
> 		tail = ACCESS_ONCE(ubuf->tail);
> 		offset = head = kbuf->head;
> 		if (CIRC_SPACE(head, tail, kbuf->size) < sz) {
> 			/* discard @buf */
> 			return;
> 		}
> 		head += sz;
> 	} while (local_cmpxchg(&kbuf->head, offset, head) != offset)
> 

Let's suppose we have a thread executing kbuf_write(), interrupted by an
IRQ or NMI right after a successful local_cmpxchg() (space reservation
in the buffer). If the nested execution context also calls kbuf_write(),
it will therefore update ubuf->head (below) with the second reserved
space, and only after that will it return to the original thread context
and continue executing kbuf_write(), thus overwriting ubuf->head with
the prior-to-last reserved offset.

All this probably works OK most of the times, when we have an event flow
guaranteeing that a following event will fix things up, but there
appears to be a risk of losing events near the end of the trace when
those are in nested execution contexts.

Thoughts ?

Thanks,

Mathieu

>         /*
>          * Ensure that if we see the userspace tail (ubuf->tail) such
>          * that there is space to write @buf without overwriting data
>          * userspace hasn't seen yet, we won't in fact store data before
>          * that read completes.
>          */
> 
>         smp_mb(); /* A, matches with D */
> 
>         memcpy(kbuf->data + offset, buf, sz);
> 
>         /*
>          * Ensure that we write all the @buf data before we update the
>          * userspace visible ubuf->head pointer.
>          */
>         smp_wmb(); /* B, matches with C */
> 
>         ubuf->head = kbuf->head;
> }
> 
> /*
>  * Consume the buffer data and update the tail pointer to indicate to
>  * kernel space there's 'free' space.
>  */
> void ubuf_read(void)
> {
>         u64 head, tail;
> 
>         tail = ACCESS_ONCE(ubuf->tail);
>         head = ACCESS_ONCE(ubuf->head);
> 
>         /*
>          * Ensure we read the buffer boundaries before the actual buffer
>          * data...
>          */
>         smp_rmb(); /* C, matches with B */
> 
>         while (tail != head) {
>                 obj = ubuf->data + tail;
>                 /* process obj */
>                 tail += obj->size;
>                 tail %= ubuf->size;
>         }
> 
>         /*
>          * Ensure all data reads are complete before we issue the
>          * ubuf->tail update; once that update hits, kbuf_write() can
>          * observe and overwrite data.
>          */
>         smp_mb(); /* D, matches with A */
> 
>         ubuf->tail = tail;
> }

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
