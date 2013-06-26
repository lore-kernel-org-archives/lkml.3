Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3FZTbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:31:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13333 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3FZTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:30:52 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=HWCg0ey-AhcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Krp7Uy9HbdsA:10 a=9B4eBwZM3edjN190uTEA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130626193050.529670718@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 26 Jun 2013 15:28:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [RFC][PATCH RT 6/6] vtime: Convert vtime_seqlock into raw_spinlock_t and seqcount combo
References: <20130626192806.107564905@goodmis.org>
Content-Disposition: inline; filename=vtime-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vtime seqlock needs to be taken in true interrupt context on -rt.
The normal seqlocks are converted to mutexes when PREEMPT_RT_FULL is
enabled, which will break the vtime code as the calls are done from
interrupt context.

Convert the vtime seqlock into the raw_spinlock_t and seqcount combo
that can be done in interrupt context.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


Index: linux-rt.git/include/linux/sched.h
===================================================================
--- linux-rt.git.orig/include/linux/sched.h
+++ linux-rt.git/include/linux/sched.h
@@ -1176,7 +1176,8 @@ struct task_struct {
 	struct cputime prev_cputime;
 #endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-	seqlock_t vtime_seqlock;
+	raw_spinlock_t vtime_lock;
+	seqcount_t vtime_seq;
 	unsigned long long vtime_snap;
 	enum {
 		VTIME_SLEEPING = 0,
Index: linux-rt.git/kernel/sched/cputime.c
===================================================================
--- linux-rt.git.orig/kernel/sched/cputime.c
+++ linux-rt.git/kernel/sched/cputime.c
@@ -668,9 +668,11 @@ void vtime_account_system(struct task_st
 	if (!vtime_accounting_enabled())
 		return;
 
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	__vtime_account_system(tsk);
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_account_irq_exit(struct task_struct *tsk)
@@ -678,11 +680,13 @@ void vtime_account_irq_exit(struct task_
 	if (!vtime_accounting_enabled())
 		return;
 
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	if (context_tracking_in_user())
 		tsk->vtime_snap_whence = VTIME_USER;
 	__vtime_account_system(tsk);
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_account_user(struct task_struct *tsk)
@@ -694,10 +698,12 @@ void vtime_account_user(struct task_stru
 
 	delta_cpu = get_vtime_delta(tsk);
 
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	tsk->vtime_snap_whence = VTIME_SYS;
 	account_user_time(tsk, delta_cpu, cputime_to_scaled(delta_cpu));
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_user_enter(struct task_struct *tsk)
@@ -705,26 +711,32 @@ void vtime_user_enter(struct task_struct
 	if (!vtime_accounting_enabled())
 		return;
 
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	tsk->vtime_snap_whence = VTIME_USER;
 	__vtime_account_system(tsk);
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_guest_enter(struct task_struct *tsk)
 {
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	__vtime_account_system(tsk);
 	current->flags |= PF_VCPU;
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_guest_exit(struct task_struct *tsk)
 {
-	write_seqlock(&tsk->vtime_seqlock);
+	raw_spin_lock(&tsk->vtime_lock);
+	write_seqcount_begin(&tsk->vtime_seq);
 	__vtime_account_system(tsk);
 	current->flags &= ~PF_VCPU;
-	write_sequnlock(&tsk->vtime_seqlock);
+	write_seqcount_end(&tsk->vtime_seq);
+	raw_spin_unlock(&tsk->vtime_lock);
 }
 
 void vtime_account_idle(struct task_struct *tsk)
@@ -741,24 +753,30 @@ bool vtime_accounting_enabled(void)
 
 void arch_vtime_task_switch(struct task_struct *prev)
 {
-	write_seqlock(&prev->vtime_seqlock);
+	raw_spin_lock(&prev->vtime_lock);
+	write_seqcount_begin(&prev->vtime_seq);
 	prev->vtime_snap_whence = VTIME_SLEEPING;
-	write_sequnlock(&prev->vtime_seqlock);
+	write_seqcount_end(&prev->vtime_seq);
+	raw_spin_unlock(&prev->vtime_lock);
 
-	write_seqlock(&current->vtime_seqlock);
+	raw_spin_lock(&current->vtime_lock);
+	write_seqcount_begin(&current->vtime_seq);
 	current->vtime_snap_whence = VTIME_SYS;
 	current->vtime_snap = sched_clock_cpu(smp_processor_id());
-	write_sequnlock(&current->vtime_seqlock);
+	write_seqcount_end(&current->vtime_seq);
+	raw_spin_unlock(&current->vtime_lock);
 }
 
 void vtime_init_idle(struct task_struct *t, int cpu)
 {
 	unsigned long flags;
 
-	write_seqlock_irqsave(&t->vtime_seqlock, flags);
+	raw_spin_lock_irqsave(&t->vtime_lock, flags);
+	write_seqcount_begin(&t->vtime_seq);
 	t->vtime_snap_whence = VTIME_SYS;
 	t->vtime_snap = sched_clock_cpu(cpu);
-	write_sequnlock_irqrestore(&t->vtime_seqlock, flags);
+	write_seqcount_end(&t->vtime_seq);
+	raw_spin_unlock_irqrestore(&t->vtime_lock, flags);
 }
 
 cputime_t task_gtime(struct task_struct *t)
@@ -767,13 +785,13 @@ cputime_t task_gtime(struct task_struct 
 	cputime_t gtime;
 
 	do {
-		seq = read_seqbegin(&t->vtime_seqlock);
+		seq = read_seqcount_begin(&t->vtime_seq);
 
 		gtime = t->gtime;
 		if (t->flags & PF_VCPU)
 			gtime += vtime_delta(t);
 
-	} while (read_seqretry(&t->vtime_seqlock, seq));
+	} while (read_seqcount_retry(&t->vtime_seq, seq));
 
 	return gtime;
 }
@@ -796,7 +814,7 @@ fetch_task_cputime(struct task_struct *t
 		*udelta = 0;
 		*sdelta = 0;
 
-		seq = read_seqbegin(&t->vtime_seqlock);
+		seq = read_seqcount_begin(&t->vtime_seq);
 
 		if (u_dst)
 			*u_dst = *u_src;
@@ -820,7 +838,7 @@ fetch_task_cputime(struct task_struct *t
 			if (t->vtime_snap_whence == VTIME_SYS)
 				*sdelta = delta;
 		}
-	} while (read_seqretry(&t->vtime_seqlock, seq));
+	} while (read_seqcount_retry(&t->vtime_seq, seq));
 }
 
 
Index: linux-rt.git/include/linux/init_task.h
===================================================================
--- linux-rt.git.orig/include/linux/init_task.h
+++ linux-rt.git/include/linux/init_task.h
@@ -151,7 +151,8 @@ extern struct task_group root_task_group
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
 # define INIT_VTIME(tsk)						\
-	.vtime_seqlock = __SEQLOCK_UNLOCKED(tsk.vtime_seqlock),	\
+	.vtime_lock = __RAW_SPIN_LOCK_UNLOCKED(tsk.vtime_lock),	\
+	.vtime_seq = SEQCNT_ZERO,			\
 	.vtime_snap = 0,				\
 	.vtime_snap_whence = VTIME_SYS,
 #else
Index: linux-rt.git/kernel/fork.c
===================================================================
--- linux-rt.git.orig/kernel/fork.c
+++ linux-rt.git/kernel/fork.c
@@ -1268,7 +1268,8 @@ static struct task_struct *copy_process(
 	p->prev_cputime.utime = p->prev_cputime.stime = 0;
 #endif
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN
-	seqlock_init(&p->vtime_seqlock);
+	raw_spin_lock_init(&p->vtime_lock);
+	seqcount_init(&p->vtime_seq);
 	p->vtime_snap = 0;
 	p->vtime_snap_whence = VTIME_SLEEPING;
 #endif

