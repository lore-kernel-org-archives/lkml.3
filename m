Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaJ1LHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaJ1LHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:07:52 -0400
Date: Tue, 28 Oct 2014 04:06:50 -0700
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-d9aade7ae1d283097a3f626790e7c325a5c69007@git.kernel.org>
Cc: hpa@zytor.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        tkhai@yandex.ru, wanpeng.li@linux.intel.com, tglx@linutronix.de,
        peterz@infradead.org, juri.lelli@arm.com, mingo@kernel.org,
        torvalds@linux-foundation.org
Reply-To: juri.lelli@arm.com, mingo@kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, wanpeng.li@linux.intel.com,
        tkhai@yandex.ru, hpa@zytor.com
In-Reply-To: <1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Do not try to push tasks if pinned task switches to dl
Git-Commit-ID: d9aade7ae1d283097a3f626790e7c325a5c69007
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

Commit-ID:  d9aade7ae1d283097a3f626790e7c325a5c69007
Gitweb:     http://git.kernel.org/tip/d9aade7ae1d283097a3f626790e7c325a5c69007
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Wed, 22 Oct 2014 08:36:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:57 +0100

sched/deadline: Do not try to push tasks if pinned task switches to dl

As Kirill mentioned (https://lkml.org/lkml/2013/1/29/118):

 | If rq has already had 2 or more pushable tasks and we try to add a
 | pinned task then call of push_rt_task will just waste a time.

Just switched pinned task is not able to be pushed. If the rq has had
several dl tasks before they have already been considered as candidates
to be pushed (or pulled). This patch implements the same behavior as rt
class which introduced by commit 10447917551e ("sched/rt: Do not try to
push tasks if pinned task switches to RT").

Suggested-by: Kirill V Tkhai <tkhai@yandex.ru>
Acked-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 5285332..9d1e76a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1622,7 +1622,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 
 	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
+		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded &&
+			push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
