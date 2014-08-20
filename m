Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaHTUz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaHTUyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:54:07 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 2/6] KVM: x86: introduce sched_in to kvm_x86_ops
Date: Wed, 20 Aug 2014 22:53:13 +0200
Message-Id: <1408567997-21222-3-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched_in preempt notifier is available for x86, allow its use in
specific virtualization technlogies as well.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/vmx.c              | 6 ++++++
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5724601..358e2f3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -772,6 +772,8 @@ struct kvm_x86_ops {
 	bool (*mpx_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
+
+	void (*sched_in)(struct kvm_vcpu *kvm, int cpu);
 };
 
 struct kvm_arch_async_pf {
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ddf7427..4baf1bc 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4305,6 +4305,10 @@ static void svm_handle_external_intr(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 }
 
+static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 static struct kvm_x86_ops svm_x86_ops = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -4406,6 +4410,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.check_intercept = svm_check_intercept,
 	.handle_external_intr = svm_handle_external_intr,
+
+	.sched_in = svm_sched_in,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bfe11cf..2b306f9 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8846,6 +8846,10 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	return X86EMUL_CONTINUE;
 }
 
+void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
 static struct kvm_x86_ops vmx_x86_ops = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -8951,6 +8955,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.mpx_supported = vmx_mpx_supported,
 
 	.check_nested_events = vmx_check_nested_events,
+
+	.sched_in = vmx_sched_in,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7c214f..5696ee7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7148,6 +7148,7 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
+	kvm_x86_ops->sched_in(vcpu, cpu);
 }
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
-- 
2.0.4

