Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaBTDPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:15:01 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56132 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaBTDPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:15:00 -0500
Message-ID: <5305732D.70001@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 11:14:53 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: reset se-depth when task switched to FAIR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022003-4790-0000-0000-00000CD417C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   10 +++++++++-
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
-- 
1.7.9.5

