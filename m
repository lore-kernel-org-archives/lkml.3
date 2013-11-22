Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3KVUcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:32:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab3KVUcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:32:13 -0500
Date: Fri, 22 Nov 2013 21:33:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, keescook@chromium.org,
        mhocko@suse.cz, snanda@chromium.org, dserrg@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] kill task_struct->did_exec
Message-ID: <20131122203320.GA20250@redhat.com>
References: <20131122175447.GA31463@redhat.com> <528FB49E.2000502@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FB49E.2000502@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, KOSAKI Motohiro wrote:
>
> (11/22/2013 12:54 PM), Oleg Nesterov wrote:
> > We can kill either task->did_exec or PF_FORKNOEXEC, they are
> > mutually exclusive. The patch kill ->did_exec because it has
> > a single user.
>
> It's ok.
>
> but,
>
> > - * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
> > - * LBT 04.03.94
> > + * !PF_FORKNOEXEC check to conform completely to POSIX. LBT 04.03.94.
>
> I guess LBT is his name and !PF_FORKNOEXEC is not his opinion. Please just
> remove "LBT 04.03.94" too. git repo still keep his achievement and can avoid
> confusion.

OK, please see v2.


Subject: [PATCH] kill task_struct->did_exec
From: Oleg Nesterov <oleg@redhat.com>
Date: Fri, 22 Nov 2013 18:43:40 +0100

We can kill either task->did_exec or PF_FORKNOEXEC, they are
mutually exclusive. The patch kills ->did_exec because it has
a single user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c             |    1 -
 include/linux/sched.h |    1 -
 kernel/fork.c         |    1 -
 kernel/sys.c          |    5 ++---
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 9944bbf..380640f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1432,7 +1432,6 @@ static int exec_binprm(struct linux_binprm *bprm)
 	if (ret >= 0) {
 		trace_sched_process_exec(current, old_pid, bprm);
 		ptrace_event(PTRACE_EVENT_EXEC, old_vpid);
-		current->did_exec = 1;
 		proc_exec_connector(current);
 	}
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 34c1903..4f1958e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1114,7 +1114,6 @@ struct task_struct {
 	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
 
-	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
 	unsigned in_iowait:1;
diff --git a/kernel/fork.c b/kernel/fork.c
index 2cb6024..7dbf504 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1224,7 +1224,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!try_module_get(task_thread_info(p)->exec_domain->module))
 		goto bad_fork_cleanup_count;
 
-	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
diff --git a/kernel/sys.c b/kernel/sys.c
index c18ecca..e54ef1c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -896,8 +896,7 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
  * only important on a multi-user system anyway, to make sure one user
  * can't send a signal to a process owned by another.  -TYT, 12/12/91
  *
- * Auch. Had to add the 'did_exec' flag to conform completely to POSIX.
- * LBT 04.03.94
+ * !PF_FORKNOEXEC check to conform completely to POSIX.
  */
 SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 {
@@ -933,7 +932,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 		if (task_session(p) != task_session(group_leader))
 			goto out;
 		err = -EACCES;
-		if (p->did_exec)
+		if (!(p->flags & PF_FORKNOEXEC))
 			goto out;
 	} else {
 		err = -ESRCH;
-- 
1.5.5.1


