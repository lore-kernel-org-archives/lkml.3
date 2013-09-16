Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3IPIfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:35:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3IPIfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:35:05 -0400
Date: Mon, 16 Sep 2013 11:37:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-ID: <20130916083707.GC815@redhat.com>
References: <87ioy11k8s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 01:38:35PM +0930, Rusty Russell wrote:
> Predates git, does anyone remember the rationale?
> 
> ie:
>         int test_bit(int nr, const volatile unsigned long *addr)
> 
> I noticed because gcc failed to elimiate some code in a patch I was
> playing with.
> 
> I'm nervous about subtle bugs involved in ripping it out, even if noone
> knows why.  Should I add __test_bit()?
> 
> Thanks,
> Rusty.

So looking at this some more, e.g. on x86 I see:

static inline int variable_test_bit(long nr, volatile const unsigned
long *addr)
{
        int oldbit;

        asm volatile("bt %2,%1\n\t"
                     "sbb %0,%0"
                     : "=r" (oldbit)
                     : "m" (*(unsigned long *)addr), "Ir" (nr));

        return oldbit;
}

and I have a vague memory that (at least for some old versions) gcc
would assume (*(unsigned long *)addr) only refers to addr[0].

OTOH constant_test_bit is
static __always_inline int constant_test_bit(long nr, const volatile unsigned long *addr)
{
        return ((1UL << (nr & (BITS_PER_LONG-1))) &
                (addr[nr >> _BITOPS_LONG_SHIFT])) != 0;
}

So there's a chance that we can drop volatile here.

I'll look at it some more.

-- 
MST
