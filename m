Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3JCNZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:25:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24182 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3JCNZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:25:08 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-cb-524d7005c873
Message-id: <1380806660.3392.30.camel@AMDC1943>
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
Date: Thu, 03 Oct 2013 15:24:20 +0200
In-reply-to: <20131001210431.GA8941@variantweb.net>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
 <5237FDCC.5010109@oracle.com> <20130923220757.GC16191@variantweb.net>
 <524318DE.7070106@samsung.com> <20130925215744.GA25852@variantweb.net>
 <52455B05.1010603@samsung.com> <20130927220045.GA751@variantweb.net>
 <1380529726.11375.11.camel@AMDC1943> <20131001210431.GA8941@variantweb.net>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xy7qsBb5BBiv/6VjMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHibNMbdovLu+awWdxb85/VYu2Ru+wWk989Y7RY9vU9u8WhfavYLea1v2R1
	4PFYvOclk8emVZ1sHps+TWL3ODHjN4vHg0ObWTw+Pr3F4tG3ZRWjx+bT1R6fN8kFcEZx2aSk
	5mSWpRbp2yVwZbTMeMFSMI+v4serRewNjGu5uxg5OSQETCTu7NrBCmGLSVy4t56ti5GLQ0hg
	KaNE+9XHUM5nRonux1/ZQap4BfQl5vU9AbOFBYwk7u4+DGazCRhLbF6+hA3EFgGq6Z69ghmk
	mVlgHbPEx7ufwYpYBFQlJr7cDraOE6jh6fNbTBAb3jJJrL7wigUkwSygLjFp3iJmiJuUJHa3
	d7JDxOUlNq95ywxxhaDEj8n3WCYwCsxC0jILSdksJGULGJlXMYqmliYXFCel5xrqFSfmFpfm
	pesl5+duYoTE0JcdjIuPWR1iFOBgVOLh7VDxCRJiTSwrrsw9xCjBwawkwmsf4xskxJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgbEgVOjw7p0ved342co+qAju6j68Jsbz37Tzs+7e2Ld7+1+L82+7
	1a+fOPr1Q//MZTtenX/mJXesy4az9k3CrIutVmLMX3Ukpyasr1N6sFY81/GmqIJaype3FX3d
	rE02ZbIrGhNV/z+747z41vuKnN7Wf/rrC3n2iNoz6O+ryrv/kfXVjZTJabJKLMUZiYZazEXF
	iQBrDzxsfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2013-10-01 at 16:04 -0500, Seth Jennings wrote:
> Yes, it is very similar.  I'm beginning to like aspects of this patch
> more as I explore this issue more.
> 
> At first, I balked at the idea of yet another abstraction layer, but it
> is very hard to avoid unless you want to completely collapse zswap and
> zbud into one another and dissolve the layering.  Then you could do a
> direct swap_offset -> address mapping.

After discussion with Tomasz Stanislawski we had an idea of merging the
trees (zswap's rb and zbud's radix added in these patches) into one tree
in zbud layer.

This would simplify the design (if migration was added, of course).

The idea looks like:
1. Get rid of the red-black tree in zswap.
2. Add radix tree to zbud (or use radix tree from address space).
 - Use offset (from swp_entry) as index to radix tree.
 - zbud page (struct page) stored in tree.
4. With both buddies filled one zbud page would be put in radix tree
twice.
5. zbud API would look like:
zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp, pgoff_t offset)
zbud_free(struct zbud_pool *pool, pgoff_t offset)
zbud_map(struct zbud_pool *pool, pgoff_t offset)
etc.

6. zbud_map/unmap() would be a little more complex than now as it would
took over some code from zswap (finding offset in tree).

7. The radix tree would be used for:
 - finding entry by offset (for zswap_frontswap_load() and others),
 - migration.

8. In case of migration colliding with zbud_map/unmap() the locking
could be limited (in comparison to my patch). Calling zbud_map() would
mark a page "dirty". During migration if page was "dirtied" then
migration would fail with EAGAIN. Of course migration won't start if
zbud buddy was mapped.


What do you think about this?


Best regards,
Krzysztof

