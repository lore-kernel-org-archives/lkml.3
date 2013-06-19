Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab3FSIwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:52:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64569 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933755Ab3FSIwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:52:33 -0400
X-AuditID: 9c930197-b7beaae000004876-c2-51c1714f21b0
Date: Wed, 19 Jun 2013 17:52:50 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: do not put a slab to cpu partial list when
 cpu_partial is 0
Message-ID: <20130619085250.GC12231@lge.com>
References: <1371623635-26575-1-git-send-email-iamjoonsoo.kim@lge.com>
 <51c1652d.246e320a.4057.ffffed4fSMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51c1652d.246e320a.4057.ffffed4fSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 04:00:32PM +0800, Wanpeng Li wrote:
> On Wed, Jun 19, 2013 at 03:33:55PM +0900, Joonsoo Kim wrote:
> >In free path, we don't check number of cpu_partial, so one slab can
> >be linked in cpu partial list even if cpu_partial is 0. To prevent this,
> >we should check number of cpu_partial in put_cpu_partial().
> >
> 
> How about skip get_partial entirely? put_cpu_partial is called 
> in two paths, one is during refill cpu partial lists in alloc 
> slow path, the other is in free slow path. And cpu_partial is 0 
> just in debug mode. 
> 
> - alloc slow path, there is unnecessary to call get_partial 
>   since cpu partial lists won't be used in debug mode. 
> - free slow patch, new.inuse won't be true in debug mode 
>   which lead to put_cpu_partial won't be called.
> 

In debug mode, put_cpu_partial() can't be called already on both path.
But, if we assign 0 to cpu_partial via sysfs, put_cpu_partial() will be called
on free slow path. On alloc slow path, it can't be called, because following
test in get_partial_node() is always failed.

available > s->cpu_partial / 2

Thanks.

> Regards,
> Wanpeng Li 
> 
> >Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> >
> >diff --git a/mm/slub.c b/mm/slub.c
> >index 57707f0..7033b4f 100644
> >--- a/mm/slub.c
> >+++ b/mm/slub.c
> >@@ -1955,6 +1955,9 @@ static void put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
> > 	int pages;
> > 	int pobjects;
> >
> >+	if (!s->cpu_partial)
> >+		return;
> >+
> > 	do {
> > 		pages = 0;
> > 		pobjects = 0;
> >-- 
> >1.7.9.5
> >
> >--
> >To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >the body to majordomo@kvack.org.  For more info on Linux MM,
> >see: http://www.linux-mm.org/ .
> >Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
