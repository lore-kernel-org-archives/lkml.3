Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab3G3Ht0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:49:26 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:59291 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3G3HtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:23 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [RFC PATCH 04/10] sched: Move active_load_balance_cpu_stop to a new helper function
Date: Tue, 30 Jul 2013 13:18:19 +0530
Message-Id: <1375170505-5967-5-git-send-email-srikar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
References: <1375170505-5967-1-git-send-email-srikar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073007-2398-0000-0000-000000DE0F87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the way active_load_balance_cpu gets called and the parameters
passed to it, the active_load_balance_cpu_stop call gets split into
multiple lines. Instead move it into a separate helper function.

this is a cleanup change. No functional changes.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8fcbf96..debb75a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5103,6 +5103,12 @@ static int need_active_balance(struct lb_env *env)
 
 static int active_load_balance_cpu_stop(void *data);
 
+static void active_load_balance(struct rq *rq)
+{
+	stop_one_cpu_nowait(cpu_of(rq), active_load_balance_cpu_stop, rq,
+			&rq->active_balance_work);
+}
+
 /*
  * Check this_cpu to ensure it is balanced within domain. Attempt to move
  * tasks if there is an imbalance.
@@ -5290,11 +5296,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			}
 			raw_spin_unlock_irqrestore(&busiest->lock, flags);
 
-			if (active_balance) {
-				stop_one_cpu_nowait(cpu_of(busiest),
-					active_load_balance_cpu_stop, busiest,
-					&busiest->active_balance_work);
-			}
+			if (active_balance)
+				active_load_balance(busiest);
 
 			/*
 			 * We've kicked active balancing, reset the failure
-- 
1.7.1

