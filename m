Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3KLWMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:12:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:4367 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350Ab3KLWMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:12:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,688,1378882800"; 
   d="scan'208";a="432338365"
Message-ID: <5282A7D5.7050406@intel.com>
Date: Tue, 12 Nov 2013 14:12:37 -0800
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>
CC: akpm@linux-foundation.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
References: <1384289478-9899-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1384289478-9899-1-git-send-email-shuah.kh@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this might be overdoing the error checking by a bit.  I would
much rather have the DMA leaked error be visible than have it buried
under messages about the failure to check for DMA errors.  In my mind
the DMA buffer leak is much more serious than the failure to check for
mapping errors.

Thanks,

Alex


On 11/12/2013 12:51 PM, Shuah Khan wrote:
> dma-debug checks to verify if driver validated the address returned by
> dma mapping routines when driver does unmap. If a driver doesn't call
> unmap, failure to check mapping errors isn't detected and reported.
>
> Enhancing existing bus notifier_call dma_debug_device_change() to check
> for mapping errors at the same time it detects leaked dma buffers for
> BUS_NOTIFY_UNBOUND_DRIVER event.
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  lib/dma-debug.c | 23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index d87a17a..6c17b90 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -712,6 +712,19 @@ out_err:
>  	return -ENOMEM;
>  }
>  
> +static void check_dma_mapping_error(struct dma_debug_entry *ref,
> +				    struct dma_debug_entry *entry)
> +{
> +	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
> +		err_printk(ref->dev, entry,
> +			   "DMA-API: device driver failed to check map error"
> +			   "[device address=0x%016llx] [size=%llu bytes] "
> +			   "[mapped as %s]",
> +			   ref->dev_addr, ref->size,
> +			   type2name[entry->type]);
> +	}
> +}
> +
>  static int device_dma_allocations(struct device *dev, struct dma_debug_entry **out_entry)
>  {
>  	struct dma_debug_entry *entry;
> @@ -724,6 +737,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
>  		spin_lock(&dma_entry_hash[i].lock);
>  		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
>  			if (entry->dev == dev) {
> +				check_dma_mapping_error(entry, entry);
>  				count += 1;
>  				*out_entry = entry;
>  			}
> @@ -928,14 +942,7 @@ static void check_unmap(struct dma_debug_entry *ref)
>  			   dir2name[ref->direction]);
>  	}
>  
> -	if (entry->map_err_type == MAP_ERR_NOT_CHECKED) {
> -		err_printk(ref->dev, entry,
> -			   "DMA-API: device driver failed to check map error"
> -			   "[device address=0x%016llx] [size=%llu bytes] "
> -			   "[mapped as %s]",
> -			   ref->dev_addr, ref->size,
> -			   type2name[entry->type]);
> -	}
> +	check_dma_mapping_error(ref, entry);
>  
>  	hash_bucket_del(entry);
>  	dma_entry_free(entry);

