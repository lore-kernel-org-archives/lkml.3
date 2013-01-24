Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3AXUhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:37:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab3AXUg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:36:59 -0500
Date: Thu, 24 Jan 2013 12:36:40 -0800
From: tip-bot for Kirill Tkhai <tkhai@yandex.ru>
Message-ID: <tip-1158ddb55416855fd17abe3214298f736f00426a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <118761353614535@web28f.yandex.ru>
References: <118761353614535@web28f.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt:
  Add reschedule check to switched_from_rt()
Git-Commit-ID: 1158ddb55416855fd17abe3214298f736f00426a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:36:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1158ddb55416855fd17abe3214298f736f00426a
Gitweb:     http://git.kernel.org/tip/1158ddb55416855fd17abe3214298f736f00426a
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Fri, 23 Nov 2012 00:02:15 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 17:14:30 +0100

sched/rt: Add reschedule check to switched_from_rt()

Reschedule rq->curr if the first RT task has just been
pulled to the rq.

Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tkhai Kirill <tkhai@yandex.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/118761353614535@web28f.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/rt.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 418feb0..29bda5b 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1889,8 +1889,11 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 	 * we may need to handle the pulling of RT tasks
 	 * now.
 	 */
-	if (p->on_rq && !rq->rt.rt_nr_running)
-		pull_rt_task(rq);
+	if (!p->on_rq || rq->rt.rt_nr_running)
+		return;
+
+	if (pull_rt_task(rq))
+		resched_task(rq->curr);
 }
 
 void init_sched_rt_class(void)
