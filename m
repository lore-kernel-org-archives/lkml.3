Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3KTPKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:10:52 -0500
Received: from mail.efficios.com ([78.47.125.74]:33088 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab3KTPKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:10:48 -0500
Date: Wed, 20 Nov 2013 15:10:48 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <1067303101.71379.1384960248303.JavaMail.zimbra@efficios.com>
In-Reply-To: <CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
References: <52803E5D.3050109@mentor.com> <52851395.3010306@mentor.com> <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com> <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com> <CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc
 4.8.x
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF25 (Linux)/8.0.5_GA_5839)
Thread-Topic: current_thread_info() not respecting program order with gcc 4.8.x
Thread-Index: Wh6Pm4YYXhGJerOt9+kRJK8Xk4BAFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Linus Torvalds" <torvalds@linux-foundation.org>
> To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Jakub Jelinek" <jakub@redhat.com>, "Richard Henderson"
> <rth@twiddle.net>
> Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>, "Will Deacon" <will.deacon@arm.com>, "Catalin
> Marinas" <catalin.marinas@arm.com>, "Peter Zijlstra" <peterz@infradead.org>, lttng-dev@lists.lttng.org, "Nathan
> Lynch" <Nathan_Lynch@mentor.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "Andrew Morton"
> <akpm@linux-foundation.org>
> Sent: Tuesday, November 19, 2013 7:41:17 PM
> Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
> 
> On Tue, Nov 19, 2013 at 7:29 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > Since each current_thread_info() is a different asm ("sp") without clobber
> > nor volatile, AFAIU, the compiler is within its right to reorder them.
> 
> I don't understand why you say that.
> 
> The ordering of the access to the asm("sp") register is totally
> irrelevant. You are "correct" in saying that the compiler is within
> its right to re-order them, but that is the worst kind of correct:
> it's totally immaterial. In fact, we *want* the compiler to not just
> re-order the accesses to %sp, but to notice that it can combine them,
> and do CSE on that whole expression when it is used multiple times
> within the same function (like it often is used).
> 
> So the compiler can very much decide to re-read %sp all it wants, and
> re-order those reads all it wants, and that's not the bug at all.
> Putting a clobber or a volatile on it would disable the optimization
> we *want* to happen.
> 
> So don't bark up the wrong tree.
> 
> The bug seems to be that gcc re-orders the *memory* *accesses* through
> that point, which is not correct in any way, shape, or form. If we
> have a write to a memory location followed by a read of the same
> memory location, the compiler ABSOLUTELY MUST NOT RE-ORDER THEM. The
> write obviously changes the value of the read.
> 
> It seems that some gcc alias analysis completely incorrectly thinks
> that they are not the same memory location, and do not alias. My guess
> would be that gcc sees that that they are based on the stack pointer
> with "different" offsets, and decides that the memory locations must
> be different - without noticing that the "& ~(THREAD_SIZE - 1)" will
> end up generating the same address for both of them.
> 
> There may be some insane "two different objects on the stack cannot
> alias" logic, which is true for *objects* on the stack, but it sure as
> hell isn't true for random accesses through asm("sp").
> 
> If I read this thread correctly, you're all talking about something
> else than the actual bug, and are trying to say that there is
> something wrong with re-ordering the access to %sp itself. Missing the
> _real_ bug entirely. See above.

Yes, exactly, your explanation clarifies the underlying issue I'm trying to
point at.

Thank you !

Mathieu


> 
>                   Linus
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
