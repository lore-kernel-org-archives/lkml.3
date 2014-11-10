Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbaKJGjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:39:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:54491 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaKJGgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364149"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 10/13] KVM: Add the handler for Wake-up Vector
Date: Mon, 10 Nov 2014 14:26:49 +0800
Message-Id: <1415600812-27773-11-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When VCPU is blocked and an external interrupts from assigned
devices is delivered to it, VT-d Posted-Interrupts mechanism
will deliver a interrrupt to the associated physical CPU with
Wake-up Vector. In its handler, we find the destination VCPU
and wake up it.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/vmx.c              |   52 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   22 +++++++++++-----
 include/linux/kvm_host.h        |    3 ++
 virt/kvm/kvm_main.c             |    3 ++
 5 files changed, 75 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 71cfe3e..ca231a3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -99,6 +99,8 @@ static inline gfn_t gfn_to_index(gfn_t gfn, gfn_t base_gfn, int level)
 
 #define ASYNC_PF_PER_VCPU 64
 
+extern void (*wakeup_handler_callback)(void);
+
 enum kvm_reg {
 	VCPU_REGS_RAX = 0,
 	VCPU_REGS_RCX = 1,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fa77714..51d2c8a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -822,6 +822,13 @@ static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 static DEFINE_PER_CPU(struct desc_ptr, host_gdt);
 
+/*
+ * We maintian a per-CPU linked-list of VCPU, so in wakeup_handler() we
+ * can find which VCPU should be waken up.
+ */
+static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
+static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
+
 static unsigned long *vmx_io_bitmap_a;
 static unsigned long *vmx_io_bitmap_b;
 static unsigned long *vmx_msr_bitmap_legacy;
@@ -2813,6 +2820,8 @@ static int hardware_enable(void)
 		return -EBUSY;
 
 	INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+	INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
+	spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 
 	/*
 	 * Now we can enable the vmclear operation in kdump
@@ -9183,6 +9192,7 @@ static int vmx_vcpu_pre_block(struct kvm_vcpu *vcpu)
 	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
 	struct pi_desc old;
 	struct pi_desc new;
+	unsigned long flags;
 
 	if (!irq_post_enabled)
 		return 0;
@@ -9222,9 +9232,22 @@ static int vmx_vcpu_pre_block(struct kvm_vcpu *vcpu)
 
 		/* set 'NV' to 'wakeup vector' */
 		new.nv = POSTED_INTR_WAKEUP_VECTOR;
+
+		/*
+		 * We should save physical cpu id here, vcpu->cpu may
+		 * be changed due to preemption, in that case, this
+		 * do-while loop will run again.
+		 */
+		vcpu->wakeup_cpu = vcpu->cpu;
 	} while (cmpxchg(&pi_desc->control, old.control, new.control)
 			!= old.control);
 
+	spin_lock_irqsave(&per_cpu(blocked_vcpu_on_cpu_lock,
+			vcpu->wakeup_cpu), flags);
+	list_add_tail(&vcpu->blocked_vcpu_list,
+			&per_cpu(blocked_vcpu_on_cpu, vcpu->wakeup_cpu));
+	spin_unlock_irqrestore(&per_cpu(blocked_vcpu_on_cpu_lock,
+			vcpu->wakeup_cpu), flags);
 	return 0;
 }
 
@@ -9234,6 +9257,7 @@ static void vmx_vcpu_post_block(struct kvm_vcpu *vcpu)
 	struct pi_desc old;
 	struct pi_desc new;
 	unsigned int dest = 0;
+	unsigned long flags;
 
 	if (!irq_post_enabled)
 		return;
@@ -9255,6 +9279,13 @@ static void vmx_vcpu_post_block(struct kvm_vcpu *vcpu)
 	} while (cmpxchg(&pi_desc->control, old.control, new.control)
 			!= old.control);
 
+	spin_lock_irqsave(&per_cpu(blocked_vcpu_on_cpu_lock,
+				vcpu->wakeup_cpu), flags);
+	list_del(&vcpu->blocked_vcpu_list);
+	spin_unlock_irqrestore(&per_cpu(blocked_vcpu_on_cpu_lock,
+				vcpu->wakeup_cpu), flags);
+	vcpu->wakeup_cpu = -1;
+
 	pi_clear_sn(pi_desc);
 }
 
@@ -9372,6 +9403,25 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.vcpu_post_block = vmx_vcpu_post_block,
 };
 
+/*
+ * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
+ */
+void wakeup_handler(void)
+{
+	struct kvm_vcpu *vcpu;
+	int cpu = smp_processor_id();
+
+	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+	list_for_each_entry(vcpu, &per_cpu(blocked_vcpu_on_cpu, cpu),
+			blocked_vcpu_list) {
+		struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
+
+		if (pi_test_on(pi_desc) == 1)
+			kvm_vcpu_kick(vcpu);
+	}
+	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
+}
+
 static int __init vmx_init(void)
 {
 	int r, i, msr;
@@ -9486,6 +9536,8 @@ static int __init vmx_init(void)
 
 	update_ple_window_actual_max();
 
+	wakeup_handler_callback = wakeup_handler;
+
 	return 0;
 
 out7:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d0c8bb2..2061b3d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6156,6 +6156,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_vcpu_reload_apic_access_page(vcpu);
 	}
 
+	/*
+	 * Since posted-interrupts can be set by VT-d HW now, in this
+	 * case, KVM_REQ_EVENT is not set. We move the following
+	 * operations out of the if statement.
+	 */
+	if (kvm_lapic_enabled(vcpu)) {
+		/*
+		 * Update architecture specific hints for APIC
+		 * virtual interrupt delivery.
+		 */
+		if (kvm_x86_ops->hwapic_irr_update)
+			kvm_x86_ops->hwapic_irr_update(vcpu,
+				kvm_lapic_find_highest_irr(vcpu));
+	}
+
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
 		kvm_apic_accept_events(vcpu);
 		if (vcpu->arch.mp_state == KVM_MP_STATE_INIT_RECEIVED) {
@@ -6172,13 +6187,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_x86_ops->enable_irq_window(vcpu);
 
 		if (kvm_lapic_enabled(vcpu)) {
-			/*
-			 * Update architecture specific hints for APIC
-			 * virtual interrupt delivery.
-			 */
-			if (kvm_x86_ops->hwapic_irr_update)
-				kvm_x86_ops->hwapic_irr_update(vcpu,
-					kvm_lapic_find_highest_irr(vcpu));
 			update_cr8_intercept(vcpu);
 			kvm_lapic_sync_to_vapic(vcpu);
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6bb8287..614b4ba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -239,6 +239,9 @@ struct kvm_vcpu {
 	unsigned long requests;
 	unsigned long guest_debug;
 
+	int wakeup_cpu;
+	struct list_head blocked_vcpu_list;
+
 	struct mutex mutex;
 	struct kvm_run *run;
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1be1a45..fb3e504 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -224,6 +224,9 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	init_waitqueue_head(&vcpu->wq);
 	kvm_async_pf_vcpu_init(vcpu);
 
+	vcpu->wakeup_cpu = -1;
+	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
+
 	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!page) {
 		r = -ENOMEM;
-- 
1.7.1

