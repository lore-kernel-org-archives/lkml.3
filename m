Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaFONMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 09:12:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60396 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaFONMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 09:12:03 -0400
Message-Id: <20140615130154.068615764@chello.nl>
User-Agent: quilt/0.61-1
Date: Sun, 15 Jun 2014 14:47:06 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 09/11] pvqspinlock, x86: Rename paravirt_ticketlocks_enabled
References: <20140615124657.264658593@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=waiman_long-pvqspinlock_x86-rename_paravirt_ticketlocks_enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Waiman Long <Waiman.Long@hp.com>

This patch renames the paravirt_ticketlocks_enabled static key to a
more generic paravirt_spinlocks_enabled name.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/spinlock.h      |    4 ++--
 arch/x86/kernel/kvm.c                |    2 +-
 arch/x86/kernel/paravirt-spinlocks.c |    4 ++--
 arch/x86/xen/spinlock.c              |    2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -39,7 +39,7 @@
 /* How long a lock should spin before we consider blocking */
 #define SPIN_THRESHOLD	(1 << 15)
 
-extern struct static_key paravirt_ticketlocks_enabled;
+extern struct static_key paravirt_spinlocks_enabled;
 static __always_inline bool static_key_false(struct static_key *key);
 
 #ifdef CONFIG_QUEUE_SPINLOCK
@@ -150,7 +150,7 @@ static inline void __ticket_unlock_slowp
 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
 	if (TICKET_SLOWPATH_FLAG &&
-	    static_key_false(&paravirt_ticketlocks_enabled)) {
+	    static_key_false(&paravirt_spinlocks_enabled)) {
 		arch_spinlock_t prev;
 
 		prev = *lock;
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -819,7 +819,7 @@ static __init int kvm_spinlock_init_jump
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
 
 	return 0;
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -16,5 +16,5 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-struct static_key paravirt_ticketlocks_enabled = STATIC_KEY_INIT_FALSE;
-EXPORT_SYMBOL(paravirt_ticketlocks_enabled);
+struct static_key paravirt_spinlocks_enabled = STATIC_KEY_INIT_FALSE;
+EXPORT_SYMBOL(paravirt_spinlocks_enabled);
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -293,7 +293,7 @@ static __init int xen_init_spinlocks_jum
 	if (!xen_domain())
 		return 0;
 
-	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	static_key_slow_inc(&paravirt_spinlocks_enabled);
 	return 0;
 }
 early_initcall(xen_init_spinlocks_jump);


