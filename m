Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab3BCTb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:31:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3BCTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:31:26 -0500
Date: Sun, 3 Feb 2013 11:30:47 -0800
From: tip-bot for Kirill Tkhai <tkhai@yandex.ru>
Message-ID: <tip-60334caf37dc7c59120b21faa625534a6fffead0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, linux-rt-users@vger.kernel.org,
        rostedt@goodmis.org, tkhai@yandex.ru, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de, linux-rt-users@vger.kernel.org
In-Reply-To: <70871359644177@web16d.yandex.ru>
References: <70871359644177@web16d.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Further simplify pick_rt_task()
Git-Commit-ID: 60334caf37dc7c59120b21faa625534a6fffead0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:30:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60334caf37dc7c59120b21faa625534a6fffead0
Gitweb:     http://git.kernel.org/tip/60334caf37dc7c59120b21faa625534a6fffead0
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Thu, 31 Jan 2013 18:56:17 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 3 Feb 2013 19:54:58 +0100

sched/rt: Further simplify pick_rt_task()

Function next_prio() has been removed and pull_rt_task() is the
only user of pick_next_highest_task_rt() at the moment.

pull_rt_task is not interested in p->nr_cpus_allowed, its only
interest is the fact that cpu is allowed to execute p. If
nr_cpus_allowed == 1, cpu != task_cpu(p) and cpu is allowed then
it means that task p is in the middle of the migration
techniques; the task waits until it is moved by migration
thread. So, lets pull it earlier.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
Link: http://lkml.kernel.org/r/70871359644177@web16d.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 94abca4..c25de14 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1427,8 +1427,7 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
 static int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
 {
 	if (!task_running(rq, p) &&
-	    (cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
-	    (p->nr_cpus_allowed > 1))
+	    cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
 		return 1;
 	return 0;
 }
