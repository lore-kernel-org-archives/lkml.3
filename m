Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab3K1LOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:14:12 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:62975 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3K1LOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:14:08 -0500
Message-ID: <5297257B.7090200@gmail.com>
Date: Thu, 28 Nov 2013 12:14:03 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new
 ABI)
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com> <1383831828-15501-3-git-send-email-juri.lelli@gmail.com> <20131127132354.GA18422@gmail.com> <20131127133027.GE10022@twins.programming.kicks-ass.net> <20131127140143.GB24403@gmail.com> <20131127141334.GA13532@twins.programming.kicks-ass.net> <20131127141721.GA24979@gmail.com>
In-Reply-To: <20131127141721.GA24979@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 03:17 PM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Wed, Nov 27, 2013 at 03:01:43PM +0100, Ingo Molnar wrote:
>>>> So the problem I see with this one is that because you're allowed to 
>>>> call sched_setparam() or whatever it will be called next on another 
>>>> task; a task can very easily fail its sched_getparam() call.
>>>>
>>>> Suppose the application is 'old' and only supports a subset of the 
>>>> fields; but its wants to get, modify and set its params. This will 
>>>> work as long nothing will set anything it doesn't know about.
>>>>
>>>> As soon as some external entity -- say a sysad using schedtool -- 
>>>> sets a param field it doesn't support the get, modify, set routing 
>>>> completely fails.
>>>
>>> There are two approaches to this that I can see:
>>>
>>> 1)
>>>
>>> allow partial information to be returned to user-space, for existing 
>>> input parameters. The new fields won't be displayed, but the tool 
>>> doesn't know about them anyway so it's OK. The tool can still display 
>>> all the other existing parameters.
>>
>> But suppose a task simply wants to lower/raise its static (FIFO)
>> priority and does:
>>
>> sched_getparam(&params);
>> params.prio += 1;
>> sched_setparam(&params);
>>
>> If anything outside of the known param fields was set, we just silently
>> lost it, for the setparam() call will fill out 0s for the unprovided
>> fields.
>>
>>> 2)
>>>
>>> Return -ENOSYS if the 'extra' fields are nonzero. In this case the 
>>> usual case of old tooling + new kernel will still work just fine, 
>>> because old tooling won't set the new fields to any non-default 
>>> (nonzero) values. In the 'mixed' case old tooling will not be able to 
>>> change/display those fields.
>>>
>>> I tend to lean towards #1. What do you think?
>>
>> As per the above that can result in silent unexpected behavioural
>> changes.
>>
>> I'd much rather be explicit and break hard; so 2).
>>
>> So mixing new tools (schedtool, chrt etc) and old apps will give pain,
>> but at least not silent surprises.
> 
> You are right, I concur.
> 

Ok, I came up with what follows. I slightly tested it, but this is intended
to be my first try to understand what you asking for :).

Question:

I do (copying from perf_copy_attr())

	if (!size)		/* abi compat */
		size = SCHED_ATTR_SIZE_VER0;

Shouldn't I return some type of error in this case? We know that there is
nothing before VER0 to which we have to be bwd compatible to. And with
this my "old" schedtool still works since he doesn't know about size...

Comments?

Thanks,

- Juri

Author: Juri Lelli <juri.lelli@gmail.com>
Date:   Thu Nov 28 11:07:47 2013 +0100

    fixup: ABI changed, builds and runs

diff --git a/arch/arm/include/uapi/asm/unistd.h b/arch/arm/include/uapi/asm/unistd.h
index 6a4985e..3e5fafa 100644
--- a/arch/arm/include/uapi/asm/unistd.h
+++ b/arch/arm/include/uapi/asm/unistd.h
@@ -407,8 +407,8 @@
 #define __NR_kcmp			(__NR_SYSCALL_BASE+378)
 #define __NR_finit_module		(__NR_SYSCALL_BASE+379)
 #define __NR_sched_setscheduler2	(__NR_SYSCALL_BASE+380)
-#define __NR_sched_setparam2		(__NR_SYSCALL_BASE+381)
-#define __NR_sched_getparam2		(__NR_SYSCALL_BASE+382)
+#define __NR_sched_setattr		(__NR_SYSCALL_BASE+381)
+#define __NR_sched_getattr		(__NR_SYSCALL_BASE+382)
 
 /*
  * This may need to be greater than __NR_last_syscall+1 in order to
diff --git a/arch/arm/kernel/calls.S b/arch/arm/kernel/calls.S
index 0fb1ef7..0008788 100644
--- a/arch/arm/kernel/calls.S
+++ b/arch/arm/kernel/calls.S
@@ -390,8 +390,8 @@
 		CALL(sys_kcmp)
 		CALL(sys_finit_module)
 /* 380 */	CALL(sys_sched_setscheduler2)
-		CALL(sys_sched_setparam2)
-		CALL(sys_sched_getparam2)
+		CALL(sys_sched_setattr)
+		CALL(sys_sched_getattr)
 #ifndef syscalls_counted
 .equ syscalls_padding, ((NR_syscalls + 3) & ~3) - NR_syscalls
 #define syscalls_counted
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index dfce815..0f13118 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -357,6 +357,6 @@
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
 349	i386	kcmp			sys_kcmp
 350	i386	finit_module		sys_finit_module
-351	i386	sched_setparam2		sys_sched_setparam2
-352	i386	sched_getparam2		sys_sched_getparam2
+351	i386	sched_setattr		sys_sched_setattr
+352	i386	sched_getattr		sys_sched_getattr
 353	i386	sched_setscheduler2	sys_sched_setscheduler2
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 1849a70..0de09ef 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -320,8 +320,8 @@
 311	64	process_vm_writev	sys_process_vm_writev
 312	common	kcmp			sys_kcmp
 313	common	finit_module		sys_finit_module
-314	common	sched_setparam2		sys_sched_setparam2
-315	common	sched_getparam2		sys_sched_getparam2
+314	common	sched_setattr		sys_sched_setattr
+315	common	sched_getattr		sys_sched_getattr
 316	common	sched_setscheduler2	sys_sched_setscheduler2
 
 #
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0cbef29e..76c9bd8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -56,6 +56,8 @@ struct sched_param {
 
 #include <asm/processor.h>
 
+#define SCHED_ATTR_SIZE_VER0	40	/* sizeof first published struct */
+
 /*
  * Extended scheduling parameters data structure.
  *
@@ -67,7 +69,7 @@ struct sched_param {
  * the tasks may be useful for a wide variety of application fields, e.g.,
  * multimedia, streaming, automation and control, and many others.
  *
- * This variant (sched_param2) is meant at describing a so-called
+ * This variant (sched_attr) is meant at describing a so-called
  * sporadic time-constrained task. In such model a task is specified by:
  *  - the activation period or minimum instance inter-arrival time;
  *  - the maximum (or average, depending on the actual scheduling
@@ -80,28 +82,30 @@ struct sched_param {
  * than the runtime and must be completed by time instant t equal to
  * the instance activation time + the deadline.
  *
- * This is reflected by the actual fields of the sched_param2 structure:
+ * This is reflected by the actual fields of the sched_attr structure:
  *
  *  @sched_priority     task's priority (might still be useful)
+ *  @sched_flags        for customizing the scheduler behaviour
  *  @sched_deadline     representative of the task's deadline
  *  @sched_runtime      representative of the task's runtime
  *  @sched_period       representative of the task's period
- *  @sched_flags        for customizing the scheduler behaviour
  *
  * Given this task model, there are a multiplicity of scheduling algorithms
  * and policies, that can be used to ensure all the tasks will make their
  * timing constraints.
  *
- * @__unused		padding to allow future expansion without ABI issues
+ *  @size		size of the structure, for fwd/bwd compat.
  */
-struct sched_param2 {
+struct sched_attr {
 	int sched_priority;
 	unsigned int sched_flags;
 	u64 sched_runtime;
 	u64 sched_deadline;
 	u64 sched_period;
+	u32 size;
 
-	u64 __unused[12];
+	/* Align to u64. */
+	u32 __reserved;
 };
 
 struct exec_domain;
@@ -2011,7 +2015,7 @@ extern int sched_setscheduler(struct task_struct *, int,
 extern int sched_setscheduler_nocheck(struct task_struct *, int,
 				      const struct sched_param *);
 extern int sched_setscheduler2(struct task_struct *, int,
-				 const struct sched_param2 *);
+				 const struct sched_attr *);
 extern struct task_struct *idle_task(int cpu);
 /**
  * is_idle_task - is the specified task an idle task?
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 11f9d5b..fbdf44a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -279,16 +279,16 @@ asmlinkage long sys_nice(int increment);
 asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
 					struct sched_param __user *param);
 asmlinkage long sys_sched_setscheduler2(pid_t pid, int policy,
-					struct sched_param2 __user *param);
+					struct sched_attr __user *attr);
 asmlinkage long sys_sched_setparam(pid_t pid,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_setparam2(pid_t pid,
-					struct sched_param2 __user *param);
+asmlinkage long sys_sched_setattr(pid_t pid,
+					struct sched_attr __user *attr);
 asmlinkage long sys_sched_getscheduler(pid_t pid);
 asmlinkage long sys_sched_getparam(pid_t pid,
 					struct sched_param __user *param);
-asmlinkage long sys_sched_getparam2(pid_t pid,
-					struct sched_param2 __user *param);
+asmlinkage long sys_sched_getattr(pid_t pid,
+					struct sched_attr __user *attr);
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 					unsigned long __user *user_mask_ptr);
 asmlinkage long sys_sched_getaffinity(pid_t pid, unsigned int len,
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 8257aa8..5904651 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3025,7 +3025,7 @@ static bool check_same_owner(struct task_struct *p)
 }
 
 static int __sched_setscheduler(struct task_struct *p, int policy,
-				const struct sched_param2 *param,
+				const struct sched_attr *param,
 				bool user)
 {
 	int retval, oldprio, oldpolicy = -1, on_rq, running;
@@ -3191,17 +3191,17 @@ recheck:
 int sched_setscheduler(struct task_struct *p, int policy,
 		       const struct sched_param *param)
 {
-	struct sched_param2 param2 = {
+	struct sched_attr attr = {
 		.sched_priority = param->sched_priority
 	};
-	return __sched_setscheduler(p, policy, &param2, true);
+	return __sched_setscheduler(p, policy, &attr, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler);
 
 int sched_setscheduler2(struct task_struct *p, int policy,
-			  const struct sched_param2 *param2)
+			  const struct sched_attr *attr)
 {
-	return __sched_setscheduler(p, policy, param2, true);
+	return __sched_setscheduler(p, policy, attr, true);
 }
 EXPORT_SYMBOL_GPL(sched_setscheduler2);
 
@@ -3221,10 +3221,10 @@ EXPORT_SYMBOL_GPL(sched_setscheduler2);
 int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 			       const struct sched_param *param)
 {
-	struct sched_param2 param2 = {
+	struct sched_attr attr = {
 		.sched_priority = param->sched_priority
 	};
-	return __sched_setscheduler(p, policy, &param2, false);
+	return __sched_setscheduler(p, policy, &attr, false);
 }
 
 static int
@@ -3249,26 +3249,92 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
 	return retval;
 }
 
+/*
+ * Mimics kerner/events/core.c perf_copy_attr().
+ */
+static int sched_copy_attr(struct sched_attr __user *uattr,
+			   struct sched_attr *attr)
+{
+	u32 size;
+	int ret;
+
+	if (!access_ok(VERIFY_WRITE, uattr, SCHED_ATTR_SIZE_VER0))
+		return -EFAULT;
+
+	/*
+	 * zero the full structure, so that a short copy will be nice.
+	 */
+	memset(attr, 0, sizeof(*attr));
+
+	ret = get_user(size, &uattr->size);
+	if (ret)
+		return ret;
+
+	if (size > PAGE_SIZE)	/* silly large */
+		goto err_size;
+
+	if (!size)		/* abi compat */
+		size = SCHED_ATTR_SIZE_VER0;
+
+	if (size < SCHED_ATTR_SIZE_VER0)
+		goto err_size;
+
+	/*
+	 * If we're handed a bigger struct than we know of,
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
+	 */
+	if (size > sizeof(*attr)) {
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
+
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
+
+		for (; addr < end; addr++) {
+			ret = get_user(val, addr);
+			if (ret)
+				return ret;
+			if (val)
+				goto err_size;
+		}
+		size = sizeof(*attr);
+	}
+
+	ret = copy_from_user(attr, uattr, size);
+	if (ret)
+		return -EFAULT;
+
+out:
+	return ret;
+
+err_size:
+	put_user(sizeof(*attr), &uattr->size);
+	ret = -E2BIG;
+	goto out;
+}
+
 static int
 do_sched_setscheduler2(pid_t pid, int policy,
-			 struct sched_param2 __user *param2)
+		       struct sched_attr __user *attr_uptr)
 {
-	struct sched_param2 lparam2;
+	struct sched_attr attr;
 	struct task_struct *p;
 	int retval;
 
-	if (!param2 || pid < 0)
+	if (!attr_uptr || pid < 0)
 		return -EINVAL;
 
-	memset(&lparam2, 0, sizeof(struct sched_param2));
-	if (copy_from_user(&lparam2, param2, sizeof(struct sched_param2)))
+	if (sched_copy_attr(attr_uptr, &attr))
 		return -EFAULT;
 
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);
 	if (p != NULL)
-		retval = sched_setscheduler2(p, policy, &lparam2);
+		retval = sched_setscheduler2(p, policy, &attr);
 	rcu_read_unlock();
 
 	return retval;
@@ -3296,15 +3362,15 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
  * sys_sched_setscheduler2 - same as above, but with extended sched_param
  * @pid: the pid in question.
  * @policy: new policy (could use extended sched_param).
- * @param: structure containg the extended parameters.
+ * @attr: structure containg the extended parameters.
  */
 SYSCALL_DEFINE3(sched_setscheduler2, pid_t, pid, int, policy,
-		struct sched_param2 __user *, param2)
+		struct sched_attr __user *, attr)
 {
 	if (policy < 0)
 		return -EINVAL;
 
-	return do_sched_setscheduler2(pid, policy, param2);
+	return do_sched_setscheduler2(pid, policy, attr);
 }
 
 /**
@@ -3320,14 +3386,14 @@ SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 }
 
 /**
- * sys_sched_setparam2 - same as above, but with extended sched_param
+ * sys_sched_setattr - same as above, but with extended sched_attr
  * @pid: the pid in question.
- * @param2: structure containing the extended parameters.
+ * @attr: structure containing the extended parameters.
  */
-SYSCALL_DEFINE2(sched_setparam2, pid_t, pid,
-		struct sched_param2 __user *, param2)
+SYSCALL_DEFINE2(sched_setattr, pid_t, pid,
+		struct sched_attr __user *, attr)
 {
-	return do_sched_setscheduler2(pid, -1, param2);
+	return do_sched_setscheduler2(pid, -1, attr);
 }
 
 /**
@@ -3401,19 +3467,21 @@ out_unlock:
 }
 
 /**
- * sys_sched_getparam2 - same as above, but with extended sched_param
+ * sys_sched_getattr - same as above, but with extended "sched_param"
  * @pid: the pid in question.
- * @param2: structure containing the extended parameters.
+ * @attr: structure containing the extended parameters.
  */
-SYSCALL_DEFINE2(sched_getparam2, pid_t, pid, struct sched_param2 __user *, param2)
+SYSCALL_DEFINE2(sched_getattr, pid_t, pid, struct sched_attr __user *, attr)
 {
-	struct sched_param2 lp;
+	struct sched_attr lp;
 	struct task_struct *p;
 	int retval;
 
-	if (!param2 || pid < 0)
+	if (!attr || pid < 0)
 		return -EINVAL;
 
+	memset(&lp, 0, sizeof(struct sched_attr));
+
 	rcu_read_lock();
 	p = find_process_by_pid(pid);
 	retval = -ESRCH;
@@ -3427,7 +3495,7 @@ SYSCALL_DEFINE2(sched_getparam2, pid_t, pid, struct sched_param2 __user *, param
 	lp.sched_priority = p->rt_priority;
 	rcu_read_unlock();
 
-	retval = copy_to_user(param2, &lp, sizeof(lp)) ? -EFAULT : 0;
+	retval = copy_to_user(attr, &lp, sizeof(lp)) ? -EFAULT : 0;
 	return retval;
 
 out_unlock:

