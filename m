Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaDRAiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:38:12 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:13916 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaDRAhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:37:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkCAERzUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxKHfMYNhhQXjmIHhDgEiVylEzo
X-IPAS-Result: AkkCAERzUFOERM5ejGdsb2JhbABZyACBIxYOAQEBJzyCJgEFJ1IQQBFXBxKHfMYNhhQXjmIHhDgEiVylEzo
X-IronPort-AV: E=Sophos;i="4.97,882,1389736800"; 
   d="scan'208";a="102882851"
From: Nadav Amit <namit@cs.technion.ac.il>
To: gleb@kernel.org, pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/5] KVM: x86: Fix CR3 reserved bits
Date: Fri, 18 Apr 2014 03:35:09 +0300
Message-Id: <1397781312-6885-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il>
References: <1397777591-6147-1-git-send-email-namit@cs.technion.ac.il>
 <1397781312-6885-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel specifications, PAE and non-PAE does not have any reserved
bits.  In long-mode, regardless to PCIDE, only the high bits (above the
physical address) are reserved.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
:100644 100644 7de069af.. e21aee9... M	arch/x86/include/asm/kvm_host.h
:100644 100644 205b17e... 1d60374... M	arch/x86/kvm/emulate.c
:100644 100644 8b8fc0b... f4d9839... M	arch/x86/kvm/x86.c
 arch/x86/include/asm/kvm_host.h |    6 +-----
 arch/x86/kvm/emulate.c          |    4 ----
 arch/x86/kvm/x86.c              |   25 +++++--------------------
 3 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7de069af..e21aee9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -50,11 +50,7 @@
 			  | X86_CR0_ET | X86_CR0_NE | X86_CR0_WP | X86_CR0_AM \
 			  | X86_CR0_NW | X86_CR0_CD | X86_CR0_PG))
 
-#define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
-#define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
-#define CR3_PCID_ENABLED_RESERVED_BITS 0xFFFFFF0000000000ULL
-#define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS |	\
-				  0xFFFFFF0000000000ULL)
+#define CR3_L_MODE_RESERVED_BITS 0xFFFFFF0000000000ULL
 #define CR4_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE\
 			  | X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE     \
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 205b17e..1d60374 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3386,10 +3386,6 @@ static int check_cr_write(struct x86_emulate_ctxt *ctxt)
 		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
 		if (efer & EFER_LMA)
 			rsvd = CR3_L_MODE_RESERVED_BITS;
-		else if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PAE)
-			rsvd = CR3_PAE_RESERVED_BITS;
-		else if (ctxt->ops->get_cr(ctxt, 0) & X86_CR0_PG)
-			rsvd = CR3_NONPAE_RESERVED_BITS;
 
 		if (new_val & rsvd)
 			return emulate_gp(ctxt, 0);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8b8fc0b..f4d9839 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -701,26 +701,11 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu)) {
-		if (kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)) {
-			if (cr3 & CR3_PCID_ENABLED_RESERVED_BITS)
-				return 1;
-		} else
-			if (cr3 & CR3_L_MODE_RESERVED_BITS)
-				return 1;
-	} else {
-		if (is_pae(vcpu)) {
-			if (cr3 & CR3_PAE_RESERVED_BITS)
-				return 1;
-			if (is_paging(vcpu) &&
-			    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
-				return 1;
-		}
-		/*
-		 * We don't check reserved bits in nonpae mode, because
-		 * this isn't enforced, and VMware depends on this.
-		 */
-	}
+	if (is_long_mode(vcpu) && (cr3 & CR3_L_MODE_RESERVED_BITS))
+		return 1;
+	if (is_pae(vcpu) && is_paging(vcpu) &&
+	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+		return 1;
 
 	vcpu->arch.cr3 = cr3;
 	__set_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail);
-- 
1.7.10.4

