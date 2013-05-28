Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab3E1NL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:11:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023Ab3E1NL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:11:26 -0400
Date: Tue, 28 May 2013 06:10:36 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-1ad4ec0dc740c4183acd6d6e367ca52b28e4fa94@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, pjt@google.com,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, efault@gmx.de, peterz@infradead.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1365724262-20142-4-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-4-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Update rq clock before calling check_preempt_curr()
Git-Commit-ID: 1ad4ec0dc740c4183acd6d6e367ca52b28e4fa94
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

Commit-ID:  1ad4ec0dc740c4183acd6d6e367ca52b28e4fa94
Gitweb:     http://git.kernel.org/tip/1ad4ec0dc740c4183acd6d6e367ca52b28e4fa94
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 12 Apr 2013 01:51:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:24 +0200

sched: Update rq clock before calling check_preempt_curr()

check_preempt_curr() of fair class needs an uptodate sched clock
value to update runtime stats of the current task of the target's rq.

When a task is woken up, activate_task() is usually called right before
ttwu_do_wakeup() unless the task is still in the runqueue. In the latter
case we need to update the rq clock explicitly because activate_task()
isn't here to do the job for us.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1365724262-20142-4-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bf0418..46d0017 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1365,6 +1365,8 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
 
 	rq = __task_rq_lock(p);
 	if (p->on_rq) {
+		/* check_preempt_curr() may use rq clock */
+		update_rq_clock(rq);
 		ttwu_do_wakeup(rq, p, wake_flags);
 		ret = 1;
 	}
