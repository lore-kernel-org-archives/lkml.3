Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbaGUIYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:24:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:37067 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaGUIYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459402781"
Message-ID: <1405931052.5102.166.camel@smile.fi.intel.com>
Subject: Re: [PATCH v1] x86: fix kernel crash on boot due to NULL dereference
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Date: Mon, 21 Jul 2014 11:24:12 +0300
In-Reply-To: <53CC7B85.6040209@linux.intel.com>
References: <1405609181-12831-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <53CC7B85.6040209@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 10:31 +0800, Jiang Liu wrote:
> Hi Andy,
> 	Have you encountered any issue with another call site of
> setup_irq() in arch/x86/kernel/time.c?

No, since Intel MID uses its own .timer_init callback.

> 	void __init setup_default_timer_irq(void)
> 	{
> 	        setup_irq(0, &irq0);
> 	}
> 	Seems it may need the same protection for system without
> legacy IRQ controller.

Agree.
I will add the same check there and resend v2.

> Regards!
> Gerry
> 
> On 2014/7/17 22:59, Andy Shevchenko wrote:
> > The patch "x86, irq: Count legacy IRQs by legacy_pic->nr_legacy_irqs instead of
> > NR_IRQS_LEGACY" (linux-next commit 95d76acc7518d566df18d67c1343bb375b78d1f3)
> > removed reserved interrupts for the platforms that do not have a legacy IOAPIC.
> > Meanwhile it breks a boot on Intel MID platforms such as Medfield.
> > 
> > [    0.000000] BUG: unable to handle kernel NULL pointer dereference at 0000003a
> > [    0.000000] IP: [<c107079a>] setup_irq+0xf/0x4d
> > [    0.000000] *pdpt = 0000000000000000 *pde = 9bbf32453167e510
> > [    0.000000] Oops: 0000 [#1] PREEMPT SMP
> > [    0.000000] Modules linked in:
> > [    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc5-next-20140717-00043-g6ab7e8d-dirty #497
> > [    0.000000] task: c184bc80 ti: c183e000 task.ti: c183e000
> > [    0.000000] EIP: 0060:[<c107079a>] EFLAGS: 00210046 CPU: 0
> > [    0.000000] EIP is at setup_irq+0xf/0x4d
> > [    0.000000] EAX: 00000000 EBX: 00000002 ECX: 00000000 EDX: 00000002
> > [    0.000000] ESI: 000000d5 EDI: c184e280 EBP: c183ffc0 ESP: c183ffb4
> > [    0.000000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > [    0.000000] CR0: 8005003b CR2: 0000003a CR3: 0195b000 CR4: 000006b0
> > [    0.000000] Stack:
> > [    0.000000]  00000100 000000d5 c195c800 c183ffd0 c18eff07 c1935100 00010800 c183ffd8
> > [    0.000000]  c18efca0 c183ffe8 c18ec92e c1935100 00020800 c183fff8 c18ec2b4 00020800
> > [    0.000000]  c195c800 025e5003 00000000
> > [    0.000000] Call Trace:
> > [    0.000000]  [<c18eff07>] native_init_IRQ+0x265/0x273
> > [    0.000000]  [<c18efca0>] init_IRQ+0x2c/0x2e
> > [    0.000000]  [<c18ec92e>] start_kernel+0x1e4/0x32a
> > [    0.000000]  [<c18ec2b4>] i386_start_kernel+0x82/0x86
> > [    0.000000] Code: eb 05 bf ea ff ff ff 8b 83 c4 00 00 00 e8 f6 a3 01 00 8d 65 f4 89 f8 5b 5e 5f 5d c3 55 89 e5 57 89 d7 56 53 89 c3 e8 4b e4 ff ff <f6> 40 3a 02 89 c6 74 16 b8 2b 3e 77 c1 ba 0a 05 00 00 e8 83 60
> > [    0.000000] EIP: [<c107079a>] setup_irq+0xf/0x4d SS:ESP 0068:c183ffb4
> > [    0.000000] CR2: 000000000000003a
> > [    0.000000] ---[ end trace cb88537fdc8fa200 ]---
> > [    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
> > [    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> > 
> > The culprit is an uncoditional setting of the IRQ2 which is used as cascade IRQ
> > on legacy platforms. It seems we have to check if we have enough legacy IRQs
> > reserved before we can call setup_irq().
> > 
> > The proposed patch adds such check.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  arch/x86/kernel/irqinit.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
> > index 1e6cff5..44f1ed4 100644
> > --- a/arch/x86/kernel/irqinit.c
> > +++ b/arch/x86/kernel/irqinit.c
> > @@ -203,7 +203,7 @@ void __init native_init_IRQ(void)
> >  		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
> >  	}
> >  
> > -	if (!acpi_ioapic && !of_ioapic)
> > +	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs())
> >  		setup_irq(2, &irq2);
> >  
> >  #ifdef CONFIG_X86_32
> > 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

