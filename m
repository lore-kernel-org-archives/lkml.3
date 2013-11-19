Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3KSWKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:10:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34392 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab3KSWKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:10:45 -0500
Date: Tue, 19 Nov 2013 23:08:40 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Richard Henderson <rth@twiddle.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Catalin Marinas <Catalin.Marinas@arm.com>, lttng-dev@lists.lttng.org,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: Multiple local register variables w/ same register
Message-ID: <20131119220840.GB892@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <52803E5D.3050109@mentor.com>
 <52851395.3010306@mentor.com>
 <67652521.68027.1384482849638.JavaMail.zimbra@efficios.com>
 <1691607547.70809.1384874952002.JavaMail.zimbra@efficios.com>
 <20131119160502.GG11778@mudshark.cambridge.arm.com>
 <1656507422.70913.1384880540574.JavaMail.zimbra@efficios.com>
 <20131119173312.GP16796@laptop.programming.kicks-ass.net>
 <528BDEA9.1050708@twiddle.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528BDEA9.1050708@twiddle.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 07:56:57AM +1000, Richard Henderson wrote:
> It appears not:
> 
> int __attribute__((noinline)) f(void)
> {
>   {
>     register int x __asm__("eax");
>     x = 1;
>   }
>   {
>     register int y __asm__("eax");
>     return ++y;
>   }
> }
> 
> extern void abort(void);
> 
> int main(void)
> {
>   if (f() != 2)
>     abort();
>   return 0;
> }
> 
> Anyone see anything wrong with the testcase?  Do we thing this sort of thing
> ought to work, perhaps with scopes lengthened?

I'd say this is undefined, when a local register var goes out of scope,
it's value can change arbitrarily.  If you insert some call in between the
two scopes, it will surely have clobbered value, and even if there isn't
any call in between those, any insn could in theory clobber those.

	Jakub
