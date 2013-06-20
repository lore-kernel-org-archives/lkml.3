Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935529Ab3FTBoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 21:44:21 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45707 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935516Ab3FTBoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 21:44:20 -0400
X-AuditID: 9c93016f-b7b6cae000007078-09-51c25e72937a
Date: Thu, 20 Jun 2013 10:44:40 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: do not put a slab to cpu partial list when
 cpu_partial is 0
Message-ID: <20130620014439.GA13026@lge.com>
References: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
 <51c1652d.246e320a.4057.ffffed4fSMTPIN_ADDED_BROKEN@mx.google.com>
 <20130619085250.GC12231@lge.com>
 <51c24c29.425c320a.433e.ffff9d8fSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c24c29.425c320a.433e.ffff9d8fSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 08:26:03AM +0800, Wanpeng Li wrote:
> On Wed, Jun 19, 2013 at 05:52:50PM +0900, Joonsoo Kim wrote:
> >On Wed, Jun 19, 2013 at 04:00:32PM +0800, Wanpeng Li wrote:
> >> On Wed, Jun 19, 2013 at 03:33:55PM +0900, Joonsoo Kim wrote:
> >> >In free path, we don't check number of cpu_partial, so one slab can
> >> >be linked in cpu partial list even if cpu_partial is 0. To prevent this,
> >> >we should check number of cpu_partial in put_cpu_partial().
> >> >
> >> 
> >> How about skip get_partial entirely? put_cpu_partial is called 
> >> in two paths, one is during refill cpu partial lists in alloc 
> >> slow path, the other is in free slow path. And cpu_partial is 0 
> >> just in debug mode. 
> >> 
> >> - alloc slow path, there is unnecessary to call get_partial 
> >>   since cpu partial lists won't be used in debug mode. 
> >> - free slow patch, new.inuse won't be true in debug mode 
> >>   which lead to put_cpu_partial won't be called.
> >> 
> >
> >In debug mode, put_cpu_partial() can't be called already on both path.
> >But, if we assign 0 to cpu_partial via sysfs, put_cpu_partial() will be called
> >on free slow path. On alloc slow path, it can't be called, because following
> >test in get_partial_node() is always failed.
> >
> >available > s->cpu_partial / 2
> 
> Is it always true? We can freeze slab from partial list, and 
> s->cpu_partial is 0. 

Do you mean node partial list?

At first, acquire_slab() is called for a cpu slab(not cpu partial list)
in get_partial_node(), and then, check above test. In this time, available
is always higher than 0, so, if we assign 0 to s->cpu_partial, we break
the loop and we don't try to get a slab for cpu partial list.

Thanks.

> 
> Regards,
> Wanpeng Li 
> 
> >
> >Thanks.
> >
> >> Regards,
> >> Wanpeng Li 
> >> 
> >> >Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >> >
> >> >diff --git a/mm/slub.c b/mm/slub.c
> >> >index 57707f0..7033b4f 100644
> >> >--- a/mm/slub.c
> >> >+++ b/mm/slub.c
> >> >@@ -1955,6 +1955,9 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
> >> > 	int pages;
> >> > 	int pobjects;
> >> >
> >> >+	if (!s->cpu_partial)
> >> >+		return;
> >> >+
> >> > 	do {
> >> > 		pages = 0;
> >> > 		pobjects = 0;
> >> >-- 
> >> >1.7.9.5
> >> >
> >> >--
> >> >To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >> >the body to majordomo@kvack.org.  For more info on Linux MM,
> >> >see: http://www.linux-mm.org/ .
> >> >Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> >> 
> >> --
> >> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >> the body to majordomo@kvack.org.  For more info on Linux MM,
> >> see: http://www.linux-mm.org/ .
> >> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
