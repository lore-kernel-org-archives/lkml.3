Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab3BSTlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:41:03 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:51304 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab3BSTlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:41:00 -0500
MIME-Version: 1.0
In-Reply-To: <1361182193-31894-1-git-send-email-hare@suse.de>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
Date: Tue, 19 Feb 2013 11:40:59 -0800
X-Google-Sender-Auth: F5MVutWdi2b7uLSL4eopzM95Qyg
Message-ID: <CAE9FiQWP1F5mLUoHoTHXy-wQoGxVK66QuuHYydaq3YfysS5Etg@mail.gmail.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
From: Yinghai Lu <yinghai@kernel.org>
To: Hannes Reinecke <hare@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, David Haerdeman <david@hardeman.nu>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 2:09 AM, Hannes Reinecke <hare@suse.de> wrote:
> The PCI config space reseves a byte for the interrupt line,
> so irq 255 actually refers to 'not set'.
> However, the 'irq' field for struct pci_dev is an integer,
> so the original meaning is lost, causing the system to
> assign an interrupt '255', which fails.
>
> So we should _not_ assign an interrupt value here, and
> allow upper layers to fixup things.
>
> This patch make PCI devices with MSI interrupts only
> (like the xhci device on certain HP laptops) work properly.

looks like the bios does not provide _PRT for device in ACPI.

also according to PCI spec, BIOS *must* set interrupt line.

>
> Cc: Frederik Himpe <fhimpe@vub.ac.be>
> Cc: Oliver Neukum <oneukum@suse.de>
> Cc: David Haerdeman <david@hardeman.nu>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Hannes Reinecke <hare@suse.de>
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 6186f03..a2db887f 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -923,7 +923,8 @@ static void pci_read_irq(struct pci_dev *dev)
>         dev->pin = irq;
>         if (irq)
>                 pci_read_config_byte(dev, PCI_INTERRUPT_LINE, &irq);
> -       dev->irq = irq;
> +       if (irq < 255)
> +               dev->irq = irq;
>  }
>
>  void set_pcie_port_type(struct pci_dev *pdev)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
