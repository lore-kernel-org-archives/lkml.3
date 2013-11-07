Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3KGQji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 11:39:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:52949 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3KGQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 11:39:36 -0500
Date: Thu, 7 Nov 2013 17:39:31 +0100 (CET)
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
In-Reply-To: <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg> <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Geert Uytterhoeven wrote:

> Hi Thomas,
> 
> On Wed, Nov 6, 2013 at 6:23 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> Also note that the value of "nested" doesn't match the indentation level,
> >> which depends on my own bookkeeping using "nesting".
> >
> > Well, nested is just an indicator. It's not the nest level.
> 
> I know, the only thing that matters is whether it's zero or not.
> But it should always be zero if there's no nesting, and non-zero if there
> is, right?
> 
> So:
> 
> #   irq 13 nested 1024
> 
> nested should be 0 here.
> 
> #   irq 4 nested 0
> 
> ok
> 
> #     irq 13 nested 1024
> 
> ok (two extra spaces in front of "irq").
> 
> #     irq 4 nested 0
> 
> nested should be non-zero here.

Hmm. The softirq code reenables interrupts unconditionally. So when an
interrupt hits there SR on stack has the bits cleared. You could
verify that by checking in_serving_softirq() at the entry to
do_IRQ(). That could also explain the irq 4 nests in irq 4 issue. You
can't observe that on the original code as the softirq invocation and
therefor the interrupt enable happens outside of do_IRQ().

Though that does not explain the non nested case where nested is !=
0. But it looks like that irq 13 has a higher level than 4:

> #     irq 13 nested 1024
>
> ok (two extra spaces in front of "irq").

So it could actually be the following:

   irq X arrives, SR I2/1/0 is set to 4

   Now before we reach do_IRQ()
   
	irq 13 arrives and interrupts irq X as it has a higher level

   	Your nest accounting shows 0, but the SR says nested, which is
   	actually the correct state.

Is there an easy to setup/use emulator around on which I could try to
dig into that myself?

Thanks,

	tglx
