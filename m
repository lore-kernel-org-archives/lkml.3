Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbaGQN6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:58:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:36193 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaGQN6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:58:52 -0400
Date: Thu, 17 Jul 2014 15:58:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v2 12/29] nios2: Interrupt handling
In-Reply-To: <CAFiDJ58oEfFN5CgLZxqTLSiGfuxNH2t3OFAaSUWLJ_P_B_QRBQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1407171555580.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com> <1405413956-2772-13-git-send-email-lftan@altera.com> <alpine.DEB.2.10.1407151147540.24854@nanos> <CAFiDJ58oEfFN5CgLZxqTLSiGfuxNH2t3OFAaSUWLJ_P_B_QRBQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Ley Foon Tan wrote:

> On Tue, Jul 15, 2014 at 5:51 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Tue, 15 Jul 2014, Ley Foon Tan wrote:
> >> +#ifndef _ASM_NIOS2_IRQ_H
> >> +#define _ASM_NIOS2_IRQ_H
> >> +
> >> +#define NIOS2_CPU_NR_IRQS    32
> >> +/* Reserve 32 additional interrupts for GPIO IRQs */
> >> +#define NR_IRQS                      (NIOS2_CPU_NR_IRQS + 32)
> >
> > Please use sparse irqs. Hardcoded limits tend to work out really bad.
> Yes, will change this.
> >
> >> +#include <linux/init.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/of.h>
> >> +
> 
> >> +static void chip_unmask(struct irq_data *d)
> >> +{
> >> +     u32 ien;
> >> +     ien = RDCTL(CTL_IENABLE);
> >> +     ien |= (1 << d->hwirq);
> >> +     WRCTL(CTL_IENABLE, ien);
> >
> > So this is UP only, right?
> Yes, this is to enable one interrupt.

The question was, whether this is always a UniProcessor machine.

> > Also why don't you cache the register content so spare the extra read
> > from the hardware?
> Need to make sure nobody modify the register if we cache the register content.
> Will keep as it is.

Sigh.

If this is a uniprocessor only design, then nothing can modify the
cached values as all these functions are always called with interrupts
disabled.

If this should be SMP safe, then you'd need serialization of the
register access as well becasue the read/modify/write sequence is not
atomic.

Thanks,

	tglx
