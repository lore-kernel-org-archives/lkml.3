Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947206Ab3BHVOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:14:42 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:50469 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947126Ab3BHVOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:14:40 -0500
MIME-Version: 1.0
In-Reply-To: <1360351703-20571-26-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org> <1360351703-20571-26-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 8 Feb 2013 14:14:20 -0700
Message-ID: <CAErSpo4iA17jh5rw05q=uaKOyMKesrPnxYrN2EvqWT_tGmE_FQ@mail.gmail.com>
Subject: Re: [PATCH v2 25/26] PCI: Disable mem in the ioapic removing path
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 12:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> For physical hot plug should be ok, but for remove/rescan path will
> need us to disable that.
>
> otherwise rescan mmio resource for pci ioapic device will not be
> sized and allocated, aka skiped.

When we scan other PCI devices, we can size memory BARs even if
PCI_COMMAND_MEMORY is already set.  So there must be something
different about IOAPICs?  Or maybe it's something different about
rescan vs. the initial scan?

> For ioapic_probe:pci_enable_device will not enable the device
> correctly, and will bail out early.

Exactly where and why do we bail out early?  The only early bail out I
see is where __pci_enable_device_flags() returns if "dev->enable_cnt >
1".  Is that what you mean?

> So we can just disable mmio for all removing case, and that will not hurt
> real hotplug path.

> Signed-off-by: <yinghai@kernel.org>
> ---
>  drivers/pci/ioapic.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 3c6bbdd..8dacfd0 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -88,6 +88,17 @@ exit_free:
>         return -ENODEV;
>  }
>
> +static void pci_disable_device_mem(struct pci_dev *dev)
> +{
> +       u16 pci_command;
> +
> +       pci_read_config_word(dev, PCI_COMMAND, &pci_command);
> +       if (pci_command & PCI_COMMAND_MEMORY) {
> +               pci_command &= ~PCI_COMMAND_MEMORY;
> +               pci_write_config_word(dev, PCI_COMMAND, pci_command);
> +       }
> +}
> +
>  static void ioapic_remove(struct pci_dev *dev)
>  {
>         struct ioapic *ioapic = pci_get_drvdata(dev);
> @@ -95,6 +106,8 @@ static void ioapic_remove(struct pci_dev *dev)
>         acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
>         pci_release_region(dev, 0);
>         pci_disable_device(dev);
> +       /* need to disable it, otherwise remove/rescan will not work */
> +       pci_disable_device_mem(dev);
>         kfree(ioapic);
>  }
>
> --
> 1.7.10.4
>
