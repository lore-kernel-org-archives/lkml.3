Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaBMVHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:07:22 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51127 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbaBMVHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:07:13 -0500
Date: Thu, 13 Feb 2014 16:07:09 -0500
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] memcg: barriers to see memcgs as fully initialized
Message-ID: <20140213210709.GE17608@htj.dyndns.org>
References: <alpine.LSU.2.11.1402121717420.5917@eggly.anvils>
 <alpine.LSU.2.11.1402121727050.5917@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1402121727050.5917@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hugh.

On Wed, Feb 12, 2014 at 05:29:09PM -0800, Hugh Dickins wrote:
> Commit d8ad30559715 ("mm/memcg: iteration skip memcgs not yet fully
> initialized") is not bad, but Greg Thelen asks "Are barriers needed?"
> 
> Yes, I'm afraid so: this makes it a little heavier than the original,
> but there's no point in guaranteeing that mem_cgroup_iter() returns only
> fully initialized memcgs, if we don't guarantee that the initialization
> is visible.
> 
> If we move online_css()'s setting CSS_ONLINE after rcu_assign_pointer()
> (I don't see why not), we can reasonably rely on the smp_wmb() in that.
> But I can't find a pre-existing barrier at the mem_cgroup_iter() end,
> so add an smp_rmb() where __mem_cgroup_iter_next() returns non-NULL.

Hmmm.... so, CSS_ONLINE was never meant to be used outside cgroup
proper.  The only guarantee that the css iterators make is that a css
which has finished its ->css_online() will be included in the
iteration, which implies that css's which haven't finished
->css_online() or already went past ->css_offline() may be included in
the iteration.  In fact, it's impossible to achieve the guarantee
without such implications if we want to avoid synchronizing everything
using common locking, which we apparently can't do across different
controllers.

The expectation is that if a controller needs to distinguish fully
online css's, it will perform its own synchronization among its
online, offline and iterations, which can usually be achieved through
per-css synchronization. There is asymmetry here due to the way
css_tryget() behaves.  Unfortuantely, I don't think it can be expanded
to become symmetrical for online testing without adding, say,
->css_post_online() callback.

So, the only thing that memcg can depend on while iterating is that it
will include all css's which finished ->css_online() and if memcg
wants to filter out the ones which haven't yet, it should do its own
marking in ->css_online() rather than depending on what cgroup core
does with the flags.  That way, locking rules are a lot more evident
in each subsystem and we don't end up depending on cgroup internal
details which aren't immediately obvious.

Thanks.

-- 
tejun
