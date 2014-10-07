Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaJGA73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:59:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:55808 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaJGA72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:59:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,666,1406617200"; 
   d="scan'208";a="614211862"
Message-ID: <54333AEC.6000603@linux.intel.com>
Date: Tue, 07 Oct 2014 08:59:24 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
CC: David Woodhouse <dwmw2@infradead.org>, jroedel@suse.de
Subject: Re: [PATCH 2/2] iommu/vt-d: Work around broken RMRR firmware entries
References: <1412244548-27617-1-git-send-email-joro@8bytes.org> <1412244548-27617-3-git-send-email-joro@8bytes.org>
In-Reply-To: <1412244548-27617-3-git-send-email-joro@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/10/2 18:09, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The VT-d specification states that an RMRR entry in the DMAR
> table needs to specify the full path to the device. This is
> also how newer Linux kernels implement it.
> 
> Unfortunatly older drivers just match for the target device
> and not the full path to the device, so that BIOS vendors
> implement that behavior into their BIOSes to make them work
> with older Linux kernels. But those RMRR entries break on
> newer Linux kernels.
> 
> Work around this issue by adding a fall-back into the RMRR
> matching code to match those old RMRR entries too.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  drivers/iommu/dmar.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 6ba28b0..371ff33 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -178,17 +178,33 @@ static bool dmar_match_pci_path(struct dmar_pci_notify_info *info, int bus,
>  	int i;
>  
>  	if (info->bus != bus)
> -		return false;
> +		goto fallback;
>  	if (info->level != count)
> -		return false;
> +		goto fallback;
>  
>  	for (i = 0; i < count; i++) {
>  		if (path[i].device != info->path[i].device ||
>  		    path[i].function != info->path[i].function)
> -			return false;
> +			goto fallback;
>  	}
>  
>  	return true;
> +
> +fallback:
> +
> +	if (count != 1)
> +		return false;
> +
> +	i = info->level - 1;
> +	if (bus              == info->path[i].bus &&
> +	    path[0].device   == info->path[i].device &&
> +	    path[0].function == info->path[i].function) {
> +		pr_info(FW_BUG "RMRR entry for device %02x:%02x.%x is broken - applying workaround\n",
> +			bus, path[0].device, path[0].function);
> +		return true;
> +	}
> +
> +	return false;
>  }
>  
>  /* Return: > 0 if match found, 0 if no match found, < 0 if error happens */
> 
Hi Joerg,
	Thanks for fixing this:)
	Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
Regards!
Gerry
