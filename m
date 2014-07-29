Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaG2W5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:57:45 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:38049 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaG2W5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:57:44 -0400
Date: Tue, 29 Jul 2014 15:57:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] mm, compaction: khugepaged should not give up
 due to need_resched()
In-Reply-To: <53D76D30.3000106@suse.cz>
Message-ID: <alpine.DEB.2.02.1407291554550.20991@chino.kir.corp.google.com>
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-8-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281748110.8998@chino.kir.corp.google.com> <53D76D30.3000106@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Vlastimil Babka wrote:

> > > diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> > > index b2e4c92..60bdf8d 100644
> > > --- a/include/linux/compaction.h
> > > +++ b/include/linux/compaction.h
> > > @@ -13,6 +13,14 @@
> > >   /* The full zone was compacted */
> > >   #define COMPACT_COMPLETE	4
> > > 
> > > +/* Used to signal whether compaction detected need_sched() or lock
> > > contention */
> > > +/* No contention detected */
> > > +#define COMPACT_CONTENDED_NONE	0
> > > +/* Either need_sched() was true or fatal signal pending */
> > > +#define COMPACT_CONTENDED_SCHED	1
> > > +/* Zone lock or lru_lock was contended in async compaction */
> > > +#define COMPACT_CONTENDED_LOCK	2
> > > +
> > 
> > Make this an enum?
> 
> I tried originally, but then I would have to define it elsewhere
> (mm/internal.h I think) together with compact_control. I didn't think it was
> worth the extra pollution of shared header, when the return codes are also
> #define and we might still get rid of need_resched() one day.
> 

Ok.

[...]

> > > @@ -2660,15 +2660,36 @@ rebalance:
> > >   	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
> > >   		migration_mode = MIGRATE_SYNC_LIGHT;
> > > 
> > > -	/*
> > > -	 * If compaction is deferred for high-order allocations, it is because
> > > -	 * sync compaction recently failed. In this is the case and the caller
> > > -	 * requested a movable allocation that does not heavily disrupt the
> > > -	 * system then fail the allocation instead of entering direct reclaim.
> > > -	 */
> > > -	if ((deferred_compaction || contended_compaction) &&
> > > -						(gfp_mask & __GFP_NO_KSWAPD))
> > > -		goto nopage;
> > 
> > Hmm, this check will have unfortunately changed in the latest mmotm due to
> > mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch.
> 
> I think you were changing (and moving around) a different check so there would
> be merge conflicts but no semantic problem.
> 

The idea is the same, though, I think the check should not rely on 
__GFP_NO_KSWAPD and rather rely on 
(gfp_mask & GFP_TRANSHUGE) == GFP_TRANSHUGE.  In other words, all the 
possibilities under your new test for gfp_mask & __GFP_NO_KSWAPD are thp 
specific and not for the other allocators who pass __GFP_NO_KSWAPD.  This 
patch would be a significant change in logic for those users that doesn't 
seem helpful.
