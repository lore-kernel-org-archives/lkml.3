Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaBUVbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:31:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59241 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbaBUVbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:31:09 -0500
Date: Fri, 21 Feb 2014 13:30:31 -0800
From: tip-bot for Michael wang <tipbot@zytor.com>
Message-ID: <tip-eb7a59b2c888c2518ba2c9d0020343ca71aa9dee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, wangyun@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        wangyun@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <5305732D.70001@linux.vnet.ibm.com>
References: <5305732D.70001@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Reset se-depth when task switched to FAIR
Git-Commit-ID: eb7a59b2c888c2518ba2c9d0020343ca71aa9dee
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

Commit-ID:  eb7a59b2c888c2518ba2c9d0020343ca71aa9dee
Gitweb:     http://git.kernel.org/tip/eb7a59b2c888c2518ba2c9d0020343ca71aa9dee
Author:     Michael wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Thu, 20 Feb 2014 11:14:53 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:17 +0100

sched/fair: Reset se-depth when task switched to FAIR

Sasha reported:

[  522.645288] BUG: unable to handle kernel NULL pointer dereference at ...
[  522.646271] IP: [<ffffffff81186c6f>] check_preempt_wakeup+0x11f/0x210
		...
[  522.650021] Call Trace:
[  522.650021]  <IRQ>
[  522.650021]  [<ffffffff8117361d>] check_preempt_curr+0x3d/0xb0
[  522.650021]  [<ffffffff81175d88>] ttwu_do_wakeup+0x18/0x130
		...

which was caused by the se-depth changed during the time when task is not
FAIR, and we will use the wrong depth value after it switched back to FAIR.

This patch reset the depth at the time when task switched to FAIR, make sure
that we always have the correct value when task is FAIR.

Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5305732D.70001@linux.vnet.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 235cfa7..280da89 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7317,7 +7317,15 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
  */
 static void switched_to_fair(struct rq *rq, struct task_struct *p)
 {
-	if (!p->se.on_rq)
+	struct sched_entity *se = &p->se;
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	/*
+	 * Since the real-depth could have been changed (only FAIR
+	 * class maintain depth value), reset depth properly.
+	 */
+	se->depth = se->parent ? se->parent->depth + 1 : 0;
+#endif
+	if (!se->on_rq)
 		return;
 
 	/*
