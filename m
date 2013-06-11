Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3FKB3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 21:29:46 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:38271 "HELO
	shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753996Ab3FKB3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 21:29:45 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 21:29:45 EDT
Date: Mon, 10 Jun 2013 20:23:04 -0500
From: vcaputo@gnugeneration.com
To: linux-kernel@vger.kernel.org
Subject: adopt(pid_t pid) syscall proposal [patch included]
Message-ID: <20130611012304.GI5638@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello all,

I'd like to propose a new system call, I know I'll probably be flamed,
but here goes.

Today there is no way to get a process which has been orphaned, and thus
become a child of init, back as a child of another process.  This is
annoying me, please allow me to explain why.

The CONFIG_CHECKPOINT_RESTORE feature enables a useful little thing in
proc which I've been taking advantage of to make some interesting
omnipresent desktop monitoring features built into my own composited
window manager.  That thing is the /proc/$pid/task/$pid/children file.

Using this file, I've created scoped per-window process monitors which
can efficiently limit their monitoring to only the client pid of the X
window and its decendants.  These monitors are always running, but
visibility is toggled when desired by a keypress, efficiency is
important and the children file helps tremendously in this regard.

So I'm thrilled with all this and everything is fantastically efficient
and simple, until the first time I detach from my screen session and
reattach.

Initially, I'll have a scenario like:

 xterm
  bash
   screen -S stuff
    screen -S stuff
     bash
     bash
      top
     bash
      vi foo.c
     bash
      make
       sh -c cc -Wall ...
        cc1 -quiet -I ...
     bash

Behind these rows of text I have user/cpu graphs for each process
sliding by.

After detaching from screen, then reattaching, this is what the above
turns into, as you can probably predict:

 xterm
  bash
   screen -dr stuff

All subsequent processes created through my interactions with this
screen are lost to the monitoring, since the "screen -S stuff" backend
is now stuck being a child of init.

With the attached adopt() syscall patch, and a 1 line change to screen's
attacher function invoking adopt(), I get the following on reattach:

 xterm
  bash
   screen -dr stuff
    screen -S stuff
     bash
     bash
      top
     bash
      vi foo.c
     bash
      make
       sh -c cc -Wall ...
        cc1 -quiet -I ...


Which makes me very happy, dance around the room happy, and I'm not a
dancer.

Here is a screenshot of the results enabled by the patch:
http://pengaru.com/~swivel/vwm/screen_sys_adopt.png

Thanks for reading, and hopefuly considering this addition, I'm sure
there are other uses as well.  Please CC me in any replies as I'm not
currently subscribed.

Regards,
Vito Caputo

--rwEMma7ioTxnRzrJ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-sched-implement-adopt-system-call.patch"

>From 2d9f1781c6cdec8d74f44f98624af2eacbd21810 Mon Sep 17 00:00:00 2001
From: Vito Caputo <vcaputo@gnugeneration.com>
Date: Mon, 10 Jun 2013 17:28:49 -0700
Subject: [PATCH 1/1] 	sched: implement adopt() system call

	This implements a proposed facility for adopting a process
	by another.  The immediate use case is programs like GNU
	screen which lose their parent-child relationship when
	detached.  Using this sytem call on reattach, the relation
	can be restored, which is particularly of use to those
	taking advantage of the /proc/$pid/task/$pid/children list
	provided by CONFIG_CHECKPOINT_RESTORE.

	This implementation applies permission checks similar to
	that of kill(), in addition to preventing the adoption of
	an ancestor process.

	I have tested it and use the change myself to complement
	process subtree monitoring, without which I lose all
	visibility of the descendants of my screen sessions on
	reattach.

Signed-off-by: Vito Caputo <vcaputo@gnugeneration.com>
---
 arch/x86/syscalls/syscall_32.tbl |    1 +
 arch/x86/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h         |    2 ++
 kernel/exit.c                    |   59 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index aabfb83..d219781 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,4 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	adopt			sys_adopt
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 38ae65d..6345ebf 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,7 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	adopt			sys_adopt
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 4147d70..3997cde 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -841,4 +841,6 @@ asmlinkage long sys_process_vm_writev(pid_t pid,
 asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
 			 unsigned long idx1, unsigned long idx2);
 asmlinkage long sys_finit_module(int fd, const char __user *uargs, int flags);
+
+asmlinkage long sys_adopt(pid_t upid);
 #endif
diff --git a/kernel/exit.c b/kernel/exit.c
index af2eb3c..5b554c8 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1681,3 +1681,62 @@ SYSCALL_DEFINE3(waitpid, pid_t, pid, int __user *, stat_addr, int, options)
 }
 
 #endif
+
+/*
+ * sys_adopt() adopts the process specified as upid by the current
+ * process if permitted.  This is linux-specific and provided so
+ * programs such as GNU screen may restore the parent-child
+ * relationship lost in detaching when reattaching.
+ */
+SYSCALL_DEFINE1(adopt, pid_t, upid)
+{
+	long ret = -ENOENT;
+	struct pid *pid;
+
+	if ((pid = find_get_pid(upid))) {
+		struct task_struct	*p;
+
+		rcu_read_lock();
+		write_lock_irq(&tasklist_lock);
+		p = pid_task(pid, PIDTYPE_PID);
+		if (p) {
+			struct task_struct *t;
+			const struct cred *cred = current_cred();
+			const struct cred *tcred = __task_cred(p);
+
+			if (!uid_eq(cred->euid, tcred->suid) &&
+			    !uid_eq(cred->euid, tcred->uid)  &&
+			    !uid_eq(cred->uid,  tcred->suid) &&
+			    !uid_eq(cred->uid,  tcred->uid) &&
+			    !ns_capable(cred->user_ns, CAP_KILL)) {
+				ret = -EPERM;
+				goto out_unlock;
+			}
+
+
+			/* upid cannot be current nor an ancestor of current */
+			for (t = current;; t = t->real_parent) {
+				if (t == p) {
+					ret = -EINVAL;
+					goto out_unlock;
+				}
+				if (is_global_init(t))
+					break;
+			}
+
+			t = p;
+			do {
+				t->real_parent = current;
+			} while_each_thread(p, t);
+
+			list_move_tail(&p->sibling, &p->real_parent->children);
+			ret = 0;
+		} /* else { ret = -ENOENT } */
+out_unlock:
+		write_unlock_irq(&tasklist_lock);
+		rcu_read_unlock();
+		put_pid(pid);
+	} /* else { ret = -ENOENT } */
+
+	return ret;
+}
-- 
1.7.10.4


--rwEMma7ioTxnRzrJ--
