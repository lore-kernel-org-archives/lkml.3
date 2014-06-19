Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaFSMhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:37:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57508 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbaFSMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:37:17 -0400
Date: Thu, 19 Jun 2014 05:36:09 -0700
From: tip-bot for Rik van Riel <tipbot@zytor.com>
Message-ID: <tip-bb97fc31647539f1f102eed646a95e200160a150@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
References: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Always try to migrate to preferred node at task_numa_placement() time
Git-Commit-ID: bb97fc31647539f1f102eed646a95e200160a150
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

Commit-ID:  bb97fc31647539f1f102eed646a95e200160a150
Gitweb:     http://git.kernel.org/tip/bb97fc31647539f1f102eed646a95e200160a150
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 4 Jun 2014 16:33:15 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:29:58 +0200

sched/numa: Always try to migrate to preferred node at task_numa_placement() time

It is possible that at task_numa_placement() time, the task's
numa_preferred_nid does not change, but the task is not
actually running on the preferred node at the time.

In that case, we still want to attempt migration to the
preferred node.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mgorman@suse.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140604163315.1dbc7b56@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8fbb011..3fa3e18 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1613,11 +1613,13 @@ static void task_numa_placement(struct task_struct *p)
 		spin_unlock_irq(group_lock);
 	}
 
-	/* Preferred node as the node with the most faults */
-	if (max_faults && max_nid != p->numa_preferred_nid) {
-		/* Update the preferred nid and migrate task if possible */
-		sched_setnuma(p, max_nid);
-		numa_migrate_preferred(p);
+	if (max_faults) {
+		/* Set the new preferred node */
+		if (max_nid != p->numa_preferred_nid)
+			sched_setnuma(p, max_nid);
+
+		if (task_node(p) != p->numa_preferred_nid)
+			numa_migrate_preferred(p);
 	}
 }
 
