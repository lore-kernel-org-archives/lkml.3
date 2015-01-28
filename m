Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907AbbA1EVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:55 -0500
Received: from mail.kernel.org ([198.145.29.136]:39728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964887AbbA1EVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:51 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 085/177] kvm: vmx: handle invvpid vm exit gracefully
Date: Wed, 28 Jan 2015 12:08:57 +0800
Message-Id: <1422418236-12852-170-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petr Matousek <pmatouse@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit a642fc305053cc1c6e47e4f4df327895747ab485 upstream.

On systems with invvpid instruction support (corresponding bit in
IA32_VMX_EPT_VPID_CAP MSR is set) guest invocation of invvpid
causes vm exit, which is currently not handled and results in
propagation of unknown exit to userspace.

Fix this by installing an invvpid vm exit handler.

This is CVE-2014-3646.

Signed-off-by: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[lizf: Backported to 3.4:
 - adjust filename
 - drop the change to VMX_EXIT_REASON strings]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/include/asm/vmx.h | 1 +
 arch/x86/kvm/vmx.c         | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 021637e..504d1cf 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -280,6 +280,7 @@ enum vmcs_field {
 #define EXIT_REASON_EPT_VIOLATION       48
 #define EXIT_REASON_EPT_MISCONFIG       49
 #define EXIT_REASON_INVEPT              50
+#define EXIT_REASON_INVVPID		53
 #define EXIT_REASON_WBINVD		54
 #define EXIT_REASON_XSETBV		55
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2815895..43c39db 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5572,6 +5572,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_invvpid(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -5615,6 +5621,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
+	[EXIT_REASON_INVVPID]                 = handle_invvpid,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -5799,7 +5806,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
-	case EXIT_REASON_INVEPT:
+	case EXIT_REASON_INVEPT: case EXIT_REASON_INVVPID:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
-- 
1.9.1

