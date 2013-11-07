Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3KGOM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:12:26 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55377 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KGOMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:12:24 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org>
	<20130917182350.449685712@linutronix.de>
	<20130917183628.534494408@linutronix.de>
	<CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
	<alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
	<87txhg3ftx.fsf@igel.home>
	<CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
	<alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
	<alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
Date: Thu, 7 Nov 2013 15:12:23 +0100
X-Google-Sender-Auth: NoH4JwpNSVzPCsCShufVEstrDX8
Message-ID: <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Nov 6, 2013 at 6:23 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Also note that the value of "nested" doesn't match the indentation level,
>> which depends on my own bookkeeping using "nesting".
>
> Well, nested is just an indicator. It's not the nest level.

I know, the only thing that matters is whether it's zero or not.
But it should always be zero if there's no nesting, and non-zero if there
is, right?

So:

#   irq 13 nested 1024

nested should be 0 here.

#   irq 4 nested 0

ok

#     irq 13 nested 1024

ok (two extra spaces in front of "irq").

#     irq 4 nested 0

nested should be non-zero here.

>       nested = pt->sr & ~ALLOWINT;
> i.e.:
>       nested = pt->sr & 0x0700;
>
> So in the case above nested is 0x400
>
>> Anyone with an idea where it's going wrong?
>
> The original code does:
>
>     add_preempt_count(HARDIRQ_OFFSET);
>
>     do_IRQ()
>         irq_enter();
>           add_preempt_count(HARDIRQ_OFFSET);
>
>         handle_irq();
>
>         irq_exit();
>             local_irq_disable();
>             sub_preempt_count(HARDIRQ_OFFSET);
>
>     sub_preempt_count(HARDIRQ_OFFSET);
>
>     /* Check for nested irq */
>     if (in_hardirq())
>        reti();
>
>     /* Check for nested irq again */
>     if (pt->sr & ~ALLOWINT != 0)
>        reti();
>
>     do_softirq();
>        ....
>     ret_from_exception();
>
> With the patches in place it looks like this:
>
>      do_IRQ()
>         nested = pt->sr & ~ALLOWINT;
>
>         irq_enter();
>           add_preempt_count(HARDIRQ_OFFSET);
>
>         handle_irq();
>
>         irq_exit_nested(nested);
>             local_irq_disable();
>             sub_preempt_count(HARDIRQ_OFFSET);
>             if (!nested && !in_hardirq())
>                do_softirq()
>
>         return nested;
>
>       if (nested)
>          reti();
>
>       ret_from_exception();
>
> So all it does essentially is to move the softirq invocation in the
> non nested case a tad earlier. I'm really puzzled as I can't spot the
> point where this change makes a real difference.

Yes, that's also my understanding.
But I can't spot it neither :-(

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
