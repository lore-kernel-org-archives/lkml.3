Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677Ab3BSTr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:47:57 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:64168 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934664Ab3BSTrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:47:53 -0500
MIME-Version: 1.0
In-Reply-To: <1361182193-31894-1-git-send-email-hare@suse.de>
References: <1361182193-31894-1-git-send-email-hare@suse.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 19 Feb 2013 12:47:32 -0700
Message-ID: <CAErSpo5j5WXx-Y4ML22yzsVzXgXnT9JoD1EGvGRMy55GGRdn6A@mail.gmail.com>
Subject: Re: [PATCH] pci: do not try to assign irq 255
To: Hannes Reinecke <hare@suse.de>
Cc: linux-kernel@vger.kernel.org, Frederik Himpe <fhimpe@vub.ac.be>,
        Oliver Neukum <oneukum@suse.de>, David Haerdeman <david@hardeman.nu>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2013 at 3:09 AM, Hannes Reinecke <hare@suse.de> wrote:
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

Is there a bugzilla or other URL with more information (problem
description, hardware involved, dmesg logs, acpidump, etc)?

Bjorn
