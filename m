Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147AbaKNPsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:48:09 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63690 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136AbaKNPsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:48:07 -0500
From: Ionut Alexa <ionut.m.alexa@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: [PATCH] kernel:signal.c Fix coding style errors and warnings.
Date: Fri, 14 Nov 2014 17:56:55 +0200
Message-Id: <1415980615-12345-1-git-send-email-ionut.m.alexa@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Fix various coding style errors and warnings as:
        - space before tabs
        - exiting a function from different points (else after return
          ..)

Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>
---
 kernel/signal.c |  104 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 49 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 8f0876f..226b41a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -109,25 +109,28 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
+			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 4:
+		ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2:
+		ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1:
+		ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
 
-#define PENDING(p,b) has_pending_signals(&(p)->signal, (b))
+#define PENDING(p, b) has_pending_signals(&(p)->signal, (b))
 
 static int recalc_sigpending_tsk(struct task_struct *t)
 {
@@ -180,7 +183,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	 * Handle the first word specially: it contains the
 	 * synchronous signals that need to be dequeued first.
 	 */
-	x = *s &~ *m;
+	x = *s & ~*m;
 	if (x) {
 		if (x & SYNCHRONOUS_MASK)
 			x &= SYNCHRONOUS_MASK;
@@ -191,7 +194,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = 1; i < _NSIG_WORDS; ++i) {
-			x = *++s &~ *++m;
+			x = *++s & ~*++m;
 			if (!x)
 				continue;
 			sig = ffz(~x) + i*_NSIG_BPW + 1;
@@ -200,7 +203,7 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 		break;
 
 	case 2:
-		x = s[1] &~ m[1];
+		x = s[1] & ~m[1];
 		if (!x)
 			break;
 		sig = ffz(~x) + _NSIG_BPW + 1;
@@ -224,8 +227,8 @@ static inline void print_dropped_signal(int sig)
 	if (!__ratelimit(&ratelimit_state))
 		return;
 
-	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
-				current->comm, current->pid, sig);
+	pr_info("%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
+					current->comm, current->pid, sig);
 }
 
 /**
@@ -936,7 +939,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 		 * There is just one thread and it does not need to be woken.
 		 * It will dequeue unblocked signals before it runs again.
 		 */
-		return;
+		goto exit_func;
 	else {
 		/*
 		 * Otherwise try to find a suitable thread.
@@ -950,7 +953,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 				 * Any eligible threads will see
 				 * the signal in the queue soon.
 				 */
-				return;
+				goto exit_func;
 		}
 		signal->curr_target = t;
 	}
@@ -982,7 +985,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 				sigaddset(&t->pending.signal, SIGKILL);
 				signal_wake_up(t, 1);
 			} while_each_thread(p, t);
-			return;
+			goto exit_func;
 		}
 	}
 
@@ -991,6 +994,7 @@ static void complete_signal(int sig, struct task_struct *p, int group)
 	 * Tell the chosen thread to wake up and dequeue it.
 	 */
 	signal_wake_up(t, sig == SIGKILL);
+exit_func:
 	return;
 }
 
@@ -1140,10 +1144,10 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
+	pr_info("potentially unexpected fatal signal %d.\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
-	printk(KERN_INFO "code at %08lx: ", regs->ip);
+	pr_info("code at %08lx: ", regs->ip);
 	{
 		int i;
 		for (i = 0; i < 16; i++) {
@@ -1151,10 +1155,10 @@ static void print_fatal_signal(int signr)
 
 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk(KERN_CONT "%02x ", insn);
+			pr_cont("%02x ", insn);
 		}
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 #endif
 	preempt_disable();
 	show_regs(regs);
@@ -1163,7 +1167,7 @@ static void print_fatal_signal(int signr)
 
 static int __init setup_print_fatal_signals(char *str)
 {
-	get_option (&str, &print_fatal_signals);
+	get_option(&str, &print_fatal_signals);
 
 	return 1;
 }
@@ -1431,7 +1435,7 @@ static int kill_something_info(int sig, struct siginfo *info, pid_t pid)
 				pid ? find_vpid(-pid) : task_pgrp(current));
 	} else {
 		int retval = 0, count = 0;
-		struct task_struct * p;
+		struct task_struct *p;
 
 		for_each_process(p) {
 			if (task_pid_vnr(p) > 1 &&
@@ -1622,8 +1626,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	BUG_ON(!tsk->ptrace &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
@@ -1745,20 +1749,20 @@ static void do_notify_parent_cldstop(struct task_struct *tsk,
 	info.si_utime = cputime_to_clock_t(utime);
 	info.si_stime = cputime_to_clock_t(stime);
 
- 	info.si_code = why;
- 	switch (why) {
- 	case CLD_CONTINUED:
- 		info.si_status = SIGCONT;
- 		break;
- 	case CLD_STOPPED:
- 		info.si_status = tsk->signal->group_exit_code & 0x7f;
- 		break;
- 	case CLD_TRAPPED:
- 		info.si_status = tsk->exit_code & 0x7f;
- 		break;
- 	default:
- 		BUG();
- 	}
+	info.si_code = why;
+	switch (why) {
+	case CLD_CONTINUED:
+		info.si_status = SIGCONT;
+		break;
+	case CLD_STOPPED:
+		info.si_status = tsk->signal->group_exit_code & 0x7f;
+		break;
+	case CLD_TRAPPED:
+		info.si_status = tsk->exit_code & 0x7f;
+		break;
+	default:
+		BUG();
+	}
 
 	sighand = parent->sighand;
 	spin_lock_irqsave(&sighand->siglock, flags);
@@ -1943,7 +1947,7 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 {
 	siginfo_t info;
 
-	memset(&info, 0, sizeof info);
+	memset(&info, 0, sizeof(info));
 	info.si_signo = signr;
 	info.si_code = exit_code;
 	info.si_pid = task_pid_vnr(current);
@@ -2357,7 +2361,7 @@ relock:
 }
 
 /**
- * signal_delivered - 
+ * signal_delivered -
  * @ksig:		kernel signal struct
  * @stepping:		nonzero if debugger single-step or block-step in use
  *
@@ -2704,7 +2708,7 @@ int copy_siginfo_to_user(siginfo_t __user *to, const siginfo_t *from)
 {
 	int err;
 
-	if (!access_ok (VERIFY_WRITE, to, sizeof(siginfo_t)))
+	if (!access_ok(VERIFY_WRITE, to, sizeof(siginfo_t)))
 		return -EFAULT;
 	if (from->si_code < 0)
 		return __copy_to_user(to, from, sizeof(siginfo_t))
@@ -3131,7 +3135,8 @@ int do_sigaction(int sig, struct k_sigaction *act, struct k_sigaction *oact)
 }
 
 static int
-do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long sp)
+do_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
+						unsigned long sp)
 {
 	stack_t oss;
 	int error;
@@ -3195,7 +3200,8 @@ do_sigaltstack (const stack_t __user *uss, stack_t __user *uoss, unsigned long s
 out:
 	return error;
 }
-SYSCALL_DEFINE2(sigaltstack,const stack_t __user *,uss, stack_t __user *,uoss)
+SYSCALL_DEFINE2(sigaltstack, const stack_t __user *, uss,
+					stack_t __user *, uoss)
 {
 	return do_sigaltstack(uss, uoss, current_user_stack_pointer());
 }
@@ -3274,7 +3280,7 @@ int __compat_save_altstack(compat_stack_t __user *uss, unsigned long sp)
  */
 SYSCALL_DEFINE1(sigpending, old_sigset_t __user *, set)
 {
-	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t)); 
+	return sys_rt_sigpending((sigset_t __user *)set, sizeof(old_sigset_t));
 }
 
 #endif
@@ -3399,7 +3405,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 	if (!ret && oact) {
 		sigset_to_compat(&mask, &old_ka.sa.sa_mask);
-		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler), 
+		ret = put_user(ptr_to_compat(old_ka.sa.sa_handler),
 			       &oact->sa_handler);
 		ret |= copy_to_user(&oact->sa_mask, &mask, sizeof(mask));
 		ret |= put_user(old_ka.sa.sa_flags, &oact->sa_flags);
@@ -3416,7 +3422,7 @@ COMPAT_SYSCALL_DEFINE4(rt_sigaction, int, sig,
 #ifdef CONFIG_OLD_SIGACTION
 SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct old_sigaction __user *, act,
-	        struct old_sigaction __user *, oact)
+		struct old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3452,7 +3458,7 @@ SYSCALL_DEFINE3(sigaction, int, sig,
 #ifdef CONFIG_COMPAT_OLD_SIGACTION
 COMPAT_SYSCALL_DEFINE3(sigaction, int, sig,
 		const struct compat_old_sigaction __user *, act,
-	        struct compat_old_sigaction __user *, oact)
+		struct compat_old_sigaction __user *, oact)
 {
 	struct k_sigaction new_ka, old_ka;
 	int ret;
@@ -3575,7 +3581,7 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t __user *, unewset, size_t, sigsetsize)
 		return -EFAULT;
 	return sigsuspend(&newset);
 }
- 
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE2(rt_sigsuspend, compat_sigset_t __user *, unewset, compat_size_t, sigsetsize)
 {
-- 
1.7.10.4

