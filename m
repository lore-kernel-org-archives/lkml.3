Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792Ab3BSTcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:32:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab3BSTch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:32:37 -0500
Date: Tue, 19 Feb 2013 11:30:28 -0800
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-2e32b7190641a184b8510d3e342400473ff1ab60@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boris.ostrovsky@oracle.com, gleb@redhat.com, andre@andrep.de,
        mtosatti@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, gleb@redhat.com, andre@andrep.de,
        mtosatti@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        bp@suse.de
In-Reply-To: <1361298793-31834-2-git-send-email-bp@alien8.de>
References: <1361298793-31834-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, kvm:
  Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs
Git-Commit-ID: 2e32b7190641a184b8510d3e342400473ff1ab60
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Feb 2013 11:30:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e32b7190641a184b8510d3e342400473ff1ab60
Gitweb:     http://git.kernel.org/tip/2e32b7190641a184b8510d3e342400473ff1ab60
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Tue, 19 Feb 2013 19:33:13 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 19 Feb 2013 10:44:07 -0800

x86, kvm: Add MSR_AMD64_BU_CFG2 to the list of ignored MSRs

The "x86, AMD: Enable WC+ memory type on family 10 processors" patch
currently in -tip added a workaround for AMD F10h CPUs which #GPs my
guest when booted in kvm. This is because it accesses MSR_AMD64_BU_CFG2
which is not currently ignored by kvm. Do that because this MSR is only
baremetal-relevant anyway. While at it, move the ignored MSRs at the
beginning of kvm_set_msr_common so that we exit then and there.

Acked-by: Gleb Natapov <gleb@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Andre Przywara <andre@andrep.de>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1361298793-31834-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c243b81..3704007 100644
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
