Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3IJRGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:06:47 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:51615 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3IJRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:06:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130910164519.GL31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
	<20130910135152.GD7537@gmail.com>
	<20130910135636.GA8268@gmail.com>
	<CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
	<20130910164519.GL31370@twins.programming.kicks-ass.net>
Date: Tue, 10 Sep 2013 10:06:44 -0700
X-Google-Sender-Auth: IfjuAbTXD293QJRvatt7DjSIaLI
Message-ID: <CA+55aFz7WtcdkwKEGoqCzmC9HsY0LPK-oVK_oATYhRnbGq=2GA@mail.gmail.com>
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

On Tue, Sep 10, 2013 at 9:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The usage site:
>
> #define preempt_enable() \
> do { \
>         barrier(); \
>         if (unlikely(preempt_count_dec_and_test())) \
>                 __preempt_schedule(); \
> } while (0)
>
> Already includes the barrier explicitly, so do we still need the memory
> clobber in that asm goto thing?

Yeah, you do to be safe, just to let gcc know that it may be changing
the memory location.

The issue is that because an "asm goto" cannot have outputs, I had to
change the (correct) "+m" input/output into just a "m" (input).

So without the memory clobber, gcc might decide that the thing doesn't
actually change the preempt count, and perhaps move a load of that
across the "asm goto".

Admittedly, that does sound almost impossibly unlikely, but I'd be
happier being careful.

> That said, your change results in:
>
> * ffffffff8106f45a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
>   ffffffff8106f461:       00
> * ffffffff8106f462:       74 0c                   je     ffffffff8106f470 <kick_process+0x50>
...
> Which is indeed perfect. So should I go 'fix' the other _and_test()
> functions we have to do this same thing?

It would be a good thing to test. There might be downsides with "asm
goto" (maybe it limits gcc some way), but it does in general save us
not only two instructions but also a register.

                 Linus
