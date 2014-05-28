Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaE1HUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:20:19 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:46786 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaE1HUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:20:18 -0400
Message-ID: <53858E28.5000403@dev.rtsoft.ru>
Date: Wed, 28 May 2014 11:20:08 +0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Organization: RTSoft Software Development Center
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
References: <Pine.LNX.4.44L0.1405271055240.1372-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405271055240.1372-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2014 19:08, Alan Stern пишет:
> On Tue, 27 May 2014, Nikita Yushchenko wrote:
> 
>> This access causes hang on Freescale P2020DS board (that has OHCI
>> provided by ULI 1533 chip).
> 
> Which access, the read or the write?

things are a bit more complex.

If inserting printk's as below


--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -619,16 +619,23 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
        }

        /* software reset of the controller, preserving HcFmInterval */
+       printk("A1\n");
        fminterval = readl(base + OHCI_FMINTERVAL);
+       printk("A2\n");
        writel(OHCI_HCR, base + OHCI_CMDSTATUS);
+       printk("A3\n");

        /* reset requires max 10 us delay */
        for (cnt = 30; cnt > 0; --cnt) {        /* ... allow extra time */
+               printk("A4\n");
                if ((readl(base + OHCI_CMDSTATUS) & OHCI_HCR) == 0)
                        break;
+               printk("A5\n");
                udelay(1);
        }
+       printk("A6\n");
        writel(fminterval, base + OHCI_FMINTERVAL);
+       printk("A7\n");

        /* Now the controller is safely in SUSPEND and nothing can wake it up */
        iounmap(base);

attempt to boot (using arch/powerpc/configs/mpc85xx_smp_defconfig and deb
file built by "make p2020ds.dtb" from the same kernel tree) results in

...
A1
random: nonblocking pool is initialized
irq 26: nobody cared (try booting with the "irqpoll" option)
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc6-dirty #5
Call Trace:
[effe5ed0] [c000726c] show_stack+0x48/0x15c (unreliable)
[effe5f10] [c05eece4] dump_stack+0x78/0xa0
[effe5f20] [c0087acc] __report_bad_irq+0x38/0x100
[effe5f40] [c0088060] note_interrupt+0x224/0x280
[effe5f70] [c008563c] handle_irq_event_percpu+0xc8/0x178
[effe5fa0] [c0085730] handle_irq_event+0x44/0x74
[effe5fc0] [c0088f88] handle_fasteoi_irq+0xd4/0x1d0
[effe5fd0] [c0084d20] generic_handle_irq+0x30/0x50
[effe5fe0] [c00048d0] __do_irq+0x2c/0x70
[effe5ff0] [c000d9a0] call_do_irq+0x24/0x3c
[ef047d10] [c00049a0] do_IRQ+0x8c/0xf8
[ef047d30] [c000f598] ret_from_except+0x0/0x18
--- Exception: 501 at quirk_usb_early_handoff+0x794/0x85c
    LR = quirk_usb_early_handoff+0x788/0x85c
[ef047e30] [c02bd66c] pci_fixup_device+0xe0/0x19c
[ef047e60] [c07d4e1c] pci_apply_final_quirks+0x60/0x13c
[ef047e90] [c0002494] do_one_initcall+0x158/0x19c
[ef047f00] [c07ba928] kernel_init_freeable+0x130/0x1e4
[ef047f30] [c0002a78] kernel_init+0x14/0x10c
[ef047f40] [c000f014] ret_from_kernel_thread+0x5c/0x64
handlers:
[<c001cc78>] fsl_pci_pme_handle
Disabling IRQ #26
A2
A3
A4
A5
A4
A5
A4
A5
A4
A5
A4

and hang.

with my patch applied, board just boots ok and works.


> It looks like you haven't read ohci_shutdown() and ohci_run() in 
> drivers/usb/host/ohci-hcd.c.  They both access the fminterval register, 
> and this patch doesn't change them.
> 
> So I don't see why this patch should make any difference to the 
> system's operation.

I think problem is caused by access to OHCI regs from PCI quirks - before
driver was initialized. ULI1553 southbridge chip could be in strange state
at this point.

Nikita
