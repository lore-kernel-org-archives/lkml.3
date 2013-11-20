Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3KTS3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:29:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3KTS3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:29:14 -0500
Date: Wed, 20 Nov 2013 19:30:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] proc: fix ->f_pos overflows in first_tid()
Message-ID: <20131120183029.GA12222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120183009.GA12193@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. proc_task_readdir()->first_tid() path truncates f_pos to
   int, this is wrong even on 64bit.

   We could check that f_pos < PID_MAX or even INT_MAX in
   proc_task_readdir(), but this patch simply checks the
   potential overflow in first_tid(), this check is nop on
   64bit. We do not care if it was negative and the new
   unsigned value is huge, all we need to ensure is that we
   never wrongly return !NULL.

2. Remove the 2nd "nr != 0" check before get_nr_threads(),
   nr_threads == 0 is not distinguishable from !pid_task()
   above.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 912ae60..cb03883 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3091,10 +3091,14 @@ out_no_task:
  * In the case of a seek we start with the leader and walk nr
  * threads past it.
  */
-static struct task_struct *first_tid(struct pid *pid, int tid,
-					int nr, struct pid_namespace *ns)
+static struct task_struct *first_tid(struct pid *pid, int tid, loff_t f_pos,
+					struct pid_namespace *ns)
 {
 	struct task_struct *pos, *task;
+	unsigned long nr = f_pos;
+
+	if (nr != f_pos)	/* 32bit overflow? */
+		return NULL;
 
 	rcu_read_lock();
 	task = pid_task(pid, PIDTYPE_PID);
@@ -3102,14 +3106,14 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
 		goto fail;
 
 	/* Attempt to start with the tid of a thread */
-	if (tid && (nr > 0)) {
+	if (tid && nr) {
 		pos = find_task_by_pid_ns(tid, ns);
 		if (pos && same_thread_group(pos, task))
 			goto found;
 	}
 
 	/* If nr exceeds the number of threads there is nothing todo */
-	if (nr && nr >= get_nr_threads(task))
+	if (nr >= get_nr_threads(task))
 		goto fail;
 
 	/* If we haven't found our starting place yet start
@@ -3117,7 +3121,7 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
 	 */
 	pos = task = task->group_leader;
 	do {
-		if (nr-- <= 0)
+		if (!nr--)
 			goto found;
 	} while_each_thread(task, pos);
 fail:
-- 
1.5.5.1

