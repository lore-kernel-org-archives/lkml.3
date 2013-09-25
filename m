Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3IYRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 13:09:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52727 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3IYRJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 13:09:55 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-2e-524318e02564
Message-id: <524318DE.7070106@samsung.com>
Date: Wed, 25 Sep 2013 19:09:50 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Bob Liu <bob.liu@oracle.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com> <20130923220757.GC16191@variantweb.net>
In-reply-to: <20130923220757.GC16191@variantweb.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xa7oPJZyDDI5GWcxZv4bNYuOM9awW
	Xaemslh8evmA0eL1C0OLs01v2C0u75rDZnFvzX9Wi7VH7rJbTH73jNFi2df37BaH9q1id+Dx
	WLznJZPHplWdbB6bPk1i9zgx4zeLx4NDm1k8Pj69xeLRt2UVo8fm09UenzfJBXBGcdmkpOZk
	lqUW6dslcGW8aj3KVjBboKJn9wW2BsZnPF2MnBwSAiYSHw79ZoSwxSQu3FvP1sXIxSEksJRR
	Yu+ep6wQzmdGia+7PrKBVPEKaEmc3v4dzGYRUJXYcX8ymM0GNOnYks9gk0QFIiT+nN7HClEv
	KPFj8j0WEJsPqGbi7l5mEFtEQF+ie/YKZpAFzAJrmSU+zL/ODpIQFjCSuLv7MDvE5n5GicVf
	joF1cwJ1n3/9hgnEZhbQkdjfOo0NwpaX2LzmLfMERsFZSBbOQlI2C0nZAkbmVYyiqaXJBcVJ
	6bmGesWJucWleel6yfm5mxghcfVlB+PiY1aHGAU4GJV4eDXZnIOEWBPLiitzDzFKcDArifCy
	cgOFeFMSK6tSi/Lji0pzUosPMTJxcEo1MOYpKz4urmXVYmswf9ZyUbDhbTxT7bKLej3Rq36a
	e+XLza9rVLsVdy1hrb9z8hT903fmBn23mrb4jk6X09q/YQpbJn4qVz+p3jnzaspPuVd/qzm2
	fdo1s/3h9A+JJdvyutrd5kb6XQ/p/PFnQ+A6xknv9n4U/py/2axqwnbflv07dl/xYonfcUOJ
	pTgj0VCLuag4EQDl2r/tiQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just had an idea this afternoon to potentially kill both these birds with one
> stone: Replace the rbtree in zswap with an address_space.
> 
> Each swap type would have its own page_tree to organize the compressed objects
> by type and offset (radix tree is more suited for this anyway) and a_ops that
> could be called by shrink_page_list() (writepage) or the migration code
> (migratepage).
> 
> Then zbud pages could be put on the normal LRU list, maybe at the beginning of
> the inactive LRU so they would live for another cycle through the list, then be
> reclaimed in the normal way with the mapping->a_ops->writepage() pointing to a
> zswap_writepage() function that would decompress the pages and call
> __swap_writepage() on them.
> 
> This might actually do away with the explicit pool size too as the compressed
> pool pages wouldn't be outside the control of the MM anymore.
> 
> I'm just starting to explore this but I think it has promise.
> 
> Seth
> 

Hi Seth,
There is a problem with the proposed idea.
The radix tree used 'struct address_space' is a part of
a bigger data structure.
The radix tree is used to translate an offset to a page.
That is ok for zswap. But struct page has a field named 'index'.
The MM assumes that this index is an offset in radix tree
where one can find the page. A lot is done by MM to sustain
this consistency.

In case of zbud, there are two swap offset pointing to
the same page. There might be more if zsmalloc is used.
What is worse it is possible that one swap entry could
point to data that cross a page boundary.

Of course, one could try to modify MM to support
multiple mapping of a page in the radix tree.
But I think that MM guys will consider this as a hack
and they will not accept it.

Regards,
Tomasz Stanislawski


> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

