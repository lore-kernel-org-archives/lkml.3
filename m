Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaGDJGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:06:46 -0400
Received: from 8bytes.org ([85.214.48.195]:42103 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaGDJGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:06:44 -0400
Date: Fri, 4 Jul 2014 11:06:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] iommu/vt-d: move up no_iommu and dmar_disabled check
Message-ID: <20140704090640.GS26537@8bytes.org>
References: <1400589472-8544-1-git-send-email-wangyijing@huawei.com>
 <1400589472-8544-3-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400589472-8544-3-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  4 11:06:41 2014
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b66ea120861814915836
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 08:37:48PM +0800, Yijing Wang wrote:
> Move up the no_iommu and dmar_disabled check, avoid the
> useless initialization for dmar.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/iommu/intel-iommu.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index e020dcf..6b71608 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3948,6 +3948,9 @@ int __init intel_iommu_init(void)
>  	/* VT-d is required for a TXT/tboot launch, so enforce that */
>  	force_on = tboot_force_iommu();
>  
> +	if (no_iommu || dmar_disabled)
> +		return ret;
> +
>  	if (iommu_init_mempool()) {
>  		if (force_on)
>  			panic("tboot: Failed to initialize iommu memory\n");
> @@ -3974,9 +3977,6 @@ int __init intel_iommu_init(void)
>  		goto out_free_dmar;
>  	}
>  
> -	if (no_iommu || dmar_disabled)
> -		goto out_free_dmar;
> -
>  	if (list_empty(&dmar_rmrr_units))
>  		printk(KERN_INFO "DMAR: No RMRR found\n");

This breaks the kexec case were the old kernel had VT-d enabled and the
new one disabled. In this case the new kernel might need to disable the
IOMMUs.


	Joerg


