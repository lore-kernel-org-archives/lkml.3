Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3E1NKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911Ab3E1NKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:10:08 -0400
Date: Tue, 28 May 2013 06:09:20 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-71b1da46ff70309a2ec12ce943aa0d192d2c8f0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, pjt@google.com,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, efault@gmx.de, peterz@infradead.org,
        zhong@linux.vnet.ibm.com, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1365724262-20142-3-git-send-email-fweisbec@gmail.com>
References: <1365724262-20142-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Update rq clock before setting fair group shares
Git-Commit-ID: 71b1da46ff70309a2ec12ce943aa0d192d2c8f0c
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

Commit-ID:  71b1da46ff70309a2ec12ce943aa0d192d2c8f0c
Gitweb:     http://git.kernel.org/tip/71b1da46ff70309a2ec12ce943aa0d192d2c8f0c
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 12 Apr 2013 01:50:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 May 2013 09:40:23 +0200

sched: Update rq clock before setting fair group shares

Because we may update the execution time in

    sched_group_set_shares()->update_cfs_shares()->reweight_entity()->update_curr()

before reweighting the entity while setting the group shares and this requires
an uptodate version of the runqueue clock.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Turner <pjt@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1365724262-20142-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f62b16d..f76ca21 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6107,6 +6107,9 @@ int sched_group_set_shares(struct task_group *tg, unsigned long shares)
 		se = tg->se[i];
 		/* Propagate contribution to hierarchy */
 		raw_spin_lock_irqsave(&rq->lock, flags);
+
+		/* Possible calls to update_curr() need rq clock */
+		update_rq_clock(rq);
 		for_each_sched_entity(se)
 			update_cfs_shares(group_cfs_rq(se));
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
