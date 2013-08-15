Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760356Ab3HOHpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:45:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63913 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab3HOHpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:45:43 -0400
Message-ID: <520C8707.4000100@huawei.com>
Date: Thu, 15 Aug 2013 15:45:11 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, <riel@redhat.com>,
        <aquini@redhat.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
References: <520B0B75.4030708@huawei.com> <20130814085711.GK2296@suse.de> <20130814155205.GA2706@gmail.com> <20130814161642.GM2296@suse.de> <20130814163921.GC2706@gmail.com> <20130814180012.GO2296@suse.de> <520C3DD2.8010905@huawei.com> <20130815024427.GA2718@gmail.com> <520C4EFF.8040305@huawei.com> <20130815041736.GA2592@gmail.com> <20130815042434.GA3139@gmail.com>
In-Reply-To: <20130815042434.GA3139@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/15 12:24, Minchan Kim wrote:

>> Please read full thread in detail.
>>
>> Mel suggested following as
>>
>> if (PageBuddy(page)) {
>>         int nr_pages = (1 << page_order(page)) - 1;
>>         if (PageBuddy(page)) {
>>                 nr_pages = min(nr_pages, MAX_ORDER_NR_PAGES - 1);
>>                 low_pfn += nr_pages;
>>                 continue;
>>         }
>> }
>>
>> min(nr_pages, xxx) removes your concern but I think Mel's version
>> isn't right. It should be aligned with pageblock boundary so I 
>> suggested following.
>>
>> if (PageBuddy(page)) {
>> #ifdef CONFIG_MEMORY_ISOLATION
>> 	unsigned long order = page_order(page);
>> 	if (PageBuddy(page)) {
>> 		low_pfn += (1 << order) - 1;
>> 		low_pfn = min(low_pfn, end_pfn);
>> 	}
>> #endif
>> 	continue;
>> }
>>

Hi Minchan,

I understand now, but why use "end_pfn" here? 
Maybe like this:

if (PageBuddy(page)) {
	/*
	 * page_order is racy without zone->lock but worst case
	 * by the racing is just skipping pageblock_nr_pages.
	 */
	unsigned long nr_pages = 1 << page_order(page);
	if (likely(PageBuddy(page))) {
		nr_pages = min(nr_pages, MAX_ORDER_NR_PAGES);

		/* Align with pageblock boundary */
		if ((low_pfn & (pageblock_nr_pages - 1)) + nr_pages >
		    pageblock_nr_pages)
			low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
		else
			low_pfn += nr_pages - 1;
	}
	continue;
}

Thanks,
Xishi Qiu

>> so worst case is (pageblock_nr_pages - 1).
>> but we don't need to add CONFIG_MEMORY_ISOLATION so my suggestion
>> is following as.
>>
>> if (PageBuddy(page)) {
>> 	unsigned long order = page_order(page);
>> 	if (PageBuddy(page)) {
>> 		low_pfn += (1 << order) - 1;
>> 		low_pfn = min(low_pfn, end_pfn);
> 
> Maybe it should be low_pfn = min(low_pfn, end_pfn - 1).
> 
> 
>> 	}
>> 	continue;
>> }
>>
>>
> 



