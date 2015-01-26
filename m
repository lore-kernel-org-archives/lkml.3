Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbbAZR2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:28:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887AbbAZR2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:28:37 -0500
Date: Mon, 26 Jan 2015 18:28:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Christoph Lameter <cl@linux.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hannes@cmpxchg.org, vdavydov@parallels.com, mgorman@suse.de,
        minchan@kernel.org
Subject: Re: [PATCH v2] mm: vmscan: fix the page state calculation in
 too_many_isolated
Message-ID: <20150126172832.GC22681@dhcp22.suse.cz>
References: <1421235419-30736-1-git-send-email-vinmenon@codeaurora.org>
 <20150114165036.GI4706@dhcp22.suse.cz>
 <54B7F7C4.2070105@codeaurora.org>
 <20150116154922.GB4650@dhcp22.suse.cz>
 <54BA7D3A.40100@codeaurora.org>
 <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501171347290.25464@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 17-01-15 13:48:34, Christoph Lameter wrote:
> On Sat, 17 Jan 2015, Vinayak Menon wrote:
> 
> > which had not updated the vmstat_diff. This CPU was in idle for around 30
> > secs. When I looked at the tvec base for this CPU, the timer associated with
> > vmstat_update had its expiry time less than current jiffies. This timer had
> > its deferrable flag set, and was tied to the next non-deferrable timer in the
> 
> We can remove the deferrrable flag now since the vmstat threads are only
> activated as necessary with the recent changes. Looks like this could fix
> your issue?

OK, I have checked the history and the deferrable behavior has been
introduced by 39bf6270f524 (VM statistics: Make timer deferrable) which
hasn't offered any numbers which would justify the change. So I think it
would be a good idea to revert this one as it can clearly cause issues.

Could you retest with this change? It still wouldn't help with the
highly overloaded workqueues but that sounds like a bigger change and
this one sounds like quite safe to me so it is a good start.
---
>From 12d00a8066e336d3e1311600b50fa9b588798448 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 26 Jan 2015 18:07:51 +0100
Subject: [PATCH] vmstat: Do not use deferrable delayed work for vmstat_update

Vinayak Menon has reported that excessive number of tasks was throttled
in the direct reclaim inside too_many_isolated because NR_ISOLATED_FILE
was relatively high compared to NR_INACTIVE_FILE. However it turned out
that the real number of NR_ISOLATED_FILE was 0 and the per-cpu
vm_stat_diff wasn't transfered into the global counter.

vmstat_work which is responsible for the sync is defined as deferrable
delayed work which means that the defined timeout doesn't wake up an
idle CPU. A CPU might stay in an idle state for a long time and general
effort is to keep such a CPU in this state as long as possible which
might lead to all sorts of troubles for vmstat consumers as can be seen
with the excessive direct reclaim throttling.

This patch basically reverts 39bf6270f524 (VM statistics: Make timer
deferrable) but it shouldn't cause any problems for idle CPUs because
only CPUs with an active per-cpu drift are woken up since 7cc36bbddde5
(vmstat: on-demand vmstat workers v8) and CPUs which are idle for a
longer time shouldn't have per-cpu drift.

Fixes: 39bf6270f524 (VM statistics: Make timer deferrable)
Reported-and-debugged-by: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/vmstat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index c95d6b39ac91..b9b9deec1d54 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1453,7 +1453,7 @@ static void __init start_shepherd_timer(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu)
-		INIT_DEFERRABLE_WORK(per_cpu_ptr(&vmstat_work, cpu),
+		INIT_DELAYED_WORK(per_cpu_ptr(&vmstat_work, cpu),
 			vmstat_update);
 
 	if (!alloc_cpumask_var(&cpu_stat_off, GFP_KERNEL))
-- 
2.1.4
-- 
Michal Hocko
SUSE Labs
