Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760747AbaGEKpY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:45:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaGEKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:45:20 -0400
Date: Sat, 5 Jul 2014 03:44:25 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-f0b8a4afd6a8c500161e45065a91738b490bf5ae@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1403538095-31256-2-git-send-email-riel@redhat.com>
References: <1403538095-31256-2-git-send-email-riel@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Use group's max nid as task'
 s preferred nid
Git-Commit-ID: f0b8a4afd6a8c500161e45065a91738b490bf5ae
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

Commit-ID:  f0b8a4afd6a8c500161e45065a91738b490bf5ae
Gitweb:     http://git.kernel.org/tip/f0b8a4afd6a8c500161e45065a91738b490bf5ae
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Mon, 23 Jun 2014 11:41:29 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:17:33 +0200

sched/numa: Use group's max nid as task's preferred nid

>From task_numa_placement, always try to consolidate the tasks
in a group on the group's top nid.

In case this task is part of a group that is interleaved over
multiple nodes, task_numa_migrate will set the task's preferred
nid to the best node it could find for the task, so this patch
will cause at most one run through task_numa_migrate.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: mgorman@suse.de
Cc: chegu_vinod@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538095-31256-2-git-send-email-riel@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e3ff3d1..96b2d39 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1594,23 +1594,8 @@ static void task_numa_placement(struct task_struct *p)
 
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
-		/*
-		 * If the preferred task and group nids are different,
-		 * iterate over the nodes again to find the best place.
-		 */
-		if (max_nid != max_group_nid) {
-			unsigned long weight, max_weight = 0;
-
-			for_each_online_node(nid) {
-				weight = task_weight(p, nid) + group_weight(p, nid);
-				if (weight > max_weight) {
-					max_weight = weight;
-					max_nid = nid;
-				}
-			}
-		}
-
 		spin_unlock_irq(group_lock);
+		max_nid = max_group_nid;
 	}
 
 	if (max_faults) {
