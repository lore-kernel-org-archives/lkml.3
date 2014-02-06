Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbaBFQO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:14:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBFQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:14:27 -0500
Date: Thu, 6 Feb 2014 17:14:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 5/5] arch: Sanitize atomic_t bitwise ops
Message-ID: <20140206161418.GS2936@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
 <20140206135001.333583247@infradead.org>
 <CAMuHMdV8BtrwfPWToxX5dUhtSQ4HP+UhWh10LM2voQ82pqcA+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV8BtrwfPWToxX5dUhtSQ4HP+UhWh10LM2voQ82pqcA+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 03:43:19PM +0100, Geert Uytterhoeven wrote:
> On Thu, Feb 6, 2014 at 2:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > --- a/arch/m68k/include/asm/atomic.h
> > +++ b/arch/m68k/include/asm/atomic.h
> > @@ -76,6 +76,9 @@ static inline int atomic_##op##_return(i
> >
> >  ATOMIC_OP(add, +=)
> >  ATOMIC_OP(sub, -=)
> > +ATOMIC_OP(and, &=)
> > +ATOMIC_OP(or , |=)
> > +ATOMIC_OP(xor, ^=)
> 
> This last one ain't gonna fly. Given
> 
> static inline void atomic_##op(int i, atomic_t *v)                     \
> {                                                                      \
>        __asm__ __volatile__(#op "l %1,%0" : "+m" (*v) : ASM_DI (i));   \
> }
> 
> from the previous patch, it'll generate the "xorl" mnemonic, which
> IIRC does not exist. It's called "eorl".

Some instruction sets I googled, others I didn't; guess what I did (or
rather didn't do) for m68k :-)

ok I'll make that:

#define ATOMIC_OP(op, aop, cop)

ATOMIC_OP(xor, eor, ^=)

I had to so similar things on a few other archs as well, asm instruction
names are odd sometimes.

Thanks!
