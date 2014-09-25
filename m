Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIYKBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 06:01:36 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51894 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaIYKBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 06:01:34 -0400
Date: Thu, 25 Sep 2014 12:01:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm: memcontrol: convert reclaim iterator to simple
 css refcounting
Message-ID: <20140925100130.GC12090@dhcp22.suse.cz>
References: <1411161059-16552-1-git-send-email-hannes@cmpxchg.org>
 <20140919212843.GA23861@cmpxchg.org>
 <20140924164739.GA15897@dhcp22.suse.cz>
 <20140924171653.GA10082@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924171653.GA10082@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 24-09-14 13:16:53, Johannes Weiner wrote:
> On Wed, Sep 24, 2014 at 06:47:39PM +0200, Michal Hocko wrote:
> > On Fri 19-09-14 17:28:43, Johannes Weiner wrote:
[...]
> > > -		memcg = __mem_cgroup_iter_next(root, last_visited);
> > > +		do {
> > > +			pos = ACCESS_ONCE(mz->reclaim_iter[priority]);
> > > +		} while (pos && !css_tryget(&pos->css));
> > 
> > This is a bit confusing. AFAIU css_tryget fails only when the current
> > ref count is zero already. When do we keep cached memcg with zero count
> > behind? We always do css_get after cmpxchg.
> > 
> > Hmm, there is a small window between cmpxchg and css_get when we store
> > the current memcg into the reclaim_iter[priority]. If the current memcg
> > is root then we do not take any css reference before cmpxchg and so it
> > might drop down to zero in the mean time so other CPU might see zero I
> > guess. But I do not see how css_get after cmpxchg on such css works.
> > I guess I should go and check the css reference counting again.
> 
> It's not about root or the newly stored memcg, it's that you might
> read the position right before it's replaced and css_put(), at which

OK, got it

	CPU0					CPU1
pos = reclaim_iter[priority]
					cmpxchg(reclaim_iter[priority], pos, memcg)
					css_put(pos)	# -> 0
css_tryget(pos)

Thanks!
-- 
Michal Hocko
SUSE Labs
