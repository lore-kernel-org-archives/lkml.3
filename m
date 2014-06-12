Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbaFLITa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:19:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:40997 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932727AbaFLIS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:18:57 -0400
X-IronPort-AV: E=Sophos;i="5.00,694,1396972800"; 
   d="scan'208";a="31803887"
Message-ID: <53996276.20906@cn.fujitsu.com>
Date: Thu, 12 Jun 2014 16:19:02 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        Gleb Natapov <gleb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <agraf@suse.de>, <kvm-ppc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 02/10] DMA, CMA: fix possible memory leak
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-3-git-send-email-iamjoonsoo.kim@lge.com> <20140612052543.GE12415@bbox> <20140612060211.GC30128@js1304-P5Q-DELUXE>
In-Reply-To: <20140612060211.GC30128@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 02:02 PM, Joonsoo Kim wrote:
> On Thu, Jun 12, 2014 at 02:25:43PM +0900, Minchan Kim wrote:
>> On Thu, Jun 12, 2014 at 12:21:39PM +0900, Joonsoo Kim wrote:
>>> We should free memory for bitmap when we find zone mis-match,
>>> otherwise this memory will leak.
>>
>> Then, -stable stuff?
> 
> I don't think so. This is just possible leak candidate, so we don't
> need to push this to stable tree.
> 
>>
>>>
>>> Additionally, I copy code comment from ppc kvm's cma code to notify
>>> why we need to check zone mis-match.
>>>
>>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>>>
>>> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
>>> index bd0bb81..fb0cdce 100644
>>> --- a/drivers/base/dma-contiguous.c
>>> +++ b/drivers/base/dma-contiguous.c
>>> @@ -177,14 +177,24 @@ static int __init cma_activate_area(struct cma *cma)
>>>  		base_pfn = pfn;
>>>  		for (j = pageblock_nr_pages; j; --j, pfn++) {
>>>  			WARN_ON_ONCE(!pfn_valid(pfn));
>>> +			/*
>>> +			 * alloc_contig_range requires the pfn range
>>> +			 * specified to be in the same zone. Make this
>>> +			 * simple by forcing the entire CMA resv range
>>> +			 * to be in the same zone.
>>> +			 */
>>>  			if (page_zone(pfn_to_page(pfn)) != zone)
>>> -				return -EINVAL;
>>> +				goto err;
>>
>> At a first glance, I thought it would be better to handle such error
>> before activating.
>> So when I see the registration code(ie, dma_contiguous_revere_area),
>> I realized it is impossible because we didn't set up zone yet. :(
>>
>> If so, when we detect to fail here, it would be better to report more
>> meaningful error message like what was successful zone and what is
>> new zone and failed pfn number?
> 
> What I want to do in early phase of this patchset is to make cma code
> on DMA APIs similar to ppc kvm's cma code. ppc kvm's cma code already
> has this error handling logic, so I make this patch.
> 
> If we think that we need more things, we can do that on general cma code
> after merging this patchset.
> 

Yeah, I also like the idea. After all, this patchset aims to a general CMA
management, we could improve more after this patchset. So

Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

-- 
Thanks.
Zhang Yanfei
