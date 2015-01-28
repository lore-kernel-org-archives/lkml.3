Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934157AbbA1EVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:12 -0500
Received: from mail.kernel.org ([198.145.29.136]:39437 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933192AbbA1EVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:06 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Honig <ahonig@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 078/177] KVM: x86: Prevent host from panicking on shared MSR writes.
Date: Wed, 28 Jan 2015 12:08:42 +0800
Message-Id: <1422418236-12852-155-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 8b3c3104c3f4f706e99365c3e0d2aa61b95f969f upstream.

The previous patch blocked invalid writes directly when the MSR
is written.  As a precaution, prevent future similar mistakes by
gracefulling handle GPs caused by writes to shared MSRs.

Signed-off-by: Andrew Honig <ahonig@google.com>
[Remove parts obsoleted by Nadav's patch. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[lizf: Backported to 3.4:
 - adjust context
 - s/wrmsrl_safe/checking_wrmsrl/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx.c              |  7 +++++--
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c1e0ef0..4f78757 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -954,7 +954,7 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
 int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
-void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7806435..338f478 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2210,12 +2210,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
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
index 51cc661..318a245 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -220,19 +220,24 @@ static void kvm_shared_msr_cpu_online(void)
 		shared_msr_update(i, shared_msrs_global.msrs[i]);
 }
 
-void kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
+int kvm_set_shared_msr(unsigned slot, u64 value, u64 mask)
 {
 	struct kvm_shared_msrs *smsr = &__get_cpu_var(shared_msrs);
+	int err;
 
 	if (((value ^ smsr->values[slot].curr) & mask) == 0)
-		return;
+		return 0;
 	smsr->values[slot].curr = value;
-	wrmsrl(shared_msrs_global.msrs[slot], value);
+	err = checking_wrmsrl(shared_msrs_global.msrs[slot], value);
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

