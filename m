Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbaCYRbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:31:24 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:43161 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbaCYRZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:25:40 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Mar 2014 13:25:40 EDT
From: Khalid Aziz <khalid.aziz@oracle.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, oleg@redhat.com, gnomes@lxorguk.ukuu.org.uk,
        riel@redhat.com, snorcht@gmail.com, dhowells@redhat.com,
        luto@amacapital.net, daeseok.youn@gmail.com, ebiederm@xmission.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2] Pre-emption control for userspace
Date: Tue, 25 Mar 2014 11:17:50 -0600
Message-Id: <1395767870-28053-1-git-send-email-khalid.aziz@oracle.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a way for a thread to request additional timeslice from
the scheduler if it is about to be preempted, so it could complete any
critical task it is in the middle of. This functionality helps with
performance on databases and has been used for many years on other OSs
by the databases. This functionality helps in situation where a thread
acquires a lock before performing a critical operation on the database,
happens to get preempted before it completes its task and releases the
lock.  This lock causes all other threads that also acquire the same
lock to perform their critical operation on the database to start
queueing up and causing large number of context switches. This queueing
problem can be avoided if the thread that acquires lock first could
request scheduler to grant it an additional timeslice once it enters its
critical section and hence allow it to complete its critical sectiona
without causing queueing problem. If critical section completes before
the thread is due for preemption, the thread can simply desassert its
request. A thread sends the scheduler this request by setting a flag in
a memory location it has shared with the kernel.  Kernel uses bytes in
the same memory location to let the thread know when its request for
amnesty from preemption has been granted. Thread should yield the
processor at the end of its critical section if it was granted amnesty
to play nice with other threads. If thread fails to yield processor, it
gets penalized by having its next amnesty request turned down by
scheduler.  Documentation file included in this patch contains further
details on how to use this functionality and conditions associated with
its use. This patch also adds a new field in scheduler statistics which
keeps track of how many times was a thread granted amnesty from
preemption. This feature and its usage are documented in
Documentation/scheduler/sched-preempt-delay.txt and this patch includes
a test for this feature under tools/testing/selftests/preempt-delay

Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
---
v2:
	- Replaced mmap operation with a more memory efficient futex
	  like communication between userspace and kernel
	- Added a flag to let userspace know if it was granted amnesty
	- Added a penalty for tasks failing to yield CPU when they
	  are granted amnesty from pre-emption

v1:
	- Initial RFC patch with mmap for communication between userspace
	  and kernel

 Documentation/scheduler/sched-preempt-delay.txt    | 121 ++++++++++
 arch/x86/Kconfig                                   |  12 +
 fs/proc/base.c                                     |  89 ++++++++
 include/linux/sched.h                              |  15 ++
 kernel/fork.c                                      |   5 +
 kernel/sched/core.c                                |   8 +
 kernel/sched/debug.c                               |   1 +
 kernel/sched/fair.c                                | 114 ++++++++-
 tools/testing/selftests/preempt-delay/Makefile     |   8 +
 .../selftests/preempt-delay/preempt-delay.c        | 254 +++++++++++++++++++++
 10 files changed, 624 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/scheduler/sched-preempt-delay.txt
 create mode 100644 tools/testing/selftests/preempt-delay/Makefile
 create mode 100644 tools/testing/selftests/preempt-delay/preempt-delay.c

diff --git a/Documentation/scheduler/sched-preempt-delay.txt b/Documentation/scheduler/sched-preempt-delay.txt
new file mode 100644
index 0000000..38b4edc
--- /dev/null
+++ b/Documentation/scheduler/sched-preempt-delay.txt
@@ -0,0 +1,121 @@
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
+enabled, the userspace process communicates with the kernel using a
+4-byte memory location in its address space. It first gives the kernel
+address for this memory location by writing its address to
+/proc/<tgid>/task/<tid>/sched_preempt_delay. This memory location is
+interpreted as a sequence of 4 bytes:
+
+	byte[0] = flag to request preemption delay
+	byte[1] = flag from kernel indicating preemption delay was granted
+	byte[2] = reserved for future use
+	byte[3] = reserved for future use
+
+Task requests a preemption delay by writing a non-zero value to the
+first byte. Scheduler checks this value before preempting the task.
+Scheduler can choose to grant one and only an additional time slice to
+the task for each delay request but this delay is not guaranteed.
+If scheduler does grant an additional timeslice, it will set the flag
+in second byte. Upon completion of the section of code where the task
+wants preemption delay, task should check the second byte. If the flag
+in second byte is set, it should clear this flag and call sched_yield()
+so as to not hog the processor. If a thread was granted additional
+timeslice and it fails to call sched_yield(), scheduler will penalize
+it by denying its next request for additional timeslice. Following sample
+code illustrates the use:
+
+int main()
+{
+	int fd, fsz;
+	unsigned char buf[256];
+	unsigned char preempt_delay[4];
+
+	sprintf(buf, “/proc/%lu/task/%lu/sched_preempt_delay”, getpid(),
+							syscall(SYS_gettid));
+	fd = open(buf, O_RDWR);
+
+	preempt_delay[0] = preempt_delay[1] = 0;
+
+	/* Tell kernel where the flag lives */
+	*(unsigned int **)buf = &preempt_delay;
+	write(fd, buf, sizeof(unsigned int *));
+
+	while (/* some condition is true */) {
+		/* do some work and get ready to enter critical section */
+		preempt_delay[0] = 1;
+		/*
+		 * Obtain lock for critical section
+		 */
+		/*
+		 * critical section
+		 */
+		/*
+		 * Release lock for critical section
+		 */
+		preempt_delay[0] = 0;
+		/* Give the CPU up if required */
+		if (preempt_delay[1]) {
+			preempt_delay[1] = 0;
+			sched_yield();
+		}
+		/* do some more work */
+	}
+	/*
+	 * Tell kernel we are done asking for preemption delay
+	 */
+	*(unsigned int **)buf = 0;
+	write(fd, buf, sizeof(unsigned int *));
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
+1. /proc/<tgid>/task/<tid>/sched_preempt_delay can be written to only
+   by the thread that corresponds to this file.
+
+2. /proc/<tgid>/task/<tid>/sched_preempt_delay can be written with valid
+   memory address once. To write a new memory address, the previous
+   memory address must be cleared first by writing NULL. Each new
+   memory address requires validation in the kernel and update of
+   pointers. Changing this address too many times creates too much
+   overhead.
+
+2. Reading /proc/<tgid>/task/<tid>/sched_preempt_delay returns the
+   current memory location address thread is using to communicate with
+   the kernel.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..2d54816 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -849,6 +849,18 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config SCHED_PREEMPT_DELAY
+	def_bool n
+	prompt "Scheduler preemption delay support"
+	depends on PROC_FS && PREEMPT_NOTIFIERS
+	---help---
+	  Say Y here if you want to be able to delay scheduler preemption
+	  when possible by setting a flag in a memory location after
+	  sharing the address of this location by writing to
+	  /proc/<tgid>/task/<tid>/sched_preempt_delay. See
+	  Documentation/scheduler/sched-preempt-delay.txt for details.
+	  If in doubt, say "N".
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b976062..f6ab240 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1304,6 +1304,92 @@ static const struct file_operations proc_pid_sched_operations = {
 
 #endif
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+static int
+tid_preempt_delay_show(struct seq_file *m, void *v)
+{
+	struct inode *inode = m->private;
+	struct task_struct *task = get_proc_task(inode);
+	unsigned char *delay_req;
+
+	if (!task)
+		return -ENOENT;
+
+	delay_req = (unsigned char *)task->sched_preempt_delay.delay_req;
+	seq_printf(m, "0x%-p\n", delay_req);
+
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
+	u32 __user *delay_req;
+	int retval;
+
+	if (!task) {
+		retval = -ENOENT;
+		goto out;
+	}
+
+	/*
+	 * A thread can write only to its corresponding preempt_delay
+	 * proc file
+	 */
+	if (current != task) {
+		retval =  -EPERM;
+		goto out;
+	}
+
+	delay_req = *(u32 __user **)buf;
+
+	/*
+	 * Do not allow write if pointer is currently set
+	 */
+	if (task->sched_preempt_delay.delay_req && (delay_req != NULL)) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Validate the pointer.
+	 */
+	if (unlikely(!access_ok(rw, delay_req, sizeof(u32)))) {
+		retval = -EFAULT;
+		goto out;
+	}
+
+	task->sched_preempt_delay.delay_req = delay_req;
+
+	/* zero out flags */
+	put_user(0, delay_req);
+
+	retval = count;
+
+out:
+	put_task_struct(task);
+	return retval;
+}
+
+static int
+tid_preempt_delay_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, tid_preempt_delay_show, inode);
+}
+
+static const struct file_operations proc_tid_preempt_delay_ops = {
+	.open		= tid_preempt_delay_open,
+	.read		= seq_read,
+	.write		= tid_preempt_delay_write,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 /*
  * Print out autogroup related information:
@@ -2999,6 +3085,9 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("gid_map",    S_IRUGO|S_IWUSR, proc_gid_map_operations),
 	REG("projid_map", S_IRUGO|S_IWUSR, proc_projid_map_operations),
 #endif
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	REG("sched_preempt_delay", S_IRUGO|S_IWUSR, proc_tid_preempt_delay_ops),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..77aba5c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1056,6 +1056,7 @@ struct sched_statistics {
 	u64			nr_wakeups_affine_attempts;
 	u64			nr_wakeups_passive;
 	u64			nr_wakeups_idle;
+	u64			nr_preempt_delayed;
 };
 #endif
 
@@ -1250,6 +1251,13 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	struct preempt_delay {
+		u32 __user *delay_req;		/* delay request flag pointer */
+		unsigned char delay_granted:1;	/* currently in delay */
+		unsigned char yield_penalty:1;	/* failure to yield penalty */
+	} sched_preempt_delay;
+#endif
 
 	pid_t pid;
 	pid_t tgid;
@@ -2061,6 +2069,13 @@ extern u64 scheduler_tick_max_deferment(void);
 static inline bool sched_can_stop_tick(void) { return false; }
 #endif
 
+#if defined(CONFIG_SCHED_PREEMPT_DELAY) && defined(CONFIG_PROC_FS)
+extern void sched_preempt_delay_show(struct seq_file *m,
+					struct task_struct *task);
+extern void sched_preempt_delay_set(struct task_struct *task,
+					unsigned char *val);
+#endif
+
 #ifdef CONFIG_SCHED_AUTOGROUP
 extern void sched_autogroup_create_attach(struct task_struct *p);
 extern void sched_autogroup_detach(struct task_struct *p);
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..8847176 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1617,6 +1617,11 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 			get_task_struct(p);
 		}
+#if CONFIG_SCHED_PREEMPT_DELAY
+		p->sched_preempt_delay.delay_req = NULL;
+		p->sched_preempt_delay.delay_granted = 0;
+		p->sched_preempt_delay.yield_penalty = 0;
+#endif
 
 		wake_up_new_task(p);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index f5c6635..ec16b4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4055,6 +4055,14 @@ SYSCALL_DEFINE0(sched_yield)
 {
 	struct rq *rq = this_rq_lock();
 
+#ifdef CONFIG_SCHED_PREEMPT_DELAY
+	/*
+	 * Clear the penalty flag for current task to reward it for
+	 * palying by the rules
+	 */
+	current->sched_preempt_delay.yield_penalty = 0;
+#endif
+
 	schedstat_inc(rq, yld_count);
 	current->sched_class->yield_task(rq);
 
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
index 9b4c4f3..142bed5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -444,6 +444,114 @@ find_matching_se(struct sched_entity **se, struct sched_entity **pse)
 
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
+	u32 __user *delay_req;
+	unsigned int delay_req_flag;
+	unsigned char *delay_flag;
+
+	/*
+	 * Check if task is using pre-emption delay feature. If address
+	 * for preemption delay request flag is not set, this task is
+	 * not using preemption delay feature, we can reschedule without
+	 * any delay
+	 */
+	delay_req = curr->sched_preempt_delay.delay_req;
+
+	if ((delay_req == NULL) || (cpu != smp_processor_id()))
+		goto resched_now;
+
+	/*
+	 * Pre-emption delay will  be granted only once. If this task
+	 * has already been granted delay, rechedule now
+	 */
+	if (curr->sched_preempt_delay.delay_granted) {
+		curr->sched_preempt_delay.delay_granted = 0;
+		goto resched_now;
+	}
+
+	/*
+	 * Get the value of preemption delay request flag from userspace.
+	 * Task had already passed us the address where the flag is stored
+	 * in userspace earlier. This flag is just like the PROCESS_PRIVATE
+	 * futex, leverage the futex code here to read the flag. If there
+	 * is a page fault accessing this flag in userspace, that means
+	 * userspace has not touched this flag recently and we can
+	 * assume no preemption delay is needed.
+	 *
+	 * If task is not requesting additional timeslice, resched now
+	 */
+	if (delay_req) {
+		int ret;
+
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(&delay_req_flag, delay_req,
+				sizeof(u32));
+		pagefault_enable();
+		delay_flag = &delay_req_flag;
+		if (ret || !delay_flag[0])
+			goto resched_now;
+	} else {
+		goto resched_now;
+	}
+
+	/*
+	 * Current thread has requested preemption delay and has not
+	 * been granted an extension yet. If this thread failed to yield
+	 * processor after being granted amnesty last time, penalize it
+	 * by not granting this delay request, otherwise give it an extra
+	 * timeslice.
+	 */
+	if (curr->sched_preempt_delay.yield_penalty) {
+		curr->sched_preempt_delay.yield_penalty = 0;
+		goto resched_now;
+	}
+
+	se = &curr->se;
+	curr->sched_preempt_delay.delay_granted = 1;
+
+	/*
+	 * Set the penalty flag for failing to yield the processor after
+	 * being granted immunity. This flag will be cleared in
+	 * sched_yield() if the thread indeed calls sched_yield
+	 */
+	curr->sched_preempt_delay.yield_penalty = 1;
+
+	/*
+	 * Let the thread know it got amnesty and it should call
+	 * sched_yield() when it is done to avoid penalty next time
+	 * it wants amnesty. We need to write to userspace location.
+	 * Since we just read from this location, chances are extremley
+	 * low we might page fault. If we do page fault, we will ignore
+	 * it and accept the cost of failed write in form of unnecessary
+	 * penalty for userspace task for not yielding processor.
+	 * This is a highly unlikely scenario.
+	 */
+	delay_flag[0] = 0;
+	delay_flag[1] = 1;
+	pagefault_disable();
+	__copy_to_user_inatomic(delay_req, &delay_req_flag, sizeof(u32));
+	pagefault_enable();
+
+	schedstat_inc(curr, se.statistics.nr_preempt_delayed);
+	return;
+
+resched_now:
+	resched_task(curr);
+}
+#else
+#define delay_resched_task(curr) resched_task(curr)
+#endif /* CONFIG_SCHED_PREEMPT_DELAY */
+
 static __always_inline
 void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec);
 
@@ -2679,7 +2787,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
+		delay_resched_task(rq_of(cfs_rq)->curr);
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2703,7 +2811,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_task(rq_of(cfs_rq)->curr);
+		delay_resched_task(rq_of(cfs_rq)->curr);
 }
 
 static void
@@ -4477,7 +4585,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_task(curr);
+	delay_resched_task(curr);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
diff --git a/tools/testing/selftests/preempt-delay/Makefile b/tools/testing/selftests/preempt-delay/Makefile
new file mode 100644
index 0000000..b2da185
--- /dev/null
+++ b/tools/testing/selftests/preempt-delay/Makefile
@@ -0,0 +1,8 @@
+all:
+	gcc -pthread preempt-delay.c -o preempt-delay -lrt
+
+run_tests: all
+	./preempt-delay 300 400
+
+clean:
+	rm -f ./preempt-delay
diff --git a/tools/testing/selftests/preempt-delay/preempt-delay.c b/tools/testing/selftests/preempt-delay/preempt-delay.c
new file mode 100644
index 0000000..59daf8f
--- /dev/null
+++ b/tools/testing/selftests/preempt-delay/preempt-delay.c
@@ -0,0 +1,254 @@
+/*
+ * This test program checks for the presence of preemption delay feature
+ * in the kernel. If the feature is present, it exercises it by running
+ * a number of threads that ask for preemption delay and checks if they
+ * are granted these preemption delays. It then runs the threads again
+ * without requesting preemption delays and verifies preemption delays
+ * are not granted when not requested (negative test).
+ */
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <time.h>
+#include <string.h>
+#include <pthread.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <sys/mman.h>
+
+#define NUMTHREADS	1000
+
+pthread_mutex_t		mylock = PTHREAD_MUTEX_INITIALIZER;
+unsigned long		iterations;
+unsigned long		delays_granted = 0;
+unsigned long		request_delay = 1;
+
+#define BUFSIZE		1024
+
+int
+feature_check()
+{
+	unsigned char buf[BUFSIZE];
+
+	sprintf(buf, "/proc/%d/task/%ld/sched_preempt_delay",
+					getpid(), syscall(SYS_gettid));
+	if (access(buf, F_OK))
+		return 1;
+	return 0;
+}
+
+void
+do_some_work(void *param)
+{
+	struct timespec timeout;
+	int i, j, tid, fd, fsz;
+	unsigned long sum;
+	unsigned char buf[BUFSIZE];
+	unsigned char delay[4];
+	int cnt = 0;
+
+	/*
+	 * mmap the sched_preempt_delay file
+	 */
+	sprintf(buf, "/proc/%d/task/%ld/sched_preempt_delay",
+					getpid(), syscall(SYS_gettid));
+	fd = open(buf, O_RDWR);
+	if (fd == -1) {
+		perror("Error opening sched_preemp_delay file");
+		return;
+	}
+
+	for (i = 0; i < 4; i++)
+		delay[i] = 0;
+
+	if (request_delay) {
+		*(unsigned int **)buf = (unsigned int *) &delay;
+		if (write(fd, buf, sizeof(unsigned int *)) < 0) {
+			perror("Error writing flag address");
+			close(fd);
+			return;
+		}
+	}
+
+	tid = *(int *) param;
+
+	for (i = 0; i < iterations; i++) {
+		/* start by locking the resource */
+		if (request_delay)
+			delay[0] = 1;
+		if (pthread_mutex_lock(&mylock)) {
+			perror("mutex_lock():");
+			delay[0] = 0;
+			return;
+		}
+
+		/* Do some busy work */
+		sum = 0;
+		for (j = 0; j < (iterations*(tid+1)); j++)
+			sum += sum;
+		for (j = 0; j < iterations/(tid+1); j++)
+			sum += i^2;
+
+		/* Now unlock the resource */
+		if (pthread_mutex_unlock(&mylock)) {
+			perror("mutex_unlock():");
+			delay[0] = 0;
+			return;
+		}
+		delay[0] = 0;
+
+		if (delay[1]) {
+			delay[1] = 0;
+			cnt++;
+			sched_yield();
+		}
+	}
+
+	if (request_delay) {
+		*(unsigned int **)buf = 0;
+		if (write(fd, buf, sizeof(unsigned int *)) < 0) {
+			perror("Error clearing flag address");
+			close(fd);
+			return;
+		}
+	}
+	close(fd);
+
+	/*
+	 * Update global count of delays granted. Need to grab a lock
+	 * since this is a global.
+	 */
+	if (pthread_mutex_lock(&mylock)) {
+		perror("mutex_lock():");
+		delay[0] = 0;
+		return;
+	}
+	delays_granted += cnt;
+	if (pthread_mutex_unlock(&mylock)) {
+		perror("mutex_unlock():");
+		delay[0] = 0;
+		return;
+	}
+}
+
+void
+help(char *progname)
+{
+	fprintf(stderr, "Usage: %s <number of threads> ", progname);
+	fprintf(stderr, "<number of iterations>\n");
+	fprintf(stderr, "   Notes: (1) Maximum number of threads is %d\n",
+								NUMTHREADS);
+	fprintf(stderr, "          (2) Suggested number of iterations is ");
+	fprintf(stderr, "300-10000\n");
+	fprintf(stderr, "          (3) Exit codes are: 1 = Failed with no ");
+	fprintf(stderr, "preemption delays granted\n");
+	fprintf(stderr, "                              2 = Failed with ");
+	fprintf(stderr, "preemption delays granted when\n");
+	fprintf(stderr, "                                  not requested\n");
+	fprintf(stderr, "                              3 = Error in test ");
+	fprintf(stderr, "arguments\n");
+	fprintf(stderr, "                              4 = Other errors\n");
+}
+
+int main(int argc, char **argv)
+{
+	pthread_t	thread[NUMTHREADS];
+	int		ret, i, tid[NUMTHREADS];
+	unsigned long	nthreads;
+
+	/* check arguments */
+	if (argc < 3) {
+		help(argv[0]);
+		exit(3);
+	}
+
+	nthreads = atoi(argv[1]);
+	iterations = atoi(argv[2]);
+	if (nthreads > NUMTHREADS) {
+		fprintf(stderr, "ERROR: exceeded maximum number of threads\n");
+		exit(3);
+	}
+
+	/*
+	 * Check for the presence of feature
+	 */
+	if (feature_check()) {
+		printf("INFO: Pre-emption delay feature is not present in ");
+		printf("this kernel\n");
+		exit(0);
+	}
+
+	/*
+	 * Create a bunch of threads that will compete for the
+	 * same mutex. Run these threads first while requesting
+	 * preemption delay.
+	 */
+	for (i = 0; i < nthreads; i++) {
+		tid[i] = i;
+		ret = pthread_create(&thread[i], NULL, (void *)&do_some_work,
+				&tid[i]);
+		if (ret) {
+			perror("pthread_create(): ");
+			exit(4);
+		}
+	}
+
+	printf("Threads started. Waiting......\n");
+	/* Now wait for threads to get done */
+	for (i = 0; i < nthreads; i++) {
+		ret = pthread_join(thread[i], NULL);
+		if (ret) {
+			perror("pthread_join(): ");
+			exit(4);
+		}
+	}
+
+	/*
+	 * We started out with requesting pre-emption delays, check if
+	 * we got at least a few.
+	 */
+	if (delays_granted == 0) {
+		fprintf(stderr, "FAIL: No delays granted at all.\n");
+		exit(1);
+	}
+
+	/*
+	 * Run the threads again, this time not requesting preemption delays
+	 */
+	request_delay = 0;
+	delays_granted = 0;
+	for (i = 0; i < nthreads; i++) {
+		tid[i] = i;
+		ret = pthread_create(&thread[i], NULL, (void *)&do_some_work,
+				&tid[i]);
+		if (ret) {
+			perror("pthread_create(): ");
+			exit(4);
+		}
+	}
+
+	printf("Threads started. Waiting......\n");
+	/* Now wait for threads to get done */
+	for (i = 0; i < nthreads; i++) {
+		ret = pthread_join(thread[i], NULL);
+		if (ret) {
+			perror("pthread_join(): ");
+			exit(4);
+		}
+	}
+
+	/*
+	 * Check if preemption delays were granted even though we
+	 * did not ask for them
+	 */
+	if (delays_granted > 0) {
+		fprintf(stderr, "FAIL: delays granted when not requested.\n");
+		exit(2);
+	}
+}
-- 
1.8.3.2

