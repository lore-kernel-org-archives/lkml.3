Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FZFfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 01:35:52 -0400
Received: from [216.32.180.188] ([216.32.180.188]:38904 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751212Ab3FZFfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 01:35:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <kvm-ppc@vger.kernel.org>, <kvm@vger.kernel.org>, <agraf@suse.de>,
        <scottwood@freescale.com>, <tiejun.chen@windriver.com>,
        <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <mikey@neuling.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 4/6 v5] KVM: PPC: exit to user space on "ehpriv" instruction
Date: Wed, 26 Jun 2013 11:12:24 +0530
Message-ID: <1372225346-5029-5-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1372225346-5029-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ehpriv" instruction is used for setting software breakpoints
by user space. This patch adds support to exit to user space
with "run->debug" have relevant information.

As this is the first point we are using run->debug, also defined
the run->debug structure.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
 arch/powerpc/include/asm/disassemble.h |    4 ++++
 arch/powerpc/include/uapi/asm/kvm.h    |   21 +++++++++++++++++----
 arch/powerpc/kvm/e500_emulate.c        |   27 +++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/disassemble.h b/arch/powerpc/include/asm/disassemble.h
index 9b198d1..856f8de 100644
--- a/arch/powerpc/include/asm/disassemble.h
+++ b/arch/powerpc/include/asm/disassemble.h
@@ -77,4 +77,8 @@ static inline unsigned int get_d(u32 inst)
 	return inst & 0xffff;
 }
 
+static inline unsigned int get_oc(u32 inst)
+{
+	return (inst >> 11) & 0x7fff;
+}
 #endif /* __ASM_PPC_DISASSEMBLE_H__ */
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index 0fb1a6e..ded0607 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -269,7 +269,24 @@ struct kvm_fpu {
 	__u64 fpr[32];
 };
 
+/*
+ * Defines for h/w breakpoint, watchpoint (read, write or both) and
+ * software breakpoint.
+ * These are used as "type" in KVM_SET_GUEST_DEBUG ioctl and "status"
+ * for KVM_DEBUG_EXIT.
+ */
+#define KVMPPC_DEBUG_NONE		0x0
+#define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
+#define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
+#define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)
 struct kvm_debug_exit_arch {
+	__u64 address;
+	/*
+	 * exiting to userspace because of h/w breakpoint, watchpoint
+	 * (read, write or both) and software breakpoint.
+	 */
+	__u32 status;
+	__u32 reserved;
 };
 
 /* for KVM_SET_GUEST_DEBUG */
@@ -281,10 +298,6 @@ struct kvm_guest_debug_arch {
 		 * Type denotes h/w breakpoint, read watchpoint, write
 		 * watchpoint or watchpoint (both read and write).
 		 */
-#define KVMPPC_DEBUG_NONE		0x0
-#define KVMPPC_DEBUG_BREAKPOINT		(1UL << 1)
-#define KVMPPC_DEBUG_WATCH_WRITE	(1UL << 2)
-#define KVMPPC_DEBUG_WATCH_READ		(1UL << 3)
 		__u32 type;
 		__u32 reserved;
 	} bp[16];
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index b10a012..dab9d07 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -26,6 +26,8 @@
 #define XOP_TLBRE   946
 #define XOP_TLBWE   978
 #define XOP_TLBILX  18
+#define XOP_EHPRIV  270
+#define EHPRIV_OC_DEBUG 0
 
 #ifdef CONFIG_KVM_E500MC
 static int dbell2prio(ulong param)
@@ -82,6 +84,26 @@ static int kvmppc_e500_emul_msgsnd(struct kvm_vcpu *vcpu, int rb)
 }
 #endif
 
+static int kvmppc_e500_emul_ehpriv(struct kvm_run *run, struct kvm_vcpu *vcpu,
+				   unsigned int inst, int *advance)
+{
+	int emulated = EMULATE_DONE;
+
+	switch (get_oc(inst)) {
+	case EHPRIV_OC_DEBUG:
+		run->exit_reason = KVM_EXIT_DEBUG;
+		run->debug.arch.address = vcpu->arch.pc;
+		run->debug.arch.status = 0;
+		kvmppc_account_exit(vcpu, DEBUG_EXITS);
+		emulated = EMULATE_EXIT_USER;
+		*advance = 0;
+		break;
+	default:
+		emulated = EMULATE_FAIL;
+	}
+	return emulated;
+}
+
 int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
                            unsigned int inst, int *advance)
 {
@@ -130,6 +152,11 @@ int kvmppc_core_emulate_op(struct kvm_run *run, struct kvm_vcpu *vcpu,
 			emulated = kvmppc_e500_emul_tlbivax(vcpu, ea);
 			break;
 
+		case XOP_EHPRIV:
+			emulated = kvmppc_e500_emul_ehpriv(run, vcpu, inst,
+							   advance);
+			break;
+
 		default:
 			emulated = EMULATE_FAIL;
 		}
-- 
1.7.0.4


