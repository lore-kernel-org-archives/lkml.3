Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3JHTmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:42:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab3JHTmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:42:11 -0400
Date: Tue, 8 Oct 2013 21:35:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131008193507.GA10145@redhat.com>
References: <20131005234430.GA22485@localhost> <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com> <20131008075151.GA15689@localhost> <CA+55aFykGxmaE9hq9xd+6HHFtEube_2QnB+ipW4oF71c6vyXAw@mail.gmail.com> <20131008185154.GA8258@redhat.com> <20131008190523.GW30970@tucnak.zalov.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008190523.GW30970@tucnak.zalov.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08, Jakub Jelinek wrote:
>
> On Tue, Oct 08, 2013 at 08:51:54PM +0200, Oleg Nesterov wrote:
> >
> > I do not really understand inline assembly constraints, but I'll ask
> > anyway.
> >
> > 	+#define __GEN_RMWcc(fullop, var, cc, ...) \
> > 	+do { \
> > 	+ asm volatile goto (fullop "; j" cc " %l[cc_label]" \
> > 	+ : : "m" (var), ## __VA_ARGS__ \
> > 	      ^^^^^^^^^
> >
> > don't we need
> >
> > 	"+m" (var)
> >
> > here?
>
> You actually can't have output operands with asm goto, only inputs
> and clobbers.  But the "memory" clobber should be enough here.

Thanks Jakub and Linus.

Cough... sorry for off-topic question,

	static inline int test_and_set_bit(long nr, volatile unsigned long *addr)
	{
		int oldbit;

		asm volatile(LOCK_PREFIX "bts %2,%1\n\t"
			     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");

doesn't this mean that "ADDR" doesn't need "+" as well?


> If you suspect a compiler bug, can somebody please narrow it down to
> a single object file (if I've skimmed the patch right, it is just an
> optimization, where object files compiled without and with the patch
> should actually coexist fine in the same kernel), ideally to a single
> routine if possible and post a preprocessed source + gcc command line
> + version of gcc?

Or at least, perhaps it makes sense to identify the include file which
makes the difference. Say, revert the changes in bitops.h, retest, then
in atomic.h if the kernel still fails, etc.

Oleg.

