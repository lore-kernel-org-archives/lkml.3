Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaE0TpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:45:11 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33391 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaE0TpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:45:08 -0400
Date: Tue, 27 May 2014 15:45:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] mm: memcontrol: remove ordering between
 pc->mem_cgroup and PageCgroupUsed
Message-ID: <20140527194500.GC2878@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-7-git-send-email-hannes@cmpxchg.org>
 <20140523132043.GB22135@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140523132043.GB22135@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 03:20:43PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:40, Johannes Weiner wrote:
> > There is a write barrier between setting pc->mem_cgroup and
> > PageCgroupUsed, which was added to allow LRU operations to lookup the
> > memcg LRU list of a page without acquiring the page_cgroup lock.  But
> > ever since 38c5d72f3ebe ("memcg: simplify LRU handling by new rule"),
> > pages are ensured to be off-LRU while charging, so nobody else is
> > changing LRU state while pc->mem_cgroup is being written.
> 
> This is quite confusing. Why do we have the lrucare path then?

Some charge paths start with the page on the LRU, lrucare makes sure
it's off during the charge.

> The code is quite tricky so this deserves a more detailed explanation
> IMO.
> 
> There are only 3 paths which check both the flag and mem_cgroup (
> without page_cgroup_lock) get_mctgt_type* and mem_cgroup_page_lruvec AFAICS.
> None of them have rmb so there was no guarantee about ordering anyway.

Yeah, exactly.  As per the changelog, this is a remnant of the way it
used to work but it's no longer needed because of guaranteed off-LRU
state.

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Anyway, the change is welcome
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks!
