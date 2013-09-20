Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3ITJ0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 05:26:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:39468 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3ITJ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 05:26:17 -0400
Date: Fri, 20 Sep 2013 11:26:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Andreas Schwab <schwab@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1309201124211.4089@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013, Geert Uytterhoeven wrote:

> On Thu, Sep 19, 2013 at 7:02 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > Thomas Gleixner <tglx@linutronix.de> writes:
> >> +     /*
> >> +      * Only the last interrupt leaving the kernel goes through the
> >> +      * various exception return checks.
> >> +      */
> >> +     cmpl    #0, %d0
> >         tstl    %d0
> 
> arch/m68k/kernel/built-in.o: In function `bad_inthandler':
> (.text+0x2a6): undefined reference to `ret_from_last_interrupt'
> 
> I came up with the quick (whitespace-damaged-gmail) fix below.
> Or should we handle the nesting in handle_badint(), too?

Hmm, probably yes. If a badint gets interrupted by a good one, you
would fail to go through ret_from_exception.
 
> --- a/arch/m68k/kernel/entry.S
> +++ b/arch/m68k/kernel/entry.S
> @@ -313,17 +313,11 @@ user_irqvec_fixup = . + 2
> 
>  ENTRY(bad_inthandler)
>         SAVE_ALL_INT
> -       GET_CURRENT(%d0)
> -       movel   %d0,%a1
> -       addqb   #1,%a1@(TINFO_PREEMPT+1)
> 
>         movel   %sp,%sp@-
>         jsr     handle_badint
>         addql   #4,%sp
> 
> -       movel   %curptr@(TASK_STACK),%a1
> -       subqb   #1,%a1@(TINFO_PREEMPT+1)
> -       jeq     ret_from_last_interrupt
>         RESTORE_ALL
> 
> However, the resulting kernel hangs (on ARAnyM) after starting userspace:
> 
> | INIT: version 2.86 booting

Hmm.
 
> I'll have a deeper look when I have some more time...

Thanks a lot!

       tglx
