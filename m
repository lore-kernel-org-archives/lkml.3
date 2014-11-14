Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056AbaKNBiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:38:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934900AbaKNBiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:38:09 -0500
Date: Fri, 14 Nov 2014 02:38:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] exit: wait: cleanup the ptrace_reparented() checks
Message-ID: <20141114013815.GA5116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114013750.GA4697@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that EXIT_DEAD is the terminal state we can kill "int traced"
variable and check "state == EXIT_DEAD" instead to cleanup the code.
In particular, this way it is clear that the check obviously doesn't
need tasklist_lock.

Also fix the type of "unsigned long state", "long" was always wrong
although this doesn't matter because cmpxchg/xchg uses typeof(*ptr).

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ee5399b..0511f1d 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -973,8 +973,7 @@ static int wait_noreap_copyout(struct wait_opts *wo, struct task_struct *p,
  */
 static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 {
-	unsigned long state;
-	int retval, status, traced;
+	int state, retval, status;
 	pid_t pid = task_pid_vnr(p);
 	uid_t uid = from_kuid_munged(current_user_ns(), task_uid(p));
 	struct siginfo __user *infop;
@@ -997,19 +996,18 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		}
 		return wait_noreap_copyout(wo, p, pid, uid, why, status);
 	}
-
-	traced = ptrace_reparented(p);
 	/*
 	 * Move the task's state to DEAD/TRACE, only one thread can do this.
 	 */
-	state = traced && thread_group_leader(p) ? EXIT_TRACE : EXIT_DEAD;
+	state = ptrace_reparented(p) && thread_group_leader(p) ?
+		EXIT_TRACE : EXIT_DEAD;
 	if (cmpxchg(&p->exit_state, EXIT_ZOMBIE, state) != EXIT_ZOMBIE)
 		return 0;
+
 	/*
-	 * It can be ptraced but not reparented, check
-	 * thread_group_leader() to filter out sub-threads.
+	 * Check thread_group_leader() to exclude the traced sub-threads.
 	 */
-	if (likely(!traced) && thread_group_leader(p)) {
+	if (state == EXIT_DEAD && thread_group_leader(p)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 		unsigned long maxrss;
-- 
1.5.5.1

