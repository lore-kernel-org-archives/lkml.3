Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3LPRTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:19:55 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:65517 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab3LPRTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:19:53 -0500
Date: Mon, 16 Dec 2013 12:19:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131216171941.GI32509@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216164154.GX21724@cmpxchg.org>
 <20131216171527.GF26797@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216171527.GF26797@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal, Johannes.

On Mon, Dec 16, 2013 at 06:15:27PM +0100, Michal Hocko wrote:
> > We already do that, swap records hold a css reference.  We do the put
> > in mem_cgroup_uncharge_swap().
> 
> Dohh! You are right I have totally missed that the css_get is burried in
> __mem_cgroup_uncharge_common and the counterpart is in mem_cgroup_uncharge_swap
> (which is less unexpected).
> 
> > It really strikes me as odd that we recycle the cgroup ID while there
> > are still references to the cgroup in circulation.
> 
> That is true but even with this fixed I still think that the Hugh's
> approach makes a lot of sense.

I thought about this a bit and I think the id really should be per
subsystem - ie. like css_id but just a dumb id as cgrp->id.  The
reason is that cgroup's lifetime and css's lifetime will soon be
decoupled.  ie. if a css is disabled and re-enabled on the same
cgroup, there can be two css's associated with a single cgroup.
cgroup_css() and css iterators should block accesses to css's which
are being drained but it does make sense for id lookup to work until
the css is actually released.

That said, for now, whatever works is fine and if Hugh's suggested
change is desirable anyway, that should do for now.

Thanks.

-- 
tejun
