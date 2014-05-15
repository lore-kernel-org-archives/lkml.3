Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaEOVVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:21:06 -0400
Received: from madhathacker.net ([178.63.244.10]:60268 "EHLO madhathacker.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755655AbaEOVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:21:03 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2014 17:21:03 EDT
Date: Thu, 15 May 2014 23:11:05 +0200
From: Erik Bosman <erik@minemu.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] SROP mitigation: Add signal counting mechanism
Message-ID: <20140515211105.GA9593@pizzadoos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a signal counting mechanism for architectures to use in order to
check whether the kernel should allow a {rt_,}sigreturn call to succeed.
If there are no signal handlers that yet have to return, we can conclude
this is not a legitimate call to {rt_,}sigreturn.

We do signal counting per thread-group, and not per thread, just to be on
the safe side.  A userland thread library may implement user-space thread
switching, which may cause a signal to return in a different thread than
where it was delivered. (I have not seen code that does this though.)

These patches are meant to make Sigreturn Oriented Programming (SROP) a much
less attractive exploitation path.  In Sigreturn Oriented Programming, an
attacker causes a user-space program to call the sigreturn system call in order
to get complete control over the entire userspace context (registers), all in
one go.

( see: http://www.cs.vu.nl/~herbertb/papers/srop_sp14.pdf )

While mitigating SROP will probably not stop determined attackers from
exploiting a program, as there's always the much more well-known Return
Oriented Programming, we still think SROP's relative ease warrants mitigation,
especially since the mitigation is so cheap.


Signed-off-by: Erik Bosman <erik@minemu.org>

---
 arch/Kconfig           | 15 +++++++++++++++
 fs/exec.c              |  7 +++++++
 include/linux/sched.h  |  4 ++++
 include/linux/signal.h |  5 +++++
 kernel/signal.c        | 39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 70 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8319984..34e82d4 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -415,6 +415,21 @@ config SIGNAL_CANARY
 	  sigreturn oriented programming by putting a canary value on a
 	  signal's struct sigframe
 
+config HAVE_SIGNAL_BOOKKEEPING
+	bool
+	help
+	  An arch should select this symbol if:
+	  - it has implemented signal counting signals that are in progress
+
+config SIGNAL_BOOKKEEPING
+	bool "signal bookkeeping"
+	default y
+	depends on HAVE_SIGNAL_BOOKKEEPING
+	help
+	  Mitigate against a userland exploitation techinque called
+	  sigreturn oriented programming by keeping track of how many
+	  signal handlers are in progress
+
 config HAVE_CONTEXT_TRACKING
 	bool
 	help
diff --git a/fs/exec.c b/fs/exec.c
index 883f456..e26190a 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1113,6 +1113,13 @@ void setup_new_exec(struct linux_binprm * bprm)
 	current->signal_canary = (unsigned long)get_random_int();
 #endif
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	/* counter to make sure no more signals can be returned than have been
+	 * delivered (mitigation against sigreturn oriented programming
+	 */
+	current->signal_count = 0;
+#endif
+
 	if (uid_eq(current_euid(), current_uid()) && gid_eq(current_egid(), current_gid()))
 		set_dumpable(current->mm, SUID_DUMP_USER);
 	else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cb8b54b..e076a5f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1369,6 +1369,10 @@ struct task_struct {
 	u32 signal_canary; /* sigreturn exploit mitigation */
 #endif
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+	u32 signal_count; /* sigreturn exploit mitigation */
+#endif
+
 	int (*notifier)(void *priv);
 	void *notifier_data;
 	sigset_t *notifier_mask;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..46cbaec 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -447,4 +447,9 @@ struct seq_file;
 extern void render_sigset_t(struct seq_file *, const char *, sigset_t *);
 #endif
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+void signals_in_progress_inc(struct task_struct *p);
+int signals_in_progress_dec(struct task_struct *p);
+#endif
+
 #endif /* _LINUX_SIGNAL_H */
diff --git a/kernel/signal.c b/kernel/signal.c
index 6ea13c0..6f98ceb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3630,6 +3630,45 @@ void __init signals_init(void)
 	sigqueue_cachep = KMEM_CACHE(sigqueue, SLAB_PANIC);
 }
 
+#ifdef CONFIG_SIGNAL_BOOKKEEPING
+
+/* these functions count the number of signals delivered to
+ * a userspace program
+ */
+
+void signals_in_progress_inc(struct task_struct *p)
+{
+	struct task_struct *leader = p->group_leader;
+
+	task_lock(leader);
+	if (leader->signal_count != U32_MAX) /* in case of 'runaway' signal delivery, disable mitigation */
+		leader->signal_count++;
+
+	task_unlock(leader);
+}
+
+int signals_in_progress_dec(struct task_struct *p)
+{
+	int ret = 0;
+	struct task_struct *leader = p->group_leader;
+
+	task_lock(leader);
+	if (leader->signal_count == 0) {
+		printk(KERN_INFO "%s/%d: attempted to return from a signal "
+					"when none were delivered (exploit attempt?)\n",
+					current->comm, current->pid);
+		ret = -EFAULT;
+	} else if (leader->signal_count != U32_MAX) {
+		leader->signal_count--;
+	}
+
+	task_unlock(leader);
+
+	return ret;
+}
+
+#endif
+
 #ifdef CONFIG_KGDB_KDB
 #include <linux/kdb.h>
 /*
-- 
1.9.1

