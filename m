Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaEWKVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:21:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:23018 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEWKVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:21:22 -0400
Date: Fri, 23 May 2014 13:20:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] sched: signedness bug in yield_to()
Message-ID: <20140523102042.GA7267@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yield_to() is supposed to return -ESRCH if there is no task to
yield to, but because the type is bool that is the same as returning
true.

The only place I see which cares is kvm_vcpu_on_spin().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9112646..7c72b14 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2173,7 +2173,7 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
-extern bool yield_to(struct task_struct *p, bool preempt);
+extern int yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 927fa33..40f8de4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4209,7 +4209,7 @@ EXPORT_SYMBOL(yield);
  *	false (0) if we failed to boost the target.
  *	-ESRCH if there's no task to yield to.
  */
-bool __sched yield_to(struct task_struct *p, bool preempt)
+int __sched yield_to(struct task_struct *p, bool preempt)
 {
 	struct task_struct *curr = current;
 	struct rq *rq, *p_rq;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 970c681..ec4e3bd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -586,7 +586,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
-bool kvm_vcpu_yield_to(struct kvm_vcpu *target);
+int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95b4c2b..9458196 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1713,11 +1713,11 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
 #endif /* !CONFIG_S390 */
 
-bool kvm_vcpu_yield_to(struct kvm_vcpu *target)
+int kvm_vcpu_yield_to(struct kvm_vcpu *target)
 {
 	struct pid *pid;
 	struct task_struct *task = NULL;
-	bool ret = false;
+	int ret = 0;
 
 	rcu_read_lock();
 	pid = rcu_dereference(target->pid);
