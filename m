Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaFEOep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:34:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48291 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaFEOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:34:42 -0400
Date: Thu, 5 Jun 2014 07:33:53 -0700
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-0f397f2c90ce68821ee864c2c53baafe78de765d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, tkhai@yandex.ru,
        tglx@linutronix.de
In-Reply-To: <3056991400578422@web14g.yandex.ru>
References: <3056991400578422@web14g.yandex.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/dl: Fix race in dl_task_timer()
Git-Commit-ID: 0f397f2c90ce68821ee864c2c53baafe78de765d
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

Commit-ID:  0f397f2c90ce68821ee864c2c53baafe78de765d
Gitweb:     http://git.kernel.org/tip/0f397f2c90ce68821ee864c2c53baafe78de765d
Author:     Kirill Tkhai <tkhai@yandex.ru>
AuthorDate: Tue, 20 May 2014 13:33:42 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:51:12 +0200

sched/dl: Fix race in dl_task_timer()

Throttled task is still on rq, and it may be moved to other cpu
if user is playing with sched_setaffinity(). Therefore, unlocked
task_rq() access makes the race.

Juri Lelli reports he got this race when dl_bandwidth_enabled()
was not set.

Other thing, pointed by Peter Zijlstra:

   "Now I suppose the problem can still actually happen when
    you change the root domain and trigger a effective affinity
    change that way".

To fix that we do the same as made in __task_rq_lock(). We do not
use __task_rq_lock() itself, because it has a useful lockdep check,
which is not correct in case of dl_task_timer(). We do not need
pi_lock locked here. This case is an exception (PeterZ):

   "The only reason we don't strictly need ->pi_lock now is because
    we're guaranteed to have p->state == TASK_RUNNING here and are
    thus free of ttwu races".

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org> # v3.14+
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/3056991400578422@web14g.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..14bc348 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -513,9 +513,17 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 						     struct sched_dl_entity,
 						     dl_timer);
 	struct task_struct *p = dl_task_of(dl_se);
-	struct rq *rq = task_rq(p);
+	struct rq *rq;
+again:
+	rq = task_rq(p);
 	raw_spin_lock(&rq->lock);
 
+	if (rq != task_rq(p)) {
+		/* Task was moved, retrying. */
+		raw_spin_unlock(&rq->lock);
+		goto again;
+	}
+
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
