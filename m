Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaLXVkw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 16:40:52 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaLXVkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 16:40:51 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, rientjes@google.com, atomlin@redhat.com,
        keescook@chromium.org, daeseok.youn@gmail.com, tglx@linutronix.de,
        vdavydov@parallels.com, riel@redhat.com, oleg@redhat.com,
        akpm@linux-foundation.org, peterz@infradead.org, mingo@redhat.com,
        viro@zeniv.linux.org.uk, luto@amacapital.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] [RFC] Deter exploit bruteforcing
Date: Wed, 24 Dec 2014 22:39:27 +0100
Message-Id: <1419457167-15042-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While exploring the offset2lib attack I remembered that
grsecurity has an interesting feature to make such attacks
much harder. Exploits can brute stack canaries often very easily
if the target is a forking server like sshd or Apache httpd.
The problem is that after fork() the child has by definition
exactly the same memory as the parent and therefore also the same
stack canaries.
The attacker can guess the stack canaries byte by byte.
After 256 times 7 forks() a good exploit can find the correct
canary value.

The basic idea behind this patch is to delay fork() if a child died
due to a fatal error.
Currently it delays fork() by 30 seconds if the parent tries to fork()
within 60 seconds after a child died due to a fatal error.

I'm sure you'll hate this patch but I want to find out how much you hate it
and whether there is a little chance to get it mainline in a modified form.
Later I'd make it depend on a new Kconfig option and off by default
and the timing constants changeable via sysctl.

Credit for the concept goes to grsecurity folks, I'll take the flames.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/coredump.c         | 10 ++++++++++
 include/linux/sched.h |  1 +
 kernel/fork.c         |  7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index b5c86ff..d7730c8 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -512,6 +512,7 @@ void do_coredump(const siginfo_t *siginfo)
 	bool need_nonrelative = false;
 	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
+	int sig = siginfo->si_signo;
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
 		.regs = signal_pt_regs(),
@@ -526,6 +527,15 @@ void do_coredump(const siginfo_t *siginfo)
 
 	audit_core_dumps(siginfo->si_signo);
 
+	if (sig == SIGSEGV || sig == SIGBUS || sig == SIGKILL || sig == SIGILL) {
+		rcu_read_lock();
+		read_lock(&tasklist_lock);
+		if (current->real_parent && (current->flags & PF_FORKNOEXEC))
+			current->real_parent->brute_expires = get_seconds() + (30 * 60);
+		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
+	}
+
 	binfmt = mm->binfmt;
 	if (!binfmt || !binfmt->core_dump)
 		goto fail;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8db31ef..c616735 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1701,6 +1701,7 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+	unsigned long brute_expires;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/fork.c b/kernel/fork.c
index 4dc2dda..178c80e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -74,6 +74,7 @@
 #include <linux/uprobes.h>
 #include <linux/aio.h>
 #include <linux/compiler.h>
+#include <linux/delay.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -352,6 +353,8 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	tsk->splice_pipe = NULL;
 	tsk->task_frag.page = NULL;
 
+	tsk->brute_expires = 0;
+
 	account_kernel_stack(ti, 1);
 
 	return tsk;
@@ -1669,6 +1672,10 @@ long do_fork(unsigned long clone_flags,
 		if (clone_flags & CLONE_PARENT_SETTID)
 			put_user(nr, parent_tidptr);
 
+		if (unlikely(current->brute_expires) && time_before(get_seconds(),
+		    current->brute_expires))
+			msleep(30 * 1000);
+
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
-- 
2.1.0

