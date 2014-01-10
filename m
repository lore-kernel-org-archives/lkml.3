Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaAJIbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 03:31:55 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:19723 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaAJIby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 03:31:54 -0500
Message-ID: <52CFAFED.1040505@hp.com>
Date: Fri, 10 Jan 2014 16:31:41 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
CC: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>, Kai Huang <dev.kai.huang@gmail.com>,
        jiang.liu@linux.intel.com
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
References: <1389342475-8540-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1389342475-8540-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is sent again because a ';' was missed in my last mail.

 > +	context->asr = value >> VTD_PAGE_SHIFT

I corrected it and created a new one. And it is tested .
Please use the latest one.


Sorry for that.

ZhenHua

On 01/10/2014 04:27 PM, Li, Zhen-Hua wrote:
> There is a structure named context_entry used by intel iommu, and there
> are some bit operations on it. Use bit structure may make these operations
> easy.
> Also the function context_set_address_root may cause problem because it uses
>   |= operation, not set the new value. And this patch can fix it.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/iommu/intel-iommu.c | 37 +++++++++++++++++++++++++++----------
>   1 file changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 43b9bfe..65cd480 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -221,47 +221,64 @@ get_context_addr_from_root(struct root_entry *root)
>    * 8-23: domain id
>    */
>   struct context_entry {
> -	u64 lo;
> -	u64 hi;
> +	union {
> +		struct {
> +			u64	present:1,
> +				fpd:1,
> +				translation_type:2,
> +				reserved_l:8,
> +				asr:52;
> +		};
> +		u64 lo;
> +	};
> +	union {
> +		struct {
> +			u64	aw:3,
> +				avail:4,
> +				reserved_h1:1,
> +				did:16,
> +				reserved_h2:40;
> +		};
> +		u64 hi;
> +	};
>   };
>
>   static inline bool context_present(struct context_entry *context)
>   {
> -	return (context->lo & 1);
> +	return context->present;
>   }
>   static inline void context_set_present(struct context_entry *context)
>   {
> -	context->lo |= 1;
> +	context->present = 1;
>   }
>
>   static inline void context_set_fault_enable(struct context_entry *context)
>   {
> -	context->lo &= (((u64)-1) << 2) | 1;
> +	context->fpd = 1;
>   }
>
>   static inline void context_set_translation_type(struct context_entry *context,
>   						unsigned long value)
>   {
> -	context->lo &= (((u64)-1) << 4) | 3;
> -	context->lo |= (value & 3) << 2;
> +	context->translation_type = value;
>   }
>
>   static inline void context_set_address_root(struct context_entry *context,
>   					    unsigned long value)
>   {
> -	context->lo |= value & VTD_PAGE_MASK;
> +	context->asr = value >> VTD_PAGE_SHIFT;
>   }
>
>   static inline void context_set_address_width(struct context_entry *context,
>   					     unsigned long value)
>   {
> -	context->hi |= value & 7;
> +	context->aw  = value;
>   }
>
>   static inline void context_set_domain_id(struct context_entry *context,
>   					 unsigned long value)
>   {
> -	context->hi |= (value & ((1 << 16) - 1)) << 8;
> +	context->did = value;
>   }
>
>   static inline void context_clear_entry(struct context_entry *context)
>

