Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaFSMhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:37:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaFSMhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:37:11 -0400
Date: Thu, 19 Jun 2014 05:35:53 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-a43455a1d572daf7b730fe12eb747d1e17411365@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140604160942.6969b101@cuia.bos.redhat.com>
References: <20140604160942.6969b101@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Ensure task_numa_migrate()
  checks the preferred node
Git-Commit-ID: a43455a1d572daf7b730fe12eb747d1e17411365
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a43455a1d572daf7b730fe12eb747d1e17411365
Gitweb:     http://git.kernel.org/tip/a43455a1d572daf7b730fe12eb747d1e17411365
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 4 Jun 2014 16:09:42 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:29:57 +0200

sched/numa: Ensure task_numa_migrate() checks the preferred node

The first thing task_numa_migrate() does is check to see if there is
CPU capacity available on the preferred node, in order to move the
task there.

However, if the preferred node is all busy, we would skip considering
that node for tasks swaps in the subsequent loop. This prevents NUMA
convergence of tasks on busy systems.

However, swapping locations with a task on our preferred nid, when
the preferred nid is busy, is perfectly fine.

The fix is to also look for a CPU on our preferred nid when it is
totally busy.

This changes "perf bench numa mem -p 4 -t 20 -m -0 -P 1000" from
not converging in 15 minutes on my 4 node system, to converging in
10-20 seconds.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140604160942.6969b101@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..8fbb011 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1302,9 +1302,8 @@ static int task_numa_migrate(struct task_struct *p)
 	groupimp = group_weight(p, env.dst_nid) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* If the preferred nid has free capacity, try to use it. */
-	if (env.dst_stats.has_free_capacity)
-		task_numa_find_cpu(&env, taskimp, groupimp);
+	/* Try to find a spot on the preferred nid. */
+	task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
 	if (env.best_cpu == -1) {
