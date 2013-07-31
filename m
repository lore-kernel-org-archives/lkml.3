Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590Ab3GaQ4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:56:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:7398 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760559Ab3GaQ4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:56:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,788,1367996400"; 
   d="scan'208";a="354996137"
Message-ID: <51F9419F.6070306@intel.com>
Date: Wed, 31 Jul 2013 09:55:59 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm/hotplug: remove unnecessary BUG_ON in __offline_pages()
References: <51F761E7.5090403@huawei.com>
In-Reply-To: <51F761E7.5090403@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 11:49 PM, Xishi Qiu wrote:
> I think we can remove "BUG_ON(start_pfn >= end_pfn)" in __offline_pages(),
> because in memory_block_action() "nr_pages = PAGES_PER_SECTION * sections_per_block" 
> is always greater than 0.
...
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1472,7 +1472,6 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  	struct zone *zone;
>  	struct memory_notify arg;
>  
> -	BUG_ON(start_pfn >= end_pfn);
>  	/* at least, alignment against pageblock is necessary */
>  	if (!IS_ALIGNED(start_pfn, pageblock_nr_pages))
>  		return -EINVAL;

I think you're saying that you don't see a way to hit this BUG_ON() in
practice.  That does appear to be true, unless sections_per_block ended
up 0 or negative.  The odds of getting in to this code if
'sections_per_block' was bogus are pretty small.

Or, is this a theoretical thing that folks might run in to when adding
new features or developing?  It's in a cold path and the cost of the
check is miniscule.  The original author (cc'd) also saw a need to put
this in probably because he actually ran in to this.

In any case, it looks fairly safe to me:

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
