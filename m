Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaCDV5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:57:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:33528 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbaCDV5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:57:49 -0500
Date: Tue, 4 Mar 2014 16:57:35 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, walken@google.com, vbabka@suse.cz,
        tj@kernel.org, semenzato@google.com, rmallon@gmail.com,
        riel@redhat.com, peterz@infradead.org, ozgun@citusdata.com,
        minchan@kernel.org, mgorman@suse.de, metin@citusdata.com,
        kosaki.motohiro@jp.fujitsu.com, klamm@yandex-team.ru, jack@suse.cz,
        hughd@google.com, hch@infradead.org, gthelen@google.com,
        david@fromorbit.com, bob.liu@oracle.com, aarcange@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: +
 mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch added to
 -mm tree
Message-ID: <20140304215735.GA11171@cmpxchg.org>
References: <52f17469.abvZ3DeLOCoQdhR5%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52f17469.abvZ3DeLOCoQdhR5%akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:14:49PM -0800, akpm@linux-foundation.org wrote:
> @@ -307,14 +331,15 @@ void truncate_inode_pages_range(struct a
>  	index = start;
>  	for ( ; ; ) {
>  		cond_resched();
> -		if (!pagevec_lookup(&pvec, mapping, index,
> -			min(end - index, (pgoff_t)PAGEVEC_SIZE))) {
> +		if (!__pagevec_lookup(&pvec, mapping, index,
> +			min(end - index, (pgoff_t)PAGEVEC_SIZE),
> +			indices)) {
>  			if (index == start)
>  				break;
>  			index = start;
>  			continue;
>  		}
> -		if (index == start && pvec.pages[0]->index >= end) {
> +		if (index == start && indices[0] >= end) {
>  			pagevec_release(&pvec);
>  			break;
>  		}

There is a missing pagevec_remove_exceptionals(), which can crash the
kernel when pagevec_release() passes the non-page pointers to the page
allocator.

Andrew, could you please include this incremental fix?

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] mm + fs: prepare for non-page entries in page cache radix
 trees fix

__pagevec_lookup() stores exceptional entries in the pagevec.  They
must be pruned before passing the pagevec along to pagevec_release()
or the kernel crashes when these non-page pointers reach the page
allocator.

Add a missing pagevec_remove_exceptionals() in the truncate path.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/truncate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/truncate.c b/mm/truncate.c
index b0f4d4bee8ab..5fafca2ed3d2 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -340,6 +340,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			continue;
 		}
 		if (index == start && indices[0] >= end) {
+			pagevec_remove_exceptionals(&pvec);
 			pagevec_release(&pvec);
 			break;
 		}
-- 
1.9.0

