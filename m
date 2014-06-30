Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaF3B0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:26:20 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52101 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaF3B0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:26:19 -0400
From: Zhihui Zhang <zzhsuny@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [sched] Don't account time after deadline twice
Date: Sun, 29 Jun 2014 21:26:10 -0400
Message-Id: <1404091570-5041-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless we want to double-penalize an overrun task, the time after the deadline
and before the current time is already accounted in the negative dl_se->runtime
value. So we can leave it as is in the case of dmiss && rorun.

Signed-off-by: Zhihui Zhang <zzhsuny@gmail.com>
---
 kernel/sched/deadline.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..67df0d6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -579,10 +579,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 	 * the next instance. Thus, if we do not account that, we are
 	 * stealing bandwidth from the system at each deadline miss!
 	 */
-	if (dmiss) {
-		dl_se->runtime = rorun ? dl_se->runtime : 0;
-		dl_se->runtime -= rq_clock(rq) - dl_se->deadline;
-	}
+	if (dmiss && !rorun)
+		dl_se->runtime = dl_se->deadline - rq_clock(rq);
 
 	return 1;
 }
-- 
1.8.1.2

