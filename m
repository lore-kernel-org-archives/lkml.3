Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbaDBN26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:28:58 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:15270 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbaDBN2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:28:54 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v8 07/10] pvqspinlock, x86: Rename paravirt_ticketlocks_enabled
Date: Wed,  2 Apr 2014 09:27:36 -0400
Message-Id: <1396445259-27670-8-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames the paravirt_ticketlocks_enabled static key to a
more generic paravirt_spinlocks_enabled name.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/spinlock.h      |    4 ++--
 arch/x86/kernel/kvm.c                |    2 +-
 arch/x86/kernel/paravirt-spinlocks.c |    4 ++--
 arch/x86/xen/spinlock.c              |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 958d20f..428d0d1 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -39,7 +39,7 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 15)
 
-extern struct static_key paravirt_ticketlocks_enabled;
+extern struct static_key paravirt_spinlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
 #ifdef CONFIG_QUEUE_SPINLOCK
@@ -150,7 +150,7 @@ static inline void __ticket_unlock_slowpath(arch_spinlock_t *lock,
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	if (TICKET_SLOWPATH_FLAG &&
-	    static_key_false(&paravirt_ticketlocks_enabled)) {
+	    static_key_false(&paravirt_spinlocks_enabled)) {
 		arch_spinlock_t prev;
 
 		prev = *lock;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 713f1b3..8e646a7 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -818,7 +818,7 @@ static __init int kvm_spinlock_init_jump(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
 
 	return 0;
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 7dfd02d..6d36731 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -17,8 +17,8 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
-EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
+struct static_key paravirt_spinlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_spinlocks_enabled);
 #endif
 
 #ifdef CONFIG_PARAVIRT_UNFAIR_LOCKS
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 581521c..06f4a64 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -290,7 +290,7 @@ static __init int xen_init_spinlocks_jump(void)
 	if (!xen_pvspin)
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	return 0;
 }
 early_initcall(xen_init_spinlocks_jump);
-- 
1.7.1

