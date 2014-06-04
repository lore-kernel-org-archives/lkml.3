Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaFDUdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:33:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbaFDUde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:33:34 -0400
Date: Wed, 4 Jun 2014 16:33:15 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mgorman@suse.de, mingo@kernel.org
Subject: [PATCH] sched,numa: always try to migrate to preferred node at
 task_numa_placement time
Message-ID: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
Organization: Red Hat, Inc
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that at task_numa_placement time, the task's
numa_preferred_nid does not change, but the task is not
actually running on the preferred node at the time.

In that case, we still want to attempt migration to the
preferred node.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fdb96d..708c6a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1575,11 +1575,13 @@ static void task_numa_placement(struct task_struct *p)
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
 
