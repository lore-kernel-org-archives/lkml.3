Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaKZXys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:54:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbaKZXyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:54:46 -0500
Date: Thu, 27 Nov 2014 00:54:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Aaron Tomlin <atomlin@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] exit: pidns: fix/update the comments in
	zap_pid_ns_processes()
Message-ID: <20141126235437.GA386@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126235416.GA32688@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comments in zap_pid_ns_processes() are not clear, we need to
explain how this code actually works.

1. "Ignore SIGCHLD" looks like optimization but it is not, we also
   need this for correctness.

2. The comment above sys_wait4() could tell more.

   EXIT_ZOMBIE child is only possible if it has exited before we
   ignored SIGCHLD. Or if it is traced from the parent namespace,
   but in this case it will be reaped by debugger after detach,
   sys_wait4() acts as a synchronization point.

3. The comment about TASK_DEAD (EXIT_DEAD in fact) children is
   outdated. Contrary to what it says we do not need to make sure
   they all go away after 0a01f2cc390e "pidns: Make the pidns proc
   mount/umount logic obvious".

   At the same time, we do need to wait for nr_hashed==init_pids,
   but the reasons are quite different and not obvious: setns().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/pid_namespace.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index db95d8e..bc6d6a8 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -190,7 +190,11 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	/* Don't allow any more processes into the pid namespace */
 	disable_pid_allocation(pid_ns);
 
-	/* Ignore SIGCHLD causing any terminated children to autoreap */
+	/*
+	 * Ignore SIGCHLD causing any terminated children to autoreap.
+	 * This speeds up the namespace shutdown, plus see the comment
+	 * below.
+	 */
 	spin_lock_irq(&me->sighand->siglock);
 	me->sighand->action[SIGCHLD - 1].sa.sa_handler = SIG_IGN;
 	spin_unlock_irq(&me->sighand->siglock);
@@ -223,15 +227,31 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	}
 	read_unlock(&tasklist_lock);
 
-	/* Firstly reap the EXIT_ZOMBIE children we may have. */
+	/*
+	 * Reap the EXIT_ZOMBIE children we had before we ignored SIGCHLD.
+	 * sys_wait4() will also block until our children traced from the
+	 * parent namespace are detached and become EXIT_DEAD.
+	 */
 	do {
 		clear_thread_flag(TIF_SIGPENDING);
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
 	/*
-	 * sys_wait4() above can't reap the TASK_DEAD children.
-	 * Make sure they all go away, see free_pid().
+	 * sys_wait4() above can't reap the EXIT_DEAD children but we do not
+	 * really care, we could reparent them to the global init. We could
+	 * exit and reap ->child_reaper even if it is not the last thread in
+	 * this pid_ns, free_pid(nr_hashed == 0) calls proc_cleanup_work(),
+	 * pid_ns can not go away until proc_kill_sb() drops the reference.
+	 *
+	 * But this ns can also have other tasks injected by setns()+fork().
+	 * Again, ignoring the user visible semantics we do not really need
+	 * to wait until they are all reaped, but they can be reparented to
+	 * us and thus we need to ensure that pid->child_reaper stays valid
+	 * until they all go away. See free_pid()->wake_up_process().
+	 *
+	 * We rely on ignored SIGCHLD, an injected zombie must be autoreaped
+	 * if reparented.
 	 */
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-- 
1.5.5.1

