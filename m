Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3AaLGc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:06:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab3AaLG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:06:27 -0500
Date: Thu, 31 Jan 2013 03:06:09 -0800
From: tip-bot for Kirill Tkhai <tkhai@yandex.ru>
Message-ID: <tip-fc79e240be5aa379dd36a62158be5a5ee0e4aec7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, linux-rt-users@vger.kernel.org,
        rostedt@goodmis.org, tkhai@yandex.ru, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, linux-rt-users@vger.kernel.org
In-Reply-To: <931541359550236@web1g.yandex.ru>
References: <931541359550236@web1g.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Do not account zero delta_exec in update_curr_rt()
Git-Commit-ID: fc79e240be5aa379dd36a62158be5a5ee0e4aec7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:06:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc79e240be5aa379dd36a62158be5a5ee0e4aec7
Gitweb:     http://git.kernel.org/tip/fc79e240be5aa379dd36a62158be5a5ee0e4aec7
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Wed, 30 Jan 2013 16:50:36 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 31 Jan 2013 10:31:13 +0100

sched/rt: Do not account zero delta_exec in update_curr_rt()

There are several places of consecutive calls of
dequeue_task_rt() and put_prev_task_rt() in the scheduler.
For example, function rt_mutex_setprio() does it.

The both calls lead to update_curr_rt(), the second of it
receives zeroed delta_exec. The only effective action in this
case is call of sched_rt_avg_update(), which can change
rq->age_stamp and rq->rt_avg. But it is possible in case of
""floating"" rq->clock. This fact is not reasonable to be
accounted. Another actions do nothing.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
Link: http://lkml.kernel.org/r/931541359550236@web1g.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 2f69ca9..94abca4 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -925,8 +925,8 @@ static void update_curr_rt(struct rq *rq)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;
-	if (unlikely((s64)delta_exec < 0))
-		delta_exec = 0;
+	if (unlikely((s64)delta_exec <= 0))
+		return;
 
 	schedstat_set(curr->se.statistics.exec_max,
 		      max(curr->se.statistics.exec_max, delta_exec));
