Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaBVXjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:39:02 -0500
Received: from www.linutronix.de ([62.245.132.108]:49204 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaBVXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:39:00 -0500
Date: Sun, 23 Feb 2014 00:38:55 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
In-Reply-To: <CAE9FiQVf7u62S4puc2iMqiFO2YU-Kf35XVB9mC+SEP6Z73x7Zw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402222338420.21251@ionos.tec.linutronix.de>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org> <1388707565-16535-3-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de> <CAE9FiQUo9NGbjiZbMsf2yBFbn=iLJ-jc3QtZ8K6qwVuhmqzq=Q@mail.gmail.com>
 <alpine.DEB.2.02.1402221104440.21251@ionos.tec.linutronix.de> <CAE9FiQVf2L-FjkXR3WC=0iHNY73D2G4jyMeko4f4DPuxAXTK+Q@mail.gmail.com> <CAE9FiQVf7u62S4puc2iMqiFO2YU-Kf35XVB9mC+SEP6Z73x7Zw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014, Yinghai Lu wrote:
> On Sat, Feb 22, 2014 at 9:28 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Sat, Feb 22, 2014 at 2:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >>
> >> As I said before irq_reserve_irq() is a misnomer and a
> >> misconception. Of course this needs to be fixed as well.
> >>
> >> And you cannot just blindly change it because !SPARSE can use the
> >> allocation. We are not creating stupid corner cases just to support
> >> your sloppyness. Its not rocket science to do it the right way.
> >>
> >> That said, it might be worthwhile to get rid of the !SPARSE case
> >> completely. That would probably make quite some stuff simpler.
> >
> > So we need to make all arches support SPARSE_IRQ at first?
> >
> > Now we have arm, arm64, c6x, metag, powerpc, sh, x86 support SPARSE_IRQ.
> >
> > The following  are not with SPARSE_IRQ yet:
> > alpha, arc, avr32, blackfin, cris, frv, hexagon, m32r, m68k, microblaze,
> > mips, mn10300, openrisc, parisc, s390, score, sparc, tile, um,
> > unicore32, xtensa.
> 
> or add calling irq_alloc_desc_at() before irq_set_chip... for !SPARSE_IRQ.
> 
> Please check attached partial patch if you like it.

OMG, you really mean that:

+++ b/arch/alpha/kernel/irq_i8259.c
@@ -92,6 +92,7 @@ init_i8259a_irqs(void)
 	outb(0xff, 0xA1);	/* mask all of 8259A-2 */
 
 	for (i = 0; i < 16; i++) {
+		irq_alloc_desc_at(i, 0);
 		irq_set_chip_and_handler(i, &i8259a_irq_type, handle_level_irq);
 	}

You can't be serious about that. There are tons of ways to call into
the core and access an irq descriptor aside of irq_set_chip* before it
is potentially allocated.

Are you going to analyze all of them and add an irq_alloc_desc_at()
before that call?

HELL, NO!

I'm really tired of that.

Stay away from kernel/irq/* and wait for people who are competent
enough and willing to spend the extra thoughts to come up with
solutions which are not completely ass backwards.

Thanks,

	tglx
