Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaGBVZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:25:45 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47737 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaGBVZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:25:43 -0400
Date: Wed, 2 Jul 2014 15:25:38 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Ryan Desfosses <ryan@desfo.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [Patch] PCI/portdrv: Remove warning about invalid IRQ
Message-ID: <20140702212538.GC28852@google.com>
References: <CAErSpo7pAv=v7JQp2UoNxYN8Pdj788NPP8OsLkM3p8NuwL_6Wg@mail.gmail.com>
 <1403070985-31373-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403070985-31373-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:56:21PM +0800, Jiang Liu wrote:
> For hot-added PCIe ports, it always generates a warning message on x86
> platforms when binding to portdrv as:
> 	"device [8086:0e0b] has invalid IRQ; check vendor BIOS".
> 
> It's due to that we check pci_dev->irq before actually allocating IRQ
> for the PCI device:
> 	if (!dev->irq && dev->pin) {
> 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
> 			 "check vendor BIOS\n", dev->vendor, dev->device);
> 	}
>  	status = pcie_port_device_register(dev);
> 		-->pci_enable_device(dev);
> 			-->pci_enable_device_flags()
> 				-->do_pci_enable_device()
> 					-->pcibios_enable_device()
> 						-->pcibios_enable_irq()
> 
> This warning message isn't generated for PCIe ports present at boot time
> because x86 arch code has called acpi_pci_irq_enable() in pci_acpi_init()
> for each PCI device for safety.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Applied to pci/misc for v3.17, thanks!

> ---
> Hi Bjorn,
> 	I have rebased it onto v3.16-rc1 and changed the patch title
> according to your suggestion.
> Thanks!
> Gerry
> ___
>  drivers/pci/pcie/portdrv_pci.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 80887eaa0668..2ccc9b926ea7 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -203,10 +203,6 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
>  	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
>  		return -ENODEV;
>  
> -	if (!dev->irq && dev->pin) {
> -		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; check vendor BIOS\n",
> -			 dev->vendor, dev->device);
> -	}
>  	status = pcie_port_device_register(dev);
>  	if (status)
>  		return status;
> -- 
> 1.7.10.4
> 
