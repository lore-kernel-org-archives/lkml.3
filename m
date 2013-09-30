Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3I3I3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 04:29:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64234 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3I3I3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 04:29:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-ac-524936402890
Content-transfer-encoding: 8BIT
Message-id: <1380529726.11375.11.camel@AMDC1943>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Bob Liu <bob.liu@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Date: Mon, 30 Sep 2013 10:28:46 +0200
In-reply-to: <20130927220045.GA751@variantweb.net>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com> <20130923220757.GC16191@variantweb.net>
 <524318DE.7070106@samsung.com> <20130925215744.GA25852@variantweb.net>
 <52455B05.1010603@samsung.com> <20130927220045.GA751@variantweb.net>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xq7oOZp5BBgcniVrMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHibNMbdovLu+awWdxb85/VYu2Ru+wWk989Y7RY9vU9u8WhfavYLea1v2R1
	4PFYvOclk8emVZ1sHps+TWL3ODHjN4vHg0ObWTw+Pr3F4tG3ZRWjx+bT1R6fN8kFcEZx2aSk
	5mSWpRbp2yVwZbTsNSl4qVSx56hOA+M9qS5GTg4JAROJY42XmCBsMYkL99azdTFycQgJLGWU
	WNg/lREkwSsgKPFj8j2WLkYODmYBeYkjl7JBwswC6hKT5i1ihqj/zCjx9+8cJoh6A4nLt3rA
	bGEBI4m7uw+zg9hsAsYSm5cvYQOxRQT0JbpnrwBrZhZYxyzx8e5nsCIWAVWJe1fmgjVzAjWv
	XfEb7AghgflMEkd3SUNcqiSxu72TfQKjwCwk981CuG8WkvsWMDKvYhRNLU0uKE5KzzXUK07M
	LS7NS9dLzs/dxAiJnC87GBcfszrEKMDBqMTDa7HUI0iINbGsuDL3EKMEB7OSCO9XPs8gId6U
	xMqq1KL8+KLSnNTiQ4xMHJxSDYz6P74edP2mt20/V88piX9uQYcjtT9+2u7WvLptTk3HvNtz
	l51tUkoXYmQW4zT/9mO3w31/7c++pUn74y2WmiT/s2rk9nV59CzYYdrZc4r/bLeY6F+efGDO
	8eIzvm9yDyawMEz5pPB3j/Da1W4nAg9LVK5nszcQ2LWnJMbw2C75G+/Ddv8M+/hDiaU4I9FQ
	i7moOBEARDReMXoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2013-09-27 at 17:00 -0500, Seth Jennings wrote:
> I have to say that when I first came up with the idea, I was thinking
> the address space would be at the zswap layer and the radix slots would
> hold zbud handles, not struct page pointers.
> 
> However, as I have discovered today, this is problematic when it comes
> to reclaim and migration and serializing access.
> 
> I wanted to do as much as possible in the zswap layer since anything
> done in the zbud layer would need to be duplicated in any other future
> allocator that zswap wanted to support.
> 
> Unfortunately, zbud abstracts away the struct page and that visibility
> is needed to properly do what we are talking about.
> 
> So maybe it is inevitable that this will need to be in the zbud code
> with the radix tree slots pointing to struct pages after all.

To me it looks very similar to the solution proposed in my patches. The
difference is that you wish to use offset as radix tree index.
I thought about this earlier but it imposed two problems:

1. A generalized handle (instead of offset) may be more suitable when
zbud will be used in other drivers (e.g. zram).

2. It requires redesigning of zswap architecture around
zswap_frontswap_store() in case of duplicated insertion. Currently when
storing a page the zswap:
 - allocates zbud page,
 - stores new data in it,
 - checks whether it is a duplicated page (same offset present in
rbtree),
 - if yes (duplicated) then zswap frees previous entry.
The problem here lies in allocating zbud page under the same offset.
This step would replace old data (because we are using the same offset
in radix tree).

In my opinion using zbud handle is in this case more flexible.


Best regards,
Krzysztof

> I like the idea of masking the bit into the struct page pointer to
> indicate which buddy maps to the offset.
> 
> There is a twist here in that, unlike a normal page cache tree, we can
> have two offsets pointing at different buddies in the same frame
> which means we'll have to do some custom stuff for migration.
> 
> The rabbit hole I was going down today has come to an end so I'll take a
> fresh look next week.
> 
> Thanks for your ideas and discussion! Maybe we can make zswap/zbud an
> upstanding MM citizen yet!
> 
> Seth
> 
> > 
> > >>
> > >> In case of zbud, there are two swap offset pointing to
> > >> the same page. There might be more if zsmalloc is used.
> > >> What is worse it is possible that one swap entry could
> > >> point to data that cross a page boundary.
> > > 
> > > We just won't set page->index since it doesn't have a good meaning in
> > > our case.  Swap cache pages also don't use index, although is seems to
> > > me that they could since there is a 1:1 mapping of a swap cache page to
> > > a swap offset and the index field isn't being used for anything else.
> > > But I digress...
> > 
> > OK.
> > 
> > > 
> > >>
> > >> Of course, one could try to modify MM to support
> > >> multiple mapping of a page in the radix tree.
> > >> But I think that MM guys will consider this as a hack
> > >> and they will not accept it.
> > > 
> > > Yes, it will require some changes to the MM to handle zbud pages on the
> > > LRU.  I'm thinking that it won't be too intrusive, depending on how we
> > > choose to mark zbud pages.
> > > 
> > 
> > Anyway, I think that zswap should use two index engines.
> > I mean index in Data Base meaning.
> > One index is used to translate swap_entry to compressed page.
> > And another one to be used by reclaim and migration by MM,
> > probably address_space is a best choice.
> > Zbud would responsible for keeping consistency
> > between mentioned indexes.
> > 
> > Regards,
> > Tomasz Stanislawski
> > 
> > > Seth
> > > 
> > >>
> > >> Regards,
> > >> Tomasz Stanislawski
> > >>
> > >>
> > >>> --
> > >>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > >>> the body to majordomo@kvack.org.  For more info on Linux MM,
> > >>> see: http://www.linux-mm.org/ .
> > >>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > >>>
> > >>
> > > 
> > > --
> > > To unsubscribe, send a message with 'unsubscribe linux-mm' in
> > > the body to majordomo@kvack.org.  For more info on Linux MM,
> > > see: http://www.linux-mm.org/ .
> > > Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> > > 
> > 

