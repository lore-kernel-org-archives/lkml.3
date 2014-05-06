Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaEFUe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:34:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEFUez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:34:55 -0400
Date: Tue, 6 May 2014 22:34:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/17] mm: page_alloc: Use word-based accesses for
 get/set pageblock bitmaps
Message-ID: <20140506203449.GG1429@laptop.programming.kicks-ass.net>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-9-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1398933888-4940-9-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 09:44:39AM +0100, Mel Gorman wrote:
> +void set_pfnblock_flags_group(struct page *page, unsigned long flags,
> +					unsigned long end_bitidx,
> +					unsigned long nr_flag_bits,
> +					unsigned long mask)
>  {
>  	struct zone *zone;
>  	unsigned long *bitmap;
> +	unsigned long pfn, bitidx, word_bitidx;
> +	unsigned long old_word, new_word;
> +
> +	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
>  
>  	zone = page_zone(page);
>  	pfn = page_to_pfn(page);
>  	bitmap = get_pageblock_bitmap(zone, pfn);
>  	bitidx = pfn_to_bitidx(zone, pfn);
> +	word_bitidx = bitidx / BITS_PER_LONG;
> +	bitidx &= (BITS_PER_LONG-1);
> +
>  	VM_BUG_ON_PAGE(!zone_spans_pfn(zone, pfn), page);
>  
> +	bitidx += end_bitidx;
> +	mask <<= (BITS_PER_LONG - bitidx - 1);
> +	flags <<= (BITS_PER_LONG - bitidx - 1);
> +
> +	do {
> +		old_word = ACCESS_ONCE(bitmap[word_bitidx]);
> +		new_word = (old_word & ~mask) | flags;
> +	} while (cmpxchg(&bitmap[word_bitidx], old_word, new_word) != old_word);
>  }

You could write it like:

	word = ACCESS_ONCE(bitmap[word_bitidx]);
	for (;;) {
		old_word = cmpxchg(&bitmap[word_bitidx], word, (word & ~mask) | flags);
		if (word == old_word);
			break;
		word = old_word;
	}

It has a slightly tighter loop by avoiding the read being included.
