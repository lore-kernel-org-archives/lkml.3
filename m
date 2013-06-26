Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3FZFuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:50:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:38993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3FZFuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:50:12 -0400
Message-ID: <1372225795.18612.3.camel@pasglop>
Subject: Re: [PATCH] powerpc/vfio: Add missing locks for take/release TCE
 table ownership
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Jun 2013 15:49:55 +1000
In-Reply-To: <1372225159-30187-1-git-send-email-aik@ozlabs.ru>
References: <1372225159-30187-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 15:39 +1000, Alexey Kardashevskiy wrote:
> VFIO IOMMU driver for sPAPR TCE locks the whole DMA window by setting
> ones to iommu_table.it_map. However this was not protected by the locks
> which other clients of iommu_table use.
> 
> The patch fixes this.
> 
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/kernel/iommu.c |   25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
> index b20ff17..9f34742 100644
> --- a/arch/powerpc/kernel/iommu.c
> +++ b/arch/powerpc/kernel/iommu.c
> @@ -1076,25 +1076,41 @@ EXPORT_SYMBOL_GPL(iommu_put_tce_user_mode);
>  int iommu_take_ownership(struct iommu_table *tbl)
>  {
>  	unsigned long sz = (tbl->it_size + 7) >> 3;
> +	int i, ret = 0;
> +
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_lock(&tbl->pools[i].lock);
> +	spin_lock(&tbl->large_pool.lock);

IOMMUs can be used at interrupt time so the above will trigger lockdep
warnings unless you also bracket the whole function in
local_irq_save/restore.

Now you *shouldn't* be racing since afaik you only take the iommu
ownership after no more drivers are hooked up, but better safe than
sorry.

Cheers,
Ben.


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
> +	spin_unlock(&tbl->large_pool.lock);
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_unlock(&tbl->pools[i].lock);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iommu_take_ownership);
>  
>  void iommu_release_ownership(struct iommu_table *tbl)
>  {
>  	unsigned long sz = (tbl->it_size + 7) >> 3;
> +	int i;
> +
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_lock(&tbl->pools[i].lock);
> +	spin_lock(&tbl->large_pool.lock);
>  
>  	iommu_clear_tces_and_put_pages(tbl, tbl->it_offset, tbl->it_size);
>  	memset(tbl->it_map, 0, sz);
> @@ -1102,6 +1118,11 @@ void iommu_release_ownership(struct iommu_table *tbl)
>  	/* Restore bit#0 set by iommu_init_table() */
>  	if (tbl->it_offset == 0)
>  		set_bit(0, tbl->it_map);
> +
> +	spin_unlock(&tbl->large_pool.lock);
> +	for (i = 0; i < tbl->nr_pools; i++)
> +		spin_unlock(&tbl->pools[i].lock);
> +
>  }
>  EXPORT_SYMBOL_GPL(iommu_release_ownership);
>  


