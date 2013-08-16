Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab3HQAV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:21:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51586 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3HPWjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 113/133] sched: Ensure update_cfs_shares() is called for parents of continuously-running tasks
Date: Fri, 16 Aug 2013 15:34:15 -0700
Message-Id: <1376692475-28413-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit bf0bd948d1682e3996adc093b43021ed391983e6 upstream.

We typically update a task_group's shares within the dequeue/enqueue
path.  However, continuously running tasks sharing a CPU are not
subject to these updates as they are only put/picked.  Unfortunately,
when we reverted f269ae046 (in 17bc14b7), we lost the augmenting
periodic update that was supposed to account for this; resulting in a
potential loss of fairness.

To fix this, re-introduce the explicit update in
update_cfs_rq_blocked_load() [called via entity_tick()].

Reported-by: Max Hailperin <max@gustavus.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Paul Turner <pjt@google.com>
Link: http://lkml.kernel.org/n/tip-9545m3apw5d93ubyrotrj31y@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sched/fair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..7d0374f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1964,6 +1964,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 */
 	update_entity_load_avg(curr, 1);
 	update_cfs_rq_blocked_load(cfs_rq, 1);
+	update_cfs_shares(cfs_rq);
 
 #ifdef CONFIG_SCHED_HRTICK
 	/*
-- 
1.8.1.2

