Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbaKLBlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:41:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60166 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934293AbaKLBlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:41:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 079/203] KVM: x86: Prevent host from panicking on shared MSR writes.
Date: Wed, 12 Nov 2014 10:15:49 +0900
Message-Id: <20141112011546.322596657@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 8b3c3104c3f4f706e99365c3e0d2aa61b95f969f upstream.

The previous patch blocked invalid writes directly when the MSR
is written.  As a precaution, prevent future similar mistakes by
gracefulling handle GPs caused by writes to shared MSRs.

Signed-off-by: Andrew Honig <ahonig@google.com>
[Remove parts obsoleted by Nadav's patch. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/kvm_host.h |    2 +-
 arch/x86/kvm/vmx.c              |    7 +++++--
 arch/x86/kvm/x86.c              |   11 ++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1042,7 +1042,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcp
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
-void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2582,12 +2582,15 @@ static int vmx_set_msr(struct kvm_vcpu *
 	default:
 		msr = find_msr_entry(vmx, msr_index);
 		if (msr) {
+			u64 old_msr_data = msr->data;
 			msr->data = data;
 			if (msr - vmx->guest_msrs < vmx->save_nmsrs) {
 				preempt_disable();
-				kvm_set_shared_msr(msr->index, msr->data,
-						   msr->mask);
+				ret = kvm_set_shared_msr(msr->index, msr->data,
+							 msr->mask);
 				preempt_enable();
+				if (ret)
+					msr->data = old_msr_data;
 			}
 			break;
 		}
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -225,20 +225,25 @@ static void kvm_shared_msr_cpu_online(vo
 		shared_msr_update(i, shared_msrs_global.msrs[i]);
 }
 
-void kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
+int kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
 {
 	unsigned int cpu = smp_processor_id();
 	struct kvm_shared_msrs *smsr = per_cpu_ptr(shared_msrs, cpu);
+	int err;
 
 	if (((value ^ smsr->values[slot].curr) & mask) == 0)
-		return;
+		return 0;
 	smsr->values[slot].curr = value;
-	wrmsrl(shared_msrs_global.msrs[slot], value);
+	err = wrmsrl_safe(shared_msrs_global.msrs[slot], value);
+	if (err)
+		return 1;
+
 	if (!smsr->registered) {
 		smsr->urn.on_user_return = kvm_on_user_return;
 		user_return_notifier_register(&smsr->urn);
 		smsr->registered = true;
 	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_set_shared_msr);
 


