Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbaKFW7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:59:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58958 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaKFWnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 097/162] KVM: x86: Prevent host from panicking on shared MSR writes.
Date: Thu,  6 Nov 2014 14:36:01 -0800
Message-Id: <1415313426-9622-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 8b3c3104c3f4f706e99365c3e0d2aa61b95f969f upstream.

The previous patch blocked invalid writes directly when the MSR
is written.  As a precaution, prevent future similar mistakes by
gracefulling handle GPs caused by writes to shared MSRs.

Signed-off-by: Andrew Honig <ahonig@google.com>
[Remove parts obsoleted by Nadav's patch. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx.c              |  7 +++++--
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7b39dfd..dba6f79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1053,7 +1053,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
-void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 21cacdc..4dd0201 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2546,12 +2546,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
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
index f435e75..450c5c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -225,20 +225,25 @@ static void kvm_shared_msr_cpu_online(void)
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
1.9.1

