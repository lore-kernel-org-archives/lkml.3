Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaLPUhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:37:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:51617 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPUhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:37:45 -0500
Date: Tue, 16 Dec 2014 21:37:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
In-Reply-To: <20141216192609.778f5f8d@bbrezillon>
Message-ID: <alpine.DEB.2.11.1412162125000.17382@nanos>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com> <2662748.NJbkr6jW7r@vostro.rjw.lan> <3542278.8lcJeXLMFm@vostro.rjw.lan> <20141216100715.57baeb65@bbrezillon> <alpine.DEB.2.11.1412161013570.17382@nanos>
 <20141216192609.778f5f8d@bbrezillon>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2014, Boris Brezillon wrote:
> On Tue, 16 Dec 2014 11:03:55 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > That avoids the whole flag, action, whatever business for the price of
> > a really trivial demux mechanism. Everything just works. Even the irq
> > storm detector will just disable the parent interrupt once all
> > handlers return NONE often enough.
> 
> Still have one question regarding the spurious interrupt detection code.
> AFAIU, it disables a specific IRQ handler if it triggers to often with
> an IRQ_NONE return, right ?
> 
> In this dumb demuxer I can't tell which child interrupt should be
> handled (there is no interrupt cause register), thus I call
> generic_handle_irq on all unmasked IRQs.
> Isn't there a risk to get some of my child interrupts disabled because
> they always return IRQ_NONE (which is a normal use case for
> IRQF_SHARED: we're only expecting at least one handler to return
> IRQ_HANDLED or IRQ_WAKE_THREAD, not all of them) ?

Good point. I missed that aspect.

Another good reason to make that core infrastructure.

So what you need is the following:

void dumb_demux_handler(....)
{
	irq_return ret = IRQ_NONE:
	int i;

	for_each_demux_irq(i)
		ret |= handle_dumb_demux_irq(base + i);

	note_interrupt(demuxirq, ret);
}   

So that disables the demux irq if all sub handlers return NONE 100k
times in a row. Otherwise if one of them handles it, you're fine.

That more or less resembles the shared action magic.

So yes, that wants to be core functionality which can be instantiated
from an affected irq chip for this particular case of HW insanity.

Thanks,

	tglx


