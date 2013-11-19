Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3KSRCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 12:02:22 -0500
Received: from mail.efficios.com ([78.47.125.74]:56888 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab3KSRCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 12:02:21 -0500
Date: Tue, 19 Nov 2013 17:02:20 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1656507422.70913.1384880540574.JavaMail.zimbra@efficios.com>
In-Reply-To: <20131119160502.GG11778@mudshark.cambridge.arm.com>
References: <52803E5D.3050109@mentor.com> <52851395.3010306@mentor.com> <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com> <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com> <20131119160502.GG11778@mudshark.cambridge.arm.com>
Subject: Re: current_thread_info() not respecting program order with gcc
 4.8.x
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: current_thread_info() not respecting program order with gcc 4.8.x
Thread-Index: 3CCIkbbcGBl5hOaZk6y9jHzTub7UCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Will Deacon" <will.deacon@arm.com>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Cc: linux-kernel@vger.kernel.org, "Catalin Marinas" <Catalin.Marinas@arm.com>, "Peter Zijlstra"
> <peterz@infradead.org>, lttng-dev@lists.lttng.org, "Nathan Lynch" <Nathan_Lynch@mentor.com>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Andrew Morton"
> <akpm@linux-foundation.org>
> Sent: Tuesday, November 19, 2013 11:05:02 AM
> Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
> 
> On Tue, Nov 19, 2013 at 03:29:12PM +0000, Mathieu Desnoyers wrote:
> > Hi,
> 
> Hi Mathieu,

Hi Will,

> 
> > I got a bug report on ARM which appears to be caused by an aggressive gcc
> > optimisation starting from gcc 4.8.x due to lack of constraints on the
> > current_thread_info() inline assembly. The only logical explanation for
> > his issue I see so far is that read of the preempt_count within
> > might_sleep() is reordered with preempt_enable() or preempt_disable().
> > AFAIU, this kind of issue also applies to other architectures.
> > 
> > First thing, preempt enable/disable only contains barrier() between the
> > inc/dec and the inside of the critical section, not the outside.
> > Therefore, we are relying on program order to ensure that the
> > preempt_count() read in might_sleep() is not reordered with the preempt
> > count inc/dec.
> 
> This sounds almost identical to an issue I experienced with our optimised
> per-cpu code (more below).
> 
> > However, looking at ARM arch/arm/include/asm/thread_info.h:
> > 
> > static inline struct thread_info *current_thread_info(void)
> > {
> >         register unsigned long sp asm ("sp");
> >         return (struct thread_info *)(sp & ~(THREAD_SIZE - 1));
> > }
> > 
> > The inline assembly has no clobber and is not volatile. (this is also true
> > for all other architectures I've looked at so far, which includes x86 and
> > powerpc)
> > 
> > As long as someone does:
> > 
> > struct thread_info *myinfo = current_thread_info();
> > 
> > load from myinfo->preempt_count;
> > store to myinfo->preempt_count;
> > 
> > The program order should be preserved, because the read and the write are
> > done wrt same base. However, what we have here in the case of
> > might_sleep() followed by preempt_enable() is:
> > 
> > load from current_thread_info()->preempt_count;
> > store to current_thread_info()->preempt_count;
> > 
> > Since each current_thread_info() is a different asm ("sp") without clobber
> > nor volatile, AFAIU, the compiler is within its right to reorder them.
> > 
> > One possible solution to this might be to add "memory" clobber and volatile
> > to this inline asm, but I fear it would put way too much constraints on
> > the compiler optimizations (too heavyweight).
> 
> Yup, that sucks, because you end up unable to cache the value when you know
> it hasn't changed.
> 
> > Have any of you experienced this issue ? Any thoughts on the matter ?
> 
> The way I got around this for the per-cpu code is to include a dummy memory
> constraint for the stack. This has a couple of advantages:
> 
> 	(1) It hazards against a "memory" clobber, so doesn't require use of
> 	    `volatile'
> 
> 	(2) It doesn't require GCC to emit any address generation code,
> 	    since dereferencing the sp is valid in ARM assembly
> 
> so adding something like:
> 
> 	asm("" :: "Q" (*sp));
> 
> immediately after the declaration of sp in current_therad_info might do the
> trick. Do you have a way to test that?

Unfortunately I don't have a ARM cross-compiler setup ready. Nathan could test
it for us though.

It might shuffle things around enough to work around the issue, but with the
approach you propose, I would be concerned about the compiler being within
its rights to reorder the code into the following sequence:

struct thread_info *ptra, *ptrb;

ptra = current_thread_info();
/*
 * each current_thread_info() would have a clobber on *sp, which orders
 * those two wrt each other.
  */
ptrb = current_thread_info();

load from ptra->preempt_count;
/*
 * however, the following accesses that depend on ptra and ptrb could be
 * reordered if the compiler has no way to know that ptra and ptrb are
 * aliased.
 */
store to ptrb->preempt_count;

One question that might be worth asking: with the local register variable
extension (http://gcc.gnu.org/onlinedocs/gcc-4.8.2/gcc/Local-Reg-Vars.html#Local-Reg-Vars)
(thanks to Jakub for the pointer), should the compiler consider two variables
bound to the same register as being aliased or not ? AFAIU, local reg vars appear
to be architecture-specific, so maybe there is something fishy on ARM ?

Thanks,

Mathieu


> 
> Cheers,
> 
> Will
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
