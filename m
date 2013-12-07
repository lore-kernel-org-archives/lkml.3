Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860Ab3LGA6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 19:58:51 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:50802 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab3LGA6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 19:58:50 -0500
Message-ID: <52A272C4.1060303@ozlabs.ru>
Date: Sat, 07 Dec 2013 11:58:44 +1100
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        benh@kernel.crashing.org
CC: paulus@samba.org, shangw@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powernv: fix VFIO support with PHB3
References: <1386332504-18339-1-git-send-email-cascardo@linux.vnet.ibm.com>
In-Reply-To: <1386332504-18339-1-git-send-email-cascardo@linux.vnet.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 11:21 PM, Thadeu Lima de Souza Cascardo wrote:
> I have recently found out that no iommu_groups could be found under
> /sys/ on a P8. That prevents PCI passthrough from working.
> 
> During my investigation, I found out there seems to be a missing
> iommu_register_group for PHB3. The following patch seems to fix the
> problem. After applying it, I see iommu_groups under
> /sys/kernel/iommu_groups/, and can also bind vfio-pci to an adapter,
> which gives me a device at /dev/vfio/.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/powernv/pci-ioda.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> index 084cdfa..2c6d173 100644
> --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> @@ -720,6 +720,7 @@ static void pnv_pci_ioda2_setup_dma_pe(struct pnv_phb *phb,
>  		tbl->it_type = TCE_PCI_SWINV_CREATE | TCE_PCI_SWINV_FREE;
>  	}
>  	iommu_init_table(tbl, phb->hose->node);
> +	iommu_register_group(tbl, pci_domain_nr(pe->pbus), pe->pe_number);
>  
>  	if (pe->pdev)
>  		set_iommu_table_base(&pe->pdev->dev, tbl);


This does not seem absolutely right - normally set_iommu_table_base() is
replaced with set_iommu_table_base_and_group() or you will not see some
devices in a group and this may make VFIO unhappy.

But - if every single device gets assigned to some group, then we can push
this to Frobisher and let people test in on power8.



-- 
Alexey
