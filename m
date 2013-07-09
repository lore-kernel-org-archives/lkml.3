Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab3GIF7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 01:59:35 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:6602 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab3GIF7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 01:59:31 -0400
X-Greylist: delayed 696 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jul 2013 01:59:31 EDT
Message-ID: <51DBA3AA.2080803@hp.com>
Date: Tue, 09 Jul 2013 13:46:18 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: Re: [PATCH 1/1] ia64/pci: set mmio decoding on for some host bridge
References: <1373348531-31893-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1373348531-31893-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

I tested on an X86 system with the same chipset, and this bug does not 
happen.
I am not sure why , but if it is needed, I will try to find out why.

Thanks
ZhenHua

On 07/09/2013 01:42 PM, Li, Zhen-Hua wrote:
> On some IA64 platforms with intel PCI bridge, for example, HP BL890c i2
> with  Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> when kernel tries to disable the mmio decoding on the PCI bridge devices,
> kernel may crash.
>
> And in the comment of function quirk_mmio_always_on, it also says:
> "But doing so (disable the mmio decoding) may cause problems on host bridge
>   and perhaps other key system devices"
>
> So, for this PCI bridge,  dev->mmio_always_on bit should be set to 1.
>
> To avoid affecting the use of quirk_mmio_always_on, a new function is created.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/pci/quirks.c    |   17 +++++++++++++++++
>   include/linux/pci_ids.h |    1 +
>   2 files changed, 18 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index e85d230..665af3e 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -44,6 +44,23 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>   DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>   				PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>   
> +#ifdef CONFIG_IA64
> +/*
> + * On some IA64 platforms, for some intel PCI bridge devices, for example,
> + * the Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> + * disable the mmio decoding on this device may cause system crash.
> + * So dev->mmio_always_on bit should be set to 1.
> + */
> +static void quirk_mmio_on_intel_pcibridge(struct pci_dev *dev)
> +{
> +	dev->mmio_always_on = 1;
> +}
> +DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL,
> +			PCI_DEVICE_ID_INTEL_5520_5550_X58,
> +			PCI_CLASS_BRIDGE_PCI,
> +			8, quirk_mmio_on_intel_pcibridge);
> +#endif
> +
>   /* The Mellanox Tavor device gives false positive parity errors
>    * Mark this device with a broken_parity_status, to allow
>    * PCI scanning code to "skip" this now blacklisted device.
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 3bed2e8..d8c60b7 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2742,6 +2742,7 @@
>   #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
>   #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
>   #define PCI_DEVICE_ID_INTEL_82855PM_HB	0x3340
> +#define PCI_DEVICE_ID_INTEL_5520_5550_X58       0x3408
>   #define PCI_DEVICE_ID_INTEL_IOAT_TBG4	0x3429
>   #define PCI_DEVICE_ID_INTEL_IOAT_TBG5	0x342a
>   #define PCI_DEVICE_ID_INTEL_IOAT_TBG6	0x342b

