Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab3FCTLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab3FCTK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:10:57 -0400
Date: Mon, 3 Jun 2013 21:07:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] proc: avoid ->f_pos overflows in
	proc_task_readdir() paths
Message-ID: <20130603190705.GA11517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603190640.GA11481@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. proc_task_readdir() truncates f_pos to long, this can lead
   to wrong result on 32bit.

2. first_tid() truncates f_pos to int, this is wrong even on
   64bit.

   We could check that f_pos < PID_MAX or even INT_MAX in
   proc_task_readdir(), but this patch simply checks the
   potential overflow in first_tid(), this check is nop on
   64bit. We do not care if it was negative and the new
   unsigned value is huge, all we need to ensure is that we
   never wrongly return !NULL.

3. Remove the 2nd "nr != 0" check before get_nr_threads(),
   nr_threads == 0 is not distinguishable from !pid_task()
   above.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5e0e02f..5598cfa 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3178,10 +3178,14 @@ out_no_task:
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
@@ -3189,14 +3193,14 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
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
@@ -3204,7 +3208,7 @@ static struct task_struct *first_tid(struct pid *pid, int tid,
 	 */
 	pos = task = task->group_leader;
 	do {
-		if (nr-- <= 0)
+		if (!nr--)
 			goto found;
 	} while_each_thread(task, pos);
 fail:
@@ -3261,7 +3265,7 @@ static int proc_task_readdir(struct file * filp, void * dirent, filldir_t filldi
 	if (proc_inode_is_dead(inode))
 		return -ENOENT;
 
-	switch ((unsigned long)filp->f_pos) {
+	switch (filp->f_pos) {
 	case 0:
 		ino = inode->i_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) < 0)
-- 
1.5.5.1

