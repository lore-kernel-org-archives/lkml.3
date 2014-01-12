Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaALSm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:42:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaALSmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:42:54 -0500
Date: Sun, 12 Jan 2014 10:42:17 -0800
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-9722c2dac708e9468cc0dc30218ef76946ffbc9d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, thellstrom@vmware.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, thellstrom@vmware.com, riel@redhat.com,
        mgorman@suse.de, tglx@linutronix.de
In-Reply-To: <20140106113912.GC6178@suse.de>
References: <20140106113912.GC6178@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Calculate effective load even if local weight is 0
Git-Commit-ID: 9722c2dac708e9468cc0dc30218ef76946ffbc9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:42:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9722c2dac708e9468cc0dc30218ef76946ffbc9d
Gitweb:     http://git.kernel.org/tip/9722c2dac708e9468cc0dc30218ef76946ffbc9d
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 6 Jan 2014 11:39:12 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 09:22:15 +0100

sched: Calculate effective load even if local weight is 0

Thomas Hellstrom bisected a regression where erratic 3D performance is
experienced on virtual machines as measured by glxgears. It identified
commit 58d081b5 ("sched/numa: Avoid overloading CPUs on a preferred NUMA
node") as the problem which had modified the behaviour of effective_load.

Effective load calculates the difference to the system-wide load if a
scheduling entity was moved to another CPU. The task group is not heavier
as a result of the move but overall system load can increase/decrease as a
result of the change. Commit 58d081b5 ("sched/numa: Avoid overloading CPUs
on a preferred NUMA node") changed effective_load to make it suitable for
calculating if a particular NUMA node was compute overloaded. To reduce
the cost of the function, it assumed that a current sched entity weight
of 0 was uninteresting but that is not the case.

wake_affine() uses a weight of 0 for sync wakeups on the grounds that it
is assuming the waking task will sleep and not contribute to load in the
near future. In this case, we still want to calculate the effective load
of the sched entity hierarchy. As effective_load is no longer used by
task_numa_compare since commit fb13c7ee (sched/numa: Use a system-wide
search to find swap/migration candidates), this patch simply restores the
historical behaviour.

Reported-and-tested-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
[ Wrote changelog]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140106113912.GC6178@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
