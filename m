Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab3HOCd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 22:33:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:7825 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758345Ab3HOCd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 22:33:26 -0400
Message-ID: <520C3DD2.8010905@huawei.com>
Date: Thu, 15 Aug 2013 10:32:50 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <riel@redhat.com>,
        <aquini@redhat.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
Subject: Re: [PATCH] mm: skip the page buddy block instead of one page
References: <520B0B75.4030708@huawei.com> <20130814085711.GK2296@suse.de> <20130814155205.GA2706@gmail.com> <20130814161642.GM2296@suse.de> <20130814163921.GC2706@gmail.com> <20130814180012.GO2296@suse.de>
In-Reply-To: <20130814180012.GO2296@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/15 2:00, Mel Gorman wrote:

>>> Even if the page is still page buddy, there is no guarantee that it's
>>> the same page order as the first read. It could have be currently
>>> merging with adjacent buddies for example. There is also a really
>>> small race that a page was freed, allocated with some number stuffed
>>> into page->private and freed again before the second PageBuddy check.
>>> It's a bit of a hand grenade. How much of a performance benefit is there
>>
>> 1. Just worst case is skipping pageblock_nr_pages
> 
> No, the worst case is that page_order returns a number that is
> completely garbage and low_pfn goes off the end of the zone
> 
>> 2. Race is really small
>> 3. Higher order page allocation customer always have graceful fallback.
>>

Hi Minchan, 
I think in this case, we may get the wrong value from page_order(page).

1. page is in page buddy

> if (PageBuddy(page)) {

2. someone allocated the page, and set page->private to another value

> 	int nr_pages = (1 << page_order(page)) - 1;

3. someone freed the page

> 	if (PageBuddy(page)) {

4. we will skip wrong pages

> 		nr_pages = min(nr_pages, MAX_ORDER_NR_PAGES - 1);
> 		low_pfn += nr_pages;
> 		continue;
> 	}
> }
> 
> It's still race-prone meaning that it really should be backed by some
> performance data justifying it.
> 



