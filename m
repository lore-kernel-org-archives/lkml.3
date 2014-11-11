Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaKKL6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:58:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57333 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaKKLJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 049/170] KVM: x86: Prevent host from panicking on shared MSR writes.
Date: Tue, 11 Nov 2014 11:06:48 +0000
Message-Id: <1415704129-12709-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 8b3c3104c3f4f706e99365c3e0d2aa61b95f969f upstream.

The previous patch blocked invalid writes directly when the MSR
is written.  As a precaution, prevent future similar mistakes by
gracefulling handle GPs caused by writes to shared MSRs.

Signed-off-by: Andrew Honig <ahonig@google.com>
[Remove parts obsoleted by Nadav's patch. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx.c              |  7 +++++--
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c7172a1e6b53..3d9bcc6b9d99 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1061,7 +1061,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
-void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2a3bf6be0506..8aa791602cb1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2615,12 +2615,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c038486c9866..28e070af5030 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -227,20 +227,25 @@ static void kvm_shared_msr_cpu_online(void)
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
 
-- 
2.1.0

