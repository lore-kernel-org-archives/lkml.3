Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab3FZMTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:19:13 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33198 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3FZMTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:19:12 -0400
Message-ID: <51CADC39.1070905@ozlabs.ru>
Date: Wed, 26 Jun 2013 22:19:05 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/vfio: Add missing locks for take/release TCE
 table ownership
References: <1372227662-28302-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1372227662-28302-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, please ignore this.
Need some more code there.



On 06/26/2013 04:21 PM, Alexey Kardashevskiy wrote:
> VFIO IOMMU driver for sPAPR TCE locks the whole DMA window by setting
> ones to iommu_table.it_map. However this was not protected by the locks
> which other clients of iommu_table use.
> 
> The patch fixes this.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> v1->v2:
> * Fixed a potential warning from lockdep.
> 
> ---
>  arch/powerpc/kernel/iommu.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index b20ff17..5c1fc89 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -1076,25 +1076,42 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
>  int iommu_take_ownership(struct iommu_table *tbl)
>  {
>  	unsigned long sz = (tbl->it_size + 7) >> 3;
> +	unsigned long i, flags;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&tbl->large_pool.lock, flags);
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_lock(&tbl->pools[i].lock);
>  
>  	if (tbl->it_offset == 0)
>  		clear_bit(0, tbl->it_map);
>  
>  	if (!bitmap_empty(tbl->it_map, tbl->it_size)) {
>  		pr_err("iommu_tce: it_map is not empty");
> -		return -EBUSY;
> +		ret = -EBUSY;
> +		goto unlock_exit;
>  	}
>  
>  	memset(tbl->it_map, 0xff, sz);
>  	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
>  
> -	return 0;
> +unlock_exit:
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_unlock(&tbl->pools[i].lock);
> +	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_take_ownership);
>  
>  void iommu_release_ownership(struct iommu_table *tbl)
>  {
>  	unsigned long sz = (tbl->it_size + 7) >> 3;
> +	unsigned long i, flags;
> +
> +	spin_lock_irqsave(&tbl->large_pool.lock, flags);
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_lock(&tbl->pools[i].lock);
>  
>  	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
>  	memset(tbl->it_map, 0, sz);
> @@ -1102,6 +1119,10 @@ void iommu_release_ownership(struct iommu_table *tbl)
>  	/* Restore bit#0 set by iommu_init_table() */
>  	if (tbl->it_offset == 0)
>  		set_bit(0, tbl->it_map);
> +
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_unlock(&tbl->pools[i].lock);
> +	spin_unlock_irqrestore(&tbl->large_pool.lock, flags);
>  }
>  EXPORT_SYMBOL_GPL(iommu_release_ownership);
>  
> 


-- 
Alexey
