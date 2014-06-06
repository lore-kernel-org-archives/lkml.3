Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaFFAeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 20:34:37 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:52480 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751384AbaFFAeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 20:34:36 -0400
Message-ID: <53910C95.7000808@hurleysoftware.com>
Date: Thu, 05 Jun 2014 20:34:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Pranith Kumar <pranith@gatech.edu>, dwmw2@infradead.org, joro@8bytes.org
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] use documented cmpxchg api
References: <5390ED07.2070009@gatech.edu>
In-Reply-To: <5390ED07.2070009@gatech.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 06:19 PM, Pranith Kumar wrote:
> use the documented atomic_cmpxchg instead of __cmpxchg64
>
> This kills the last user of said API in drivers code.
>
>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>   drivers/iommu/intel-iommu.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 6bb3277..270113f 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -293,7 +293,7 @@ static inline u64 dma_pte_addr(struct dma_pte *pte)
>   	return pte->val & VTD_PAGE_MASK;
>   #else
>   	/* Must have a full atomic 64-bit read */
> -	return  __cmpxchg64(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;
> +	return  atomic_cmpxchg(&pte->val, 0ULL, 0ULL) & VTD_PAGE_MASK;

This is not equivalent.

The __cmpxchg64() is specifically being used in this case
when !CONFIG_64BIT for a full 64-bit RMW, whereas atomic_cmpxchg()
uses ints which would be 32-bit RMW.

Regards,
Peter Hurley


