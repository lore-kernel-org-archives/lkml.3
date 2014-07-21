Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaGULk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:40:29 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:54462 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932197AbaGULjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:39:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4KIZMF49LBxaEMAWKX6g8aQ
X-IPAS-Result: AjcBAIb6zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4KIZMF49LBxaEMAWKX6g8aQ
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353347"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/7] KVM: x86: Function for determining exception type
Date: Mon, 21 Jul 2014 14:37:25 +0300
Message-Id: <1405942650-22589-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New function for determining the x86 exception type: fault, abort, trap, etc.
This function is used by the next patch for setting rflags.rf upon faults.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/x86.c | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h |  9 +++++++++
 2 files changed, 44 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f750b69..c2aa58e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -311,6 +311,41 @@ static int exception_class(int vector)
 	return EXCPT_BENIGN;
 }
 
+int kvm_exception_type(unsigned int nr)
+{
+	switch (nr) {
+	case DE_VECTOR:
+	case BR_VECTOR:
+	case UD_VECTOR:
+	case NM_VECTOR:
+	case TS_VECTOR:
+	case NP_VECTOR:
+	case SS_VECTOR:
+	case GP_VECTOR:
+	case PF_VECTOR:
+	case MF_VECTOR:
+	case AC_VECTOR:
+	case XM_VECTOR:
+	case VE_VECTOR:
+		return EXCPT_FAULT;
+	case DB_VECTOR:
+		return EXCPT_FAULT_OR_TRAP;
+	case BP_VECTOR:
+	case OF_VECTOR:
+		return EXCPT_TRAP;
+	case DF_VECTOR:
+	case MC_VECTOR:
+		return EXCPT_ABORT;
+	case 15:
+	case 21 ... 31:
+		return EXCPT_RESERVED;
+	default:
+		break;
+	}
+	return EXCPT_INTERRUPT;
+}
+EXPORT_SYMBOL_GPL(kvm_exception_type);
+
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		unsigned nr, bool has_error, u32 error_code,
 		bool reinject)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 306a1b7..b413181 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -151,6 +151,15 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 
 #define KVM_SUPPORTED_XCR0     (XSTATE_FP | XSTATE_SSE | XSTATE_YMM \
 				| XSTATE_BNDREGS | XSTATE_BNDCSR)
+
+#define EXCPT_FAULT		0
+#define EXCPT_TRAP		1
+#define EXCPT_FAULT_OR_TRAP	2
+#define EXCPT_ABORT		3
+#define EXCPT_RESERVED		4
+#define EXCPT_INTERRUPT		5
+int kvm_exception_type(unsigned int nr);
+
 extern u64 host_xcr0;
 
 extern u64 kvm_supported_xcr0(void);
-- 
1.9.1

