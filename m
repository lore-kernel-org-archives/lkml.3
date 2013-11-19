Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3KSWez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:34:55 -0500
Received: from mail.efficios.com ([78.47.125.74]:58131 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab3KSWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:34:54 -0500
Date: Tue, 19 Nov 2013 22:34:57 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Jakub Jelinek <jakub@redhat.com>, gcc@gcc.gnu.org,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Nathan Lynch <Nathan_Lynch@mentor.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, lttng-dev@lists.lttng.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1592290367.71078.1384900497357.JavaMail.zimbra@efficios.com>
In-Reply-To: <554114696.71072.1384899918486.JavaMail.zimbra@efficios.com>
References: <52803E5D.3050109@mentor.com> <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com> <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com> <20131119160502.GG11778@mudshark.cambridge.arm.com> <1656507422.70913.1384880540574.JavaMail.zimbra@efficios.com> <20131119173312.GP16796@laptop.programming.kicks-ass.net> <528BDEA9.1050708@twiddle.net> <554114696.71072.1384899918486.JavaMail.zimbra@efficios.com>
Subject: Re: [lttng-dev] Multiple local register variables w/ same register
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.212.11.60]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: Multiple local register variables w/ same register
Thread-Index: M70R/uo0XUMpi9MkwofOuGT9/N66yHq2tAOS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> To: "Richard Henderson" <rth@twiddle.net>
> Cc: "Jakub Jelinek" <jakub@redhat.com>, gcc@gcc.gnu.org, "Peter Zijlstra" <peterz@infradead.org>, "Catalin Marinas"
> <Catalin.Marinas@arm.com>, "Nathan Lynch" <Nathan_Lynch@mentor.com>, linux-kernel@vger.kernel.org, "Will Deacon"
> <will.deacon@arm.com>, lttng-dev@lists.lttng.org, "Andrew Morton" <akpm@linux-foundation.org>, "Paul E. McKenney"
> <paulmck@linux.vnet.ibm.com>, "Linus Torvalds" <torvalds@linux-foundation.org>
> Sent: Tuesday, November 19, 2013 5:25:18 PM
> Subject: Re: [lttng-dev] Multiple local register variables w/ same register
> 
> ----- Original Message -----
> > From: "Richard Henderson" <rth@twiddle.net>
> > To: "Peter Zijlstra" <peterz@infradead.org>, "Mathieu Desnoyers"
> > <mathieu.desnoyers@efficios.com>
> > Cc: "Will Deacon" <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
> > "Catalin Marinas" <Catalin.Marinas@arm.com>,
> > lttng-dev@lists.lttng.org, "Nathan Lynch" <Nathan_Lynch@mentor.com>, "Paul
> > E. McKenney"
> > <paulmck@linux.vnet.ibm.com>, "Linus Torvalds"
> > <torvalds@linux-foundation.org>, "Andrew Morton"
> > <akpm@linux-foundation.org>, "Jakub Jelinek" <jakub@redhat.com>,
> > gcc@gcc.gnu.org
> > Sent: Tuesday, November 19, 2013 4:56:57 PM
> > Subject: Multiple local register variables w/ same register
> > 
> > On 11/20/2013 03:33 AM, Peter Zijlstra wrote:
> > > On Tue, Nov 19, 2013 at 05:02:20PM +0000, Mathieu Desnoyers wrote:
> > >> Unfortunately I don't have a ARM cross-compiler setup ready. Nathan
> > >> could
> > >> test
> > >> it for us though.
> > >>
> > >> It might shuffle things around enough to work around the issue, but with
> > >> the
> > >> approach you propose, I would be concerned about the compiler being
> > >> within
> > >> its rights to reorder the code into the following sequence:
> > >>
> > >> struct thread_info *ptra, *ptrb;
> > >>
> > >> ptra = current_thread_info();
> > >> /*
> > >>  * each current_thread_info() would have a clobber on *sp, which orders
> > >>  * those two wrt each other.
> > >>   */
> > >> ptrb = current_thread_info();
> > >>
> > >> load from ptra->preempt_count;
> > >> /*
> > >>  * however, the following accesses that depend on ptra and ptrb could be
> > >>  * reordered if the compiler has no way to know that ptra and ptrb are
> > >>  * aliased.
> > >>  */
> > >> store to ptrb->preempt_count;
> > >>
> > >> One question that might be worth asking: with the local register
> > >> variable
> > >> extension
> > >> (http://gcc.gnu.org/onlinedocs/gcc-4.8.2/gcc/Local-Reg-Vars.html#Local-Reg-Vars)
> > >> (thanks to Jakub for the pointer), should the compiler consider two
> > >> variables
> > >> bound to the same register as being aliased or not ? AFAIU, local reg
> > >> vars
> > >> appear
> > >> to be architecture-specific, so maybe there is something fishy on ARM ?
> > 
> > It appears not:
> > 
> > int __attribute__((noinline)) f(void)
> > {
> >   {
> >     register int x __asm__("eax");
> >     x = 1;
> >   }
> >   {
> >     register int y __asm__("eax");
> >     return ++y;
> >   }
> > }
> > 
> > extern void abort(void);
> > 
> > int main(void)
> > {
> >   if (f() != 2)
> >     abort();
> >   return 0;
> > }
> > 
> > Anyone see anything wrong with the testcase?
> 
> This testcase is targeting a general purpose register, whereas the issue I'm
> presenting gets the stack pointer as base address for many memory operations
> targeting the same offset from this base address. So strictly speaking, I
> think the two cases are slightly different.

By the way, I just had more info from Nathan, where a splat clearly shows a scheduling while atomic, which points rather to an unbalanced preempt enable/disable within LTTng. It's weird though, because so far it only triggers on ARM, and only with gcc 4.8.x. Don't waste your time on this one until we can figure out if the issue is within LTTng.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> 
> > Do we thing this sort of thing
> > ought to work, perhaps with scopes lengthened?
> > 
> > 
> > r~
> > 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 
> _______________________________________________
> lttng-dev mailing list
> lttng-dev@lists.lttng.org
> http://lists.lttng.org/cgi-bin/mailman/listinfo/lttng-dev
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
