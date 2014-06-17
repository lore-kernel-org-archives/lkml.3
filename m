Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaFQPag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:30:36 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:37045 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932869AbaFQPae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:30:34 -0400
Date: Tue, 17 Jun 2014 11:30:18 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 03/12] mm: huge_memory: use GFP_TRANSHUGE when charging
 huge pages
Message-ID: <20140617153018.GA7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-4-git-send-email-hannes@cmpxchg.org>
 <20140617134745.GB19886@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140617134745.GB19886@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 03:47:45PM +0200, Michal Hocko wrote:
> On Mon 16-06-14 15:54:23, Johannes Weiner wrote:
> > Transparent huge page charges prefer falling back to regular pages
> > rather than spending a lot of time in direct reclaim.
> > 
> > Desired reclaim behavior is usually declared in the gfp mask, but THP
> > charges use GFP_KERNEL and then rely on the fact that OOM is disabled
> > for THP charges, and that OOM-disabled charges currently skip reclaim.
> 
> OOM-disabled charges do one round of reclaim currently.

Oops, fixed in v4.

> > Needless to say, this is anything but obvious and quite error prone.
> > 
> > Convert THP charges to use GFP_TRANSHUGE instead, which implies
> > __GFP_NORETRY, to indicate the low-latency requirement.
> 
> OK, this makes sense. It would be ideal if we could use the same gfp as
> for allocation but that would be too much churn I guess because some
> allocator use a allocation helper which deduces proper gfp flags without
> giving them back to the caller.
> 
> Nevertheless, I would still prefer if 05/12 was moved before
> this patch because this is strictly speaking a behavior change.

Yes, that's bungled up, thanks for catching that.  So here is the
order I put it in (reverse git history order of course):

commit d0d31c8d4f4cf91edcffa704e8c65ca62af24cf8
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Mon Apr 14 08:16:09 2014 -0400

    mm: memcontrol: retry reclaim for oom-disabled and __GFP_NOFAIL charges
    
    There is no reason why oom-disabled and __GFP_NOFAIL charges should
    try to reclaim only once when every other charge tries several times
    before giving up.  Make them all retry the same number of times.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

commit 69f5c6c1a6553a04d7701012a73b2477df8d5a19
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu Jun 5 22:02:26 2014 -0400

    mm: huge_memory: use GFP_TRANSHUGE when charging huge pages
    
    Transparent huge page charges prefer falling back to regular pages
    rather than spending a lot of time in direct reclaim.
    
    Desired reclaim behavior is usually declared in the gfp mask, but THP
    charges use GFP_KERNEL and then rely on the fact that OOM is disabled
    for THP charges, and that OOM-disabled charges don't retry reclaim.
    Needless to say, this is anything but obvious and quite error prone.
    
    Convert THP charges to use GFP_TRANSHUGE instead, which implies
    __GFP_NORETRY, to indicate the low-latency requirement.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by: Michal Hocko <mhocko@suse.cz>

commit d485e6b4ed62885d54c57c18c5427e2f174c9012
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Tue May 27 15:23:18 2014 -0400

    mm: memcontrol: reclaim at least once for __GFP_NORETRY
    
    Currently, __GFP_NORETRY tries charging once and gives up before even
    trying to reclaim.  Bring the behavior on par with the page allocator
    and reclaim at least once before giving up.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Acked-by: Michal Hocko <mhocko@suse.cz>

This first changes __GFP_NORETRY to provide THP-required semantics,
then switches THP over to it, then fixes oom-disabled/NOFAIL charges.

Does that make more sense?

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!
