Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaE1OYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 10:24:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42521 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754398AbaE1OYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 10:24:52 -0400
Date: Wed, 28 May 2014 10:24:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lugovskoy@dev.rtsoft.ru>
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
In-Reply-To: <53858E28.5000403@dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Nikita Yushchenko wrote:

> 27.05.2014 19:08, Alan Stern пишет:
> > On Tue, 27 May 2014, Nikita Yushchenko wrote:
> > 
> >> This access causes hang on Freescale P2020DS board (that has OHCI
> >> provided by ULI 1533 chip).
> > 
> > Which access, the read or the write?
> 
> things are a bit more complex.
> 
> If inserting printk's as below
> 
> 
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -619,16 +619,23 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
>         }
> 
>         /* software reset of the controller, preserving HcFmInterval */
> +       printk("A1\n");
>         fminterval = readl(base + OHCI_FMINTERVAL);
> +       printk("A2\n");

It would help to print the value of fminterval.

>         writel(OHCI_HCR, base + OHCI_CMDSTATUS);
> +       printk("A3\n");
> 
>         /* reset requires max 10 us delay */
>         for (cnt = 30; cnt > 0; --cnt) {        /* ... allow extra time */
> +               printk("A4\n");
>                 if ((readl(base + OHCI_CMDSTATUS) & OHCI_HCR) == 0)
>                         break;

And here to print the value obtained by the readl().

> +               printk("A5\n");
>                 udelay(1);
>         }
> +       printk("A6\n");
>         writel(fminterval, base + OHCI_FMINTERVAL);
> +       printk("A7\n");
> 
>         /* Now the controller is safely in SUSPEND and nothing can wake it up */
>         iounmap(base);
> 
> attempt to boot (using arch/powerpc/configs/mpc85xx_smp_defconfig and deb
> file built by "make p2020ds.dtb" from the same kernel tree) results in
> 
> ...
> A1
> random: nonblocking pool is initialized
> irq 26: nobody cared (try booting with the "irqpoll" option)
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc6-dirty #5
> Call Trace:
> [effe5ed0] [c000726c] show_stack+0x48/0x15c (unreliable)
> [effe5f10] [c05eece4] dump_stack+0x78/0xa0
> [effe5f20] [c0087acc] __report_bad_irq+0x38/0x100
> [effe5f40] [c0088060] note_interrupt+0x224/0x280
> [effe5f70] [c008563c] handle_irq_event_percpu+0xc8/0x178
> [effe5fa0] [c0085730] handle_irq_event+0x44/0x74
> [effe5fc0] [c0088f88] handle_fasteoi_irq+0xd4/0x1d0
> [effe5fd0] [c0084d20] generic_handle_irq+0x30/0x50
> [effe5fe0] [c00048d0] __do_irq+0x2c/0x70
> [effe5ff0] [c000d9a0] call_do_irq+0x24/0x3c
> [ef047d10] [c00049a0] do_IRQ+0x8c/0xf8
> [ef047d30] [c000f598] ret_from_except+0x0/0x18
> --- Exception: 501 at quirk_usb_early_handoff+0x794/0x85c
>     LR = quirk_usb_early_handoff+0x788/0x85c

That exception looks very suspicious.  Do you know what it means?

> [ef047e30] [c02bd66c] pci_fixup_device+0xe0/0x19c
> [ef047e60] [c07d4e1c] pci_apply_final_quirks+0x60/0x13c
> [ef047e90] [c0002494] do_one_initcall+0x158/0x19c
> [ef047f00] [c07ba928] kernel_init_freeable+0x130/0x1e4
> [ef047f30] [c0002a78] kernel_init+0x14/0x10c
> [ef047f40] [c000f014] ret_from_kernel_thread+0x5c/0x64
> handlers:
> [<c001cc78>] fsl_pci_pme_handle
> Disabling IRQ #26

It looks like this IRQ 26 stuff has no connection with OHCI, right?

> A2
> A3
> A4
> A5
> A4
> A5
> A4
> A5
> A4
> A5
> A4
> 
> and hang.

Meaning that it stops completely, not that it goes into an infinite 
loop?

> with my patch applied, board just boots ok and works.
> 
> 
> > It looks like you haven't read ohci_shutdown() and ohci_run() in 
> > drivers/usb/host/ohci-hcd.c.  They both access the fminterval register, 
> > and this patch doesn't change them.
> > 
> > So I don't see why this patch should make any difference to the 
> > system's operation.
> 
> I think problem is caused by access to OHCI regs from PCI quirks - before
> driver was initialized. ULI1553 southbridge chip could be in strange state
> at this point.

If that is the cause, we ought to be able to see it from the values
printed out by the debugging statements.  And if that is so, it's a
serious problem.  The southbridge chip really should be working at this
point, because the quirk_usb_handoff_* routines need to be able to
communicate with the host controllers.

Alan Stern

