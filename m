Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3INPjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 11:39:51 -0400
Received: from relay.parallels.com ([195.214.232.42]:49410 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3INPju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 11:39:50 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Alex Shi <alex.shi@intel.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: [PATCH] sched: Fix task_h_load calculation
Date: Sat, 14 Sep 2013 19:39:46 +0400
Message-ID: <1379173186-11944-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.21.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch a003a2 (sched: Consider runnable load average in move_tasks())
sets all top-level cfs_rqs' h_load to rq->avg.load_avg_contrib, which is
always 0. This mistype leads to all tasks having weight 0 when load
balancing in a cpu-cgroup enabled setup. There obviously should be sum
of weights of all runnable tasks there instead. Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..13abc29 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4242,7 +4242,7 @@ static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
 	}
 
 	if (!se) {
-		cfs_rq->h_load = rq->avg.load_avg_contrib;
+		cfs_rq->h_load = cfs_rq->runnable_load_avg;
 		cfs_rq->last_h_load_update = now;
 	}
 
-- 
1.7.10.4

