Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161467AbaJ3Wj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 18:39:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:46204 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161449AbaJ3Wjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 18:39:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,289,1413270000"; 
   d="scan'208";a="623777836"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3 5/6] sched/deadline: reschedule from switched_from_dl() after a successful pull
Date: Fri, 31 Oct 2014 06:39:35 +0800
Message-Id: <1414708776-124078-5-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In switched_from_dl() we have to issue a resched if we successfully 
pulled some task from other cpus. This patch also aligns the behavior 
with -rt.

Suggested-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * align the behaviour with -rt.

 kernel/sched/deadline.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 1c09751..2b23d50 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1623,8 +1623,11 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * this is the right place to try to pull some other one
 	 * from an overloaded cpu, if any.
 	 */
-	if (!rq->dl.dl_nr_running)
-		pull_dl_task(rq);
+	if (!task_on_rq_queued(p) || rq->dl.dl_nr_running)
+		return;
+
+	if (pull_dl_task(rq))
+		resched_curr(rq);
 #endif
 }
 
-- 
1.9.1

