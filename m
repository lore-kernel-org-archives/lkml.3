Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaCCSQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:16:01 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:55733
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754139AbaCCSP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:15:57 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Mar 2014 13:15:57 EST
From: Khalid Aziz <khalid.aziz@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, venki@google.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH] Pre-emption control for userspace
Date: Mon,  3 Mar 2014 11:07:13 -0700
Message-Id: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am working on a feature that has been requested by database folks that
helps with performance. Some of the oft executed database code uses
mutexes to lock other threads out of a critical section. They often see
a situation where a thread grabs the mutex, runs out of its timeslice
and gets switched out which then causes another thread to run which
tries to grab the same mutex, spins for a while and finally gives up.
This can happen with multiple threads until original lock owner gets the
CPU again and can complete executing its critical section. This queueing
and subsequent CPU cycle wastage can be avoided if the locking thread
could request to be granted an additional timeslice if its current
timeslice runs out before it gives up the lock. Other operating systems
have implemented this functionality and is used by databases as well as
JVM. This functionality has been shown to improve performance by 3%-5%.

I have implemented similar functionality for Linux. This patch adds a
file /proc/<tgid>/task/<tid>/sched_preempt_delay for each thread.
Writing 1 to this file causes CFS scheduler to grant additional time
slice if the currently running process comes up for pre-emption. Writing
to this file needs to be very quick operation, so I have implemented
code to allow mmap'ing /proc/<tgid>/task/<tid>/sched_preempt_delay. This
allows a userspace task to write this flag very quickly. Usage model is
a thread mmaps this file during initialization. It then writes a 1 to
the mmap'd file after it grabs the lock in its critical section where it
wants immunity from pre-emption. It then writes 0 again to this file
after it releases the lock and calls sched_yield() to give up the
processor. I have also added a new field in scheduler statistics -
nr_preempt_delayed, that counts the number of times a thread has been
granted amnesty. Further details on using this functionality are in 
Documentation/scheduler/sched-preempt-delay.txt in the patch. This
patch is based upon the work Venkatesh Pallipadi had done couple of
years ago.

Please provide feedback on this functionality and patch.

-- Khalid

--------------------------------

This patch adds a way for a thread to request additional timeslice from
the scheduler if it is about to be preempted, so it could complete any
critical task it is in the middle of. This functionality helps with
performance on databases and has been used for many years on other OSs
by the databases. This functionality helps in situation where a thread
acquires a lock before performing a critical operation on the database,
happens to get preempted before it completes its task and releases the
lock. This lock causes all other threads that also acquire the same
lock to perform their critical operation on the database to start
queueing up and causing large number of context switches. This queueing
problem can be avoided if the thread that acquires lock first could
request scheduler to grant it an additional timeslice once it enters
its critical section and hence allow it to complete its critical sectiona
without causing queueing problem. If critical section completes before
the thread is due for preemption, the thread can simply desassert its
request. A thread sends the scheduler this request through a proc file
which it can mmap and write to with very little overhead. Documentation
file included in this patch contains further details on how to use this
functionality and conditions associated with its use. This patch also
adds a new field in scheduler statistics which keeps track of how many
times was a thread granted amnesty from preemption.

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
 Documentation/scheduler/sched-preempt-delay.txt |  85 ++++++++++++
 arch/x86/Kconfig                                |  10 ++
 fs/proc/base.c                                  | 173 ++++++++++++++++++++++++
 include/linux/preempt_delay.h                   |  37 +++++
 include/linux/sched.h                           |  12 ++
 kernel/exit.c                                   |   9 ++
 kernel/fork.c                                   |   7 +
 kernel/sched/Makefile                           |   1 +
 kernel/sched/debug.c                            |   1 +
 kernel/sched/fair.c                             |  59 +++++++-
 kernel/sched/preempt_delay.c                    |  39 ++++++
 11 files changed, 430 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/scheduler/sched-preempt-delay.txt
 create mode 100644 include/linux/preempt_delay.h
 create mode 100644 kernel/sched/preempt_delay.c

diff --git a/Documentation/scheduler/sched-preempt-delay.txt b/Documentation/scheduler/sched-preempt-delay.txt
new file mode 100644
index 0000000..aa7e611
--- /dev/null
+++ b/Documentation/scheduler/sched-preempt-delay.txt
@@ -0,0 +1,85 @@
+=================================
+What is preemption delay feature?
+=================================
+
+There are times when a userspace task is executing a critical section
+which gates a number of other tasks that want access to the same
+critical section. If the task holding the lock that guards this critical
+section is preempted by the scheduler in the middle of its critical
+section because its timeslice is up, scheduler ends up scheduling other
+threads which immediately try to grab the lock to enter the critical
+section. This only results in lots of context changes are tasks wake up
+and go to sleep immediately again. If on the other hand, the original
+task were allowed to run for an extra timeslice, it could have completed
+executing its critical section allowing other tasks to make progress
+when they get scheduled. Preemption delay feature allows a task to
+request scheduler to grant it one extra timeslice, if possible.
+
+
+==================================
+Using the preemption delay feature
+==================================
+
+This feature is enabled in the kernel by setting
+CONFIG_SCHED_PREEMPT_DELAY in kernel configuration. Once this feature is
+enabled, kernel creates a file
+/proc/<tgid>/task/<tid>/sched_preempt_delay. This file can be mmapped by
+the task. This file contains a single long value which is a flag to
+indicate if the task is requesting a preemption delay or not. Task
+requests a preemption delay by writing a non-zero value to this file.
+Scheduler checks this value before preempting the task. Scheduler can
+choose to grant one and only an additional time slice to the task for
+each delay request. Scheduler will clear this flag when it makes
+decision to grant or not grant the delay request. Following sample code
+illustrates the use:
+
+int main()
+{
+	int fd, fsz;
+	unsigned char fn[256];
+	unsigned long *map;
+
+	sprintf(fn, “/proc/%lu/task/%lu/sched_preempt_delay”, getpid(), syscall(SYS_gettid));
+	fd = open(fn, O_RDWR);
+	fsz = sysconf(_SC_PAGE_SIZE);
+	map = mmap(NULL, fsz, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	while (/* some condition is true */) {
+		/* do some work and get ready to enter critical section */
+		map[0] = 1;
+		/*
+		 * critical section
+		 */
+		map[0] = 0;
+		/* Give the CPU up */
+		sched_yield();
+		/* do some more work */
+	}
+	munmap(map, fsz);
+	close(fd);
+}
+
+
+====================
+Scheduler statistics
+====================
+
+Preemption delay features adds a new field to scheduler statictics -
+nr_preempt_delayed. This is a per thread statistic that tracks the
+number of times a thread was granted amnesty from preemption when it
+requested for one. "cat /proc/<pid>/task/<tid>/sched" will list this
+number along with other scheduler statistics.
+
+
+=====
+Notes
+=====
+
+1. /proc/<tgid>/task/<tid>/sched_preempt_delay can be mmap'd by only
+   one task at a time.
+
+2. Once mmap'd, /proc/<tgid>/task/<tid>/sched_preempt_delay can be written
+   to only by the task that mmap'd it. Reading
+   /proc/<tgid>/task/<tid>/sched_preempt_delay will continue to return the
+   current value.
+
+3. Upon mmap, /proc/<tgid>/task/<tid>/sched_preempt_delay is set to 0.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..ee10019 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -849,6 +849,16 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_PREEMPT_DELAY
+	def_bool n
+	prompt "Scheduler preemption delay support"
+	depends on PROC_FS && PREEMPT_NOTIFIERS
+	---help---
+	  Say Y here if you want to be able to delay scheduler preemption
+	  when possible by writing to
+	  /proc/<tgid>/task/<tid>/sched_preempt_delay.
+	  If in doubt, say "N".
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5150706..902d07f 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1304,6 +1304,176 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+static int
+tid_preempt_delay_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ENOENT;
+
+	sched_preempt_delay_show(m, task);
+	put_task_struct(task);
+	return 0;
+}
+
+static ssize_t
+tid_preempt_delay_write(struct file *file, const char __user *buf,
+			  size_t count, loff_t *offset)
+{
+	struct inode *inode = file_inode(file);
+	struct task_struct *task = get_proc_task(inode);
+
+	if (!task)
+		return -ENOENT;
+
+	/*
+	 * Do not allow write if proc file is currently mmap'd
+	 */
+	if (task->sched_preempt_delay.mmap_state)
+		return -EPERM;
+
+	sched_preempt_delay_set(task, buf[0]);
+	put_task_struct(task);
+	return count;
+}
+
+static int
+tid_preempt_delay_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, tid_preempt_delay_show, inode);
+}
+
+static int
+fault_preempt_delay_vmops(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct preemp_delay_mmap_state *state;
+
+	state = (struct preemp_delay_mmap_state *) vma->vm_private_data;
+	if (!state)
+		return VM_FAULT_SIGBUS;
+
+	if (vmf->flags & FAULT_FLAG_MKWRITE) {
+		SetPageUptodate(state->page);
+		return 0;
+	}
+
+	get_page(state->page);
+	vmf->page = state->page;
+	vmf->page->mapping = vma->vm_file->f_mapping;
+	vmf->page->index = vmf->pgoff;
+
+	return 0;
+}
+
+static void
+close_preempt_delay_vmops(struct vm_area_struct *vma)
+{
+	struct preemp_delay_mmap_state *state;
+
+	state = (struct preemp_delay_mmap_state *) vma->vm_private_data;
+	BUG_ON(!state || !state->task);
+
+	state->page->mapping = NULL;
+	/* point delay request flag pointer back to old flag in task_struct */
+	state->task->sched_preempt_delay.delay_req =
+			&state->task->sched_preempt_delay.delay_flag;
+	state->task->sched_preempt_delay.mmap_state = NULL;
+	vfree(state->kaddr);
+	kfree(state);
+	vma->vm_private_data = NULL;
+}
+
+static const struct vm_operations_struct preempt_delay_vmops = {
+	.fault		= fault_preempt_delay_vmops,
+	.page_mkwrite	= fault_preempt_delay_vmops,
+	.close		= close_preempt_delay_vmops,
+};
+
+
+static int
+tid_preempt_delay_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	int retval = 0;
+	void *kaddr = NULL;
+	struct preemp_delay_mmap_state *state = NULL;
+	struct inode *inode = file_inode(file);
+	struct task_struct *task;
+	struct page *page;
+
+	/*
+	 * Validate args:
+	 * - Only offset 0 support for now
+	 * - size should be PAGE_SIZE
+	 */
+	if (vma->vm_pgoff != 0 || (vma->vm_end - vma->vm_start) != PAGE_SIZE) {
+		retval = -EINVAL;
+		goto error;
+	}
+
+	/*
+	 * Only one mmap allowed at a time
+	 */
+	if (current->sched_preempt_delay.mmap_state != NULL) {
+		retval = -EEXIST;
+		goto error;
+	}
+
+	state = kzalloc(sizeof(struct preemp_delay_mmap_state), GFP_KERNEL);
+	kaddr = vmalloc_user(PAGE_SIZE);
+	if (!state || !kaddr) {
+		retval = -ENOMEM;
+		goto error;
+	}
+
+	page = vmalloc_to_page(kaddr);
+	if (!page) {
+		retval = -ENOMEM;
+		goto error;
+	}
+	/*
+	 * This mmap belongs to the thread that owns the preemption
+	 * delay request flag, not to other threads that may belong to
+	 * the same process.
+	 */
+	task = get_proc_task(inode);
+	state->page = page;
+	state->kaddr = kaddr;
+	state->uaddr = (void *)vma->vm_start;
+	state->task = task;
+
+	/* Clear the current delay request flag */
+	task->sched_preempt_delay.delay_flag = 0;
+
+	/* Point delay request flag pointer to the newly allocated memory */
+	task->sched_preempt_delay.delay_req = (unsigned char *)kaddr;
+
+	task->sched_preempt_delay.mmap_state = state;
+	vma->vm_private_data = state;
+	vma->vm_ops = &preempt_delay_vmops;
+	vma->vm_flags |= VM_DONTCOPY | VM_DONTEXPAND | VM_SHARED | VM_WRITE;
+
+	return 0;
+
+error:
+	kfree(state);
+	if (kaddr)
+		vfree(kaddr);
+	return retval;
+}
+
+static const struct file_operations proc_tid_preempt_delay_ops = {
+	.open		= tid_preempt_delay_open,
+	.read		= seq_read,
+	.write		= tid_preempt_delay_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.mmap		= tid_preempt_delay_mmap,
+};
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 /*
  * Print out autogroup related information:
@@ -2998,6 +3168,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	REG("sched_preempt_delay", S_IRUGO|S_IWUSR, proc_tid_preempt_delay_ops),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/preempt_delay.h b/include/linux/preempt_delay.h
new file mode 100644
index 0000000..70caa81
--- /dev/null
+++ b/include/linux/preempt_delay.h
@@ -0,0 +1,37 @@
+#ifndef __PREEMPT_DELAY_H__
+#define __PREEMPT_DELAY_H__
+
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+/*
+ * struct preempt_delay is part of task struct. It keeps the status
+ * of current request flag, if the request has been granted and a
+ * pointer to strtcure that holds data needed for mmap. This structure
+ * has a variable to hold the delay request flag and a pointer to
+ * the delay request flag. When a new task is initialized, delay_req
+ * pointer points to delay_flag elemnt in this structure. This pointer
+ * is changed when mmap happens on /proc/<pid>/task/<tid>/sched_preempt_delay.
+ * Since procfs works on the granularity of a page size, it makes no sense
+ * to allocate a whole page for each task to hold just a flag. So
+ * initially delay_req pointer points to a single unsigned char sized
+ * variable. When mmap happens, a page is allocated and this pointer
+ * is redirected to the newly allocated page for mmap. Race is not much
+ * of an issue since delay_req always points to a valid memory address.
+ * mmap operation always causes task to start with a request flag value
+ * of 0, so old value of the flag is irrelevant. munmap will point
+ * delay_req back to delay_flag.
+ */
+struct preempt_delay {
+	unsigned char *delay_req;	/* delay request flag pointer */
+	unsigned char delay_flag;	/* delay request flag */
+	unsigned char delay_granted;	/* currently in delay */
+	struct preemp_delay_mmap_state *mmap_state;
+};
+
+struct preemp_delay_mmap_state {
+	void *kaddr;			/* kernel vmalloc access addr */
+	void *uaddr;			/* user mapped address */
+	struct page *page;
+	struct task_struct *task;
+};
+#endif /* CONFIG_SCHED_PREEMPT_DELAY */
+#endif /* __PREEMPT_DELAY_H__ */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..eeaf7f3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -54,6 +54,7 @@ struct sched_param {
 #include <linux/llist.h>
 #include <linux/uidgid.h>
 #include <linux/gfp.h>
+#include <linux/preempt_delay.h>
 
 #include <asm/processor.h>
 
@@ -1056,6 +1057,7 @@ struct sched_statistics {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+	u64			nr_preempt_delayed;
 };
 #endif
 
@@ -1250,6 +1252,9 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	struct preempt_delay sched_preempt_delay;
+#endif
 
 	pid_t pid;
 	pid_t tgid;
@@ -2061,6 +2066,13 @@ extern u64 scheduler_tick_max_deferment(void);
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
 
+#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
+extern void sched_preempt_delay_show(struct seq_file *m,
+					struct task_struct *task);
+extern void sched_preempt_delay_set(struct task_struct *task,
+					unsigned char val);
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/kernel/exit.c b/kernel/exit.c
index 1e77fc6..b7e4dbf 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -53,6 +53,7 @@
 #include <linux/oom.h>
 #include <linux/writeback.h>
 #include <linux/shm.h>
+#include <linux/preempt_delay.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -721,6 +722,14 @@ void do_exit(long code)
 
 	validate_creds_for_do_exit(tsk);
 
+#if CONFIG_SCHED_PREEMPT_DELAY
+	if (tsk->sched_preempt_delay.mmap_state) {
+		sys_munmap((unsigned long)
+			tsk->sched_preempt_delay.mmap_state->uaddr, PAGE_SIZE);
+		vfree(tsk->sched_preempt_delay.mmap_state->kaddr);
+		kfree(tsk->sched_preempt_delay.mmap_state);
+	}
+#endif
 	/*
 	 * We're taking recursive faults here in do_exit. Safest is to just
 	 * leave this task alone and wait for reboot.
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..94b65c0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -71,6 +71,7 @@
 #include <linux/signalfd.h>
 #include <linux/uprobes.h>
 #include <linux/aio.h>
+#include <linux/preempt_delay.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -1617,6 +1618,12 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 			get_task_struct(p);
 		}
+#if CONFIG_SCHED_PREEMPT_DELAY
+		p->sched_preempt_delay.delay_req =
+				&p->sched_preempt_delay.delay_flag;
+		p->sched_preempt_delay.delay_flag = 0;
+		p->sched_preempt_delay.delay_granted = 0;
+#endif
 
 		wake_up_new_task(p);
 
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 9a95c8c..b2582fe 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_SCHED_PREEMPT_DELAY) += preempt_delay.o
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index dd52e7f..2abd02b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -602,6 +602,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	P(se.statistics.nr_wakeups_affine_attempts);
 	P(se.statistics.nr_wakeups_passive);
 	P(se.statistics.nr_wakeups_idle);
+	P(se.statistics.nr_preempt_delayed);
 
 	{
 		u64 avg_atom, avg_per_cpu;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7815709..4250733 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -29,6 +29,7 @@
 #include <linux/mempolicy.h>
 #include <linux/migrate.h>
 #include <linux/task_work.h>
+#include <linux/preempt_delay.h>
 
 #include <trace/events/sched.h>
 
@@ -444,6 +445,58 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+/*
+ * delay_resched_task(): Check if the task about to be preempted has
+ *	requested an additional time slice. If it has, grant it additional
+ *	timeslice once.
+ */
+static void
+delay_resched_task(struct task_struct *curr)
+{
+	struct sched_entity *se;
+	int cpu = task_cpu(curr);
+	unsigned char *delay_req;
+
+	if (cpu != smp_processor_id())
+		goto resched_now;
+
+	/*
+	 * Pre-emption delay will  be granted only once. If this task
+	 * has already been granted delay, rechedule now
+	 */
+	delay_req = curr->sched_preempt_delay.delay_req;
+	if (curr->sched_preempt_delay.delay_granted) {
+		curr->sched_preempt_delay.delay_granted = 0;
+		if (delay_req)
+			*delay_req = 0;
+		goto resched_now;
+	}
+
+	/* If task is not requestin additional timeslice, resched now */
+	if (delay_req && (*delay_req == 0))
+		goto resched_now;
+
+	/*
+	 * Current thread has requested preemption delay and has not
+	 * been granted an extension yet. Give it an extra timeslice.
+	 */
+	se = &curr->se;
+	curr->sched_preempt_delay.delay_granted = 1;
+	schedstat_inc(curr, se.statistics.nr_preempt_delayed);
+	return;
+
+resched_now:
+	resched_task(curr);
+}
+#else
+static void
+delay_resched_task(struct task_struct *curr)
+{
+	resched_task(curr);
+}
+#endif /* CONFIG_SCHED_PREEMPT_DELAY */
+
 static __always_inline
 void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
@@ -2679,7 +2732,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
+		delay_resched_task(rq_of(cfs_rq)->curr);
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2703,7 +2756,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_task(rq_of(cfs_rq)->curr);
+		delay_resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -4477,7 +4530,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_task(curr);
+	delay_resched_task(curr);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
diff --git a/kernel/sched/preempt_delay.c b/kernel/sched/preempt_delay.c
new file mode 100644
index 0000000..a8b1c1e
--- /dev/null
+++ b/kernel/sched/preempt_delay.c
@@ -0,0 +1,39 @@
+/*
+ * preempt_delay.c - Facility to allow tasks to request additional
+ *		     timeslice from the scheduler at scheduler's discretion
+ * Copyright (C) 2013 Khalid Aziz <khalid.aziz@oracle.com>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ *
+ * CONFIG_SCHED_PREEMPT_DELAY infrastructure creates a proc file
+ * /proc/<pid>/task/<tid>/sched_preempt_delay which allows a task to
+ * signal to the scheduler to grant it an extra timeslice once if the
+ * task is about to be pre-empted, by writing a 1 to the file. This
+ * file includes the code to support reading from and writing to this
+ * proc file.
+ */
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+#include "sched.h"
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/preempt_delay.h>
+
+void
+sched_preempt_delay_show(struct seq_file *m, struct task_struct *task)
+{
+	unsigned char *delay_req = task->sched_preempt_delay.delay_req;
+
+	if (delay_req)
+		seq_printf(m, "%d\n", *delay_req);
+}
+
+void
+sched_preempt_delay_set(struct task_struct *task, unsigned char val)
+{
+	unsigned char *delay_req = task->sched_preempt_delay.delay_req;
+
+	if (delay_req)
+		*delay_req = (val != '0'?1:0);
+}
+#endif
-- 
1.8.3.2

