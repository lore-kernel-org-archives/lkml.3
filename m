Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaFXOFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:05:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51723 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752643AbaFXOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:05:09 -0400
Date: Tue, 24 Jun 2014 10:05:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Chen, Alvin" <alvin.chen@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
In-Reply-To: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
Message-ID: <Pine.LNX.4.44L0.1406240959270.990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> 
> This patch is to enable USB host controller for Intel Quark X1000. Add pci quirks
> to adjust the packet buffer in/out threshold value, and ensure EHCI packet buffer
> i/o threshold value is reconfigured to half.

What is the packet buffer in/out threshold value and why does it need
to be reconfigured to half?

> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
>  drivers/usb/host/ehci-pci.c   |    4 ++++
>  drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/pci-quirks.h |    2 ++
>  3 files changed, 48 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..33cfa23 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>  	if (!retval)
>  		ehci_dbg(ehci, "MWI active\n");
>  
> +	/* Reset the threshold limit */
> +	if(unlikely(usb_is_intel_qrk(pdev)))
> +		usb_set_qrk_bulk_thresh(pdev);
> +
>  	return 0;
>  }
>  
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 00661d3..1ea8803 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
>  	return -ETIMEDOUT;
>  }
>  
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +bool usb_is_intel_qrk(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);
> +
> +#define EHCI_INSNREG01		0x84
> +#define EHCI_INSNREG01_THRESH	0x007F007F	/* Threshold value */
> +void usb_set_qrk_bulk_thresh(struct pci_dev *pdev)
> +{
> +	void __iomem *base, *op_reg_base;
> +	u8 cap_length;
> +	u32 val;
> +
> +	if (!mmio_resource_enabled(pdev, 0))
> +		return;
> +
> +	base = pci_ioremap_bar(pdev, 0);
> +	if (base == NULL)
> +		return;
> +
> +	cap_length = readb(base);
> +	op_reg_base = base + cap_length;
> +
> +	val = readl(op_reg_base + EHCI_INSNREG01);
> +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);
> +
> +	val = EHCI_INSNREG01_THRESH;
> +
> +	writel(val, op_reg_base + EHCI_INSNREG01);
> +
> +	val = readl(op_reg_base + EHCI_INSNREG01);
> +	dev_printk(KERN_INFO, &pdev->dev, "INSNREG01 is 0x%08x\n", val);

What good will these log messages do anybody?  Is there any reason not 
to make them debug messages?  Or even leave them out entirely, since 
you pretty much know beforehand what they're going to say?

> +
> +	iounmap(base);
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_set_qrk_bulk_thresh);

None of this material belongs in pci-quirks.c.  Please move it into 
ehci-pci.c.

Alan Stern

