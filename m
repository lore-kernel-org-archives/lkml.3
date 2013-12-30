Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3L3OPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 09:15:18 -0500
Received: from 8bytes.org ([85.214.48.195]:56636 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3L3OPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 09:15:17 -0500
Date: Mon, 30 Dec 2013 15:15:12 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: akpm@linux-foundation.org, alexander.h.duyck@intel.com,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH v2] dma-debug: enhance dma_debug_device_change() to check
 for mapping errors
Message-ID: <20131230141511.GC2799@8bytes.org>
References: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384376168-2148-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Dec 30 15:15:14 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 52c17ff220861613411349
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 01:56:08PM -0700, Shuah Khan wrote:
> dma-debug checks to verify if driver validated the address returned by
> dma mapping routines when driver does unmap. If a driver doesn't call
> unmap, failure to check mapping errors isn't detected and reported.
> 
> Enhancing existing bus notifier_call dma_debug_device_change() to check
> for mapping errors at the same time it detects leaked dma buffers for
> BUS_NOTIFY_UNBOUND_DRIVER event. It scans for mapping errors and if any
> found, prints one warning message that includes mapping error count.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  lib/dma-debug.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index d87a17a..e34865e 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -717,6 +717,7 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
>  	struct dma_debug_entry *entry;
>  	unsigned long flags;
>  	int count = 0, i;
> +	int map_err_cnt = 0;
>  
>  	local_irq_save(flags);
>  
> @@ -724,6 +725,8 @@ static int device_dma_allocations(struct device *dev, struct dma_debug_entry **o
>  		spin_lock(&dma_entry_hash[i].lock);
>  		list_for_each_entry(entry, &dma_entry_hash[i].list, list) {
>  			if (entry->dev == dev) {
> +				if (entry->map_err_type == MAP_ERR_NOT_CHECKED)
> +					map_err_cnt += 1;
>  				count += 1;
>  				*out_entry = entry;

I think it is better to check for this in a seperate function and use
err_printk instead of dev_warn in the end to print the errors.
The new function can then be called in the dma_debug_device_change
callback like device_dma_allocations is.


	Joerg


