Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbaFQQMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:12:08 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:58885 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbaFQQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:12:05 -0400
MIME-Version: 1.0
In-Reply-To: <1402982995-13747-9-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com> <1402982995-13747-9-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 Jun 2014 10:11:44 -0600
Message-ID: <CAErSpo7pAv=v7JQp2UoNxYN8Pdj788NPP8OsLkM3p8NuwL_6Wg@mail.gmail.com>
Subject: Re: [RFC Patch V2 08/16] PCI: kill wrong warning message in pcieport driver
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pay attention to the existing convention of changelog summaries
(email subject lines), including spacing and capitalization.  "git log
--oneline drivers/pci/pcie" is a good way to see the pattern.  In this
case, you could use something like this:

  PCI/portdrv: Remove warning about invalid IRQ

On Mon, Jun 16, 2014 at 11:29 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> For hot-added PCIe ports, it always generates a warning message on x86
> platforms when binding to pcieport driver as:
>         "device [8086:0e0b] has invalid IRQ; check vendor BIOS".
>
> It's due to that we check pci_dev->irq before actually allocating IRQ
> number for the PCI device:
>         if (!dev->irq && dev->pin) {
>                 dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
>                          "check vendor BIOS\n", dev->vendor, dev->device);
>         }
>         status = pcie_port_device_register(dev);
>                 -->pci_enable_device(dev);
>                         -->pci_enable_device_flags()
>                                 -->do_pci_enable_device()
>                                         -->pcibios_enable_device()
>                                                 -->pcibios_enable_irq()
>
> This warning message isn't generated for PCIe ports present at boot time
> because x86 arch code has called acpi_pci_irq_enable() in pci_acpi_init()
> for each PCI device for safety.
>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/pcie/portdrv_pci.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 0d8fdc48e642..0e35f9670066 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -203,10 +203,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>              (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>                 return -ENODEV;
>
> -       if (!dev->irq && dev->pin) {
> -               dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
> -                        "check vendor BIOS\n", dev->vendor, dev->device);
> -       }

This needs to be rebased to v3.16-rc1.

>         status = pcie_port_device_register(dev);
>         if (status)
>                 return status;
> --
> 1.7.10.4
>
