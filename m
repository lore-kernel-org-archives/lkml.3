Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbaKDQMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbaKDQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:12:45 -0500
Date: Tue, 4 Nov 2014 08:11:56 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-cd66091162d34f589631a23bbe0ed214798245b4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ktkhai@parallels.com,
        torvalds@linux-foundation.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, juri.lelli@arm.com, hpa@zytor.com,
        wanpeng.li@linux.intel.com
Reply-To: linux-kernel@vger.kernel.org, ktkhai@parallels.com,
        tglx@linutronix.de, peterz@infradead.org,
        torvalds@linux-foundation.org, mingo@kernel.org,
        wanpeng.li@linux.intel.com, juri.lelli@arm.com, hpa@zytor.com
In-Reply-To: <1414708776-124078-5-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-5-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Reschedule from switched_from_dl
 () after a successful pull
Git-Commit-ID: cd66091162d34f589631a23bbe0ed214798245b4
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

Commit-ID:  cd66091162d34f589631a23bbe0ed214798245b4
Gitweb:     http://git.kernel.org/tip/cd66091162d34f589631a23bbe0ed214798245b4
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:35 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:55 +0100

sched/deadline: Reschedule from switched_from_dl() after a successful pull

In switched_from_dl() we have to issue a resched if we successfully
pulled some task from other cpus. This patch also aligns the behavior
with -rt.

Suggested-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-5-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e7779b3..362ab1f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1643,8 +1643,11 @@ static void switched_from_dl(struct rq *rq, struct task_struct *p)
 	 * this is the right place to try to pull some other one
 	 * from an overloaded cpu, if any.
 	 */
-	if (!rq->dl.dl_nr_running)
-		pull_dl_task(rq);
+	if (!task_on_rq_queued(p) || rq->dl.dl_nr_running)
+		return;
+
+	if (pull_dl_task(rq))
+		resched_curr(rq);
 #endif
 }
 
