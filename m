Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab3HABf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:35:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16329 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3HABf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:35:26 -0400
Message-ID: <51F9BB50.1010905@huawei.com>
Date: Thu, 1 Aug 2013 09:35:12 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm/hotplug: remove unnecessary BUG_ON in __offline_pages()
References: <51F761E7.5090403@huawei.com> <51F9419F.6070306@intel.com>
In-Reply-To: <51F9419F.6070306@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/1 0:55, Dave Hansen wrote:

> On 07/29/2013 11:49 PM, Xishi Qiu wrote:
>> I think we can remove "BUG_ON(start_pfn >= end_pfn)" in __offline_pages(),
>> because in memory_block_action() "nr_pages = PAGES_PER_SECTION * sections_per_block" 
>> is always greater than 0.
> ...
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -1472,7 +1472,6 @@ static int __ref __offline_pages(unsigned long start_pfn,
>>  	struct zone *zone;
>>  	struct memory_notify arg;
>>  
>> -	BUG_ON(start_pfn >= end_pfn);
>>  	/* at least, alignment against pageblock is necessary */
>>  	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
>>  		return -EINVAL;
> 
> I think you're saying that you don't see a way to hit this BUG_ON() in
> practice.  That does appear to be true, unless sections_per_block ended
> up 0 or negative.  The odds of getting in to this code if
> 'sections_per_block' was bogus are pretty small.
> 

Yes, I find there is an only to hit this BUG_ON() in v3.11, and "sections_per_block"
seems to be always greater than 0.

> Or, is this a theoretical thing that folks might run in to when adding
> new features or developing?  It's in a cold path and the cost of the
> check is miniscule.  The original author (cc'd) also saw a need to put
> this in probably because he actually ran in to this.
> 

In v2.6.32, If info->length==0, this way may hit this BUG_ON().
acpi_memory_disable_device()
	remove_memory(info->start_addr, info->length)
		offline_pages()

Later Fujitsu's patch rename this function and the BUG_ON() is unnecessary.

Thanks,
Xishi Qiu

> In any case, it looks fairly safe to me:
> 
> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
> .
> 


