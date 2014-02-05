Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBEP2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:28:36 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:57682 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbaBEP2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:28:34 -0500
Date: Wed, 5 Feb 2014 10:28:21 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 4/6] memcg: make sure that memcg is not offline when
 charging
Message-ID: <20140205152821.GY6963@cmpxchg.org>
References: <1391520540-17436-1-git-send-email-mhocko@suse.cz>
 <1391520540-17436-5-git-send-email-mhocko@suse.cz>
 <20140204162939.GP6963@cmpxchg.org>
 <20140205133834.GB2425@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140205133834.GB2425@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 02:38:34PM +0100, Michal Hocko wrote:
> On Tue 04-02-14 11:29:39, Johannes Weiner wrote:
> [...]
> > Maybe we should remove the XXX if it makes you think we should change
> > the current situation by any means necessary.  This patch is not an
> > improvement.
> >
> > I put the XXX there so that we one day maybe refactor the code in a
> > clean fashion where try_get_mem_cgroup_from_whatever() is in the same
> > rcu section as the first charge attempt.  On failure, reclaim, and do
> > the lookup again.
> 
> I wouldn't be opposed to such a cleanup. It is not that simple, though.
>
> > Also, this problem only exists on swapin, where the memcg is looked up
> > from an auxilliary data structure and not the current task, so maybe
> > that would be an angle to look for a clean solution.
> 
> I am not so sure about that. Task could have been moved to a different
> group basically anytime it was outside of rcu_read_lock section (which
> means most of the time). And so the group might get removed and we are
> in the very same situation.
> 
> > Either way, the problem is currently fixed 
> 
> OK, my understanding (and my ack was based on that) was that we needed
> a simple and safe fix for the stable trees and we would have something
> more appropriate later on. Preventing from the race sounds like a more
> appropriate and a better technical solution to me. So I would rather ask
> why to keep a workaround in place. Does it add any risk?
> Especially when we basically abuse the 2 stage cgroup removal. All the
> charges should be cleared out after css_offline.

I thought more about this and talked to Tejun as well.  He told me
that the rcu grace period between disabling tryget and calling
css_offline() is currently an implementation detail of the refcounter
that css uses, but it's not a guarantee.  So my initial idea of
reworking memcg to do css_tryget() and res_counter_charge() in the
same rcu section is no longer enough to synchronize against offlining.
We can forget about that.

On the other hand, memcg holds a css reference only while an actual
controller reference is being established (res_counter_charge), then
drops it.  This means that once css_tryget() is disabled, we only need
to wait for the css refcounter to hit 0 to know for sure that no new
charges can show up and reparent_charges() is safe to run, right?

Well, css_free() is the callback invoked when the ref counter hits 0,
and that is a guarantee.  From a memcg perspective, it's the right
place to do reparenting, not css_offline().

Here is the only exception to the above: swapout records maintain
permanent css references, so they prevent css_free() from running.
For that reason alone we should run one optimistic reparenting in
css_offline() to make sure one swap record does not pin gigabytes of
pages in an offlined cgroup, which is unreachable for reclaim.  But
the reparenting for *correctness* is in css_free(), not css_offline().

We should be changing the comments.  The code is already correct.

> > Unless the alternative solution is inherent in a clean rework of the
> > code to match cgroup core lifetime management, I don't see any reason
> > to move away from the status quo.
> 
> To be honest this sounds like a weak reasoning to refuse a real fix
> which replaces a workaround.
> 
> This is a second attempt to fix the actual race that you are dismissing
> which is really surprising to me. Especially when the workaround is an
> ugly hack.

IMO it was always functionally correct, just something that could have
been done cleaner from a design POV.  That's why I refused every
alternative solution that made the code worse instead of better.

But looks like it also makes perfect sense from a design POV, so
it's all moot now.
