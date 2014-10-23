Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaJWRxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:53:48 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:42780 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbaJWRxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:53:46 -0400
Date: Thu, 23 Oct 2014 13:53:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: fold
 mem_cgroup_start_move()/mem_cgroup_end_move()
Message-ID: <20141023175338.GA15937@phnom.home.cmpxchg.org>
References: <1414075327-15039-1-git-send-email-hannes@cmpxchg.org>
 <20141023155607.GN23011@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023155607.GN23011@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 05:56:07PM +0200, Michal Hocko wrote:
> On Thu 23-10-14 10:42:07, Johannes Weiner wrote:
> > Having these functions and their documentation split out and somewhere
> > makes it harder, not easier, to follow what's going on.
> > 
> > Inline them directly where charge moving is prepared and finished, and
> > put an explanation right next to it.
> 
> I do not see the open coded version much more readable or maintainable to be
> honest. mem_cgroup_{start,end}_move are a good markers of the transaction.

What transaction, though?  The names are really non-descript and they
actively hide what's going on.  mem_cgroup_start_move() could mean
anything that prepares for moving and it doesn't seem out of place in
can_attach().  atomic_inc(&memcg->moving_account) on the other hand is
much more specific and nicely shows that we are currently forcing the
page stat update slow path way too early.  There is no reason to make
it take the move_lock while we are still counting rss and precharging,
we are not actually moving charges and flipping pc->mem_cgroups yet.

[ I already have a patch to relocate it into mem_cgroup_move_charge(),
  but let's let the dust in -mm settle a bit first. :-) ]
