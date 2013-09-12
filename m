Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab3ILCnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 22:43:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33918 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3ILCnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 22:43:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130912022040.GT31370@twins.programming.kicks-ass.net>
References: <20130910135636.GA8268@gmail.com>
	<CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
	<20130910164519.GL31370@twins.programming.kicks-ass.net>
	<CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
	<20130910212509.GA18147@laptop.programming.kicks-ass.net>
	<CA+55aFxsEYQPXnoxNXAeSPEkk3uT8iq-_KJVe2M2qZZbtL=cbA@mail.gmail.com>
	<20130911131323.GQ31370@twins.programming.kicks-ass.net>
	<CA+55aFyxcHvQUe_h8cyQrNbGJ6-G_NQnK9pVenABLjCF-7WMXg@mail.gmail.com>
	<20130911185944.GA1798@laptop.programming.kicks-ass.net>
	<CA+55aFxDbqeFumkVApf-L2pi+FQn06GQqQf4rWkzOC4LF=fn=A@mail.gmail.com>
	<20130912022040.GT31370@twins.programming.kicks-ass.net>
Date: Wed, 11 Sep 2013 19:43:42 -0700
X-Google-Sender-Auth: H3y0310SM33wbMu74gYErvJjmxI
Message-ID: <CA+55aFwdS5-U8UtjZ8qsKyn7ap05MPXMFeU-GXgU2PE5KrCrHg@mail.gmail.com>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Peter Anvin <hpa@zytor.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 7:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> I split the thing up into two macros GEN_UNARY_RMWcc and
> GEN_BINARY_RMWcc which ends up being more readable as well as smaller
> code overall.

Yes, that looks like the right abstraction level. Powerful without
being complicated.

> I also attempted to convert asm/bitops.h, although I'm not sure it'll
> compile right with older GCCs due to the comment near BITOP_ADDR()

Actually, since you now have that memory clobber, it no longer
matters, and "m" is the right thing.

That said, the very same memory clobber may be what makes this whole
approach a loss, if it causes gcc to do tons of reloads or other
random things.

That memory clobber wasn't an issue for the whole
__preempt_count_dec_and_test() thing, because there we needed to keep
anything before the decrement contained anyway.

For other cases? Who knows.. A lot of the "change and test atomically"
things have the same containment need, so it might not be a problem.

> I might have to add the clobber to the macro arguments so we can do
> version without "memory" clobber, although bitops is inconsistent with
> that as well, __test_and_clear_bit() doesn't have a memory clobber but
> __test_and_change_bit() does.

You do need the memory clobber. The "asm goto" version can not have
outputs, so "=m" and "+m" are both no-go, and so the only thing left
is that memory clobber, as far as I can see..

The bitops didn't use to need it, because they had that "+/=m" that
already tells gcc that the target is changed.

           Linus
