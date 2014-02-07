Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBGPlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:41:07 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:51640 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbaBGPlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:41:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402071121310.21991@ionos.tec.linutronix.de>
References: <1391721117-27446-1-git-send-email-carlo@caione.org>
	<alpine.DEB.2.02.1402062213590.21991@ionos.tec.linutronix.de>
	<CAOQ7t2Z0agZdDZ_OQZPtXWXoi5NMTcOOZz04q6wEVNy0rxn4AA@mail.gmail.com>
	<alpine.DEB.2.02.1402062229000.21991@ionos.tec.linutronix.de>
	<CAOQ7t2bzz9vKh_5h2nF=m+JpeYVa=Ttd4XQgrAa6Lhdzjg_Qxw@mail.gmail.com>
	<alpine.DEB.2.02.1402071121310.21991@ionos.tec.linutronix.de>
Date: Fri, 7 Feb 2014 16:41:03 +0100
Message-ID: <CAOQ7t2b5qVTUXOB4iWAOoTehm=u6zxP0-zQmirSF0DvEk8KddQ@mail.gmail.com>
Subject: Re: [linux-sunxi] Re: [PATCH] irq: Add new flag to ack
 level-triggered interrupts before unmasking
From: Carlo Caione <carlo.caione@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans De Goede <hdegoede@redhat.com>, emilio@elopez.com.ar,
        linux-sunxi@googlegroups.com, t.figa@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 12:51 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> I can't see why it would be specific for the threaded case.
>
> The explanation says that the NMI chip is ignoring the ack on mask,
> which is basically the entry of the interrupt handler. Now it does not
> matter whether you are threaded or not. The interrupt line at the NMI
> controller is asserted in both cases. So the same issue should be
> visible for a non threaded interrupt, if the NMI controller really
> needs an ack on unmask.

Yes, you are right. I was focusing on the threaded case because it was
the only case I have experienced with the hardware I have.
The problem should be there also for the non threaded case (even
though I don't know how to double check this).
At this point I suspect that here the problem is that ACKing the NMI
controller without ACKing ahead the device connected always fails (or
at least is useless and the pending flag is not cleared), so when I
unmask later the irqchip I have a spurious interrupt. That's why I
need another ACK for the NMI controller _after_ having ACKed at device
level.

> But there is another detail:
>
>         sunxi_sc_nmi_handle_irq()
>         chained_irq_enter()
>                 NOP, because GIC uses EOI
>
>         generic_handle_irq();
>                 nmi->mask();
>                 dev_handler();
>                 nmi->unmask();
>
>         chained_irq_exit()
>                 gic->eoi();
>
> In the threaded case this looks like:
>
>         sunxi_sc_nmi_handle_irq()
>         chained_irq_enter()
>                 NOP, because GIC uses EOI
>
>         generic_handle_irq();
>                 nmi->mask();
>                 wake_thread();
>
>         chained_irq_exit()
>                 gic->eoi();
>
>         run_thread()
>                 dev_handler();
>                 nmi->unmask();
>
> So the difference is that in the non threaded case the gic->eoi is
> called after the device interrupt has been cleared and the
> nmi->interrupt has been unmasked. And in the threaded case its the
> other way round. I have no idea how that stuff is connected internaly,
> but I suspect that the gic->eoi is related to this as it might
> actually ack the NMI chip, which of course only works in the non
> threaded case.

Yeah, no really difference between threaded and non threaded.
For the record, from a mail exchange with Allwinner's engineers: "the
NMI module is a signal conversion module. It catches the NMI pin's
state and generates irq to GIC", so GIC does not really ACK anything.
BTW being a dummy "signal conversion module" this is probably why I
still need to clear the pending status even though my IRQ line has
already been cleared.

> Now back to your patch.
>
> I'm not against having a flag, but this should be done less convoluted
> and have proper names which make the use case clear along with a good
> technical explanation of the flag in the comment.

Ok, at this point do you think that a patch in the core could be
useful or is it better to stick with modifying the unmask callback?

> unmask_and_ack() plus IRQCHIP_ACK_ON_UNMASK are not really telling
> what the heck is going on. You can restrict it to level irqs in the
> core, but please use the proper functions and not some opencoded
> hackery.

I'll do in case of v2.

Thanks,

-- 
Carlo Caione
