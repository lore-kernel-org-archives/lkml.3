Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaBUVcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:32:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59318 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:32:32 -0500
Date: Fri, 21 Feb 2014 13:32:01 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a296858625f810c28ceb360d448d4db5758ca48a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-5-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-5-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Adjust sched_reset_on_fork when nothing else changes
Git-Commit-ID: a296858625f810c28ceb360d448d4db5758ca48a
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

Commit-ID:  a296858625f810c28ceb360d448d4db5758ca48a
Gitweb:     http://git.kernel.org/tip/a296858625f810c28ceb360d448d4db5758ca48a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:19 +0100

sched: Adjust sched_reset_on_fork when nothing else changes

If the policy and priority remain unchanged a possible modification of
sched_reset_on_fork gets lost in the early exit path.

[bigeasy: rebase ontop of v3.14-rc1]
Cc: Ingo Molnar <mingo@redhat.com>
Cc: stable@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-5-git-send-email-bigeasy@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 241f7465..7527e68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3370,7 +3370,8 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed further,
+	 * but store a possible modification of reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy)) {
 		if (fair_policy(policy) && attr->sched_nice != task_nice(p))
@@ -3380,6 +3381,7 @@ recheck:
 		if (dl_policy(policy))
 			goto change;
 
+		p->sched_reset_on_fork = reset_on_fork;
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
