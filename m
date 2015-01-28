Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbbA1EVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:39699 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964859AbbA1EVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:46 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Nadav Har'El" <nyh@il.ibm.com>,
        Jun Nakajima <jun.nakajima@intel.com>, Xinhao Xu <xinhao.xu@intel.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 084/177] nEPT: Nested INVEPT
Date: Wed, 28 Jan 2015 12:08:55 +0800
Message-Id: <1422418236-12852-168-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Har'El <nyh@il.ibm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bfd0a56b90005f8c8a004baf407ad90045c2b11e upstream.

If we let L1 use EPT, we should probably also support the INVEPT instruction.

In our current nested EPT implementation, when L1 changes its EPT table
for L2 (i.e., EPT12), L0 modifies the shadow EPT table (EPT02), and in
the course of this modification already calls INVEPT. But if last level
of shadow page is unsync not all L1's changes to EPT12 are intercepted,
which means roots need to be synced when L1 calls INVEPT. Global INVEPT
should not be different since roots are synced by kvm_mmu_load() each
time EPTP02 changes.

Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
Signed-off-by: Jun Nakajima <jun.nakajima@intel.com>
Signed-off-by: Xinhao Xu <xinhao.xu@intel.com>
Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context, filename
 - Simplify handle_invept() as recommended by Paolo - nEPT is not
   supported so we always raise #UD]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/vmx.c         | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 31f180c..021637e 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -279,6 +279,7 @@ enum vmcs_field {
 #define EXIT_REASON_APIC_ACCESS         44
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
+#define EXIT_REASON_INVEPT              50
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 338f478..2815895 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5566,6 +5566,12 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_invept(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5608,6 +5614,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PAUSE_INSTRUCTION]       = handle_pause,
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
+	[EXIT_REASON_INVEPT]                  = handle_invept,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5792,6 +5799,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
+	case EXIT_REASON_INVEPT:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
-- 
1.9.1

