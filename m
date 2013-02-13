Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab3BMLmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:42:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60986 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611Ab3BMLmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:42:50 -0500
From: Borislav Petkov <bp@alien8.de>
To: kvm@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andre Przywara <andre@andrep.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH] x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs
Date: Wed, 13 Feb 2013 12:42:41 +0100
Message-Id: <1360755761-725-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The "x86, AMD: Enable WC+ memory type on family 10 processors" patch
currently in -tip added a workaround for AMD F10h CPUs which #GPs my
guest when booted in kvm. This is because it accesses MSR_AMD64_BU_CFG2
which is not currently ignored by kvm. Do that because this MSR is only
baremetal-relevant anyway. While at it, move the ignored MSRs at the
beginning of kvm_set_msr_common so that we exit then and there.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Andre Przywara <andre@andrep.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c243b81e3c74..37040079cd6b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1881,6 +1881,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u64 data = msr_info->data;
 
 	switch (msr) {
+	case MSR_AMD64_NB_CFG:
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_UCODE_WRITE:
+	case MSR_VM_HSAVE_PA:
+	case MSR_AMD64_PATCH_LOADER:
+	case MSR_AMD64_BU_CFG2:
+		break;
+
 	case MSR_EFER:
 		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
@@ -1900,8 +1908,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		}
 		break;
-	case MSR_AMD64_NB_CFG:
-		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!data) {
 			/* We support the non-activated case already */
@@ -1914,11 +1920,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu_unimpl(vcpu, "%s: MSR_IA32_DEBUGCTLMSR 0x%llx, nop\n",
 			    __func__, data);
 		break;
-	case MSR_IA32_UCODE_REV:
-	case MSR_IA32_UCODE_WRITE:
-	case MSR_VM_HSAVE_PA:
-	case MSR_AMD64_PATCH_LOADER:
-		break;
 	case 0x200 ... 0x2ff:
 		return set_msr_mtrr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
@@ -2253,6 +2254,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_K8_INT_PENDING_MSG:
 	case MSR_AMD64_NB_CFG:
 	case MSR_FAM10H_MMIO_CONF_BASE:
+	case MSR_AMD64_BU_CFG2:
 		data = 0;
 		break;
 	case MSR_P6_PERFCTR0:
-- 
1.8.1.3.535.ga923c31

