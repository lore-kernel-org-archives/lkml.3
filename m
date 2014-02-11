Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaBKMQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:16:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBKMQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:16:20 -0500
Date: Tue, 11 Feb 2014 04:15:50 -0800
From: tip-bot for Daniel Lezcano <tipbot@zytor.com>
Message-ID: <tip-e5fc66119ec97054eefc83f173a7ee9e133c3c3a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org>
References: <1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix race in idle_balance()
Git-Commit-ID: e5fc66119ec97054eefc83f173a7ee9e133c3c3a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 11 Feb 2014 04:15:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e5fc66119ec97054eefc83f173a7ee9e133c3c3a
Gitweb:     http://git.kernel.org/tip/e5fc66119ec97054eefc83f173a7ee9e133c3c3a
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Fri, 17 Jan 2014 10:04:02 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 10 Feb 2014 16:17:04 +0100

sched: Fix race in idle_balance()

The scheduler main function 'schedule()' checks if there are no more tasks
on the runqueue. Then it checks if a task should be pulled in the current
runqueue in idle_balance() assuming it will go to idle otherwise.

But idle_balance() releases the rq->lock in order to look up the sched
domains and takes the lock again right after. That opens a window where
another cpu may put a task in our runqueue, so we won't go to idle but
we have filled the idle_stamp, thinking we will.

This patch closes the window by checking if the runqueue has been modified
but without pulling a task after taking the lock again, so we won't go to idle
right after in the __schedule() function.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: alex.shi@linaro.org
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1389949444-14821-2-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 428bc9d..5ebc681 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6589,6 +6589,13 @@ void idle_balance(struct rq *this_rq)
 
 	raw_spin_lock(&this_rq->lock);
 
+	/*
+	 * While browsing the domains, we released the rq lock.
+	 * A task could have be enqueued in the meantime
+	 */
+	if (this_rq->nr_running && !pulled_task)
+		return;
+
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
 		 * We are going idle. next_balance may be set based on
