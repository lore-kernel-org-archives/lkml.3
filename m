Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3FIIpm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 04:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753234Ab3FIIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:45:29 -0400
Date: Sun, 9 Jun 2013 11:45:26 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: fix missed memory synchronization when patch
 hypercall
Message-ID: <20130609084526.GH4725@redhat.com>
References: <51B2A1D9.6060306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B2A1D9.6060306@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 08, 2013 at 11:15:37AM +0800, Xiao Guangrong wrote:
> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Currently, memory synchronization is missed in emulator_fix_hypercall,
> please see the commit 758ccc89b83
> (KVM: x86: drop calling kvm_mmu_zap_all in emulator_fix_hypercall)
> 
> This patch fixes it by introducing kvm_vcpus_hang_on_page_start() and
> kvm_vcpus_hang_on_page_end which unmap the patched page from guest
> and use kvm_flush_remote_tlbs() as the serializing instruction to
> ensure the memory coherence
> [ The SDM said that INVEPT, INVVPID and MOV (to control register, with
>   the exception of MOV CR8) are the serializing instructions. ]
> 
> The mmu-lock is held during host patches the page so that it stops vcpus
> to fix its further page fault
> 
I have a patch to implement is much simple and in generic way, not
relying on MMU internals.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6402951..49774ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5517,7 +5517,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
 
-static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
+static int emulator_fix_hypercall_cb(void *ctxt)
 {
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	char instruction[3];
@@ -5528,6 +5528,14 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 	return emulator_write_emulated(ctxt, rip, instruction, 3, NULL);
 }
 
+static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
+{
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+	return kvm_exec_with_stopped_vcpu(vcpu->kvm,
+			emulator_fix_hypercall_cb, ctxt);
+}
+
+
 /*
  * Check if userspace requested an interrupt window, and that the
  * interrupt window is open.
@@ -5761,6 +5769,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			kvm_deliver_pmi(vcpu);
 		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
 			vcpu_scan_ioapic(vcpu);
+		if (kvm_check_request(KVM_REQ_STOP_VCPU, vcpu)){
+			mutex_lock(&vcpu->kvm->lock);
+			mutex_unlock(&vcpu->kvm->lock);
+		}
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e3aae6d..6c9361a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -125,6 +125,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_EPR_EXIT          20
 #define KVM_REQ_SCAN_IOAPIC       21
 #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
+#define KVM_REQ_STOP_VCPU         23
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID		0
 #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
@@ -576,6 +577,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
 void kvm_reload_remote_mmus(struct kvm *kvm);
 void kvm_make_mclock_inprogress_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request(struct kvm *kvm);
+int kvm_exec_with_stopped_vcpu(struct kvm *kvm, int (*cb)(void *), void *data);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1580dd4..531e765 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -222,6 +222,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
 }
 
+int kvm_exec_with_stopped_vcpu(struct kvm *kvm, int (*cb)(void *), void *data)
+{
+	int r;
+
+	mutex_lock(&kvm->lock);
+	make_all_cpus_request(kvm, KVM_REQ_STOP_VCPU);
+	r = cb(data);
+	mutex_unlock(&kvm->lock);
+
+	return r;
+}
+
 int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 {
 	struct page *page;
--
			Gleb.
