Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3KSP6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:58:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41378 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KSP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:58:14 -0500
Date: Tue, 19 Nov 2013 16:57:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
Message-ID: <20131119155749.GL10022@twins.programming.kicks-ass.net>
References: <52803E5D.3050109@mentor.com>
 <52851395.3010306@mentor.com>
 <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
 <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:29:12PM +0000, Mathieu Desnoyers wrote:
> Hi,
> 
> I got a bug report on ARM which appears to be caused by an aggressive
> gcc optimisation starting from gcc 4.8.x due to lack of constraints on
> the current_thread_info() inline assembly. The only logical
> explanation for his issue I see so far is that read of the
> preempt_count within might_sleep() is reordered with preempt_enable()
> or preempt_disable(). AFAIU, this kind of issue also applies to other
> architectures.
> 
> First thing, preempt enable/disable only contains barrier() between
> the inc/dec and the inside of the critical section, not the outside.
> Therefore, we are relying on program order to ensure that the
> preempt_count() read in might_sleep() is not reordered with the
> preempt count inc/dec.
> 
> However, looking at ARM arch/arm/include/asm/thread_info.h:
> 
> static inline struct thread_info *current_thread_info(void) { register
> unsigned long sp asm ("sp"); return (struct thread_info *)(sp &
> ~(THREAD_SIZE - 1)); }
> 
> The inline assembly has no clobber and is not volatile. (this is also
> true for all other architectures I've looked at so far, which includes
> x86 and powerpc)
> 
> As long as someone does:
> 
> struct thread_info *myinfo = current_thread_info();
> 
> load from myinfo->preempt_count; store to myinfo->preempt_count;
> 
> The program order should be preserved, because the read and the write
> are done wrt same base. However, what we have here in the case of
> might_sleep() followed by preempt_enable() is:
> 
> load from current_thread_info()->preempt_count; store to
> current_thread_info()->preempt_count;
> 
> Since each current_thread_info() is a different asm ("sp") without
> clobber nor volatile, AFAIU, the compiler is within its right to
> reorder them.
> 
> One possible solution to this might be to add "memory" clobber and
> volatile to this inline asm, but I fear it would put way too much
> constraints on the compiler optimizations (too heavyweight).
> 
> Have any of you experienced this issue ? Any thoughts on the matter ?
> 
> I'm providing the original bug report email exchange below. I had
> confirmation that adding barrier() outside
> preempt_enable()/preempt_disable() does indeed work-around the issue,
> but I fear that this work-around would be leaving the
> current_thread_info() semantic gap in place: people expect program
> order to be respected.

This all brings to mind commit 509eb76ebf977 ("ARM: 7747/1: pcpu: ensure
__my_cpu_offset cannot be re-ordered across barrier()").

GCC seems overly happy with reordering asm() thingies.

Ideally we'd be able to tell gcc that:

  register unsigned long *sp asm ("sp")

not only acts like a variable but should be treated like a variable and
thus such reshuffeling should be limited to preserve program-order.

There doesn't seem to be any __attribute__() that can do this, and
currently out only recourse seems to add either volatile, which seems
overly strict as Mathieu said, or add fake input like Will did.
