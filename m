Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaAFBll (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 20:41:41 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:43700 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaAFBlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 20:41:40 -0500
Message-ID: <52CA09C9.7000205@hp.com>
Date: Mon, 06 Jan 2014 09:41:29 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Wu, Feng" <feng.wu@intel.com>
CC: Kai Huang <dev.kai.huang@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
References: <1387529101-29769-1-git-send-email-zhen-hual@hp.com> <CAOtp4KqUgSnwadP0T=aWYX7rRzDBn3qkuqMzceDBO0c_bhpFwQ@mail.gmail.com> <E959C4978C3B6342920538CF579893F001D3C26D@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <E959C4978C3B6342920538CF579893F001D3C26D@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, that's the problem. And some other structures like this, see "union 
irte".

On 12/26/2013 01:12 PM, Wu, Feng wrote:
> I think if using |= operation, it should use &= operation to clear those
> bits first.
>
> Thanks,
>
> Feng
>
> *From:*iommu-bounces@lists.linux-foundation.org
> [mailto:iommu-bounces@lists.linux-foundation.org] *On Behalf Of *Kai Huang
> *Sent:* Thursday, December 26, 2013 9:55 AM
> *To:* Li, Zhen-Hua
> *Cc:* David Woodhouse; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> *Subject:* Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
>
> Just curious, why would |= operation cause problem? :)
>
> On Fri, Dec 20, 2013 at 4:45 PM, Li, Zhen-Hua <zhen-hual@hp.com
> <mailto:zhen-hual@hp.com>> wrote:
>
> There is a structure named context_entry used by intel iommu, and there
> are some bit operations on it. Use bit structure may make these operations
> easy.
> Also the function context_set_address_root may cause problem because it uses
>   |= operation, not set the new value. And this patch can fix it.
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com <mailto:zhen-hual@hp.com>>
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
> -       u64 lo;
> -       u64 hi;
> +       union {
> +               struct {
> +                       u64     present:1,
> +                               fpd:1,
> +                               translation_type:2,
> +                               reserved_l:8,
> +                               asr:52;
> +               };
> +               u64 lo;
> +       };
> +       union {
> +               struct {
> +                       u64     aw:3,
> +                               avail:4,
> +                               reserved_h1:1,
> +                               did:16,
> +                               reserved_h2:40;
> +               };
> +               u64 hi;
> +       };
>   };
>
>   static inline bool context_present(struct context_entry *context)
>   {
> -       return (context->lo & 1);
> +       return context->present;
>   }
>   static inline void context_set_present(struct context_entry *context)
>   {
> -       context->lo |= 1;
> +       context->present = 1;
>   }
>
>   static inline void context_set_fault_enable(struct context_entry *context)
>   {
> -       context->lo &= (((u64)-1) << 2) | 1;
> +       context->fpd = 1;
>   }
>
>   static inline void context_set_translation_type(struct context_entry
> *context,
>                                                  unsigned long value)
>   {
> -       context->lo &= (((u64)-1) << 4) | 3;
> -       context->lo |= (value & 3) << 2;
> +       context->translation_type = value;
>   }
>
>   static inline void context_set_address_root(struct context_entry *context,
>                                              unsigned long value)
>   {
> -       context->lo |= value & VTD_PAGE_MASK;
> +       context->asr = value >> VTD_PAGE_SHIFT
>   }
>
>   static inline void context_set_address_width(struct context_entry
> *context,
>                                               unsigned long value)
>   {
> -       context->hi |= value & 7;
> +       context->aw  = value;
>   }
>
>   static inline void context_set_domain_id(struct context_entry *context,
>                                           unsigned long value)
>   {
> -       context->hi |= (value & ((1 << 16) - 1)) << 8;
> +       context->did = value;
>   }
>
>   static inline void context_clear_entry(struct context_entry *context)
> --
> 1.8.4.3
>
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org <mailto:iommu@lists.linux-foundation.org>
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>

