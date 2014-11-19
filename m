Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaKSKmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:42:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:12708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819AbaKSKlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:41:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="418550840"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/2] sched/deadline: fix pull if dl task who's prio changed is not on queue
Date: Wed, 19 Nov 2014 16:35:03 +0800
Message-Id: <1416386103-90800-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1416386103-90800-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dl task who is not on queue and it is also the curr task simultaneously 
can not happen. In addition, pull since the priority of a not on queue 
dl task doesn't make any sense.

This patch fix it by don't pull if dl task who's prio changed is not on 
queue.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index b9e44ae..4eaf55c 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1678,7 +1678,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 			    int oldprio)
 {
-	if (task_on_rq_queued(p) || rq->curr == p) {
+	if (!task_on_rq_queued(p))
+		return;
+
+	if (rq->curr == p) {
 #ifdef CONFIG_SMP
 		/*
 		 * This might be too much, but unfortunately
-- 
1.9.1

