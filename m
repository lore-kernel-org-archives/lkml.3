Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3K0Qqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:46:37 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42413 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3K0Qqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:46:35 -0500
Date: Wed, 27 Nov 2013 11:45:44 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>, Tejun Heo <tj@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] mm + fs: store shadow entries in page cache
Message-ID: <20131127164544.GC3556@cmpxchg.org>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-7-git-send-email-hannes@cmpxchg.org>
 <20131125231716.GJ8803@dastard>
 <20131126102053.GJ10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126102053.GJ10022@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 11:20:53AM +0100, Peter Zijlstra wrote:
> On Tue, Nov 26, 2013 at 10:17:16AM +1100, Dave Chinner wrote:
> > void truncate_inode_pages_final(struct address_space *mapping)
> > {
> > 	mapping_set_exiting(mapping);
> > 	if (inode->i_data.nrpages || inode->i_data.nrshadows) {
> > 		/*
> > 		 * spinlock barrier to ensure all modifications are
> > 		 * complete before we do the final truncate
> > 		 */
> > 		spin_lock_irq(&mapping->tree_lock);
> > 		spin_unlock_irq(&mapping->tree_lock);
> 
> 	spin_unlock_wait() ?
> 
> Its cheaper, but prone to starvation; its typically useful when you're
> waiting for the last owner to go away and know there won't be any new
> ones around.

The other side is reclaim plucking pages one-by-one from the address
space in LRU order.  It'd be preferable to not starve the truncation
side, because it is much more efficient at getting rid of those pages.
