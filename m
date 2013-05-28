Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033Ab3E1NJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:09:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911Ab3E1NJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:09:15 -0400
Date: Tue, 28 May 2013 06:08:04 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-77bd39702f0b3840cea17681409270b16a3b93c0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, pjt@google.com,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, efault@gmx.de, peterz@infradead.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1365724262-20142-2-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Update rq clock before migrating tasks out of dying CPU
Git-Commit-ID: 77bd39702f0b3840cea17681409270b16a3b93c0
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

Commit-ID:  77bd39702f0b3840cea17681409270b16a3b93c0
Gitweb:     http://git.kernel.org/tip/77bd39702f0b3840cea17681409270b16a3b93c0
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 12 Apr 2013 01:50:58 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:23 +0200

sched: Update rq clock before migrating tasks out of dying CPU

Because the sched_class::put_prev_task() callback of rt and fair
classes are referring to the rq clock to update their runtime
statistics. There is a missing rq clock update from the CPU
hotplug notifier's entry point of the scheduler.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1365724262-20142-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 79e48e6..7bf0418 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4378,6 +4378,13 @@ static void migrate_tasks(unsigned int dead_cpu)
 	 */
 	rq->stop = NULL;
 
+	/*
+	 * put_prev_task() and pick_next_task() sched
+	 * class method both need to have an up-to-date
+	 * value of rq->clock[_task]
+	 */
+	update_rq_clock(rq);
+
 	for ( ; ; ) {
 		/*
 		 * There's this thread running, bail when that's the only
