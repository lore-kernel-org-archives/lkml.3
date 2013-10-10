Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3JJHB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:01:29 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58523 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3JJHB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:01:28 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fc-525650c6a169
Message-id: <1381388484.21461.16.camel@AMDC1943>
Subject: Re: [PATCH v3 5/6] zswap: replace tree in zswap with radix tree in zbud
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <spartacus06@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Date: Thu, 10 Oct 2013 09:01:24 +0200
In-reply-to: <20131009171617.GA21057@variantweb.net>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
 <1381238980-2491-6-git-send-email-k.kozlowski@samsung.com>
 <20131009153022.GB5406@variantweb.net> <20131009171617.GA21057@variantweb.net>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xa7rHAsKCDM608VvMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHibNMbdovLu+awWdxb85/VYu2Ru+wWk989Y7RY9vU9u8XZRRuYLea1v2R1
	4PHYOesuu8fiPS+ZPDat6mTz2PRpErvHiRm/WTw+Pr3F4tG3ZRWjx+bT1R6fN8kFcEZx2aSk
	5mSWpRbp2yVwZTxecYqx4JNwxdlDnSwNjC0CXYycHBICJhKLjl1khLDFJC7cW8/WxcjFISSw
	lFHi/ZZ2VgjnM6NE354zLCBVvAIGElNe/mQHsYUFAiRO7ethBrHZBIwlNi9fwgZiiwhoSvQu
	X8YO0swssI5ZYl3Pb7AiFgFVibY3b8GaOYFWr+/eD7XuCqPEqpOXwbqZBdQlJs1bxAxxk5LE
	7vZOdoi4vMTmNW+ZIa4QlPgx+R7LBEaBWUhaZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi
	0rx0veT83E2MkBj6soNx8TGrQ4wCHIxKPLwKJaFBQqyJZcWVuYcYJTiYlUR4p58ECvGmJFZW
	pRblxxeV5qQWH2Jk4uCUamDMlC8X9pwr3yMX/m3dbelErc6loft0l/10kt5Y8egPm/aMB0vu
	5BjM3ieTlK0nLGLcIGhgy/d93a5K6Uyh62GX3vxsdVutwHn75vXN/THJZo77K0uc19qnF35N
	uenGz/dl2sn68ueXYou38L/d9OFQodekVqupfnl9CqXxd0RLpuoXSLz6JKnEUpyRaKjFXFSc
	CABxegDhfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 12:16 -0500, Seth Jennings wrote:
> On Wed, Oct 09, 2013 at 10:30:22AM -0500, Seth Jennings wrote:
> > In my approach, I was also looking at allowing the zbud pools to use
> > HIGHMEM pages, since the handle is no longer an address.  This requires
> > the pages that are being mapped to be kmapped (atomic) which will
> > disable preemption.  This isn't an additional overhead since the
> > map/unmap corresponds with a compress/decompress operation at the zswap
> > level which uses per-cpu variables that disable preemption already.
> 
> On second though, lets not mess with the HIGHMEM page support for now.
> Turns out it is tricker than I thought since the unbuddied lists are
> linked through the zbud header stored in the page.  But we can still
> disable preemption to allow per-cpu tracking of the current mapping and
> avoid a lookup (and races) in zbud_unmap().

This tracking of current mapping could solve another problem I
encountered with new one-radix-tree approach with storage of duplicated
entries.

The problem is in zbud_unmap() API using offset to unmap (if duplicated
entries are overwritten):
 - thread 1: zswap_fronstwap_load() of some offset
   - zbud_map() maps this offset -> zhdr1
 - thread 2: zswap_frontswap_store() stores new data for this offset 
   - zbud_alloc() allocated new zhdr2 and replaces zhdr1 in radix tree 
     under this offset
   - new compressed data is stored by zswap
 - thread 1: tries to zbud_unmap() of this offset, but now the old
   zhdr1 is not present in radix tree so unmap will either fail or use
   zhdr2 which is wrong

To solve this issue I experimented with unmapping by zbud_mapped_entry
instead of offset (so zbud_unmap() won't search zbud_header in radix
tree at all):
##########################
int zbud_unmap(struct zbud_pool *pool, pgoff_t offset,
		struct zbud_mapped_entry *entry)
{
	struct zbud_header *zhdr = handle_to_zbud_header((unsigned
long)entry->addr);

	VM_BUG_ON((offset != zhdr->first_offset) && (offset !=
zhdr->last_offset));
	spin_lock(&pool->lock);
	if (put_map_count(zhdr, offset)) {
		/* Racing zbud_free() could not free the offset because
		 * it was still mapped so it is our job to free. */
		zbud_header_free(pool, zhdr, offset);
		spin_unlock(&pool->lock);
		return -EFAULT;
	}
	put_zbud_page(zhdr);
	spin_unlock(&pool->lock);
	return 0;
}
##########################

However getting rid of first/last_map_count seems much more simpler! 

Best regards,
Krzysztof


