Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaHFIGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:06:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:51462 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaHFIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:06:10 -0400
Message-ID: <1407312361.8424.35.camel@tkhai>
Subject: [PATCH v4 1/6] sched/fair: Fix reschedule which is generated on
 throttled cfs_rq
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <peterz@infradead.org>, <pjt@google.com>, <oleg@redhat.com>,
        <rostedt@goodmis.org>, <umgwanakikbuti@gmail.com>, <tkhai@yandex.ru>,
        <tim.c.chen@linux.intel.com>, <mingo@kernel.org>,
        <nicolas.pitre@linaro.org>
Date: Wed, 6 Aug 2014 12:06:01 +0400
In-Reply-To: <20140806075138.24858.23816.stgit@tkhai>
References: <20140806075138.24858.23816.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(sched_entity::on_rq == 1) does not guarantee the task is pickable;
changes on throttled cfs_rq must not lead to reschedule.

Check for task_struct::on_rq instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..6f0ce2b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7465,7 +7465,7 @@ static void task_fork_fair(struct task_struct *p)
 static void
 prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		return;
 
 	/*
@@ -7521,15 +7521,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
  */
 static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
-	struct sched_entity *se = &p->se;
 #ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_entity *se = &p->se;
 	/*
 	 * Since the real-depth could have been changed (only FAIR
 	 * class maintain depth value), reset depth properly.
 	 */
 	se->depth = se->parent ? se->parent->depth + 1 : 0;
 #endif
-	if (!se->on_rq)
+	if (!p->on_rq)
 		return;
 
 	/*



