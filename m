Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3KFQHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:07:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60077 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3KFQHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:07:50 -0500
Date: Wed, 6 Nov 2013 17:07:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, anton@samba.org,
        mathieu.desnoyers@polymtl.ca, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, paulmck@linux.vnet.ibm.com,
        benh@kernel.crashing.org, fweisbec@gmail.com, VICTORK@il.ibm.com,
        tglx@linutronix.de, oleg@redhat.com, mikey@neuling.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] tools/perf: Add required memory barriers
Message-ID: <20131106160720.GK26785@twins.programming.kicks-ass.net>
References: <20131030104246.GH16117@laptop.programming.kicks-ass.net>
 <tip-a94d342b9cb09edfe888ea972af0883b6a8d992b@git.kernel.org>
 <alpine.DEB.2.02.1311060847340.27224@pianoman.cluster.toy>
 <20131106140011.GL10651@twins.programming.kicks-ass.net>
 <20131106144456.GI26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106144456.GI26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:44:56PM +0100, Peter Zijlstra wrote:
> long head = ((__atomic long)pc->data_head).load(memory_order_acquire);
> 
> coupled with:
> 
> ((__atomic long)pc->data_tail).store(tail, memory_order_release);
> 
> might be the 'right' and proper C11 incantations to avoid having to
> touch kernel macros; but would obviously require a recent compiler.
> 
> Barring that, I think we're stuck with:
> 
> long head = ACCESS_ONCE(pc->data_head);
> smp_rmb();
> 
> ...
> 
> smp_mb();
> pc->data_tail = tail;
> 
> And using the right asm goo for the barriers. That said, all these asm
> barriers should include a compiler barriers (memory clobber) which
> _should_ avoid the worst compiler trickery -- although I don't think it
> completely obviates the need for ACCESS_ONCE() -- uncertain there.

http://software.intel.com/en-us/articles/single-producer-single-consumer-queue/

There's one for icc on x86.
