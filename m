Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbaFIXGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:06:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681AbaFIWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 37/78] sched/dl: Fix race in dl_task_timer()
Date: Mon,  9 Jun 2014 15:48:17 -0700
Message-Id: <20140609224814.540854196@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kirill Tkhai <tkhai@yandex.ru>

commit 0f397f2c90ce68821ee864c2c53baafe78de765d upstream.

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/3056991400578422@web14g.yandex.ru
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/deadline.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -490,9 +490,17 @@ static enum hrtimer_restart dl_task_time
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


