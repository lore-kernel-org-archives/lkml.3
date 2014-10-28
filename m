Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbaJ1LGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:06:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777AbaJ1LGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:06:25 -0400
Date: Tue, 28 Oct 2014 04:05:29 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-9de05d48711cd5314920ed05f873d84eaf66ccf1@git.kernel.org>
Cc: torvalds@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, riel@redhat.com,
        chegu_vinod@hp.com, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        chegu_vinod@hp.com, torvalds@linux-foundation.org, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20141009172747.0d97c38c@annuminas.surriel.com>
References: <20141009172747.0d97c38c@annuminas.surriel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Check all nodes when placing a pseudo-interleaved group
Git-Commit-ID: 9de05d48711cd5314920ed05f873d84eaf66ccf1
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

Commit-ID:  9de05d48711cd5314920ed05f873d84eaf66ccf1
Gitweb:     http://git.kernel.org/tip/9de05d48711cd5314920ed05f873d84eaf66ccf1
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Thu, 9 Oct 2014 17:27:47 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:52 +0100

sched/numa: Check all nodes when placing a pseudo-interleaved group

In pseudo-interleaved numa_groups, all tasks try to relocate to
the group's preferred_nid.  When a group is spread across multiple
NUMA nodes, this can lead to tasks swapping their location with
other tasks inside the same group, instead of swapping location with
tasks from other NUMA groups. This can keep NUMA groups from converging.

Examining all nodes, when dealing with a task in a pseudo-interleaved
NUMA group, avoids this problem. Note that only CPUs in nodes that
improve the task or group score are examined, so the loop isn't too
bad.

Tested-by: Vinod Chegu <chegu_vinod@hp.com>
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Vinod Chegu" <chegu_vinod@hp.com>
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141009172747.0d97c38c@annuminas.surriel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7760c2a..ec32c26d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1436,8 +1436,15 @@ static int task_numa_migrate(struct task_struct *p)
 	/* Try to find a spot on the preferred nid. */
 	task_numa_find_cpu(&env, taskimp, groupimp);
 
-	/* No space available on the preferred nid. Look elsewhere. */
-	if (env.best_cpu == -1) {
+	/*
+	 * Look at other nodes in these cases:
+	 * - there is no space available on the preferred_nid
+	 * - the task is part of a numa_group that is interleaved across
+	 *   multiple NUMA nodes; in order to better consolidate the group,
+	 *   we need to check other locations.
+	 */
+	if (env.best_cpu == -1 || (p->numa_group &&
+			nodes_weight(p->numa_group->active_nodes) > 1)) {
 		for_each_online_node(nid) {
 			if (nid == env.src_nid || nid == p->numa_preferred_nid)
 				continue;
