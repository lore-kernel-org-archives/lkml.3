Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaKKL4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:56:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaKKLJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:52 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Petr Matousek <pmatouse@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 054/170] kvm: vmx: handle invvpid vm exit gracefully
Date: Tue, 11 Nov 2014 11:06:53 +0000
Message-Id: <1415704129-12709-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Matousek <pmatouse@redhat.com>

commit a642fc305053cc1c6e47e4f4df327895747ab485 upstream.

On systems with invvpid instruction support (corresponding bit in
IA32_VMX_EPT_VPID_CAP MSR is set) guest invocation of invvpid
causes vm exit, which is currently not handled and results in
propagation of unknown exit to userspace.

Fix this by installing an invvpid vm exit handler.

This is CVE-2014-3646.

Signed-off-by: Petr Matousek <pmatouse@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/uapi/asm/vmx.h | 2 ++
 arch/x86/kvm/vmx.c              | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 0e79420376eb..990a2fe1588d 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -67,6 +67,7 @@
 #define EXIT_REASON_EPT_MISCONFIG       49
 #define EXIT_REASON_INVEPT              50
 #define EXIT_REASON_PREEMPTION_TIMER    52
+#define EXIT_REASON_INVVPID             53
 #define EXIT_REASON_WBINVD              54
 #define EXIT_REASON_XSETBV              55
 #define EXIT_REASON_APIC_WRITE          56
@@ -114,6 +115,7 @@
 	{ EXIT_REASON_EOI_INDUCED,           "EOI_INDUCED" }, \
 	{ EXIT_REASON_INVALID_STATE,         "INVALID_STATE" }, \
 	{ EXIT_REASON_INVD,                  "INVD" }, \
+	{ EXIT_REASON_INVVPID,               "INVVPID" }, \
 	{ EXIT_REASON_INVPCID,               "INVPCID" }
 
 #endif /* _UAPIVMX_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 8aa791602cb1..5f885b760846 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6618,6 +6618,12 @@ static int handle_invept(struct kvm_vcpu *vcpu)
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
@@ -6663,6 +6669,7 @@ static int (*const kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_mwait,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_monitor,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
+	[EXIT_REASON_INVVPID]                 = handle_invvpid,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6896,7 +6903,7 @@ static bool nested_vmx_exit_handled(struct kvm_vcpu *vcpu)
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
-	case EXIT_REASON_INVEPT:
+	case EXIT_REASON_INVEPT: case EXIT_REASON_INVVPID:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!
-- 
2.1.0

