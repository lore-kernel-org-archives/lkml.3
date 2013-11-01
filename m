Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3KANxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 09:53:51 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:52360 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab3KANxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 09:53:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAFiDJ59naSs9z_g3RRHnFEYkzp_tSfA0nvBrADvkv1iO018Ukw@mail.gmail.com>
References: <CAFiDJ59naSs9z_g3RRHnFEYkzp_tSfA0nvBrADvkv1iO018Ukw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Nov 2013 07:53:28 -0600
Message-ID: <CAErSpo6EsVyvZ3Wm8n3zVMRpyzMowYBiAhPRe45b4xq_yOiFKA@mail.gmail.com>
Subject: Re: BUG_ON(irq_has_action(entry->irq + i)) in free_msi_irqs()
To: "LF.Tan" <lftan.linux@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 8:44 PM, LF.Tan <lftan.linux@gmail.com> wrote:
> Hi all
>
> I am new in PCI and now working on MSI support on our PCIe host
> driver. I have an endpoint driver requests for a MSI interrupt. When
> the endpoint driver try to free the interrupt, it cause the kernel
> BUG_ON() message is printed out.
>
> The software flow:
> Endpoint driver --> pci_disable_msi -->free_msi_irqs -->
> BUG_ON(irq_has_action(entry->irq + i));
>
> I have checked desc->action in irq_has_action(), it is non-zero.
> It is running on ARM platform. CONFIG_GENERIC_HARDIRQS is turn on by default.
>
> Anyone how to fix this issue? Thanks.

The easiest way is probably to compare your driver with some of the
many drivers in the tree and see what's different in the way your
driver manages MSI.

Bjorn

> static void free_msi_irqs(struct pci_dev *dev)
> {
>         struct msi_desc *entry, *tmp;
>
>         list_for_each_entry(entry, &dev->msi_list, list) {
>                 int i, nvec;
>
>                 if (!entry->irq)
>                         continue;
>                 nvec = 1 << entry->msi_attrib.multiple;
> #ifdef CONFIG_GENERIC_HARDIRQS
>                 for (i = 0; i < nvec; i++)
>                         BUG_ON(irq_has_action(entry->irq + i));
> #endif
>         }
>         .....................
> }
>
>
> static inline int irq_has_action(unsigned int irq)
> {
>          struct irq_desc *desc = irq_to_desc(irq);
>         return desc->action != NULL;
> }
>
>
>
> Regards
> LF Tan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
