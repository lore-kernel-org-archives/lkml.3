Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3H2UFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:05:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10772 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab3H2UFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:05:45 -0400
From: Jason Low <jason.low2@hp.com>
To: mingo@redhat.com, peterz@infradead.org, jason.low2@hp.com
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, pjt@google.com,
        preeti@linux.vnet.ibm.com, akpm@linux-foundation.org, mgorman@suse.de,
        riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Subject: [PATCH v4 1/3] sched: Reduce overestimating rq->avg_idle
Date: Thu, 29 Aug 2013 13:05:34 -0700
Message-Id: <1377806736-3752-2-git-send-email-jason.low2@hp.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
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
---
 kernel/sched/core.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 05c39f0..93b18ef 100644
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

