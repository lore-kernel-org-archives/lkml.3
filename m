Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaEGV2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:28:42 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53726 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaEGV2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:28:41 -0400
Date: Wed, 7 May 2014 14:28:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v3 6/6] mm, compaction: terminate async compaction when
 rescheduling
In-Reply-To: <20140507142033.1ec148fe35059121db547f25@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1405071421580.8454@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com>
 <20140507142033.1ec148fe35059121db547f25@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014, Andrew Morton wrote:

> > --- a/mm/compaction.c
> > +++ b/mm/compaction.c
> > @@ -500,8 +500,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
> >  			return 0;
> >  	}
> >  
> > +	if (cond_resched()) {
> > +		/* Async terminates prematurely on need_resched() */
> > +		if (cc->mode == MIGRATE_ASYNC)
> > +			return 0;
> > +	}
> 
> Comment comments the obvious.  What is less obvious is *why* we do this.
> 

Async compaction is most prevalent for thp pagefaults and without 
zone->lru_lock contention we have no other termination criteria.  Without 
this, we would scan a potentially very long zone (zones 64GB in length in 
my testing) and it would be very expensive for pagefault.  Async is best 
effort, so if it is becoming too expensive then it's better to just 
fallback to PAGE_SIZE pages instead and rely on khugepaged to collapse 
later.

> Someone please remind my why sync and async compaction use different
> scanning cursors?
> 

It's introduced in this patchset.  Async compaction does not consider 
pageblocks unless it is MIGRATE_MOVABLE since it is best effort, sync 
compaction considers all pageblocks.  In the past, we only updated the 
cursor for sync compaction since it would be wrong to update it for async 
compaction if it can skip certain pageblocks.  Unfortunately, if async 
compaction is relied upon solely for certain allocations (such as thp 
pagefaults), it is possible to scan an enormous amount of a 64GB zone, for 
example, pointlessly every time if none of the memory can be isolated.

The result is that sync compaction always updates both scanners and async 
compaction only updates its own scanner.  Either scanner is only updated 
if the new cursor is "beyond" the previous cursor.  ("Beyond" is _after_ 
the previous migration scanner pfn and _before_ the previous free scanner 
pfn.)
