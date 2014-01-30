Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaA3R3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:29:13 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:54943 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330AbaA3R3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:29:11 -0500
Date: Thu, 30 Jan 2014 12:29:06 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC 4/5] memcg: make sure that memcg is not offline when
 charging
Message-ID: <20140130172906.GE6963@cmpxchg.org>
References: <1387295130-19771-1-git-send-email-mhocko@suse.cz>
 <1387295130-19771-5-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387295130-19771-5-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:45:29PM +0100, Michal Hocko wrote:
> The current charge path might race with memcg offlining because holding
> css reference doesn't stop css offline. As a result res counter might be
> charged after mem_cgroup_reparent_charges (called from memcg css_offline
> callback) and so the charge would never be freed. This has been worked
> around by 96f1c58d8534 (mm: memcg: fix race condition between memcg
> teardown and swapin) which tries to catch such a leaked charges later
> during css_free. It is more optimal to heal this race in the long term
> though.

We already deal with the race, so IMO the only outstanding improvement
is to take advantage of the teardown synchronization provided by the
cgroup core and get rid of our one-liner workaround in .css_free.

> In order to make this raceless we would need to hold rcu_read_lock since
> css_tryget until res_counter_charge. This is not so easy unfortunately
> because mem_cgroup_do_charge might sleep so we would need to do drop rcu
> lock and do css_tryget tricks after each reclaim.

Yes, why not?

> This patch addresses the issue by introducing memcg->offline flag
> which is set from mem_cgroup_css_offline callback before the pages are
> reparented. mem_cgroup_do_charge checks the flag before res_counter
> is charged inside rcu read section. mem_cgroup_css_offline uses
> synchronize_rcu to let all preceding chargers finish while all the new
> ones will see the group offline already and back out.
>
> Callers are then updated to retry with a new memcg which is fallback to
> mem_cgroup_from_task(current).
> 
> The only exception is mem_cgroup_do_precharge which should never see
> this race because it is called from cgroup {can_}attach callbacks and so
> the whole cgroup cannot go away.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 55 insertions(+), 3 deletions(-)

That makes no sense to me.  It's a lateral move in functionality and
cgroup integration, but more complicated.
