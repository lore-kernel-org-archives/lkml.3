Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaHTIWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:22:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaHTIWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:22:18 -0400
Date: Wed, 20 Aug 2014 01:20:01 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-f36c019c79edb3a89920afae1b2b45987af1a112@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1407312361.8424.35.camel@tkhai>
References: <1407312361.8424.35.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Fix reschedule which is generated on throttled cfs_rq
Git-Commit-ID: f36c019c79edb3a89920afae1b2b45987af1a112
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

Commit-ID:  f36c019c79edb3a89920afae1b2b45987af1a112
Gitweb:     http://git.kernel.org/tip/f36c019c79edb3a89920afae1b2b45987af1a112
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Wed, 6 Aug 2014 12:06:01 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:20 +0200

sched/fair: Fix reschedule which is generated on throttled cfs_rq

(sched_entity::on_rq == 1) does not guarantee the task is pickable;
changes on throttled cfs_rq must not lead to reschedule.

Check for task_struct::on_rq instead.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407312361.8424.35.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1413c44..bc37bb9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7494,7 +7494,7 @@ static void task_fork_fair(struct task_struct *p)
 static void
 prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 {
-	if (!p->se.on_rq)
+	if (!p->on_rq)
 		return;
 
 	/*
@@ -7550,15 +7550,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
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
