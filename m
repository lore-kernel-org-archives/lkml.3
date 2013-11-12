Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3KLPIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:08:18 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:63501 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3KLPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:08:14 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org>
	<CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
	<alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
	<87txhg3ftx.fsf@igel.home>
	<CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
	<alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311042032130.16975@ayla.of.borg>
	<alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de>
	<CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
	<alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
	<ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de>
	<CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
	<alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311112031220.30673@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1311112052360.30673@ionos.tec.linutronix.de>
Date: Tue, 12 Nov 2013 16:08:13 +0100
X-Google-Sender-Auth: PxK4LQnVd4sMQrv4RsiWqUQHPLA
Message-ID: <CAMuHMdWx68OxP__3EkpTjVnYRk9KjrVrovpk00k_vqYGpshVNw@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Mon, Nov 11, 2013 at 9:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Some more thoughts on this.
>
> The whole nesting check in the exisiting low level entry code and what
> I tried to resemble with the irq_exit_nested() is pretty pointless.
>
> Let's look at auto_inthandler and ret_from_exception
>
> ENTRY(auto_inthandler)
>         SAVE_ALL_INT
>         GET_CURRENT(%d0)
>         movel   %d0,%a1
>         addqb   #1,%a1@(TINFO_PREEMPT+1)
>                                         |  put exception # in d0
>         bfextu  %sp@(PT_OFF_FORMATVEC){#4,#10},%d0
>         subw    #VEC_SPUR,%d0
>
>         movel   %sp,%sp@-
>         movel   %d0,%sp@-               |  put vector # on stack
> auto_irqhandler_fixup = . + 2
>         jsr     do_IRQ                  |  process the IRQ
>         addql   #8,%sp                  |  pop parameters off stack
>
> ret_from_interrupt:
>         movel   %curptr@(TASK_STACK),%a1
>         subqb   #1,%a1@(TINFO_PREEMPT+1)
>         jeq     ret_from_last_interrupt
> 2:      RESTORE_ALL
>
>         ALIGN
> ret_from_last_interrupt:
>         moveq   #(~ALLOWINT>>8)&0xff,%d0
>         andb    %sp@(PT_OFF_SR),%d0
>         jne     2b
>
>         /* check if we need to do software interrupts */
>         tstl    irq_stat+CPUSTAT_SOFTIRQ_PENDING
>         jeq     .Lret_from_exception
>         pea     ret_from_exception
>         jra     do_softirq
>
>
> ENTRY(ret_from_exception)
> .Lret_from_exception:
>         btst    #5,%sp@(PT_OFF_SR)      | check if returning to kernel
>         bnes    1f                      | if so, skip resched, signals
>         ....
> 1:      RESTORE_ALL
>
> So in every interrupt exit path we check:
>
>    1) Whether the hardirq part of preempt_count is zero
>
>    2) Whether the interrupt prio mask of SR on stack is zero
>
> and if we finally reach ret_from_exception we have the final check:
>
>    3) whether we return to kernel or user space.
>
> And this final check is the only one which matters, really.
>
> If you look at the probability of the first two checks catching
> anything, then it's pretty low. Most interrupts returns go through
> ret_from_exception. Yes, I added counters which prove that at least on
> the aranym, but I doubt that it will make a real difference if you run
> this on real hardware.
>
> So what's the point of having these checks in the hotpath? The patch

Most of this seems to be as old as stone-age. It was rewritten for
v2.5.29, but the initial bookkeeping was there in v2.1, and even in some
form in v1.3.94.

> below against 3.12 vanilla works nicely on the aranym and I don't see
> a reason why this extra hackery is necessary at all. It's just code
> bloat in a hotpath.
>
> Now the only valid concern might be do_softirq itself, but that's
> pointless as well. If the softirq is interrupted, then we do not
> invoke it again. If the nested interrupt happens before irq_exit()
> actually disables interrupts, then we won't invoke it either as the
> hardirq part of preempt_count is still not zero.
>
> As a side note: The do_softirq calls in the platform/68xxx entry
> pathes are just copied leftovers as well. Both entry code pathes are
> not fiddling with the preempt count and both call do_IRQ() which will
> call irq_exit() at the end which will invoke do_softirq(), so the
> check for more softirqs in the irq return path is just pointless.

Your reasoning sounds OK, and it works on ARAnyM, so, thanks again and
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

BTW, do you plan to get the "make hardirq bits generic" series in 3.13?
Or do you want me to take this patch through the m68k tree?
So far I don't have any plans to send another pull request for 3.13.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
