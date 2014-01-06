Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaAFLjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 06:39:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbaAFLjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 06:39:16 -0500
Date: Mon, 6 Jan 2014 11:39:12 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Calculate effective load even if local weight is 0
Message-ID: <20140106113912.GC6178@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Rik, you authored this patch so it should be sent from you and needs a
signed-off assuming people are ok with the changelog.)

Thomas Hellstrom bisected a regression where erratic 3D performance is
experienced on virtual machines as measured by glxgears. It identified
commit 58d081b5 (sched/numa: Avoid overloading CPUs on a preferred NUMA
node) as the problem which had modified the behaviour of effective_load.

Effective load calculates the difference to the system-wide load if a
scheduling entity was moved to another CPU. The task group is not heavier
as a result of the move but overall system load can increase/decrease as a
result of the change. Commit 58d081b5 (sched/numa: Avoid overloading CPUs
on a preferred NUMA node) changed effective_load to make it suitable for
calculating if a particular NUMA node was compute overloaded. To reduce
the cost of the function, it assumed that a current sched entity weight
of 0 was uninteresting but that is not the case.

wake_affine uses a weight of 0 for sync wakeups on the grounds that it
is assuming the waking task will sleep and not contribute to load in the
near future. In this case, we still want to calculate the effective load
of the sched entity hierarchy. As effective_load is no longer used by
task_numa_compare since commit fb13c7ee (sched/numa: Use a system-wide
search to find swap/migration candidates), this patch simply restores the
historical behaviour.

[mgorman@suse.de: Wrote changelog]
Reported-and-tested-by: Thomas Hellstrom <thellstrom@vmware.com>
Should-be-signed-off-and-authored-by-Rik
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..e64b079 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3923,7 +3923,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
 
-	if (!tg->parent || !wl)	/* the trivial, non-cgroup case */
+	if (!tg->parent)	/* the trivial, non-cgroup case */
 		return wl;
 
 	for_each_sched_entity(se) {
