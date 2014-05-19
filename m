Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaESTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:31:26 -0400
Received: from forward13.mail.yandex.net ([95.108.130.120]:44206 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbaESTbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:31:24 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
In-Reply-To: <20140519151233.5043b749361e1b384f1e5562@gmail.com>
References: <20140516213003.10384.7946.stgit@localhost> <20140519151233.5043b749361e1b384f1e5562@gmail.com>
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and sched_setaffinity()
MIME-Version: 1.0
Message-Id: <783871400527879@web2j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 19 May 2014 23:31:19 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

19.05.2014, 17:11, "Juri Lelli" <juri.lelli@gmail.com>:
> On Sat, 17 May 2014 01:30:03 +0400
> Kirill Tkhai <tkhai@yandex.ru> wrote:
>
>> šThe race is in unlocked task_rq() access. In pair with parallel
>> šcall of sched_setaffinity() it may be a reason of corruption
>> šof internal rq's data.
>
> Sure, the thing can happen!

[snipped]

>> š@@ -513,9 +513,16 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>> šššššššššššššššššššššššššššššššššššššššššššššššššššššššstruct sched_dl_entity,
>> šššššššššššššššššššššššššššššššššššššššššššššššššššššššdl_timer);
>> ššššššššššstruct task_struct *p = dl_task_of(dl_se);
>> š- struct rq *rq = task_rq(p);
>> š+ struct rq *rq;
>
> We could maybe add a comment here, in line with what we have below, to
> document why we need this.

How about this? (I added comment and rewrote changelog).

[PATCH] sched/dl: Fix race between dl_task_timer() and sched_setaffinity()

Throttled task is still on rq, and it may be moved to other cpu
if user is playing with sched_setaffinity(). Therefore, unlocked
task_rq() access makes the race.

To fix that we do the same as made in __task_rq_lock(). We do not
use __task_rq_lock() itself, because it has a useful lockdep check,
which is not correct in case of dl_task_timer(). This case is
an exception.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # v3.14

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..c0a6921 100644
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
 
+	if (unlikely(rq != task_rq(p))) {
+		/* Task was moved, retrying. */
+		raw_spin_unlock(&rq->lock);
+		goto again;
+	}
+
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something
