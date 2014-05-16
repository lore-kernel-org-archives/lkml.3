Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaEPVaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:30:11 -0400
Received: from forward7l.mail.yandex.net ([84.201.143.140]:45039 "EHLO
	forward7l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaEPVaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:30:09 -0400
X-Yandex-Uniq: acc410b4-5a08-4631-a3e5-64d94f57a5e3
Authentication-Results: smtp8.mail.yandex.net; dkim=pass header.i=@yandex.ru
Subject: [PATCH] sched/dl: Fix race between dl_task_timer() and
 sched_setaffinity()
From: Kirill Tkhai <tkhai@yandex.ru>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, tkhai@yandex.ru, mingo@redhat.com,
        stable@vger.kernel.org, juri.lelli@gmail.com
Date: Sat, 17 May 2014 01:30:03 +0400
Message-ID: <20140516213003.10384.7946.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race is in unlocked task_rq() access. In pair with parallel
call of sched_setaffinity() it may be a reason of corruption
of internal rq's data.

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # v3.14
---
 kernel/sched/deadline.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 800e99b..ffb023a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -513,9 +513,16 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 						     struct sched_dl_entity,
 						     dl_timer);
 	struct task_struct *p = dl_task_of(dl_se);
-	struct rq *rq = task_rq(p);
+	struct rq *rq;
+again:
+	rq = task_rq(p);
 	raw_spin_lock(&rq->lock);
 
+	if (unlikely(rq != task_rq(p))) {
+		raw_spin_unlock(&rq->lock);
+		goto again;
+	}
+
 	/*
 	 * We need to take care of a possible races here. In fact, the
 	 * task might have changed its scheduling policy to something

