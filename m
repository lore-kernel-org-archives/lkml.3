Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBYBbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:31:47 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:43416 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaBYBbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402222338420.21251@ionos.tec.linutronix.de>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-3-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de>
	<CAE9FiQUo9NGbjiZbMsf2yBFbn=iLJ-jc3QtZ8K6qwVuhmqzq=Q@mail.gmail.com>
	<alpine.DEB.2.02.1402221104440.21251@ionos.tec.linutronix.de>
	<CAE9FiQVf2L-FjkXR3WC=0iHNY73D2G4jyMeko4f4DPuxAXTK+Q@mail.gmail.com>
	<CAE9FiQVf7u62S4puc2iMqiFO2YU-Kf35XVB9mC+SEP6Z73x7Zw@mail.gmail.com>
	<alpine.DEB.2.02.1402222338420.21251@ionos.tec.linutronix.de>
Date: Mon, 24 Feb 2014 17:31:43 -0800
X-Google-Sender-Auth: Hbgrhu4FKK9OD7bljOJxsFbDCBU
Message-ID: <CAE9FiQUbWrAeavs-9Ze19FxWWn7dC1JA-69FfVhZSgwYCcohhA@mail.gmail.com>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 3:38 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> OMG, you really mean that:
>
> +++ b/arch/alpha/kernel/irq_i8259.c
> @@ -92,6 +92,7 @@ init_i8259a_irqs(void)
>         outb(0xff, 0xA1);       /* mask all of 8259A-2 */
>
>         for (i = 0; i < 16; i++) {
> +               irq_alloc_desc_at(i, 0);
>                 irq_set_chip_and_handler(i, &i8259a_irq_type, handle_level_irq);
>         }
>
> You can't be serious about that. There are tons of ways to call into
> the core and access an irq descriptor aside of irq_set_chip* before it
> is potentially allocated.
>
> Are you going to analyze all of them and add an irq_alloc_desc_at()
> before that call?
>
> HELL, NO!
>
> I'm really tired of that.
>
> Stay away from kernel/irq/* and wait for people who are competent
> enough and willing to spend the extra thoughts to come up with
> solutions which are not completely ass backwards.

oh, no, sorry for annoying you again.

In the irq_alloc_desc_at() path for !SPARSE_IRQ, it should not touch anything
except setting that bit in allocated_irqs bitmap.

Or could just replace irq_reserve_irq in irq_set_chip(), in that way will avoid
touching arch codes.

like

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dc04c16..02d6ad0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -28,8 +28,13 @@
 int irq_set_chip(unsigned int irq, struct irq_chip *chip)
 {
     unsigned long flags;
-    struct irq_desc *desc = irq_get_desc_lock(irq, &flags, 0);
+    struct irq_desc *desc;
+
+#ifndef CONFIG_SPARSE_IRQ
+    irq_alloc_desc_at(irq, 0);
+#endif

+    desc = irq_get_desc_lock(irq, &flags, 0);
     if (!desc)
         return -EINVAL;

@@ -38,12 +43,7 @@ int irq_set_chip(unsigned int irq, struct irq_chip *chip)

     desc->irq_data.chip = chip;
     irq_put_desc_unlock(desc, flags);
-    /*
-     * For !CONFIG_SPARSE_IRQ make the irq show up in
-     * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
-     * already marked, and this call is harmless.
-     */
-    irq_reserve_irq(irq);
+
     return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
