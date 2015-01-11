Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbbAKWFX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 17:05:23 -0500
Received: from shelob.surriel.com ([74.92.59.67]:38177 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbAKWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 17:05:12 -0500
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, hpa@zytor.com, matt.fleming@intel.com, bp@suse.de,
        oleg@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
Subject: [RFC PATCH 09/11] x86,fpu,kvm: keep vcpu FPU active as long as it is resident
Date: Sun, 11 Jan 2015 16:46:31 -0500
Message-Id: <1421012793-30106-10-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421012793-30106-1-git-send-email-riel@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Currently KVM always deactivates the FPU on VCPU unload, only to
reactivate it next time the guest uses it. This can make using the
FPU inside a KVM guest fairly expensive.

On the other hand, restoring the FPU state for a KVM guest is also
significantly more involved (and expensive) than restoring the FPU
state on bare metal, so it is unlikely we will want to do this all
the time for every single guest.

This patch strikes a fairly conservative balance, where the FPU
state is re-used as long as nothing else used the FPU registers
on the same CPU. This means the guest FPU will stay active across
KVM event handling in the host, and even periods where the guest
VCPU went idle, or got interrupted by a kernel thread, but no
userspace tasks ran on the CPU.

Smarter, and more aggressive policies may make sense.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/kvm/x86.c       | 26 +++++++++++++++++++-------
 include/linux/kvm_host.h |  2 +-
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0033df3..a5b01e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6128,10 +6128,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
-		if (kvm_check_request(KVM_REQ_DEACTIVATE_FPU, vcpu)) {
-			vcpu->fpu_active = 0;
-			kvm_x86_ops->fpu_deactivate(vcpu);
-		}
 		if (kvm_check_request(KVM_REQ_APF_HALT, vcpu)) {
 			/* Page is swapped out. Do synthetic halt */
 			vcpu->arch.apf.halted = true;
@@ -6188,8 +6184,23 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	preempt_disable();
 
 	kvm_x86_ops->prepare_guest_switch(vcpu);
-	if (vcpu->fpu_active)
-		kvm_load_guest_fpu(vcpu);
+
+	if (vcpu->fpu_active) {
+		if (this_cpu_read(fpu_owner) == &vcpu->arch.guest_fpu) {
+			/*
+			 * The FPU is all ours. Still restore the FPU state
+			 * from memory, just in case the emulator touched it.
+			 */
+			kvm_load_guest_fpu(vcpu);
+		} else {
+			/*
+			 * Something else is using the FPU. The guest will
+			 * re-activate it on demand, if needed.
+			 */
+			vcpu->fpu_active = 0;
+			kvm_x86_ops->fpu_deactivate(vcpu);
+		}
+	}
 	kvm_load_guest_xcr0(vcpu);
 
 	vcpu->mode = IN_GUEST_MODE;
@@ -6903,6 +6914,7 @@ void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	kvm_put_guest_xcr0(vcpu);
 	vcpu->guest_fpu_loaded = 1;
 	__kernel_fpu_begin();
+	this_cpu_write(fpu_owner, &vcpu->arch.guest_fpu);
 	fpu_restore_checking(&vcpu->arch.guest_fpu);
 	trace_kvm_fpu(1);
 }
@@ -6917,8 +6929,8 @@ void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	vcpu->guest_fpu_loaded = 0;
 	fpu_save_init(&vcpu->arch.guest_fpu);
 	__kernel_fpu_end();
+	/* but keep fpu_owner pointed at &vcpu->arch.guest_fpu */
 	++vcpu->stat.fpu_reload;
-	kvm_make_request(KVM_REQ_DEACTIVATE_FPU, vcpu);
 	trace_kvm_fpu(0);
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a6059bd..503259f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -121,7 +121,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_MMU_SYNC           7
 #define KVM_REQ_CLOCK_UPDATE       8
 #define KVM_REQ_KICK               9
-#define KVM_REQ_DEACTIVATE_FPU    10
+
 #define KVM_REQ_EVENT             11
 #define KVM_REQ_APF_HALT          12
 #define KVM_REQ_STEAL_UPDATE      13
-- 
1.9.3

