Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934545AbaEFJNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:13:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59266 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934274AbaEFJNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:13:40 -0400
Date: Tue, 6 May 2014 10:13:36 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Sasha Levin <sasha.levin@oracle.com>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Jan Kara <jack@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/17] mm: page_alloc: Use word-based accesses for
 get/set pageblock bitmaps
Message-ID: <20140506091336.GX23991@suse.de>
References: <1398933888-4940-1-git-send-email-mgorman@suse.de>
 <1398933888-4940-9-git-send-email-mgorman@suse.de>
 <53641D8C.6040601@oracle.com>
 <20140504131454.GS23991@suse.de>
 <536786C6.8040805@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <536786C6.8040805@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 02:40:38PM +0200, Vlastimil Babka wrote:
> >@@ -62,11 +65,35 @@ extern int pageblock_order;
> >  /* Forward declaration */
> >  struct page;
> >
> >+unsigned long get_pageblock_flags_mask(struct page *page,
> >+				unsigned long end_bitidx,
> >+				unsigned long nr_flag_bits,
> >+				unsigned long mask);
> >+void set_pageblock_flags_mask(struct page *page,
> >+				unsigned long flags,
> >+				unsigned long end_bitidx,
> >+				unsigned long nr_flag_bits,
> >+				unsigned long mask);
> >+
> 
> The nr_flag_bits parameter is not used anymore and can be dropped.
> 

Fixed

> >  /* Declarations for getting and setting flags. See mm/page_alloc.c */
> >-unsigned long get_pageblock_flags_group(struct page *page,
> >-					int start_bitidx, int end_bitidx);
> >-void set_pageblock_flags_group(struct page *page, unsigned long flags,
> >-					int start_bitidx, int end_bitidx);
> >+static inline unsigned long get_pageblock_flags_group(struct page *page,
> >+					int start_bitidx, int end_bitidx)
> >+{
> >+	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
> >+	unsigned long mask = (1 << nr_flag_bits) - 1;
> >+
> >+	return get_pageblock_flags_mask(page, end_bitidx, nr_flag_bits, mask);
> >+}
> >+
> >+static inline void set_pageblock_flags_group(struct page *page,
> >+					unsigned long flags,
> >+					int start_bitidx, int end_bitidx)
> >+{
> >+	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
> >+	unsigned long mask = (1 << nr_flag_bits) - 1;
> >+
> >+	set_pageblock_flags_mask(page, flags, end_bitidx, nr_flag_bits, mask);
> >+}
> >
> >  #ifdef CONFIG_COMPACTION
> >  #define get_pageblock_skip(page) \
> >diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >index dc123ff..f393b0e 100644
> >--- a/mm/page_alloc.c
> >+++ b/mm/page_alloc.c
> >@@ -6032,53 +6032,64 @@ static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
> >   * @end_bitidx: The last bit of interest
> >   * returns pageblock_bits flags
> >   */
> >-unsigned long get_pageblock_flags_group(struct page *page,
> >-					int start_bitidx, int end_bitidx)
> >+unsigned long get_pageblock_flags_mask(struct page *page,
> >+					unsigned long end_bitidx,
> >+					unsigned long nr_flag_bits,
> >+					unsigned long mask)
> >  {
> >  	struct zone *zone;
> >  	unsigned long *bitmap;
> >-	unsigned long pfn, bitidx;
> >-	unsigned long flags = 0;
> >-	unsigned long value = 1;
> >+	unsigned long pfn, bitidx, word_bitidx;
> >+	unsigned long word;
> >
> >  	zone = page_zone(page);
> >  	pfn = page_to_pfn(page);
> >  	bitmap = get_pageblock_bitmap(zone, pfn);
> >  	bitidx = pfn_to_bitidx(zone, pfn);
> >+	word_bitidx = bitidx / BITS_PER_LONG;
> >+	bitidx &= (BITS_PER_LONG-1);
> >
> >-	for (; start_bitidx <= end_bitidx; start_bitidx++, value <<= 1)
> >-		if (test_bit(bitidx + start_bitidx, bitmap))
> >-			flags |= value;
> >-
> >-	return flags;
> >+	word = bitmap[word_bitidx];
> 
> I wonder if on some architecture this may result in inconsistent
> word when racing with set(), i.e. cmpxchg? We need consistency at
> least on the granularity of byte to prevent the problem with bogus
> migratetype values being read.
> 

The number of bits align on the byte boundary so I do not think there is
a problem there. There is a BUILD_BUG_ON check in set_pageblock_flags_mask
in case this changes so it can be revisited if necessary.

> >+	bitidx += end_bitidx;
> >+	return (word >> (BITS_PER_LONG - bitidx - 1)) & mask;
> 
> Yes that looks correct to me, bits don't seem to overlap anymore.
> 

Thanks.

-- 
Mel Gorman
SUSE Labs
