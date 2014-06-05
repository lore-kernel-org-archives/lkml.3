Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaFEOgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:36:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48398 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaFEOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:36:05 -0400
Date: Thu, 5 Jun 2014 07:34:59 -0700
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-fa93384f40deeb294fd29f2fdcadbd0ebc2dedf1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, gleb@kernel.org,
        raghavendra.kt@linux.vnet.ibm.com, pbonzini@redhat.com,
        tglx@linutronix.de, dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, gleb@kernel.org,
        raghavendra.kt@linux.vnet.ibm.com, pbonzini@redhat.com,
        tglx@linutronix.de, dan.carpenter@oracle.com
In-Reply-To: <20140523102042.GA7267@mwanda>
References: <20140523102042.GA7267@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix signedness bug in yield_to()
Git-Commit-ID: fa93384f40deeb294fd29f2fdcadbd0ebc2dedf1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa93384f40deeb294fd29f2fdcadbd0ebc2dedf1
Gitweb:     http://git.kernel.org/tip/fa93384f40deeb294fd29f2fdcadbd0ebc2dedf1
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Fri, 23 May 2014 13:20:42 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 11:52:13 +0200

sched: Fix signedness bug in yield_to()

yield_to() is supposed to return -ESRCH if there is no task to
yield to, but because the type is bool that is the same as returning
true.

The only place I see which cares is kvm_vcpu_on_spin().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Raghavendra <raghavendra.kt@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/r/20140523102042.GA7267@mwanda
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kvm_host.h | 2 +-
 include/linux/sched.h    | 2 +-
 kernel/sched/core.c      | 2 +-
 virt/kvm/kvm_main.c      | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 7d21cf9..3c4bcf1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -584,7 +584,7 @@ void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
 void kvm_vcpu_block(struct kvm_vcpu *vcpu);
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
-bool kvm_vcpu_yield_to(struct kvm_vcpu *target);
+int kvm_vcpu_yield_to(struct kvm_vcpu *target);
 void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu);
 void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
 void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f91d00..6790c3b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2180,7 +2180,7 @@ static inline void sched_autogroup_fork(struct signal_struct *sig) { }
 static inline void sched_autogroup_exit(struct signal_struct *sig) { }
 #endif
 
-extern bool yield_to(struct task_struct *p, bool preempt);
+extern int yield_to(struct task_struct *p, bool preempt);
 extern void set_user_nice(struct task_struct *p, long nice);
 extern int task_prio(const struct task_struct *p);
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 321d800..afcc842 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4195,7 +4195,7 @@ EXPORT_SYMBOL(yield);
  *	false (0) if we failed to boost the target.
  *	-ESRCH if there's no task to yield to.
  */
-bool __sched yield_to(struct task_struct *p, bool preempt)
+int __sched yield_to(struct task_struct *p, bool preempt)
 {
 	struct task_struct *curr = current;
 	struct rq *rq, *p_rq;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 56baae8..86d1c45 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1708,11 +1708,11 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
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
