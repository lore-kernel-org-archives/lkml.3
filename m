Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaJWOOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:14:54 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42736 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932157AbaJWOOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:14:50 -0400
Date: Thu, 23 Oct 2014 10:14:43 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcontrol: fix missed end-writeback page
 accounting
Message-ID: <20141023141443.GA20526@phnom.home.cmpxchg.org>
References: <1414002568-21042-1-git-send-email-hannes@cmpxchg.org>
 <1414002568-21042-3-git-send-email-hannes@cmpxchg.org>
 <20141023130331.GC23011@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023130331.GC23011@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:03:31PM +0200, Michal Hocko wrote:
> On Wed 22-10-14 14:29:28, Johannes Weiner wrote:
> > 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") changed page
> > migration to uncharge the old page right away.  The page is locked,
> > unmapped, truncated, and off the LRU, but it could race with writeback
> > ending, which then doesn't unaccount the page properly:
> > 
> > test_clear_page_writeback()              migration
> >   acquire pc->mem_cgroup->move_lock
> 
> I do not think that mentioning move_lock is important/helpful here
> because the hot path which is taken all the time (except when there is a
> task move in progress) doesn't take it.
> Besides that it is not even relevant for the race.

You're right.  It's not worth mentioning the transaction setup/finish
at all, because migration does not participate in that protocol.  How
about this?  Andrew, could you please copy-paste this into the patch?

test_clear_page_writeback()              migration
                                           wait_on_page_writeback()
  TestClearPageWriteback()
                                           mem_cgroup_migrate()
                                             clear PCG_USED
  mem_cgroup_update_page_stat()
    if (PageCgroupUsed(pc))
      decrease memcg pages under writeback
