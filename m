Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaFDOEM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:04:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:56712 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaFDOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:04:08 -0400
Message-ID: <1401890642.4484.6.camel@tkhai>
Subject: [PATCH RESEND 1/2] sched/dl: Add necessary dl_{task,prio}
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, <tkhai@yandex.ru>
Date: Wed, 4 Jun 2014 18:04:02 +0400
In-Reply-To: <20140604124735.3951.61242.stgit@tkhai>
References: <20140604124735.3951.61242.stgit@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add some symmetric to rt checks.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
CC: Juri Lelli <juri.lelli@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c |    8 +++++---
 kernel/sched/core.c    |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..cb9f381 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -21,6 +21,7 @@
 #include <linux/ww_mutex.h>
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/deadline.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
@@ -459,10 +460,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		/*
 		 * When there's no owner, we might have preempted between the
 		 * owner acquiring the lock and setting the owner field. If
-		 * we're an RT task that will live-lock because we won't let
-		 * the owner complete.
+		 * we're an RT or DL task that will live-lock because we won't
+		 * let the owner complete.
 		 */
-		if (!owner && (need_resched() || rt_task(task)))
+		if (!owner &&
+		    (need_resched() || rt_task(task) || dl_task(task)))
 			break;
 
 		/*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 240aa83..ba7617a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -962,11 +962,11 @@ static int effective_prio(struct task_struct *p)
 {
 	p->normal_prio = normal_prio(p);
 	/*
-	 * If we are RT tasks or we were boosted to RT priority,
+	 * If we are RT or DL tasks or we were boosted to RT or DL priority,
 	 * keep the priority unchanged. Otherwise, update priority
 	 * to the normal priority:
 	 */
-	if (!rt_prio(p->prio))
+	if (!rt_prio(p->prio) && !dl_prio(p->prio))
 		return p->normal_prio;
 	return p->prio;
 }




