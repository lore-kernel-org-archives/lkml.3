Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaKEHgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:36:18 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:17162 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaKEHgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:36:16 -0500
Message-ID: <5459D356.1040604@hp.com>
Date: Wed, 05 Nov 2014 15:35:50 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: joro@8bytes.org
CC: "Li, Zhen-Hua" <zhen-hual@hp.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 1/1] x86/iommu: fix incorrect bit operations in setting
 values
References: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1415172619-4801-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

While debugging Bill's patches, I found this problem:
When copying iommu data from old kernel to the kdump kernel, the 
original function context_set_address_root() may cause kdump kernel 
using incorrect address root value.

So I created this patch to fix it.

Zhenhua

On 11/05/2014 03:30 PM, Li, Zhen-Hua wrote:
> The function context_set_address_root() and set_root_value are setting new
> address in a wrong way, and this patch is trying to fix this problem.
>
> According to Intel Vt-d specs(Feb 2011, Revision 1.3), Chapter 9.1 and 9.2,
> field ctp in root entry is using bits 12:63, field asr in context entry is
> using bits 12:63.
>
> To set these fields, the following functions are used:
> static inline void context_set_address_root(struct context_entry *context,
>          unsigned long value);
> and
> static inline void set_root_value(struct root_entry *root, unsigned long value)
>
> But they are using an invalid method to set these fields, in current code, only
> a '|' operator is used to set it. This will not set the asr to the expected
> value if it has an old value.
>
> For example:
> Before calling this function,
> 	context->lo = 0x3456789012111;
> 	value = 0x123456789abcef12;
>
> After we call context_set_address_root(context, value), expected result is
> 	context->lo == 0x123456789abce111;
>
> But the actual result is:
> 	context->lo == 0x1237577f9bbde111;
>
> So we need to clear bits 12:63 before setting the new value, this will fix
> this problem.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>   drivers/iommu/intel-iommu.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index a27d6cb..11ac47b 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -195,6 +195,7 @@ static inline void set_root_present(struct root_entry *root)
>   }
>   static inline void set_root_value(struct root_entry *root, unsigned long value)
>   {
> +	root->val &= ~VTD_PAGE_MASK;
>   	root->val |= value & VTD_PAGE_MASK;
>   }
>
> @@ -247,6 +248,7 @@ static inline void context_set_translation_type(struct context_entry *context,
>   static inline void context_set_address_root(struct context_entry *context,
>   					    unsigned long value)
>   {
> +	context->lo &= ~VTD_PAGE_MASK;
>   	context->lo |= value & VTD_PAGE_MASK;
>   }
>
>

