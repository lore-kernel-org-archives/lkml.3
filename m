Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaFXMiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:38:18 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:57400 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaFXMiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:38:16 -0400
Message-ID: <53A9713A.3020202@cogentembedded.com>
Date: Tue, 24 Jun 2014 16:38:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Chen, Alvin" <alvin.chen@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH] USB: ehci-pci: USB host controller support for Intel
 Quark X1000
References: <1403625103-28078-1-git-send-email-alvin.chen@intel.com> <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
In-Reply-To: <1403625103-28078-2-git-send-email-alvin.chen@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/24/2014 07:51 PM, Chen, Alvin wrote:

> From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

> This patch is to enable USB host controller for Intel Quark X1000. Add pci quirks
> to adjust the packet buffer in/out threshold value, and ensure EHCI packet buffer
> i/o threshold value is reconfigured to half.

> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
> Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
> ---
>   drivers/usb/host/ehci-pci.c   |    4 ++++
>   drivers/usb/host/pci-quirks.c |   42 +++++++++++++++++++++++++++++++++++++++++
>   drivers/usb/host/pci-quirks.h |    2 ++
>   3 files changed, 48 insertions(+)

> diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
> index 3e86bf4..33cfa23 100644
> --- a/drivers/usb/host/ehci-pci.c
> +++ b/drivers/usb/host/ehci-pci.c
> @@ -50,6 +50,10 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
>   	if (!retval)
>   		ehci_dbg(ehci, "MWI active\n");
>
> +	/* Reset the threshold limit */
> +	if(unlikely(usb_is_intel_qrk(pdev)))

    Please run your patch thru scripts/checkpatch.pl -- space needed after *if*.

> +		usb_set_qrk_bulk_thresh(pdev);
> +
>   	return 0;
>   }
>
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index 00661d3..1ea8803 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -823,6 +823,48 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
>   	return -ETIMEDOUT;
>   }
>
> +#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
> +bool usb_is_intel_qrk(struct pci_dev *pdev)
> +{
> +	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
> +		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
> +
> +}
> +EXPORT_SYMBOL_GPL(usb_is_intel_qrk);

    Why not use DECLARE_PCI_FIXUP_FINAL() instead?

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

    I doubt these dev_printk() calls are really useful. But if the are, it's 
worth merging them into one call.

WBR, Sergei

