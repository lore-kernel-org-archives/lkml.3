Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032AbaBGLvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:18 -0500
Received: from www.linutronix.de ([62.245.132.108]:43529 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967AbaBGLvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:08 -0500
Date: Fri, 7 Feb 2014 12:51:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Carlo Caione <carlo.caione@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, emilio@elopez.com.ar,
        linux-sunxi@googlegroups.com, t.figa@samsung.com
Subject: Re: [linux-sunxi] Re: [PATCH] irq: Add new flag to ack level-triggered
 interrupts before unmasking
In-Reply-To: <CAOQ7t2bzz9vKh_5h2nF=m+JpeYVa=Ttd4XQgrAa6Lhdzjg_Qxw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402071121310.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org> <alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de> <CAOQ7t2Z0agZdDZ_OQZPtXWXoi5NMTcOOZz04q6wEVNy0rxn4AA@mail.gmail.com> <alpine.DEB.2.02.1402062229000.21991@ionos.tec.linutronix.de>
 <CAOQ7t2bzz9vKh_5h2nF=m+JpeYVa=Ttd4XQgrAa6Lhdzjg_Qxw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Feb 2014, Carlo Caione wrote:
> The context and the rationale is fully explained in this thread
> http://www.spinics.net/lists/arm-kernel/msg299952.html and some
> answers are already given along the thread especially by Hans here
> http://www.spinics.net/lists/arm-kernel/msg303542.html
> Shortly, the double interrupt problem as seen on sunxi NMI controller
> (and other chips AFAIK) is specific for level-triggered interrupts
> when the hard interrupt handler is not able to ACK the interrupts on
> the originating device since this device can only be accessed via a
> bus (in our case it was a PMIC on I2C).
> This explains why my patch was specific for the threaded case and why
> the ACK on mask is not really effective in actually acking the IRQs
> (so that I need a second ACK before unmasking the line). In fact in
> our case (PMIC connected via I2C with an interrupt line on a special
> NMI controller) the implicit ACK done by the unmask is ignored if the
> NMI line is still high, and to have the line going down we have to ACK
> all the IRQs on the device accessing to it by I2C in the thread and
> then ACK the NMI controller with the second ACK before the unmasking
> callback.

I can't see why it would be specific for the threaded case.

The explanation says that the NMI chip is ignoring the ack on mask,
which is basically the entry of the interrupt handler. Now it does not
matter whether you are threaded or not. The interrupt line at the NMI
controller is asserted in both cases. So the same issue should be
visible for a non threaded interrupt, if the NMI controller really
needs an ack on unmask. But there is another detail:

	sunxi_sc_nmi_handle_irq()
	chained_irq_enter()
		NOP, because GIC uses EOI

	generic_handle_irq();
		nmi->mask();		      
		dev_handler();
		nmi->unmask();

	chained_irq_exit()
		gic->eoi();

In the threaded case this looks like:

	sunxi_sc_nmi_handle_irq()
	chained_irq_enter()
		NOP, because GIC uses EOI

	generic_handle_irq();
		nmi->mask();
		wake_thread();

	chained_irq_exit()
		gic->eoi();

	run_thread()
		dev_handler();
		nmi->unmask();

So the difference is that in the non threaded case the gic->eoi is
called after the device interrupt has been cleared and the
nmi->interrupt has been unmasked. And in the threaded case its the
other way round. I have no idea how that stuff is connected internaly,
but I suspect that the gic->eoi is related to this as it might
actually ack the NMI chip, which of course only works in the non
threaded case.

Now back to your patch.

I'm not against having a flag, but this should be done less convoluted
and have proper names which make the use case clear along with a good
technical explanation of the flag in the comment.

unmask_and_ack() plus IRQCHIP_ACK_ON_UNMASK are not really telling
what the heck is going on. You can restrict it to level irqs in the
core, but please use the proper functions and not some opencoded
hackery.

Thanks,

	tglx
