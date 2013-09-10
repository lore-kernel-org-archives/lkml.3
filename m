Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3IJQe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:34:56 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36550 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3IJQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:34:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130910135636.GA8268@gmail.com>
References: <20130910130811.507933095@infradead.org>
	<20130910135152.GD7537@gmail.com>
	<20130910135636.GA8268@gmail.com>
Date: Tue, 10 Sep 2013 09:34:52 -0700
X-Google-Sender-Auth: n82zUBCumNX9p5wzt7x1FULVVo0
Message-ID: <CA+55aFwmEQeF+PtM7cuaQ8OkuTS=R4JJ61Wwfv8u-Svo-V3KwQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] preempt_count rework -v2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>,
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

On Tue, Sep 10, 2013 at 6:56 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> +static __always_inline bool __preempt_count_dec_and_test(void)
> +{
> +       unsigned char c;
> +
> +       asm ("decl " __percpu_arg(0) "; sete %1"
> +                       : "+m" (__preempt_count), "=qm" (c));
> +
> +       return c != 0;
> +}
>
> And that's where the sete and test originates from.

We could make this use "asm goto" instead.

An "asm goto" cannot have outputs, but this particular one doesn't
_need_ outputs. You could mark the preempt_count memory as an input,
and then have a memory clobber. I think you need the memory clobber
anyway for that preempt-count thing.

So I _think_ something like

static __always_inline bool __preempt_count_dec_and_test(void)
{
       asm goto("decl " __percpu_arg(0) "\n\t"
                "je %l[became_zero]"
                       : :"m" (__preempt_count):"memory":became_zero);
       return 0;
became_zero:
       return 1;
}

would work.

You need to wrap it in

  #ifdef CC_HAVE_ASM_GOTO

and then have the old "sete" version for older compilers, but for
newer ones you'd get pretty much perfect code. UNTESTED.

             Linus
