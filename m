Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933412AbaKROy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:54:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaKROJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Honig <ahonig@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 103/206] KVM: x86: Prevent host from panicking on shared MSR writes.
Date: Tue, 18 Nov 2014 15:07:38 +0100
Message-Id: <9f9a1ce3932ca0b1bd52932d70929eab6e574d97.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8b3c3104c3f4f706e99365c3e0d2aa61b95f969f upstream.

The previous patch blocked invalid writes directly when the MSR
is written.  As a precaution, prevent future similar mistakes by
gracefulling handle GPs caused by writes to shared MSRs.

Signed-off-by: Andrew Honig <ahonig@google.com>
[Remove parts obsoleted by Nadav's patch. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx.c              |  7 +++++--
 arch/x86/kvm/x86.c              | 11 ++++++++---
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 847b165b9f9e..7cd6e5af871e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1032,7 +1032,7 @@ int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
 
 void kvm_define_shared_msr(unsigned index, u32 msr);
-void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
+int kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
 
 bool kvm_is_linear_rip(struct kvm_vcpu *vcpu, unsigned long linear_rip);
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 59181e653826..f6e13e6bc025 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2540,12 +2540,15 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index 77046f7177d5..c969e93c208c 100644
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
2.1.3

