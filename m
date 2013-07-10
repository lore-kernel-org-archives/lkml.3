Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3GJWxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:53:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:21479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab3GJWxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:53:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1039,1363158000"; 
   d="scan'208";a="368099842"
Message-ID: <51DDE5BA.9020800@intel.com>
Date: Wed, 10 Jul 2013 15:52:42 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [RFC PATCH 1/5] mm, page_alloc: support multiple pages allocation
References: <1372840460-5571-1-git-send-email-iamjoonsoo.kim@lge.com> <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1372840460-5571-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 01:34 AM, Joonsoo Kim wrote:
> -		if (page)
> +		do {
> +			page = buffered_rmqueue(preferred_zone, zone, order,
> +							gfp_mask, migratetype);
> +			if (!page)
> +				break;
> +
> +			if (!nr_pages) {
> +				count++;
> +				break;
> +			}
> +
> +			pages[count++] = page;
> +			if (count >= *nr_pages)
> +				break;
> +
> +			mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
> +			if (!zone_watermark_ok(zone, order, mark,
> +					classzone_idx, alloc_flags))
> +				break;
> +		} while (1);

I'm really surprised this works as well as it does.  Calling
buffered_rmqueue() a bunch of times enables/disables interrupts a bunch
of times, and mucks with the percpu pages lists a whole bunch.
buffered_rmqueue() is really meant for _single_ pages, not to be called
a bunch of times in a row.

Why not just do a single rmqueue_bulk() call?
