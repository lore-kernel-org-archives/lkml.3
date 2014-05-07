Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaEGQEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:04:00 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:45848 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaEGQD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:03:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140507154335.452206351@linutronix.de>
References: <20140507153622.703412101@linutronix.de> <20140507154335.452206351@linutronix.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 May 2014 10:03:38 -0600
Message-ID: <CAErSpo4=GUxUpAEtBH_=-DeXAij4zy+r15N4bjapY=54Y7x0Sg@mail.gmail.com>
Subject: Re: [patch 08/32] x86: htirq: Use irq_alloc/free_irq()
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 9:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> No functional change, just cleaned up a bit.
>
> This does not replace the requirement to move x86 to irq domains, but
> it limits the mess to some degree.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

I assume you'll merge this along with the rest of your series.  Let me
know if you need me to do anything.

> Cc: x86@kernel.org
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/pci/htirq.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> Index: tip/drivers/pci/htirq.c
> ===================================================================
> --- tip.orig/drivers/pci/htirq.c
> +++ tip/drivers/pci/htirq.c
> @@ -87,12 +87,9 @@ void unmask_ht_irq(struct irq_data *data
>  int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
>  {
>         struct ht_irq_cfg *cfg;
> +       int max_irq, pos, irq;
>         unsigned long flags;
>         u32 data;
> -       int max_irq;
> -       int pos;
> -       int irq;
> -       int node;
>
>         pos = pci_find_ht_capability(dev, HT_CAPTYPE_IRQ);
>         if (!pos)
> @@ -120,10 +117,8 @@ int __ht_create_irq(struct pci_dev *dev,
>         cfg->msg.address_lo = 0xffffffff;
>         cfg->msg.address_hi = 0xffffffff;
>
> -       node = dev_to_node(&dev->dev);
> -       irq = create_irq_nr(0, node);
> -
> -       if (irq <= 0) {
> +       irq = irq_alloc_hwirq(dev_to_node(&dev->dev));
> +       if (!irq) {
>                 kfree(cfg);
>                 return -EBUSY;
>         }
> @@ -166,7 +161,7 @@ void ht_destroy_irq(unsigned int irq)
>         cfg = irq_get_handler_data(irq);
>         irq_set_chip(irq, NULL);
>         irq_set_handler_data(irq, NULL);
> -       destroy_irq(irq);
> +       irq_free_hwirq(irq);
>
>         kfree(cfg);
>  }
>
>
