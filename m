Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaIVLR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:17:58 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59351 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaIVLR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:17:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: chris@arachsys.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86: kvm: use alternatives for VMCALL vs. VMMCALL if kernel text is read-only
Date: Mon, 22 Sep 2014 13:17:48 +0200
Message-Id: <1411384668-11135-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On x86_64, kernel text mappings are mapped read-only with CONFIG_DEBUG_RODATA.
In that case, KVM will fail to patch VMCALL instructions to VMMCALL
as required on AMD processors.

The failure mode is currently a divide-by-zero exception, which obviously
is a KVM bug that has to be fixed.  However, picking the right instruction
between VMCALL and VMMCALL will be faster and will help if you cannot upgrade
the hypervisor.

Reported-by: Chris Webb <chris@arachsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/cpufeature.h |  1 +
 arch/x86/include/asm/kvm_para.h   | 10 ++++++++--
 arch/x86/kernel/cpu/amd.c         |  7 +++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index bb9b258d60e7..2075e6c34c78 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -202,6 +202,7 @@
 #define X86_FEATURE_DECODEASSISTS ( 8*32+12) /* AMD Decode Assists support */
 #define X86_FEATURE_PAUSEFILTER ( 8*32+13) /* AMD filtered pause intercept */
 #define X86_FEATURE_PFTHRESHOLD ( 8*32+14) /* AMD pause filter threshold */
+#define X86_FEATURE_VMMCALL     ( 8*32+15) /* Prefer vmmcall to vmcall */
 
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (ebx), word 9 */
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index c7678e43465b..e62cf897f781 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_KVM_PARA_H
 
 #include <asm/processor.h>
+#include <asm/alternative.h>
 #include <uapi/asm/kvm_para.h>
 
 extern void kvmclock_init(void);
@@ -16,10 +17,15 @@ static inline bool kvm_check_and_clear_guest_paused(void)
 }
 #endif /* CONFIG_KVM_GUEST */
 
-/* This instruction is vmcall.  On non-VT architectures, it will generate a
- * trap that we will then rewrite to the appropriate instruction.
+#ifdef CONFIG_DEBUG_RODATA
+#define KVM_HYPERCALL \
+        ALTERNATIVE(".byte 0x0f,0x01,0xc1", ".byte 0x0f,0x01,0xd9", X86_FEATURE_VMMCALL)
+#else
+/* On AMD processors, vmcall will generate a trap that we will
+ * then rewrite to the appropriate instruction.
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
+#endif
 
 /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
  * instruction.  The hypervisor may replace it with something else but only the
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 60e5497681f5..813d29d00a17 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -525,6 +525,13 @@ static void early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
+	/*
+	 * This is only needed to tell the kernel whether to use VMCALL
+	 * and VMMCALL.  VMMCALL is never executed except under virt, so
+	 * we can set it unconditionally.
+	 */
+	set_cpu_cap(c, X86_FEATURE_VMMCALL);
+
 	/* F16h erratum 793, CVE-2013-6885 */
 	if (c->x86 == 0x16 && c->x86_model <= 0xf)
 		msr_set_bit(MSR_AMD64_LS_CFG, 15);
-- 
1.8.3.1

