Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3IZB0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:26:49 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54302 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3IZB0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:26:48 -0400
MIME-Version: 1.0
In-Reply-To: <1380156027.17366.39.camel@joe-AO722>
References: <1380125886-10341-1-git-send-email-fweisbec@gmail.com>
	<1380125886-10341-8-git-send-email-fweisbec@gmail.com>
	<CA+55aFzPArB0dotWZz8dLTPVM4MMT75NAb5_DVcPrNuvWu4QUA@mail.gmail.com>
	<20130925172121.00c23e416398139f4615943c@linux-foundation.org>
	<1380156027.17366.39.camel@joe-AO722>
Date: Wed, 25 Sep 2013 18:26:47 -0700
X-Google-Sender-Auth: 06T2vwkRBVbp4MBJMfo07mqX8ps
Message-ID: <CA+55aFycQ9XJvEOsiM3txHL5bjUc8CeKWJNR_H+MiicaddB42Q@mail.gmail.com>
Subject: Re: [PATCH 7/7] x86: Tell about irq stack coverage
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 5:40 PM, Joe Perches <joe@perches.com> wrote:
>
> Huh?  That matches all the ARCH_HAS_<foo> patterns.

Right. And they are all crap. lib/string.c is a prime example of
something that should never have happened.

The ARCH_HAS_xyz pattern is totally retarded. It's wrong.

For big conceptual features, we should use Kconfig symbols.

And for smaller things - like lib/string.c - where we have
compatibility fallback functions but want architectures able to
override them with optimized ones one function at a time, we should
either use weak functions (appropriate for some cases), or the symbol
that protects them should the the SAME SYMBOL WE USE. Rather than some
made-up crap-for-brains new ARCH_HAS_xyz symbol. That way it shows up
in greps, and that way we don't have any question about what random
symbol pattern we use that particular day.

So for *bad* use, see lib/string.c, and the ARCH_AS_xyz horror.

For *good* use, see lib/div64.c or lib/find_next_bit.c.

Notice how div64.c doesn't make up new ARCH_HAS_random_crap names? And
no, you don't have to define those things as macros, you can define
them as functions (inline or not), and then just do

    #define find_next_zero_bit find_next_zero_bit

to tell the rest of the world "Look, I have this defined".

The whole "make up a totally unrelated second name for it" means that
we have things like __HAVE_ARCH_STRLEN but also things like
ARCH_HAS_PREFETCHW. Ugh.

                       Linus
