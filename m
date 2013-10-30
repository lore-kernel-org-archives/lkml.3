Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab3J3Coe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 22:44:34 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:56162 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3J3Cod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 22:44:33 -0400
MIME-Version: 1.0
Date: Wed, 30 Oct 2013 10:44:32 +0800
Message-ID: <CAFiDJ59naSs9z_g3RRHnFEYkzp_tSfA0nvBrADvkv1iO018Ukw@mail.gmail.com>
Subject: BUG_ON(irq_has_action(entry->irq + i)) in free_msi_irqs()
From: "LF.Tan" <lftan.linux@gmail.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I am new in PCI and now working on MSI support on our PCIe host
driver. I have an endpoint driver requests for a MSI interrupt. When
the endpoint driver try to free the interrupt, it cause the kernel
BUG_ON() message is printed out.

The software flow:
Endpoint driver --> pci_disable_msi -->free_msi_irqs -->
BUG_ON(irq_has_action(entry->irq + i));

I have checked desc->action in irq_has_action(), it is non-zero.
It is running on ARM platform. CONFIG_GENERIC_HARDIRQS is turn on by default.

Anyone how to fix this issue? Thanks.


static void free_msi_irqs(struct pci_dev *dev)
{
        struct msi_desc *entry, *tmp;

        list_for_each_entry(entry, &dev->msi_list, list) {
                int i, nvec;

                if (!entry->irq)
                        continue;
                nvec = 1 << entry->msi_attrib.multiple;
#ifdef CONFIG_GENERIC_HARDIRQS
                for (i = 0; i < nvec; i++)
                        BUG_ON(irq_has_action(entry->irq + i));
#endif
        }
        .....................
}


static inline int irq_has_action(unsigned int irq)
{
         struct irq_desc *desc = irq_to_desc(irq);
        return desc->action != NULL;
}



Regards
LF Tan
