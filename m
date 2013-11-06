Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3KFR3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 12:29:54 -0500
Received: from smtpauth03h.mfg.siteprotect.com ([64.26.60.134]:56807 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750871Ab3KFR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 12:29:53 -0500
Date: Wed, 6 Nov 2013 12:31:53 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <peterz@infradead.org>
cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
In-Reply-To: <20131106160720.GK26785@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.02.1311061223290.28798@pianoman.cluster.toy>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net> <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org> <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy> <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net> <20131106160720.GK26785@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020209.527A7C91.0003,ss=1,re=0.100,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Nov 2013, Peter Zijlstra wrote:

> On Wed, Nov 06, 2013 at 03:44:56PM +0100, Peter Zijlstra wrote:
> > long head = ((__atomic long)pc->data_head).load(memory_order_acquire);
> > 
> > coupled with:
> > 
> > ((__atomic long)pc->data_tail).store(tail, memory_order_release);
> > 
> > might be the 'right' and proper C11 incantations to avoid having to
> > touch kernel macros; but would obviously require a recent compiler.
> > 
> > Barring that, I think we're stuck with:
> > 
> > long head = ACCESS_ONCE(pc->data_head);
> > smp_rmb();
> > 
> > ...
> > 
> > smp_mb();
> > pc->data_tail = tail;
> > 
> > And using the right asm goo for the barriers. That said, all these asm
> > barriers should include a compiler barriers (memory clobber) which
> > _should_ avoid the worst compiler trickery -- although I don't think it
> > completely obviates the need for ACCESS_ONCE() -- uncertain there.
> 
> http://software.intel.com/en-us/articles/single-producer-single-consumer-queue/
> 
> There's one for icc on x86.
> 

I think the problem here is this really isn't a good interface.

Most users just want the most recent batch of samples.  Something like

    char buffer[4096];
    int count;

    do {
       count=perf_read_sample_buffer(buffer,4096);
       process_samples(buffer);
    } while(count);

where perf_read_sample_buffer() is a syscall that just copies the current 
valid samples to userspace.

Yes, this is inefficient (requires an extra copy of the values) but the 
kernel then could handle all the SMP/multithread/barrier/locking issues.

How much overhead is really introduced by making a copy?

Requiring the user of a kernel interface to have a deep knowledge of 
optimizing compilers, barriers, and CPU memory models is just asking for 
trouble.

Especially as this all needs to get documented in the manpage and I'm not 
sure that's possible in a sane fashion.

Vince


