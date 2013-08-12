Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3HLQsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:48:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:23206 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279Ab3HLQsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:48:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,863,1367996400"; 
   d="scan'208";a="385811364"
Message-ID: <520911C5.5060506@intel.com>
Date: Mon, 12 Aug 2013 09:48:05 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, guz.fnst@cn.fujitsu.com,
        bcrl@kvack.org
Subject: Re: [RFC PATCH v2 0/4] mm: reclaim zbud pages on migration and compaction
References: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com> <20130812022535.GA18832@bbox>
In-Reply-To: <20130812022535.GA18832@bbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2013 07:25 PM, Minchan Kim wrote:
> +int set_pinned_page(struct pin_page_owner *owner,
> +			struct page *page, void *private)
> +{
> +	struct pin_page_info *pinfo = kmalloc(sizeof(pinfo), GFP_KERNEL);
> +
> +	INIT_HLIST_NODE(&pinfo->hlist);
> +	pinfo->owner = owner;
> +
> +	pinfo->pfn = page_to_pfn(page);
> +	pinfo->private = private;
> +	
> +	spin_lock(&hash_lock);
> +	hash_add(pin_page_hash, &pinfo->hlist, pinfo->pfn);
> +	spin_unlock(&hash_lock);
> +
> +	SetPinnedPage(page);
> +	return 0;
> +};

I definitely agree that we're getting to the point where we need to look
at this more generically.  We've got at least four use-cases that have a
need for deterministically relocating memory:

1. CMA (many sub use cases)
2. Memory hot-remove
3. Memory power management
4. Runtime hugetlb-GB page allocations

Whatever we do, it _should_ be good enough to largely let us replace
PG_slab with this new bit.
