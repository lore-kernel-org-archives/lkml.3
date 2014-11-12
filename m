Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380AbaKLBlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:41:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaKLBln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:41:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.14 085/203] kvm: vmx: handle invvpid vm exit gracefully
Date: Wed, 12 Nov 2014 10:15:55 +0900
Message-Id: <20141112011546.587060483@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/uapi/asm/vmx.h |    2 ++
 arch/x86/kvm/vmx.c              |    9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

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
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6444,6 +6444,12 @@ static int handle_invept(struct kvm_vcpu
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
@@ -6489,6 +6495,7 @@ static int (*const kvm_vmx_exit_handlers
 	[EXIT_REASON_MWAIT_INSTRUCTION]	      = handle_invalid_op,
 	[EXIT_REASON_MONITOR_INSTRUCTION]     = handle_invalid_op,
 	[EXIT_REASON_INVEPT]                  = handle_invept,
+	[EXIT_REASON_INVVPID]                 = handle_invvpid,
 };
 
 static const int kvm_vmx_max_exit_handlers =
@@ -6722,7 +6729,7 @@ static bool nested_vmx_exit_handled(stru
 	case EXIT_REASON_VMPTRST: case EXIT_REASON_VMREAD:
 	case EXIT_REASON_VMRESUME: case EXIT_REASON_VMWRITE:
 	case EXIT_REASON_VMOFF: case EXIT_REASON_VMON:
-	case EXIT_REASON_INVEPT:
+	case EXIT_REASON_INVEPT: case EXIT_REASON_INVVPID:
 		/*
 		 * VMX instructions trap unconditionally. This allows L1 to
 		 * emulate them for its L2 guest, i.e., allows 3-level nesting!


