Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3FNOWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 10:22:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490Ab3FNOWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 10:22:13 -0400
Date: Fri, 14 Jun 2013 16:22:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: lizefan@huawei.com, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, koverstreet@google.com,
        linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        Mike Snitzer <snitzer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mikulas Patocka <mpatocka@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/11] cgroup: use percpu refcnt for cgroup_subsys_states
Message-ID: <20130614142211.GG10084@dhcp22.suse.cz>
References: <1371096298-24402-1-git-send-email-tj@kernel.org>
 <1371096298-24402-12-git-send-email-tj@kernel.org>
 <20130614125539.GC10084@dhcp22.suse.cz>
 <20130614141510.GA19021@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130614141510.GA19021@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 14-06-13 18:15:12, Glauber Costa wrote:
> On Fri, Jun 14, 2013 at 02:55:39PM +0200, Michal Hocko wrote:
> > On Wed 12-06-13 21:04:58, Tejun Heo wrote:
> > [...]
> > > +/**
> > > + * cgroup_destroy_locked - the first stage of cgroup destruction
> > > + * @cgrp: cgroup to be destroyed
> > > + *
> > > + * css's make use of percpu refcnts whose killing latency shouldn't be
> > > + * exposed to userland and are RCU protected.  Also, cgroup core needs to
> > > + * guarantee that css_tryget() won't succeed by the time ->css_offline() is
> > > + * invoked.  To satisfy all the requirements, destruction is implemented in
> > > + * the following two steps.
> > > + *
> > > + * s1. Verify @cgrp can be destroyed and mark it dying.  Remove all
> > > + *     userland visible parts and start killing the percpu refcnts of
> > > + *     css's.  Set up so that the next stage will be kicked off once all
> > > + *     the percpu refcnts are confirmed to be killed.
> > > + *
> > > + * s2. Invoke ->css_offline(), mark the cgroup dead and proceed with the
> > > + *     rest of destruction.  Once all cgroup references are gone, the
> > > + *     cgroup is RCU-freed.
> > > + *
> > > + * This function implements s1.  After this step, @cgrp is gone as far as
> > > + * the userland is concerned and a new cgroup with the same name may be
> > > + * created.  As cgroup doesn't care about the names internally, this
> > > + * doesn't cause any problem.
> > 
> > Glauber is this asumption correct for kmem caches naming scheme?
> > I guess it should, but I would rather be sure this won't blow up later
> > specially when caches might live longer than css_offline.
> > 
> 
> We append names to caches, but never the name alone, always (kmemcg_id:name)
> So you can reuse the same name as many times as you want (from the kmemcg
> perspective), provided you use different kmemcg_ids. Because kmemcg_ids are
> dissociated from css_ids (partly because I was already seeing people talking
> about wanting to free the css_ids earlier), we should not have any problems
> with this.

Thanks for double checking, Glauber!

-- 
Michal Hocko
SUSE Labs
