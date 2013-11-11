Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3KKOLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 09:11:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:41631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3KKOLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 09:11:14 -0500
Date: Mon, 11 Nov 2013 15:11:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
In-Reply-To: <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311111421400.30673@ionos.tec.linutronix.de>
References: <20130917082838.218329307@infradead.org> <20130917182350.449685712@linutronix.de> <20130917183628.534494408@linutronix.de> <CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com> <alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de> <alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de> <87txhg3ftx.fsf@igel.home> <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com> <alpine.DEB.2.02.1311041305540.28335@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1311042032130.16975@ayla.of.borg> <alpine.DEB.2.02.1311061237430.23353@ionos.tec.linutronix.de> <CAMuHMdXDA2MRbR3GmD3KWC-iE6jnWX4uvbf1qeMd7RYX3O8f_g@mail.gmail.com> <alpine.DEB.2.02.1311071655240.23353@ionos.tec.linutronix.de>
 <ecf977d9ccbd241723a606423267bb2d@biophys.uni-duesseldorf.de> <CAMuHMdVXk0NpinvqEszqL63fZEt3rOk6ZR9ogz0aHEzmEaW22A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Nov 2013, Geert Uytterhoeven wrote:

> On Sun, Nov 10, 2013 at 9:49 AM, Michael Schmitz
> <schmitz@biophys.uni-duesseldorf.de> wrote:
> >> Is there an easy to setup/use emulator around on which I could try to
> >> dig into that myself?
> >
> > I believe Geert uses ARAnyM for his tests of m68k kernels on emulators - it
> > is reasonably easy to set up and use. I've used it to debug problems we had
> > with the SLUB allocator two years ago.
> 
> Indeed. ARAnyM is the way to go.

Ok. Got it running and looked a bit deeper. I haven't yet found the
root cause, but there are quite some fishy things going on. Adding
enough debug printks makes the thing boot. Aside of that there seems
to be a violation of the 68k interrupt model.

The 68k interrupt handling allows only interrupts which have an higher
level than the value of the interrupt priority mask in SR. Further the
cpu sets the SR priority mask on interrupt entry to the level of the
interrupt which is serviced.

So now with aranym I can see a different behaviour. I just added the
debug patch below to a vanilla 3.12.

And I can see ever repeating

  IRQ 13 flags 0x400 regs->sr 0x400

with a few

  IRQ 15 flags 0x400 regs->sr 0x400

sprinkeled in.

Not what you would expect, right?

Thanks,

	tglx

Index: linux-2.6/arch/m68k/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/m68k/kernel/irq.c
+++ linux-2.6/arch/m68k/kernel/irq.c
@@ -20,6 +20,12 @@
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
 {
 	struct pt_regs *oldregs = set_irq_regs(regs);
+	unsigned long nested = regs->sr & ~ALLOWINT;
+	unsigned long flags = arch_local_save_flags() & ~ALLOWINT;
+
+	if (nested >= flags)
+		printk(KERN_ERR "IRQ %d flags 0x%lx regs->sr 0x%lx\n",
+		       irq, flags, nested);
 
 	irq_enter();
 	generic_handle_irq(irq);
