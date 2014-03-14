Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbaCNWYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 18:24:40 -0400
Received: from forward9.mail.yandex.net ([77.88.61.48]:58784 "EHLO
	forward9.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaCNWYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 18:24:39 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Mar 2014 18:24:38 EDT
X-Yandex-Uniq: ff80224e-6863-480e-8719-1f8bf9a3b33b
Authentication-Results: smtp9.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1394835289.18748.31.camel@HP-250-G1-Notebook-PC>
Subject: [PATCH 1/4] sched/rt: Sum number of all children tasks in hierarhy
 at rt_nr_running
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Sat, 15 Mar 2014 02:14:49 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{inc,dec}_rt_tasks used to count entities which are directly queued
on rt_rq. If an entity was not a task (i.e., it is some queue), its
children were not counted.

There is no problem here, but now we want to count number of all tasks
which are actually queued under the rt_rq in all the hierarhy (except
throttled rt queues).

Empty queues are not able to be queued and all of the places, which
use rt_nr_running, just compare it with zero, so we do not break
anything here.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index d8cdf16..e4def13 100644
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




