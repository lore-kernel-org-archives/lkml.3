Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3ITNst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:48:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44317 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:48:13 -0400
Date: Fri, 20 Sep 2013 06:47:19 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-abfafa54db9aba404e8e6763503f04d35bd07138@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, riel@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, jason.low2@hp.com, riel@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1379096813-3032-2-git-send-email-jason.low2@hp.com>
References: <1379096813-3032-2-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Reduce overestimating rq->avg_idle
Git-Commit-ID: abfafa54db9aba404e8e6763503f04d35bd07138
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:47:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abfafa54db9aba404e8e6763503f04d35bd07138
Gitweb:     http://git.kernel.org/tip/abfafa54db9aba404e8e6763503f04d35bd07138
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Fri, 13 Sep 2013 11:26:51 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 12:03:41 +0200

sched: Reduce overestimating rq->avg_idle

When updating avg_idle, if the delta exceeds some max value, then avg_idle
gets set to the max, regardless of what the previous avg was. This can cause
avg_idle to often be overestimated.

This patch modifies the way we update avg_idle by always updating it with the
function call to update_avg() first. Then, if avg_idle exceeds the max, we set
it to the max.

Signed-off-by: Jason Low <jason.low2@hp.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379096813-3032-2-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5ac63c9..048f39e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1332,10 +1332,11 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
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
