Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaIOImC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:42:02 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:46198 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbaIOImA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:42:00 -0400
Message-ID: <5416A64E.1060005@ozlabs.ru>
Date: Mon, 15 Sep 2014 18:41:50 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Alistair Popple <alistair@popple.id.au>,
        Anton Blanchard <anton@samba.org>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH] powerpc/iommu/ddw: Fix endianness
References: <1410261723-21810-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1410261723-21810-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 09:22 PM, Alexey Kardashevskiy wrote:
> rtas_call() accepts and returns values in CPU endianness.
> 
> of_read_number() accepts big-endian values but create.addr_hi/lo returned
> by rtas_call() are in CPU endiannes.
> 
> The dynamic_dma_window_prop struct defines all members as BE so let's
> make it true.
> 
> struct dynamic_dma_window_prop {
>         __be32  liobn;          /* tce table number */
>         __be64  dma_base;       /* address hi,lo */
>         __be32  tce_shift;      /* ilog2(tce_page_size) */
>         __be32  window_shift;   /* ilog2(tce_window_size) */
> };
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Alexander Graf <agraf@suse.de>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>



Ping, anyone?



> ---
>  arch/powerpc/platforms/pseries/iommu.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
> index 7c1d77c..700020a 100644
> --- a/arch/powerpc/platforms/pseries/iommu.c
> +++ b/arch/powerpc/platforms/pseries/iommu.c
> @@ -750,7 +750,7 @@ static void remove_ddw(struct device_node *np, bool remove_prop)
>  		pr_debug("%s successfully cleared tces in window.\n",
>  			 np->full_name);
>  
> -	ret = rtas_call(ddw_avail[2], 1, 1, NULL, liobn);
> +	ret = rtas_call(be32_to_cpu(ddw_avail[2]), 1, 1, NULL, liobn);
>  	if (ret)
>  		pr_warning("%s: failed to remove direct window: rtas returned "
>  			"%d to ibm,remove-pe-dma-window(%x) %llx\n",
> @@ -842,7 +842,7 @@ static int query_ddw(struct pci_dev *dev, const u32 *ddw_avail,
>  		cfg_addr = edev->pe_config_addr;
>  	buid = edev->phb->buid;
>  
> -	ret = rtas_call(ddw_avail[0], 3, 5, (u32 *)query,
> +	ret = rtas_call(be32_to_cpu(ddw_avail[0]), 3, 5, (u32 *)query,
>  		  cfg_addr, BUID_HI(buid), BUID_LO(buid));
>  	dev_info(&dev->dev, "ibm,query-pe-dma-windows(%x) %x %x %x"
>  		" returned %d\n", ddw_avail[0], cfg_addr, BUID_HI(buid),
> @@ -874,8 +874,9 @@ static int create_ddw(struct pci_dev *dev, const u32 *ddw_avail,
>  
>  	do {
>  		/* extra outputs are LIOBN and dma-addr (hi, lo) */
> -		ret = rtas_call(ddw_avail[1], 5, 4, (u32 *)create, cfg_addr,
> -				BUID_HI(buid), BUID_LO(buid), page_shift, window_shift);
> +		ret = rtas_call(be32_to_cpu(ddw_avail[1]), 5, 4, (u32 *)create,
> +				cfg_addr, BUID_HI(buid), BUID_LO(buid),
> +				page_shift, window_shift);
>  	} while (rtas_busy_delay(ret));
>  	dev_info(&dev->dev,
>  		"ibm,create-pe-dma-window(%x) %x %x %x %x %x returned %d "
> @@ -972,11 +973,11 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
>  		dev_dbg(&dev->dev, "no free dynamic windows");
>  		goto out_failed;
>  	}
> -	if (be32_to_cpu(query.page_size) & 4) {
> +	if (query.page_size & 4) {
>  		page_shift = 24; /* 16MB */
> -	} else if (be32_to_cpu(query.page_size) & 2) {
> +	} else if (query.page_size & 2) {
>  		page_shift = 16; /* 64kB */
> -	} else if (be32_to_cpu(query.page_size) & 1) {
> +	} else if (query.page_size & 1) {
>  		page_shift = 12; /* 4kB */
>  	} else {
>  		dev_dbg(&dev->dev, "no supported direct page size in mask %x",
> @@ -987,7 +988,7 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
>  	/* verify the window * number of ptes will map the partition */
>  	/* check largest block * page size > max memory hotplug addr */
>  	max_addr = memory_hotplug_max();
> -	if (be32_to_cpu(query.largest_available_block) < (max_addr >> page_shift)) {
> +	if (query.largest_available_block < (max_addr >> page_shift)) {
>  		dev_dbg(&dev->dev, "can't map partiton max 0x%llx with %u "
>  			  "%llu-sized pages\n", max_addr,  query.largest_available_block,
>  			  1ULL << page_shift);
> @@ -1014,8 +1015,9 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
>  	if (ret != 0)
>  		goto out_free_prop;
>  
> -	ddwprop->liobn = create.liobn;
> -	ddwprop->dma_base = cpu_to_be64(of_read_number(&create.addr_hi, 2));
> +	ddwprop->liobn = cpu_to_be32(create.liobn);
> +	ddwprop->dma_base = cpu_to_be64(((u64)create.addr_hi << 32) |
> +			create.addr_lo);
>  	ddwprop->tce_shift = cpu_to_be32(page_shift);
>  	ddwprop->window_shift = cpu_to_be32(len);
>  
> @@ -1048,7 +1050,7 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
>  	list_add(&window->list, &direct_window_list);
>  	spin_unlock(&direct_window_list_lock);
>  
> -	dma_addr = of_read_number(&create.addr_hi, 2);
> +	dma_addr = be64_to_cpu(ddwprop->dma_base);
>  	goto out_unlock;
>  
>  out_free_window:
> 


-- 
Alexey
