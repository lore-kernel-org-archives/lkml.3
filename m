Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3IMS1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:27:05 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32710 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IMS1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:27:03 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com, chegu_vinod@hp.com
Subject: [PATCH v5 1/3] sched: Reduce overestimating rq->avg_idle
Date: Fri, 13 Sep 2013 11:26:51 -0700
Message-Id: <1379096813-3032-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379096813-3032-1-git-send-email-jason.low2@hp.com>
References: <1379096813-3032-1-git-send-email-jason.low2@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When updating avg_idle, if the delta exceeds some max value, then avg_idle
gets set to the max, regardless of what the previous avg was. This can cause
avg_idle to often be overestimated.

This patch modifies the way we update avg_idle by always updating it with the
function call to update_avg() first. Then, if avg_idle exceeds the max, we set
it to the max.

Signed-off-by: Jason Low <jason.low2@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/sched/core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 725aa06..25b0f79 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1347,10 +1347,11 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
 		u64 delta = rq_clock(rq) - rq->idle_stamp;
 		u64 max = 2*sysctl_sched_migration_cost;
 
-		if (delta > max)
+		update_avg(&rq->avg_idle, delta);
+
+		if (rq->avg_idle > max)
 			rq->avg_idle = max;
-		else
-			update_avg(&rq->avg_idle, delta);
+
 		rq->idle_stamp = 0;
 	}
 #endif
-- 
1.7.1

