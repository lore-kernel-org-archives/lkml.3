Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaDRNID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:08:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDRNH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:07:57 -0400
Date: Fri, 18 Apr 2014 06:07:01 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-22abdef37cebcdd4933c72339401a174b7d87768@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC>
References: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Sum number of all children tasks in hierarhy at ->rt_nr_running
Git-Commit-ID: 22abdef37cebcdd4933c72339401a174b7d87768
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22abdef37cebcdd4933c72339401a174b7d87768
Gitweb:     http://git.kernel.org/tip/22abdef37cebcdd4933c72339401a174b7d87768
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Sat, 15 Mar 2014 02:14:49 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:07:25 +0200

sched/rt: Sum number of all children tasks in hierarhy at ->rt_nr_running

{inc,dec}_rt_tasks() used to count entities which are directly queued
on the rt_rq. If an entity was not a task (i.e., it is some queue), its
children were not counted.

There is no problem here, but now we want to count number of all tasks
which are actually queued under the rt_rq in all the hierarchy (except
throttled rt queues).

Empty queues are not able to be queued and all of the places, which
use ->rt_nr_running, just compare it with zero, so we do not break
anything here.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394835289.18748.31.camel@HP-250-G1-Notebook-PC
Cc: linux-kernel@vger.kernel.org
[ Twiddled the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 1e4992e..6892ed7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1045,12 +1045,23 @@ void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 static inline
+unsigned int rt_se_nr_running(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *group_rq = group_rt_rq(rt_se);
+
+	if (group_rq)
+		return group_rq->rt_nr_running;
+	else
+		return 1;
+}
+
+static inline
 void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	int prio = rt_se_prio(rt_se);
 
 	WARN_ON(!rt_prio(prio));
-	rt_rq->rt_nr_running++;
+	rt_rq->rt_nr_running += rt_se_nr_running(rt_se);
 
 	inc_rt_prio(rt_rq, prio);
 	inc_rt_migration(rt_se, rt_rq);
@@ -1062,7 +1073,7 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	WARN_ON(!rt_rq->rt_nr_running);
-	rt_rq->rt_nr_running--;
+	rt_rq->rt_nr_running -= rt_se_nr_running(rt_se);
 
 	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
 	dec_rt_migration(rt_se, rt_rq);
