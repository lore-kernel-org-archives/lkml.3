Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbaI3GQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:16:08 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37356 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbaI3GQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:16:04 -0400
Message-ID: <542A4A99.4030204@hp.com>
Date: Tue, 30 Sep 2014 14:15:53 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        linda.knippers@hp.com
Subject: Re: [PATCH 1/1] pci/quirks: fix a dmar fault for intel 82599 card
References: <1412057394-7186-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1412057394-7186-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Joerg to CC list. For it is also related to iommu module.

Joerg,
There was a try for this dmar fault,
	https://lkml.org/lkml/2014/8/18/118

This patch is trying to fix the same thing.


Zhenhua
On 09/30/2014 02:09 PM, Li, Zhen-Hua wrote:
> On a HP system with Intel Corporation 82599 ethernet adapter, when kernel
> crashed and the kdump kernel boots with intel_iommu=on, there may be some
> unexpected DMA requests on this adapter, which will cause DMA Remapping
> faults like:
>      dmar: DRHD: handling fault status reg 102
>      dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
>      DMAR:[fault reason 01] Present bit in root entry is clear
>
> Analysis for this bug:
>
> The present bit is set in this function:
>
> static struct context_entry * device_to_context_entry(
> 		struct intel_iommu *iommu, u8 bus, u8 devfn)
> {
>      ......
>                  set_root_present(root);
>      ......
> }
>
> Calling tree:
> ixgbe_open
>      ixgbe_setup_tx_resources
>          intel_alloc_coherent
>              __intel_map_single
>                  domain_context_mapping
>                      domain_context_mapping_one
>                          device_to_context_entry
>
> This means, the present bit in root entry will not be set until the device
>   driver is loaded.
>
> But in the kdump kernel, some hardware device does not know the OS is the
>   second kernel and the drivers should be loaded again, this causes there are
>   some unexpected DMA requsts on this device when it has not been initialized,
>   and then the DMA Remapping errors come.
>
> To fix this DMAR fault, we need to reset the bus that this device on. Reset
>   the device itself does not work.
>
> There also was a discussion:
> https://lkml.org/lkml/2013/5/14/9
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/pci/quirks.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 80c2d01..5198af3 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -25,6 +25,7 @@
>   #include <linux/sched.h>
>   #include <linux/ktime.h>
>   #include <asm/dma.h>	/* isa_dma_bridge_buggy */
> +#include <linux/crash_dump.h>
>   #include "pci.h"
>
>   /*
> @@ -3832,3 +3833,13 @@ void pci_dev_specific_enable_acs(struct pci_dev *dev)
>   		}
>   	}
>   }
> +
> +#ifdef CONFIG_CRASH_DUMP
> +void quirk_reset_buggy_devices(struct pci_dev *dev)
> +{
> +	if (unlikely(is_kdump_kernel()))
> +		pci_try_reset_bus(dev->bus);
> +}
> +DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_INTEL, 0x10f8,
> +		PCI_CLASS_NETWORK_ETHERNET, 8, quirk_reset_buggy_devices);
> +#endif
>

