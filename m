Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaCFXEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:04:15 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:33657 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbaCFXEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:04:14 -0500
Date: Thu, 6 Mar 2014 18:04:04 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@kernel.org, riel@redhat.com, mgorman@suse.de, jstancek@redhat.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [merged]
 mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch removed from -mm
 tree
Message-ID: <20140306230404.GY6963@cmpxchg.org>
References: <5318dca5.AwhU/92X21JgbpdE%akpm@linux-foundation.org>
 <20140306214927.GB11171@cmpxchg.org>
 <20140306135635.6999d703429afb7fd3949304@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306135635.6999d703429afb7fd3949304@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 01:56:35PM -0800, Andrew Morton wrote:
> On Thu, 6 Mar 2014 16:49:27 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Thu, Mar 06, 2014 at 12:37:57PM -0800, akpm@linux-foundation.org wrote:
> > > Subject: [merged] mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch removed from -mm tree
> > > To: hannes@cmpxchg.org,jstancek@redhat.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org,mm-commits@vger.kernel.org
> > > From: akpm@linux-foundation.org
> > > Date: Thu, 06 Mar 2014 12:37:57 -0800
> > > 
> > > 
> > > The patch titled
> > >      Subject: mm: page_alloc: exempt GFP_THISNODE allocations from zone fairness
> > > has been removed from the -mm tree.  Its filename was
> > >      mm-page_alloc-reset-aging-cycle-with-gfp_thisnode-v2.patch
> > > 
> > > This patch was dropped because it was merged into mainline or a subsystem tree
> > 
> > Would it make sense to also merge
> > 
> > mm-fix-gfp_thisnode-callers-and-clarify.patch
> > 
> > at this point?  It's not as critical as the GFP_THISNODE exemption,
> > which is why I didn't tag it for stable, but it's a bugfix as well.
> 
> Changelog fail!
> 
> : GFP_THISNODE is for callers that implement their own clever fallback to
> : remote nodes, and so no direct reclaim is invoked.  There are many current
> : users that only want node exclusiveness but still want reclaim to make the
> : allocation happen.  Convert them over to __GFP_THISNODE and update the
> : documentation to clarify GFP_THISNODE semantics.
> 
> what bug does it fix and what are the user-visible effects??

Ok, maybe this is better?

---

GFP_THISNODE is for callers that implement their own clever fallback
to remote nodes.  It restricts the allocation to the specified node
and does not invoke reclaim, assuming that the caller will take care
of it when the fallback fails, e.g. through a subsequent allocation
request without GFP_THISNODE set.

However, many current GFP_THISNODE users only want the node exclusive
aspect of the flag, without actually implementing their own fallback
or triggering reclaim if necessary.  This results in things like page
migration failing prematurely even when there is easily reclaimable
memory available, unless kswapd happens to be running already or a
concurrent allocation attempt triggers the necessary reclaim.

Convert all callsites that don't implement their own fallback strategy
to __GFP_THISNODE.  This restricts the allocation a single node too,
but at the same time allows the allocator to enter the slowpath, wake
kswapd, and invoke direct reclaim if necessary, to make the allocation
happen when memory is full.
