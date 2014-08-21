Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaHUQKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:10:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaHUQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:10:28 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: [PATCH v3 1/7] KVM: add kvm_arch_sched_in
Date: Thu, 21 Aug 2014 18:08:05 +0200
Message-Id: <1408637291-18533-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce preempt notifiers for architecture specific code.
Advantage over creating a new notifier in every arch is slightly simpler
code and guaranteed call order with respect to kvm_sched_in.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/arm/kvm/arm.c         | 4 ++++
 arch/mips/kvm/mips.c       | 4 ++++
 arch/powerpc/kvm/powerpc.c | 4 ++++
 arch/s390/kvm/kvm-s390.c   | 4 ++++
 arch/x86/kvm/x86.c         | 4 ++++
 include/linux/kvm_host.h   | 2 ++
 virt/kvm/kvm_main.c        | 2 ++
 7 files changed, 24 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index a99e0cd..9f788eb 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -288,6 +288,10 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	vcpu->cpu = cpu;
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index cd71141..2362df2 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1002,6 +1002,10 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 				  struct kvm_translation *tr)
 {
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 4c79284..cbc432f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -720,6 +720,10 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	kvmppc_subarch_vcpu_uninit(vcpu);
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 #ifdef CONFIG_BOOKE
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ce81eb2..a3c324e 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -555,6 +555,10 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	/* Nothing todo */
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	save_fp_ctl(&vcpu->arch.host_fpregs.fpc);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f1e22d..d7c214f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7146,6 +7146,10 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 		static_key_slow_dec(&kvm_no_apic_vcpu);
 }
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
 	if (type)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a4c33b3..ebd7236 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -624,6 +624,8 @@ void kvm_arch_exit(void);
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
 
+void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu);
+
 void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 33712fb..d3c3ed0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3123,6 +3123,8 @@ static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
 	if (vcpu->preempted)
 		vcpu->preempted = false;
 
+	kvm_arch_sched_in(vcpu, cpu);
+
 	kvm_arch_vcpu_load(vcpu, cpu);
 }
 
-- 
2.1.0

