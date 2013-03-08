Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737Ab3CHEhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:37:52 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:39811 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760386Ab3CHEhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:37:24 -0500
From: Michel Lespinasse <walken@google.com>
To: Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/5] kernel: use tasklist_{read,write}_lock() to lock tasklist in process context
Date: Thu,  7 Mar 2013 20:37:15 -0800
Message-Id: <1362717437-1729-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362717437-1729-1-git-send-email-walken@google.com>
References: <1362717437-1729-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For most of these call sites, the process context is relatively
obvious from looking at the surrounding code.

Some of these changes deserve additional comments though:

- arch/ia64/kernel/mca.c default_monarch_init_process(): runs very early
  within setup_arch(), there should be no need to worry about tasklist_lock
  being already locked at this point.

- kernel/trace/ftrace.c alloc_retstack_tasklist(): Note that disabling
  local interrupts here was not necessary for lockdep purposes, and it
  did not protect the setup code either (as noted in 26c01624a2a40)
  since these structures are per-task, not cpu-local.

- mm/memory-failure.c collect_procs(): This runs in process context because
  it's invoked from memory_failure(), which runs out of a work queue.

- mm/oom_kill.c oom_kill_process(): This runs in process context because
  in other contexts memory allocations can't use ___GFP_FS and thus can't
  trigger ooms. This property also explains why kernel/cgroup.c
  cgroup_enable_task_cg_lists() can't run in non-process contexts
  through its mem_cgroup_out_of_memory() cgroup_iter_start() call path.

Signed-off-by: Michel Lespinasse <walken@google.com>

---
 arch/frv/mm/mmu-context.c        |  4 ++--
 arch/ia64/kernel/mca.c           | 13 ++++++-------
 arch/ia64/kernel/perfmon.c       |  8 ++++----
 arch/ia64/kernel/ptrace.c        |  8 ++++----
 arch/metag/kernel/smp.c          |  4 ++--
 arch/mips/kernel/mips-mt-fpaff.c |  4 ++--
 arch/sh/mm/asids-debugfs.c       |  4 ++--
 arch/um/kernel/reboot.c          |  4 ++--
 drivers/tty/tty_io.c             | 20 +++++++++----------
 fs/exec.c                        | 14 +++++++-------
 fs/fs_struct.c                   |  4 ++--
 fs/proc/array.c                  |  4 ++--
 fs/proc/base.c                   |  4 ++--
 kernel/cgroup.c                  |  4 ++--
 kernel/cpu.c                     |  4 ++--
 kernel/exit.c                    | 42 ++++++++++++++++++++--------------------
 kernel/fork.c                    |  6 +++---
 kernel/pid_namespace.c           |  8 ++++----
 kernel/posix-cpu-timers.c        | 26 ++++++++++++-------------
 kernel/power/process.c           | 16 +++++++--------
 kernel/ptrace.c                  | 20 +++++++++----------
 kernel/sched/core.c              |  8 ++++----
 kernel/signal.c                  | 22 ++++++++++-----------
 kernel/sys.c                     | 22 ++++++++++-----------
 kernel/trace/ftrace.c            |  5 ++---
 kernel/tracepoint.c              | 10 ++++------
 mm/kmemleak.c                    |  4 ++--
 mm/memory-failure.c              |  8 ++++----
 mm/oom_kill.c                    |  4 ++--
 security/keys/keyctl.c           |  4 ++--
 security/selinux/hooks.c         |  4 ++--
 31 files changed, 154 insertions(+), 158 deletions(-)

diff --git a/arch/frv/mm/mmu-context.c b/arch/frv/mm/mmu-context.c
index 81757d55a5b5..87fe8142a393 100644
--- a/arch/frv/mm/mmu-context.c
+++ b/arch/frv/mm/mmu-context.c
@@ -180,7 +180,7 @@ int cxn_pin_by_pid(pid_t pid)
 	ret = -ESRCH;
 
 	/* get a handle on the mm_struct */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	tsk = find_task_by_vpid(pid);
 	if (tsk) {
 		ret = -EINVAL;
@@ -193,7 +193,7 @@ int cxn_pin_by_pid(pid_t pid)
 		}
 		task_unlock(tsk);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	if (ret < 0)
 		return ret;
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 65bf9cd39044..bfae92433372 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1631,13 +1631,12 @@ default_monarch_init_process(struct notifier_block *self, unsigned long val, voi
 		}
 	}
 	printk("\n\n");
-	if (read_trylock(&tasklist_lock)) {
-		do_each_thread (g, t) {
-			printk("\nBacktrace of pid %d (%s)\n", t->pid, t->comm);
-			show_stack(t, NULL);
-		} while_each_thread (g, t);
-		read_unlock(&tasklist_lock);
-	}
+	tasklist_read_lock();
+	do_each_thread (g, t) {
+		printk("\nBacktrace of pid %d (%s)\n", t->pid, t->comm);
+		show_stack(t, NULL);
+	} while_each_thread (g, t);
+	tasklist_read_unlock();
 	/* FIXME: This will not restore zapped printk locks. */
 	RESTORE_LOGLEVEL(console_loglevel);
 	return NOTIFY_DONE;
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 433f5e8a2cd1..e8e283483876 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2629,14 +2629,14 @@ pfm_get_task(pfm_context_t *ctx, pid_t pid, struct task_struct **task)
 
 	if (pid != task_pid_vnr(current)) {
 
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 
 		p = find_task_by_vpid(pid);
 
 		/* make sure task cannot go away while we operate on it */
 		if (p) get_task_struct(p);
 
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 
 		if (p == NULL) return -ESRCH;
 	}
@@ -4159,7 +4159,7 @@ pfm_check_task_exist(pfm_context_t *ctx)
 	struct task_struct *g, *t;
 	int ret = -ESRCH;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 
 	do_each_thread (g, t) {
 		if (t->thread.pfm_context == ctx) {
@@ -4168,7 +4168,7 @@ pfm_check_task_exist(pfm_context_t *ctx)
 		}
 	} while_each_thread (g, t);
 out:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	DPRINT(("pfm_check_task_exist: ret=%d ctx=%p\n", ret, ctx));
 
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index b7a5fffe0924..8840b0bce2a0 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -636,7 +636,7 @@ ptrace_attach_sync_user_rbs (struct task_struct *child)
 	 * we are doing the sync.  (It can only be woken up for SIGKILL.)
 	 */
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_STOPPED &&
@@ -648,7 +648,7 @@ ptrace_attach_sync_user_rbs (struct task_struct *child)
 		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	if (!stopped)
 		return;
@@ -660,7 +660,7 @@ ptrace_attach_sync_user_rbs (struct task_struct *child)
 	 * Now move the child back into TASK_STOPPED if it should be in a
 	 * job control stop, so that SIGCONT can be used to wake it up.
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (child->sighand) {
 		spin_lock_irq(&child->sighand->siglock);
 		if (child->state == TASK_TRACED &&
@@ -669,7 +669,7 @@ ptrace_attach_sync_user_rbs (struct task_struct *child)
 		}
 		spin_unlock_irq(&child->sighand->siglock);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 }
 
 /*
diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 4b6d1f14df32..37295c82b579 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -181,12 +181,12 @@ int __cpuexit __cpu_disable(void)
 	flush_cache_all();
 	local_flush_tlb_all();
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	for_each_process(p) {
 		if (p->mm)
 			cpumask_clear_cpu(cpu, mm_cpumask(p->mm));
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	return 0;
 }
diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index fd814e08c945..7f95b10a0dac 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -163,7 +163,7 @@ asmlinkage long mipsmt_sys_sched_getaffinity(pid_t pid, unsigned int len,
 		return -EINVAL;
 
 	get_online_cpus();
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
@@ -176,7 +176,7 @@ asmlinkage long mipsmt_sys_sched_getaffinity(pid_t pid, unsigned int len,
 	cpumask_and(&mask, &p->thread.user_cpus_allowed, cpu_possible_mask);
 
 out_unlock:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	put_online_cpus();
 	if (retval)
 		return retval;
diff --git a/arch/sh/mm/asids-debugfs.c b/arch/sh/mm/asids-debugfs.c
index 74c03ecc4871..cef66537735b 100644
--- a/arch/sh/mm/asids-debugfs.c
+++ b/arch/sh/mm/asids-debugfs.c
@@ -28,7 +28,7 @@ static int asids_seq_show(struct seq_file *file, void *iter)
 {
 	struct task_struct *p;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 
 	for_each_process(p) {
 		int pid = p->pid;
@@ -41,7 +41,7 @@ static int asids_seq_show(struct seq_file *file, void *iter)
 				   cpu_asid(smp_processor_id(), p->mm));
 	}
 
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	return 0;
 }
diff --git a/arch/um/kernel/reboot.c b/arch/um/kernel/reboot.c
index ced8903921ae..f96669cc9271 100644
--- a/arch/um/kernel/reboot.c
+++ b/arch/um/kernel/reboot.c
@@ -24,7 +24,7 @@ static void kill_off_processes(void)
 		struct task_struct *p;
 		int pid;
 
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		for_each_process(p) {
 			struct task_struct *t;
 
@@ -35,7 +35,7 @@ static void kill_off_processes(void)
 			task_unlock(t);
 			os_kill_ptraced_process(pid, 1);
 		}
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 05400acbc456..188be8bf540e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -605,7 +605,7 @@ static void __tty_hangup(struct tty_struct *tty)
 	 */
 	tty_ldisc_hangup(tty);
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (tty->session) {
 		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
 			spin_lock_irq(&p->sighand->siglock);
@@ -629,7 +629,7 @@ static void __tty_hangup(struct tty_struct *tty)
 			spin_unlock_irq(&p->sighand->siglock);
 		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	spin_lock_irqsave(&tty->ctrl_lock, flags);
 	clear_bit(TTY_THROTTLED, &tty->flags);
@@ -846,9 +846,9 @@ void disassociate_ctty(int on_exit)
 	}
 
 	/* Now clear signal->tty under the lock */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	session_clear_tty(task_session(current));
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 }
 
 /**
@@ -1760,11 +1760,11 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * tty.
 	 */
 	if (tty_closing || o_tty_closing) {
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		session_clear_tty(tty->session);
 		if (o_tty)
 			session_clear_tty(o_tty->session);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 
 	mutex_unlock(&tty_mutex);
@@ -2326,9 +2326,9 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 			/*
 			 * Steal it away
 			 */
-			read_lock(&tasklist_lock);
+			tasklist_read_lock();
 			session_clear_tty(tty->session);
-			read_unlock(&tasklist_lock);
+			tasklist_read_unlock();
 		} else {
 			ret = -EPERM;
 			goto unlock;
@@ -2844,7 +2844,7 @@ void __do_SAK(struct tty_struct *tty)
 
 	tty_driver_flush_buffer(tty);
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	/* Kill the entire session */
 	do_each_pid_task(session, PIDTYPE_SID, p) {
 		printk(KERN_NOTICE "SAK: killed process %d"
@@ -2873,7 +2873,7 @@ void __do_SAK(struct tty_struct *tty)
 		}
 		task_unlock(p);
 	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 #endif
 }
 
diff --git a/fs/exec.c b/fs/exec.c
index a96a4885bbbf..b1e4539001a6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -898,11 +898,11 @@ static int de_thread(struct task_struct *tsk)
 
 		sig->notify_count = -1;	/* for exit_notify() */
 		for (;;) {
-			write_lock_irq(&tasklist_lock);
+			tasklist_write_lock();
 			if (likely(leader->exit_state))
 				break;
 			__set_current_state(TASK_KILLABLE);
-			write_unlock_irq(&tasklist_lock);
+			tasklist_write_unlock();
 			schedule();
 			if (unlikely(__fatal_signal_pending(tsk)))
 				goto killed;
@@ -959,7 +959,7 @@ static int de_thread(struct task_struct *tsk)
 		 */
 		if (unlikely(leader->ptrace))
 			__wake_up_parent(leader, leader->parent);
-		write_unlock_irq(&tasklist_lock);
+		tasklist_write_unlock();
 
 		release_task(leader);
 	}
@@ -988,11 +988,11 @@ no_thread_group:
 		memcpy(newsighand->action, oldsighand->action,
 		       sizeof(newsighand->action));
 
-		write_lock_irq(&tasklist_lock);
+		tasklist_write_lock();
 		spin_lock(&oldsighand->siglock);
 		rcu_assign_pointer(tsk->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
-		write_unlock_irq(&tasklist_lock);
+		tasklist_write_unlock();
 
 		__cleanup_sighand(oldsighand);
 	}
@@ -1002,10 +1002,10 @@ no_thread_group:
 
 killed:
 	/* protects against exit_notify() and __exit_signal() */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	return -EAGAIN;
 }
 
diff --git a/fs/fs_struct.c b/fs/fs_struct.c
index d8ac61d0c932..de9c7ea00885 100644
--- a/fs/fs_struct.c
+++ b/fs/fs_struct.c
@@ -59,7 +59,7 @@ void chroot_fs_refs(const struct path *old_root, const struct path *new_root)
 	struct fs_struct *fs;
 	int count = 0;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	do_each_thread(g, p) {
 		task_lock(p);
 		fs = p->fs;
@@ -78,7 +78,7 @@ void chroot_fs_refs(const struct path *old_root, const struct path *new_root)
 		}
 		task_unlock(p);
 	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	while (count--)
 		path_put(old_root);
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index f7ed9ee46eb9..1d55578fd530 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -604,7 +604,7 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 	struct task_struct *start, *task;
 	struct pid *pid = NULL;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 
 	start = pid_task(proc_pid(inode), PIDTYPE_PID);
 	if (!start)
@@ -650,7 +650,7 @@ get_children_pid(struct inode *inode, struct pid *pid_prev, loff_t pos)
 	}
 
 out:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	return pid;
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 69078c7cef1f..76d36b28308a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -409,11 +409,11 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	unsigned long totalpages = totalram_pages + total_swap_pages;
 	unsigned long points = 0;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (pid_alive(task))
 		points = oom_badness(task, NULL, NULL, totalpages) *
 						1000 / totalpages;
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	return sprintf(buffer, "%lu\n", points);
 }
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a32f9432666c..ea79ffaeb2d5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2966,7 +2966,7 @@ static void cgroup_enable_task_cg_lists(void)
 	 * is not guaranteed to have its child immediately visible in the
 	 * tasklist if we walk through it with RCU.
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	do_each_thread(g, p) {
 		task_lock(p);
 		/*
@@ -2978,7 +2978,7 @@ static void cgroup_enable_task_cg_lists(void)
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	write_unlock(&css_set_lock);
 }
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index b5e4ab2d427e..6cf2a3f2702a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -226,7 +226,7 @@ static inline void check_for_tasks(int cpu)
 	struct task_struct *p;
 	cputime_t utime, stime;
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	for_each_process(p) {
 		task_cputime(p, &utime, &stime);
 		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
@@ -236,7 +236,7 @@ static inline void check_for_tasks(int cpu)
 				p->comm, task_pid_nr(p), cpu,
 				p->state, p->flags);
 	}
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 }
 
 struct take_cpu_down_param {
diff --git a/kernel/exit.c b/kernel/exit.c
index 51e485ca9935..028dcdf1fd1f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -180,7 +180,7 @@ repeat:
 
 	proc_flush_task(p);
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	ptrace_release_task(p);
 	__exit_signal(p);
 
@@ -202,7 +202,7 @@ repeat:
 			leader->exit_state = EXIT_DEAD;
 	}
 
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
 
@@ -262,9 +262,9 @@ int is_current_pgrp_orphaned(void)
 {
 	int retval;
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	retval = will_become_orphaned_pgrp(task_pgrp(current), NULL);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	return retval;
 }
@@ -387,7 +387,7 @@ retry:
 		return;
 	}
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	/*
 	 * Search in the children
 	 */
@@ -413,7 +413,7 @@ retry:
 			goto assign_new_owner;
 	} while_each_thread(g, c);
 
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	/*
 	 * We found no owner yet mm_users > 1: this implies that we are
 	 * most likely racing with swapoff (try_to_unuse()) or /proc or
@@ -434,7 +434,7 @@ assign_new_owner:
 	 * Delay read_unlock() till we have the task_lock()
 	 * to ensure that c does not slip away underneath us
 	 */
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	if (c->mm != mm) {
 		task_unlock(c);
 		put_task_struct(c);
@@ -526,7 +526,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 	}
 
 	if (unlikely(pid_ns->child_reaper == father)) {
-		write_unlock_irq(&tasklist_lock);
+		tasklist_write_unlock();
 		if (unlikely(pid_ns == &init_pid_ns)) {
 			panic("Attempted to kill init! exitcode=0x%08x\n",
 				father->signal->group_exit_code ?:
@@ -534,7 +534,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		}
 
 		zap_pid_ns_processes(pid_ns);
-		write_lock_irq(&tasklist_lock);
+		tasklist_write_lock();
 	} else if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 
@@ -600,7 +600,7 @@ static void forget_original_parent(struct task_struct *father)
 	struct task_struct *p, *n, *reaper;
 	LIST_HEAD(dead_children);
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	/*
 	 * Note that exit_ptrace() and find_new_reaper() might
 	 * drop tasklist_lock and reacquire it.
@@ -622,7 +622,7 @@ static void forget_original_parent(struct task_struct *father)
 		} while_each_thread(p, t);
 		reparent_leader(father, p, &dead_children);
 	}
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 
 	BUG_ON(!list_empty(&father->children));
 
@@ -651,7 +651,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	forget_original_parent(tsk);
 	exit_task_namespaces(tsk);
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	if (group_dead)
 		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
@@ -673,7 +673,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
 		wake_up_process(tsk->signal->group_exit_task);
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 
 	/* If the process is dead, release it - nobody will wait for it */
 	if (autoreap)
@@ -1037,7 +1037,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		int why;
 
 		get_task_struct(p);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 		if ((exit_code & 0x7f) == 0) {
 			why = CLD_EXITED;
 			status = exit_code >> 8;
@@ -1121,7 +1121,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 	 * Now we are sure this task is interesting, and no other
 	 * thread can reap it because we set its state to EXIT_DEAD.
 	 */
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	retval = wo->wo_rusage
 		? getrusage(p, RUSAGE_BOTH, wo->wo_rusage) : 0;
@@ -1157,7 +1157,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		retval = pid;
 
 	if (traced) {
-		write_lock_irq(&tasklist_lock);
+		tasklist_write_lock();
 		/* We dropped tasklist, ptracer could die and untrace */
 		ptrace_unlink(p);
 		/*
@@ -1169,7 +1169,7 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 			p->exit_state = EXIT_ZOMBIE;
 			p = NULL;
 		}
-		write_unlock_irq(&tasklist_lock);
+		tasklist_write_unlock();
 	}
 	if (p != NULL)
 		release_task(p);
@@ -1255,7 +1255,7 @@ unlock_sig:
 	get_task_struct(p);
 	pid = task_pid_vnr(p);
 	why = ptrace ? CLD_TRAPPED : CLD_STOPPED;
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	if (unlikely(wo->wo_flags & WNOWAIT))
 		return wait_noreap_copyout(wo, p, pid, uid, why, exit_code);
@@ -1317,7 +1317,7 @@ static int wait_task_continued(struct wait_opts *wo, struct task_struct *p)
 
 	pid = task_pid_vnr(p);
 	get_task_struct(p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	if (!wo->wo_info) {
 		retval = wo->wo_rusage
@@ -1533,7 +1533,7 @@ repeat:
 		goto notask;
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	tsk = current;
 	do {
 		retval = do_wait_thread(wo, tsk);
@@ -1547,7 +1547,7 @@ repeat:
 		if (wo->wo_flags & __WNOTHREAD)
 			break;
 	} while_each_thread(current, tsk);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 notask:
 	retval = wo->notask_error;
diff --git a/kernel/fork.c b/kernel/fork.c
index 8d932b1c9056..827fe2e48e8c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1409,7 +1409,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->task_works = NULL;
 
 	/* Need tasklist lock for parent etc handling! */
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
@@ -1433,7 +1433,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	recalc_sigpending();
 	if (signal_pending(current)) {
 		spin_unlock(&current->sighand->siglock);
-		write_unlock_irq(&tasklist_lock);
+		tasklist_write_unlock();
 		retval = -ERESTARTNOINTR;
 		goto bad_fork_free_pid;
 	}
@@ -1469,7 +1469,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1c6023..60c2ebae8fb5 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -203,7 +203,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	 * 	  maintain a tasklist for each pid namespace.
 	 *
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	nr = next_pidmap(pid_ns, 1);
 	while (nr > 0) {
 		rcu_read_lock();
@@ -216,7 +216,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 
 		nr = next_pidmap(pid_ns, nr);
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	/* Firstly reap the EXIT_ZOMBIE children we may have. */
 	do {
@@ -298,9 +298,9 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 		return -EINVAL;
 	}
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	force_sig(SIGKILL, pid_ns->child_reaper);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	do_exit(0);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 2f1caac51a7e..bd6b59e25fff 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -309,10 +309,10 @@ static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 			error = cpu_clock_sample(which_clock,
 						 current, &rtn);
 		} else {
-			read_lock(&tasklist_lock);
+			tasklist_read_lock();
 			error = cpu_clock_sample_group(which_clock,
 						       current, &rtn);
-			read_unlock(&tasklist_lock);
+			tasklist_read_unlock();
 		}
 	} else {
 		/*
@@ -329,13 +329,13 @@ static int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *tp)
 								 p, &rtn);
 				}
 			} else {
-				read_lock(&tasklist_lock);
+				tasklist_read_lock();
 				if (thread_group_leader(p) && p->sighand) {
 					error =
 					    cpu_clock_sample_group(which_clock,
 							           p, &rtn);
 				}
-				read_unlock(&tasklist_lock);
+				tasklist_read_unlock();
 			}
 		}
 		rcu_read_unlock();
@@ -405,7 +405,7 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 	int ret = 0;
 
 	if (likely(p != NULL)) {
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * We raced with the reaping of the task.
@@ -420,7 +420,7 @@ static int posix_cpu_timer_del(struct k_itimer *timer)
 				list_del(&timer->it.cpu.entry);
 			spin_unlock(&p->sighand->siglock);
 		}
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 
 		if (!ret)
 			put_task_struct(p);
@@ -658,14 +658,14 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 
 	new_expires = timespec_to_sample(timer->it_clock, &new->it_value);
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	/*
 	 * We need the tasklist_lock to protect against reaping that
 	 * clears p->sighand.  If p has just been reaped, we can no
 	 * longer get any information about it at all.
 	 */
 	if (unlikely(p->sighand == NULL)) {
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 		put_task_struct(p);
 		timer->it.cpu.task = NULL;
 		return -ESRCH;
@@ -739,7 +739,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 		 * it as an overrun (thanks to bump_cpu_timer above).
 		 */
 		spin_unlock(&p->sighand->siglock);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 		goto out;
 	}
 
@@ -759,7 +759,7 @@ static int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	}
 
 	spin_unlock(&p->sighand->siglock);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	/*
 	 * Install the new reload setting, and
@@ -832,7 +832,7 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 		cpu_clock_sample(timer->it_clock, p, &now);
 		clear_dead = p->exit_state;
 	} else {
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		if (unlikely(p->sighand == NULL)) {
 			/*
 			 * The process has been reaped.
@@ -842,14 +842,14 @@ static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			put_task_struct(p);
 			timer->it.cpu.task = NULL;
 			timer->it.cpu.expires.sched = 0;
-			read_unlock(&tasklist_lock);
+			tasklist_read_unlock();
 			goto dead;
 		} else {
 			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead = (unlikely(p->exit_state) &&
 				      thread_group_empty(p));
 		}
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 
 	if (unlikely(clear_dead)) {
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 98088e0e71e8..58b9e9ca3c99 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -43,7 +43,7 @@ static int try_to_freeze_tasks(bool user_only)
 
 	while (true) {
 		todo = 0;
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		do_each_thread(g, p) {
 			if (p == current || !freeze_task(p))
 				continue;
@@ -51,7 +51,7 @@ static int try_to_freeze_tasks(bool user_only)
 			if (!freezer_should_skip(p))
 				todo++;
 		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 
 		if (!user_only) {
 			wq_busy = freeze_workqueues_busy();
@@ -87,13 +87,13 @@ static int try_to_freeze_tasks(bool user_only)
 		       todo - wq_busy, wq_busy);
 
 		if (!wakeup) {
-			read_lock(&tasklist_lock);
+			tasklist_read_lock();
 			do_each_thread(g, p) {
 				if (p != current && !freezer_should_skip(p)
 				    && freezing(p) && !frozen(p))
 					sched_show_task(p);
 			} while_each_thread(g, p);
-			read_unlock(&tasklist_lock);
+			tasklist_read_unlock();
 		}
 	} else {
 		printk("(elapsed %d.%02d seconds) ", elapsed_csecs / 100,
@@ -176,11 +176,11 @@ void thaw_processes(void)
 
 	thaw_workqueues();
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	do_each_thread(g, p) {
 		__thaw_task(p);
 	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	usermodehelper_enable();
 
@@ -197,12 +197,12 @@ void thaw_kernel_threads(void)
 
 	thaw_workqueues();
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	do_each_thread(g, p) {
 		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
 			__thaw_task(p);
 	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	schedule();
 	printk("done.\n");
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index acbd28424d81..f6e91cabbef8 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -184,7 +184,7 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 	 * we are sure that this is our traced child and that can only
 	 * be changed by us so it's not changing right after this.
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (child->ptrace && child->parent == current) {
 		WARN_ON(child->state == __TASK_TRACED);
 		/*
@@ -194,7 +194,7 @@ static int ptrace_check_attach(struct task_struct *child, bool ignore_state)
 		if (ignore_state || ptrace_freeze_traced(child))
 			ret = 0;
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	if (!ret && !ignore_state) {
 		if (!wait_task_inactive(child, __TASK_TRACED)) {
@@ -314,7 +314,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 	if (retval)
 		goto unlock_creds;
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
 		goto unlock_tasklist;
@@ -362,7 +362,7 @@ static int ptrace_attach(struct task_struct *task, long request,
 
 	retval = 0;
 unlock_tasklist:
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 unlock_creds:
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out:
@@ -385,7 +385,7 @@ static int ptrace_traceme(void)
 {
 	int ret = -EPERM;
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	/* Are we already being traced? */
 	if (!current->ptrace) {
 		ret = security_ptrace_traceme(current->parent);
@@ -399,7 +399,7 @@ static int ptrace_traceme(void)
 			__ptrace_link(current, current->real_parent);
 		}
 	}
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 
 	return ret;
 }
@@ -468,7 +468,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	/*
 	 * This child can be already killed. Make sure de_thread() or
 	 * our sub-thread doing do_wait() didn't do release_task() yet.
@@ -477,7 +477,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 		child->exit_code = data;
 		dead = __ptrace_detach(current, child);
 	}
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 
 	proc_ptrace_connector(child, PTRACE_DETACH);
 	if (unlikely(dead))
@@ -509,7 +509,7 @@ void exit_ptrace(struct task_struct *tracer)
 			list_add(&p->ptrace_entry, &ptrace_dead);
 	}
 
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	BUG_ON(!list_empty(&tracer->ptraced));
 
 	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
@@ -517,7 +517,7 @@ void exit_ptrace(struct task_struct *tracer)
 		release_task(p);
 	}
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8d87d7ae80a5..b6f5cdee64fe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7430,7 +7430,7 @@ static int tg_set_rt_bandwidth(struct task_group *tg,
 	int i, err = 0;
 
 	mutex_lock(&rt_constraints_mutex);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	err = __rt_schedulable(tg, rt_period, rt_runtime);
 	if (err)
 		goto unlock;
@@ -7448,7 +7448,7 @@ static int tg_set_rt_bandwidth(struct task_group *tg,
 	}
 	raw_spin_unlock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 unlock:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	mutex_unlock(&rt_constraints_mutex);
 
 	return err;
@@ -7519,9 +7519,9 @@ static int sched_rt_global_constraints(void)
 		return -EINVAL;
 
 	mutex_lock(&rt_constraints_mutex);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	ret = __rt_schedulable(NULL, 0, 0);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	mutex_unlock(&rt_constraints_mutex);
 
 	return ret;
diff --git a/kernel/signal.c b/kernel/signal.c
index 9d2b7a4b2a0b..41bae0e93a6c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1439,7 +1439,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 		return ret;
 	}
 
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (pid != -1) {
 		ret = __kill_pgrp_info(sig, info,
 				pid ? find_vpid(-pid) : task_pgrp(current));
@@ -1458,7 +1458,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 		}
 		ret = count ? retval : -ESRCH;
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	return ret;
 }
@@ -1887,7 +1887,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 	task_clear_jobctl_trapping(current);
 
 	spin_unlock_irq(&current->sighand->siglock);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (may_ptrace_stop()) {
 		/*
 		 * Notify parents of the stop.
@@ -1910,7 +1910,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		 * XXX: implement read_unlock_no_resched().
 		 */
 		preempt_disable();
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 		preempt_enable_no_resched();
 		freezable_schedule();
 	} else {
@@ -1931,7 +1931,7 @@ static void ptrace_stop(int exit_code, int why, int clear_code, siginfo_t *info)
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code = 0;
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 
 	/*
@@ -2084,9 +2084,9 @@ static bool do_signal_stop(int signr)
 		 * TASK_TRACED.
 		 */
 		if (notify) {
-			read_lock(&tasklist_lock);
+			tasklist_read_lock();
 			do_notify_parent_cldstop(current, false, notify);
-			read_unlock(&tasklist_lock);
+			tasklist_read_unlock();
 		}
 
 		/* Now we don't run again until woken by SIGCONT or SIGKILL */
@@ -2231,13 +2231,13 @@ relock:
 		 * the ptracer of the group leader too unless it's gonna be
 		 * a duplicate.
 		 */
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		do_notify_parent_cldstop(current, false, why);
 
 		if (ptrace_reparented(current->group_leader))
 			do_notify_parent_cldstop(current->group_leader,
 						true, why);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 
 		goto relock;
 	}
@@ -2484,9 +2484,9 @@ out:
 	 * should always go to the real parent of the group leader.
 	 */
 	if (unlikely(group_stop)) {
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		do_notify_parent_cldstop(tsk, false, group_stop);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 81f56445fba9..959efe8b4d31 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -190,7 +190,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 		niceval = 19;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
@@ -227,7 +227,7 @@ SYSCALL_DEFINE3(setpriority, int, which, int, who, int, niceval)
 			break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	rcu_read_unlock();
 out:
 	return error;
@@ -252,7 +252,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 		return -EINVAL;
 
 	rcu_read_lock();
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	switch (which) {
 		case PRIO_PROCESS:
 			if (who)
@@ -297,7 +297,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			break;
 	}
 out_unlock:
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	rcu_read_unlock();
 
 	return retval;
@@ -1101,7 +1101,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 	/* From this point forward we keep holding onto the tasklist lock
 	 * so that our parent does not change from under us. -DaveM
 	 */
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 
 	err = -ESRCH;
 	p = find_task_by_vpid(pid);
@@ -1149,7 +1149,7 @@ SYSCALL_DEFINE2(setpgid, pid_t, pid, pid_t, pgid)
 	err = 0;
 out:
 	/* All paths lead to here, thus we are safe. -DaveM */
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	rcu_read_unlock();
 	return err;
 }
@@ -1226,7 +1226,7 @@ SYSCALL_DEFINE0(setsid)
 	pid_t session = pid_vnr(sid);
 	int err = -EPERM;
 
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 	/* Fail if I am already a session leader */
 	if (group_leader->signal->leader)
 		goto out;
@@ -1244,7 +1244,7 @@ SYSCALL_DEFINE0(setsid)
 
 	err = session;
 out:
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	if (err > 0) {
 		proc_sid_connector(group_leader);
 		sched_autogroup_create_attach(group_leader);
@@ -1530,7 +1530,7 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 	}
 
 	/* protect tsk->signal and tsk->sighand from disappearing */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	if (!tsk->sighand) {
 		retval = -ESRCH;
 		goto out;
@@ -1575,8 +1575,8 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 			 new_rlim->rlim_cur != RLIM_INFINITY)
 		update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
-	read_unlock(&tasklist_lock);
-	return retval;
+	 tasklist_read_unlock();
+	 return retval;
 }
 
 /* rcu lock must be held */
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ab25b88aae56..0d516cd0c261 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4594,7 +4594,6 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 {
 	int i;
 	int ret = 0;
-	unsigned long flags;
 	int start = 0, end = FTRACE_RETSTACK_ALLOC_SIZE;
 	struct task_struct *g, *t;
 
@@ -4610,7 +4609,7 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 		}
 	}
 
-	read_lock_irqsave(&tasklist_lock, flags);
+	tasklist_read_lock();
 	do_each_thread(g, t) {
 		if (start == end) {
 			ret = -EAGAIN;
@@ -4628,7 +4627,7 @@ static int alloc_retstack_tasklist(struct ftrace_ret_stack **ret_stack_list)
 	} while_each_thread(g, t);
 
 unlock:
-	read_unlock_irqrestore(&tasklist_lock, flags);
+	tasklist_read_unlock();
 free:
 	for (i = start; i < end; i++)
 		kfree(ret_stack_list[i]);
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0c05a4592047..2de6132fa2de 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -732,33 +732,31 @@ static int sys_tracepoint_refcount;
 
 void syscall_regfunc(void)
 {
-	unsigned long flags;
 	struct task_struct *g, *t;
 
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
+		tasklist_read_lock();
 		do_each_thread(g, t) {
 			/* Skip kernel threads. */
 			if (t->mm)
 				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		tasklist_read_unlock();
 	}
 	sys_tracepoint_refcount++;
 }
 
 void syscall_unregfunc(void)
 {
-	unsigned long flags;
 	struct task_struct *g, *t;
 
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
+		tasklist_read_lock();
 		do_each_thread(g, t) {
 			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		tasklist_read_unlock();
 	}
 }
 #endif
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index c8d7f3110fd0..b248650f1fcc 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1323,12 +1323,12 @@ static void kmemleak_scan(void)
 	if (kmemleak_stack_scan) {
 		struct task_struct *p, *g;
 
-		read_lock(&tasklist_lock);
+		tasklist_read_lock();
 		do_each_thread(g, p) {
 			scan_block(task_stack_page(p), task_stack_page(p) +
 				   THREAD_SIZE, NULL, 0);
 		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
+		tasklist_read_unlock();
 	}
 
 	/*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index df0694c6adef..2481c8aeb71e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -407,7 +407,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 		return;
 
 	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	for_each_process (tsk) {
 		struct anon_vma_chain *vmac;
 
@@ -422,7 +422,7 @@ static void collect_procs_anon(struct page *page, struct list_head *to_kill,
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	page_unlock_anon_vma_read(av);
 }
 
@@ -437,7 +437,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	struct address_space *mapping = page->mapping;
 
 	mutex_lock(&mapping->i_mmap_mutex);
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	for_each_process(tsk) {
 		pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 
@@ -457,7 +457,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 				add_to_kill(tsk, page, vma, to_kill, tkc);
 		}
 	}
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 	mutex_unlock(&mapping->i_mmap_mutex);
 }
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 79e451a78c9e..3d9ba3d1775c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -436,7 +436,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * parent.  This attempts to lose the minimal amount of work done while
 	 * still freeing memory.
 	 */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
@@ -456,7 +456,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			}
 		}
 	} while_each_thread(p, t);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 
 	rcu_read_lock();
 	p = find_lock_task_mm(victim);
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 4b5c948eb414..7d119aee220d 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1501,7 +1501,7 @@ long keyctl_session_to_parent(void)
 
 	me = current;
 	rcu_read_lock();
-	write_lock_irq(&tasklist_lock);
+	tasklist_write_lock();
 
 	ret = -EPERM;
 	oldwork = NULL;
@@ -1550,7 +1550,7 @@ long keyctl_session_to_parent(void)
 	if (!ret)
 		newwork = NULL;
 unlock:
-	write_unlock_irq(&tasklist_lock);
+	tasklist_write_unlock();
 	rcu_read_unlock();
 	if (oldwork)
 		put_cred(container_of(oldwork, struct cred, rcu));
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2fa28c88900c..87b1b12f40a3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2226,9 +2226,9 @@ static void selinux_bprm_committed_creds(struct linux_binprm *bprm)
 
 	/* Wake up the parent if it is waiting so that it can recheck
 	 * wait permission to the new task SID. */
-	read_lock(&tasklist_lock);
+	tasklist_read_lock();
 	__wake_up_parent(current, current->real_parent);
-	read_unlock(&tasklist_lock);
+	tasklist_read_unlock();
 }
 
 /* superblock security operations */
-- 
1.8.1.3
