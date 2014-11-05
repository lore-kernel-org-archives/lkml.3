Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaKECSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:18:38 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:64971 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbaKECSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:18:36 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="42865329"
Message-ID: <545988BE.3050201@cn.fujitsu.com>
Date: Wed, 5 Nov 2014 10:17:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <yinghai@kernel.org>,
        <isimatu.yasuaki@jp.fujitsu.co>, <fabf@skynet.be>, <nzimmer@sgi.com>,
        <wangnan0@huawei.com>, <vdavydov@parallels.com>, <toshi.kani@hp.com>,
        <phacht@linux.vnet.ibm.com>, <tj@kernel.org>,
        <kirill.shutemov@linux.intel.com>, <riel@redhat.com>,
        <luto@amacapital.net>, <hpa@linux.intel.com>, <aarcange@redhat.com>,
        <qiuxishi@huawei.com>, <mgorman@suse.de>, <rientjes@google.com>,
        <hannes@cmpxchg.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, <jiang.liu@linux.intel.com>
Subject: Re: [PATCH 2/2] mem-hotplug: Fix wrong check for zone->pageset initialization
 in online_pages().
References: <1414748812-22610-1-git-send-email-tangchen@cn.fujitsu.com> <1414748812-22610-3-git-send-email-tangchen@cn.fujitsu.com> <545976F9.50503@jp.fujitsu.com>
In-Reply-To: <545976F9.50503@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 09:01 AM, Kamezawa Hiroyuki wrote:
> ......
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3ab01b2..bc0de0f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1013,9 +1013,13 @@ int __ref online_pages(unsigned long pfn, unsigned long nr_pages, int online_typ
>   	 * If this zone is not populated, then it is not in zonelist.
>   	 * This means the page allocator ignores this zone.
>   	 * So, zonelist must be updated after online.
> +	 *
> +	 * If this zone is populated, zone->pageset could be initialized
> +	 * to boot_pageset for the first time a node is added. If so,
> +	 * zone->pageset should be allocated.
>   	 */
>   	mutex_lock(&zonelists_mutex);
> -	if (!populated_zone(zone)) {
> +	if (!populated_zone(zone) || !zone_pcp_initialized(zone)) {
> Please don't add another strange meanings to zone's pcplist.
>
> If you say zone->present_pages doesn't mean zone has pages in buddy list any more,
> please rewrite all parts using zone->present_pages including populated_zone().

Adding Liu Jiang...

I think zone->managed_pages was introduced by Liu Jiang in the following
patch:

>From 9feedc9d831e18ae6d0d15aa562e5e46ba53647b Mon Sep 17 00:00:00 2001
From: Jiang Liu <liuj97@gmail.com>
Date: Wed, 12 Dec 2012 13:52:12 -0800
Subject: [PATCH 1/1] mm: introduce new field "managed_pages" to struct zone

Before this patch, zone->present_pages meant "amount of memory
(excluding holes)",
not the zone has pages in buddy system.

So I think zone->present_pages keeps its meaning as before. But it may
be abused
somewhere else, such as here.

> I think there are several parts calculates parameters based on present_pages.
>
> I myself doesn't welcome having both of compliated "managed pages" and "present pages"...
>
> How about adding 
>
> static inline int managed_zone(struct zone *zone)
> {
> 	return (!!zone->managed_pages);
> }
>
> for this bug fix ?

Yes, adding this function could fix this problem.

And by the way, we have the following code in onine_pages():

zone->present_pages += onlined_pages;

pgdat_resize_lock(zone->zone_pgdat, &flags);
zone->zone_pgdat->node_present_pages += onlined_pages;
pgdat_resize_unlock(zone->zone_pgdat, &flags);

We should do this when the zone size is changed, not where it is now.
Will send patches for this soon.

Thanks.

>
> Other parts, using present_pages, should be considered well.
>
>

