Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3KTAlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:41:19 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:33269 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3KTAlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
References: <52803E5D.3050109@mentor.com>
	<52851395.3010306@mentor.com>
	<67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
	<1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
Date: Tue, 19 Nov 2013 16:41:17 -0800
X-Google-Sender-Auth: wPOMOW-vYS16jgfC4vSNVXsoS-0
Message-ID: <CA+55aFw923sA0E1RQNxFF0OWFtAfcaG-dBUc-0YYZGDSAsaQyg@mail.gmail.com>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 7:29 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Since each current_thread_info() is a different asm ("sp") without clobber nor volatile, AFAIU, the compiler is within its right to reorder them.

I don't understand why you say that.

The ordering of the access to the asm("sp") register is totally
irrelevant. You are "correct" in saying that the compiler is within
its right to re-order them, but that is the worst kind of correct:
it's totally immaterial. In fact, we *want* the compiler to not just
re-order the accesses to %sp, but to notice that it can combine them,
and do CSE on that whole expression when it is used multiple times
within the same function (like it often is used).

So the compiler can very much decide to re-read %sp all it wants, and
re-order those reads all it wants, and that's not the bug at all.
Putting a clobber or a volatile on it would disable the optimization
we *want* to happen.

So don't bark up the wrong tree.

The bug seems to be that gcc re-orders the *memory* *accesses* through
that point, which is not correct in any way, shape, or form. If we
have a write to a memory location followed by a read of the same
memory location, the compiler ABSOLUTELY MUST NOT RE-ORDER THEM. The
write obviously changes the value of the read.

It seems that some gcc alias analysis completely incorrectly thinks
that they are not the same memory location, and do not alias. My guess
would be that gcc sees that that they are based on the stack pointer
with "different" offsets, and decides that the memory locations must
be different - without noticing that the "& ~(THREAD_SIZE - 1)" will
end up generating the same address for both of them.

There may be some insane "two different objects on the stack cannot
alias" logic, which is true for *objects* on the stack, but it sure as
hell isn't true for random accesses through asm("sp").

If I read this thread correctly, you're all talking about something
else than the actual bug, and are trying to say that there is
something wrong with re-ordering the access to %sp itself. Missing the
_real_ bug entirely. See above.

                  Linus
