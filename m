Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3K0NYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:24:01 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:40727 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3K0NX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:23:59 -0500
Date: Wed, 27 Nov 2013 14:23:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new ABI)
Message-ID: <20131127132354.GA18422@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juri Lelli <juri.lelli@gmail.com> wrote:

> + * @__unused		padding to allow future expansion without ABI issues
> + */
> +struct sched_param2 {
> +	int sched_priority;
> +	unsigned int sched_flags;
> +	u64 sched_runtime;
> +	u64 sched_deadline;
> +	u64 sched_period;
> +
> +	u64 __unused[12];
> +};

So this really needs to use s32/u32.

But the bigger problem is that this is a rather dumb ABI which copies 
128 bytes unconditionally. That will be enough up to the point we run 
out of it.

Instead I think what we want is a simple yet extensible ABI where the 
size of the parameters is part of the structure itself - which acts as 
a natural 'version'.

We already have such an extensible syscall implementation, see 
sys_perf_event_open in kernel/events/core.c: bits of which could be 
factored out to make all this easier and more robust.

To make this auto-versioning property more apparent I'd suggest a 
rename of the syscalls as well: sys_sched_setattr(), 
sys_sched_getattr(), or so.

The compatibility principle is: there's a 'struct sched_attr' with a 
sched_attr::size field (plus the fields above, and no padding). The 
sched_attr::size field us the structure size user-space expects.

There are 3 main compatibility cases:

 - the kernel's 'sizeof sched_attr' is equal to sched_attr:size: the 
   kernel version and user-space version matches, it's a straight ABI 
   in this case with full functionality.

 - the kernel's 'sizeof sched_attr' is larger than sched_attr::size 
   [the kernel is newer than what user-space was built for], in this 
   case the kernel assumes that all remaining values are zero and acts
   accordingly.

 - the kernel's 'sizeof sched_attr' is smaller than sched_attr::size 
   [the kernel is older than what user-space was built for]. In this 
   case the kernel should return -ENOSYS if any of the additional 
   fields are nonzero. If those are all zero then it will work as if a 
   smaller structure was passed in.

This ensures maximal upwards and downwards compatibility and keeps the 
syscall ABI compat yet extensible. The ABI is the quickest when tool 
version matches kernel version - but that's the typical case for 
distros. Yet even the mismatching versions work fine and the ABI is 
kept.

( See kernel/events/core.c for more details. Some of the helpers there
  should be factored out to allow easier support for such syscalls. )

Note that I did a few other small fixes to the changelog and to the 
code as well - see the patch attached below - please work based on 
this version.

Thanks,

	Ingo

======================>
Subject: sched: Add 3 new scheduler syscalls to support an extended scheduling parameters ABI
From: Dario Faggioli <raistlin@linux.it>
Date: Thu, 7 Nov 2013 14:43:36 +0100

Add the syscalls needed for supporting scheduling algorithms
with extended scheduling parameters (e.g., SCHED_DEADLINE).

In general, it makes possible to specify a periodic/sporadic task,
that executes for a given amount of runtime at each instance, and is
scheduled according to the urgency of their own timing constraints,
i.e.:

 - a (maximum/typical) instance execution time,
 - a minimum interval between consecutive instances,
 - a time constraint by which each instance must be completed.

Thus, both the data structure that holds the scheduling parameters of
the tasks and the system calls dealing with it must be extended.
Unfortunately, modifying the existing struct sched_param would break
the ABI and result in potentially serious compatibility issues with
legacy binaries.

For these reasons, this patch:

 - defines the new struct sched_param2, containing all the fields
   that are necessary for specifying a task in the computational
   model described above;
 - defines and implements the new scheduling related syscalls that
   manipulate it, i.e., sched_setscheduler2(), sched_setparam2()
   and sched_getparam2().

Syscalls are introduced for x86 (32 and 64 bits) and ARM only, as a
proof of concept and for developing and testing purposes. Making them
available on other architectures is straightforward.

Since no "user" for these new parameters is introduced in this patch,
the implementation of the new system calls is just identical to their
already existing counterpart. Future patches that implement scheduling
policies able to exploit the new data structure must also take care of
modifying the *2() calls accordingly with their own purposes.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: bruce.ashfield@windriver.com
Cc: claudio@evidence.eu.com
Cc: darren@dvhart.com
Cc: dhaval.giani@gmail.com
Cc: fchecconi@gmail.com
Cc: fweisbec@gmail.com
Cc: harald.gustafsson@ericsson.com
Cc: hgu1972@gmail.com
Cc: insop.song@gmail.com
Cc: jkacur@redhat.com
Cc: johan.eker@ericsson.com
Cc: liming.wang@windriver.com
Cc: luca.abeni@unitn.it
Cc: michael@amarulasolutions.com
Cc: nicola.manica@disi.unitn.it
Cc: oleg@redhat.com
Cc: paulmck@linux.vnet.ibm.com
Cc: p.faure@akatech.ch
Cc: rostedt@goodmis.org
Cc: tommaso.cucinotta@sssup.it
Cc: vincent.guittot@linaro.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1383831828-15501-3-git-send-email-juri.lelli@gmail.com
[ Twiddled the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arm/include/asm/unistd.h      |    2 
 arch/arm/include/uapi/asm/unistd.h |    3 +
 arch/arm/kernel/calls.S            |    3 +
 arch/x86/syscalls/syscall_32.tbl   |    3 +
 arch/x86/syscalls/syscall_64.tbl   |    3 +
 include/linux/sched.h              |   50 +++++++++++++++++
 include/linux/syscalls.h           |    7 ++
 kernel/sched/core.c                |  106 +++++++++++++++++++++++++++++++++++--
 8 files changed, 173 insertions(+), 4 deletions(-)

Index: tip/arch/arm/include/asm/unistd.h
===================================================================
--- tip.orig/arch/arm/include/asm/unistd.h
+++ tip/arch/arm/include/asm/unistd.h
@@ -15,7 +15,7 @@
 
 #include <uapi/asm/unistd.h>
 
-#define __NR_syscalls  (380)
+#define __NR_syscalls  (383)
 #define __ARM_NR_cmpxchg		(__ARM_NR_BASE+0x00fff0)
 
 #define __ARCH_WANT_STAT64
Index: tip/arch/arm/include/uapi/asm/unistd.h
===================================================================
--- tip.orig/arch/arm/include/uapi/asm/unistd.h
+++ tip/arch/arm/include/uapi/asm/unistd.h
@@ -406,6 +406,9 @@
 #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
 #define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
+#define __NR_sched_setscheduler2	(__NR_SYSCALL_BASE+380)
+#define __NR_sched_setparam2		(__NR_SYSCALL_BASE+381)
+#define __NR_sched_getparam2		(__NR_SYSCALL_BASE+382)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
Index: tip/arch/arm/kernel/calls.S
===================================================================
--- tip.orig/arch/arm/kernel/calls.S
+++ tip/arch/arm/kernel/calls.S
@@ -389,6 +389,9 @@
 		CALL(sys_process_vm_writev)
 		CALL(sys_kcmp)
 		CALL(sys_finit_module)
+/* 380 */	CALL(sys_sched_setscheduler2)
+		CALL(sys_sched_setparam2)
+		CALL(sys_sched_getparam2)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
Index: tip/arch/x86/syscalls/syscall_32.tbl
===================================================================
--- tip.orig/arch/x86/syscalls/syscall_32.tbl
+++ tip/arch/x86/syscalls/syscall_32.tbl
@@ -357,3 +357,6 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
+351	i386	sched_setparam2		sys_sched_setparam2
+352	i386	sched_getparam2		sys_sched_getparam2
+353	i386	sched_setscheduler2	sys_sched_setscheduler2
Index: tip/arch/x86/syscalls/syscall_64.tbl
===================================================================
--- tip.orig/arch/x86/syscalls/syscall_64.tbl
+++ tip/arch/x86/syscalls/syscall_64.tbl
@@ -320,6 +320,9 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
+314	common	sched_setparam2		sys_sched_setparam2
+315	common	sched_getparam2		sys_sched_getparam2
+316	common	sched_setscheduler2	sys_sched_setscheduler2
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
Index: tip/include/linux/sched.h
===================================================================
--- tip.orig/include/linux/sched.h
+++ tip/include/linux/sched.h
@@ -56,6 +56,54 @@ struct sched_param {
 
 #include <asm/processor.h>
 
+/*
+ * Extended scheduling parameters data structure.
+ *
+ * This is needed because the original struct sched_param can not be
+ * altered without introducing ABI issues with legacy applications
+ * (e.g., in sched_getparam()).
+ *
+ * However, the possibility of specifying more than just a priority for
+ * the tasks may be useful for a wide variety of application fields, e.g.,
+ * multimedia, streaming, automation and control, and many others.
+ *
+ * This variant (sched_param2) is meant at describing a so-called
+ * sporadic time-constrained task. In such model a task is specified by:
+ *  - the activation period or minimum instance inter-arrival time;
+ *  - the maximum (or average, depending on the actual scheduling
+ *    discipline) computation time of all instances, a.k.a. runtime;
+ *  - the deadline (relative to the actual activation time) of each
+ *    instance.
+ * Very briefly, a periodic (sporadic) task asks for the execution of
+ * some specific computation --which is typically called an instance--
+ * (at most) every period. Moreover, each instance typically lasts no more
+ * than the runtime and must be completed by time instant t equal to
+ * the instance activation time + the deadline.
+ *
+ * This is reflected by the actual fields of the sched_param2 structure:
+ *
+ *  @sched_priority     task's priority (might still be useful)
+ *  @sched_deadline     representative of the task's deadline
+ *  @sched_runtime      representative of the task's runtime
+ *  @sched_period       representative of the task's period
+ *  @sched_flags        for customizing the scheduler behaviour
+ *
+ * Given this task model, there are a multiplicity of scheduling algorithms
+ * and policies, that can be used to ensure all the tasks will make their
+ * timing constraints.
+ *
+ * @__unused		padding to allow future expansion without ABI issues
+ */
+struct sched_param2 {
+	int sched_priority;
+	unsigned int sched_flags;
+	u64 sched_runtime;
+	u64 sched_deadline;
+	u64 sched_period;
+
+	u64 __unused[12];
+};
+
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
@@ -1961,6 +2009,8 @@ extern int sched_setscheduler(struct tas
 			      const struct sched_param *);
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
+extern int sched_setscheduler2(struct task_struct *, int,
+				 const struct sched_param2 *);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
Index: tip/include/linux/syscalls.h
===================================================================
--- tip.orig/include/linux/syscalls.h
+++ tip/include/linux/syscalls.h
@@ -38,6 +38,7 @@ struct rlimit;
 struct rlimit64;
 struct rusage;
 struct sched_param;
+struct sched_param2;
 struct sel_arg_struct;
 struct semaphore;
 struct sembuf;
@@ -277,11 +278,17 @@ asmlinkage long sys_clock_nanosleep(cloc
 asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setscheduler2(pid_t pid, int policy,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_setparam2(pid_t pid,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
+asmlinkage long sys_sched_getparam2(pid_t pid,
+					struct sched_param2 __user *param);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
Index: tip/kernel/sched/core.c
===================================================================
--- tip.orig/kernel/sched/core.c
+++ tip/kernel/sched/core.c
@@ -3025,7 +3025,8 @@ static bool check_same_owner(struct task
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param *param, bool user)
+				const struct sched_param2 *param,
+				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
 	unsigned long flags;
@@ -3190,10 +3191,20 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, true);
+	struct sched_param2 param2 = {
+		.sched_priority = param->sched_priority
+	};
+	return __sched_setscheduler(p, policy, &param2, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
+int sched_setscheduler2(struct task_struct *p, int policy,
+			  const struct sched_param2 *param2)
+{
+	return __sched_setscheduler(p, policy, param2, true);
+}
+EXPORT_SYMBOL_GPL(sched_setscheduler2);
+
 /**
  * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
  * @p: the task in question.
@@ -3210,7 +3221,10 @@ EXPORT_SYMBOL_GPL(sched_setscheduler);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	return __sched_setscheduler(p, policy, param, false);
+	struct sched_param2 param2 = {
+		.sched_priority = param->sched_priority
+	};
+	return __sched_setscheduler(p, policy, &param2, false);
 }
 
 static int
@@ -3235,6 +3249,31 @@ do_sched_setscheduler(pid_t pid, int pol
 	return retval;
 }
 
+static int
+do_sched_setscheduler2(pid_t pid, int policy,
+			 struct sched_param2 __user *param2)
+{
+	struct sched_param2 lparam2;
+	struct task_struct *p;
+	int retval;
+
+	if (!param2 || pid < 0)
+		return -EINVAL;
+
+	memset(&lparam2, 0, sizeof(struct sched_param2));
+	if (copy_from_user(&lparam2, param2, sizeof(struct sched_param2)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (p != NULL)
+		retval = sched_setscheduler2(p, policy, &lparam2);
+	rcu_read_unlock();
+
+	return retval;
+}
+
 /**
  * sys_sched_setscheduler - set/change the scheduler policy and RT priority
  * @pid: the pid in question.
@@ -3254,6 +3293,21 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_
 }
 
 /**
+ * sys_sched_setscheduler2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @policy: new policy (could use extended sched_param).
+ * @param: structure containg the extended parameters.
+ */
+SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
+		struct sched_param2 __user *, param2)
+{
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler2(pid, policy, param2);
+}
+
+/**
  * sys_sched_setparam - set/change the RT priority of a thread
  * @pid: the pid in question.
  * @param: structure containing the new RT priority.
@@ -3266,6 +3320,17 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, p
 }
 
 /**
+ * sys_sched_setparam2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @param2: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE2(sched_setparam2, pid_t, pid,
+		struct sched_param2 __user *, param2)
+{
+	return do_sched_setscheduler2(pid, -1, param2);
+}
+
+/**
  * sys_sched_getscheduler - get the policy (scheduling class) of a thread
  * @pid: the pid in question.
  *
@@ -3331,6 +3396,41 @@ SYSCALL_DEFINE2(sched_getparam, pid_t, p
 	return retval;
 
 out_unlock:
+	rcu_read_unlock();
+	return retval;
+}
+
+/**
+ * sys_sched_getparam2 - same as above, but with extended sched_param
+ * @pid: the pid in question.
+ * @param2: structure containing the extended parameters.
+ */
+SYSCALL_DEFINE2(sched_getparam2, pid_t, pid, struct sched_param2 __user *, param2)
+{
+	struct sched_param2 lp;
+	struct task_struct *p;
+	int retval;
+
+	if (!param2 || pid < 0)
+		return -EINVAL;
+
+	rcu_read_lock();
+	p = find_process_by_pid(pid);
+	retval = -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority = p->rt_priority;
+	rcu_read_unlock();
+
+	retval = copy_to_user(param2, &lp, sizeof(lp)) ? -EFAULT : 0;
+	return retval;
+
+out_unlock:
 	rcu_read_unlock();
 	return retval;
 }
