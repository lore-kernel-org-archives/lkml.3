Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaJFIHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 04:07:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:53021 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaJFIHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 04:07:01 -0400
Date: Mon, 6 Oct 2014 10:06:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Richard Cochran <richardcochran@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Why do we still have 32 bit counters? Interrupt counters overflow
 within 50 days
In-Reply-To: <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
Message-ID: <alpine.DEB.2.11.1410060959510.4383@nanos>
References: <alpine.DEB.2.11.1410030435260.8324@gentwo.org> <alpine.DEB.2.11.1410031231420.4383@nanos> <alpine.DEB.2.11.1410030653040.8496@gentwo.org> <20141003120345.GA6652@localhost.localdomain> <alpine.DEB.2.11.1410030706220.8990@gentwo.org>
 <alpine.DEB.2.11.1410052331420.4383@nanos> <alpine.DEB.2.11.1410051824190.3424@gentwo.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014, Christoph Lameter wrote:
> -DEFINE_PER_CPU(unsigned int, irq_count) __visible = -1;
> +DEFINE_PER_CPU(u64, irq_count) __visible = -1;

What's the point of this? irq_count is solely used to figure out
whether interrupts are nested, i.e. whether we need to switch the
stack on x86_64 or not. See the usage sites in arch/x86/kernel/entry_64.S
 
> @@ -51,7 +51,7 @@ struct irq_desc {
>  	unsigned int		core_internal_state__do_not_mess_with_it;
>  	unsigned int		depth;		/* nested irq disables */
>  	unsigned int		wake_depth;	/* nested wake enables */
> -	unsigned int		irq_count;	/* For detecting broken IRQs */
> +	u64			irq_count;	/* For detecting broken IRQs */

This is pointless as this count is solely used for the spurious
detector and reset to 0 when irq_count reaches 100000. See
note_interrupt().

> -extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
> +extern u64 kstat_irqs_cpu(unsigned int irq, int cpu);

Care to fixup the other call sites of this as well? git grep is your friend.

Thanks,

	tglx
