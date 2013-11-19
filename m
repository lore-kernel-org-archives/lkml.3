Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3KSQOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:14:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab3KSQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:14:21 -0500
Date: Tue, 19 Nov 2013 17:13:22 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: current_thread_info() not respecting program order with gcc 4.8.x
Message-ID: <20131119161322.GX892@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <52803E5D.3050109@mentor.com>
 <52851395.3010306@mentor.com>
 <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
 <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
 <20131119155749.GL10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119155749.GL10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 04:57:49PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 19, 2013 at 03:29:12PM +0000, Mathieu Desnoyers wrote:
> > However, looking at ARM arch/arm/include/asm/thread_info.h:
> > 
> > static inline struct thread_info *current_thread_info(void) { register
> > unsigned long sp asm ("sp"); return (struct thread_info *)(sp &
> > ~(THREAD_SIZE - 1)); }
> > 
> > The inline assembly has no clobber and is not volatile. (this is also
> > true for all other architectures I've looked at so far, which includes
> > x86 and powerpc)

The above is not inline assembly, it is a local register variable extension,
see
http://gcc.gnu.org/onlinedocs/gcc-4.8.2/gcc/Local-Reg-Vars.html#Local-Reg-Vars

> > Since each current_thread_info() is a different asm ("sp") without
> > clobber nor volatile, AFAIU, the compiler is within its right to
> > reorder them.

Sure.

> > One possible solution to this might be to add "memory" clobber and
> > volatile to this inline asm, but I fear it would put way too much
> > constraints on the compiler optimizations (too heavyweight).

As it is not inline asm extension, you can't.
Of course you could add asm volatile ("" : "=r" (ret) : "0" (sp));
or similar and thus make it a barrier, but I think the current
definition of current_thread_info meant to avoid all that extra
overhead.  Why does it matter when sp is different between the
current_thread_info () calls?  As long as sp & ~(THREAD_SIZE - 1) is
the same, it shouldn't make a difference.  Or is the call in between those
changing sp to something else?

	Jakub
