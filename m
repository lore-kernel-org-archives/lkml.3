Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3JIJDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:03:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59051 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab3JIJDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:03:43 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <gleb@redhat.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>
Cc: <konrad.wilk@oracle.com>, <habanero@linux.vnet.ibm.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <mtosatti@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Subject: [PATCH] kvm fix: Enable pvspinlock after jump_label_init() to avoid VM hang
Date: Wed,  9 Oct 2013 14:33:21 +0530
Message-Id: <1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <y>
References: <y>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100909-5806-0000-0000-000023006210
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use jump label to enable pv-spinlock. With the changes in
(442e0973e927 Merge branch 'x86/jumplabel'), the jump label behaviour has changed
that would result in evntual hang of the VM since we would end up in a situation
where slowpath locks would halt the vcpus but we will not be able to wakeup the
vcpu by lock releaser using unlock kick.

Similar problem in Xen and more detailed description is available in
a945928ea270 (xen: Do not enable spinlocks before jump_label_init() has executed)

This patch splits kvm_spinlock_init to separate jump label changes with pvops
patching and also make jump label enabling after jump_label_init().

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
---
 Thanks to Andrew Theurer who reported weird behaviour of pvspinlock
 in 3.12-rc that led to my git bisection and investigation and Konrad
 for his jump label findings for Xen.

 arch/x86/kernel/kvm.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 697b93a..a0e2a8a 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -775,11 +775,22 @@ void __init kvm_spinlock_init(void)
 	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
 		return;
 
-	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
+	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
+	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+}
+
+static __init int kvm_spinlock_init_jump(void)
+{
+	if (!kvm_para_available())
+		return 0;
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
+		return 0;
 
 	static_key_slow_inc(&paravirt_ticketlocks_enabled);
+	printk(KERN_INFO "KVM setup paravirtual spinlock\n");
 
-	pv_lock_ops.lock_spinning = PV_CALLEE_SAVE(kvm_lock_spinning);
-	pv_lock_ops.unlock_kick = kvm_unlock_kick;
+	return 0;
 }
+early_initcall(kvm_spinlock_init_jump);
+
 #endif	/* CONFIG_PARAVIRT_SPINLOCKS */
-- 
1.7.11.7

