Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbbAWUlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:41:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:27345 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbbAWUks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:40:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,456,1418112000"; 
   d="scan'208";a="674998219"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v2 2/2] x86: Add support for the clwb instruction
Date: Fri, 23 Jan 2015 13:40:28 -0700
Message-Id: <1422045628-16225-3-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1422045628-16225-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new clwb instruction.  This instruction was
announced in the document "Intel Architecture Instruction Set Extensions
Programming Reference" with reference number 319433-022.

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

Regarding the details of how the alternatives assembly is set up, we
need one additional byte at the beginning of the clflush so that we can
flip it into a clflushopt by changing that byte into a 0x66 prefix.  Two
options are to either insert a 1 byte ASM_NOP1, or to add a 1 byte
NOP_DS_PREFIX.  Both have no functional effect with the plain clflush,
but I've been told that executing a clflush + prefix should be faster
than executing a clflush + NOP.

We had to hard code the assembly for clwb because, lacking the ability
to assemble the clwb instruction itself, the next closest thing is to
have an xsaveopt instruction with a 0x66 prefix.  Unfortunately xsaveopt
itself is also relatively new, and isn't included by all the GCC
versions that the kernel needs to support.

I tested this patch with the following versions of GCC:
gcc (GCC) 4.8.3 20140911 (Red Hat 4.8.3-7)
gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-55)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: H Peter Anvin <h.peter.anvin@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
---
 arch/x86/include/asm/cpufeature.h    |  1 +
 arch/x86/include/asm/special_insns.h | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index dfdd689..dc91747 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -222,6 +222,7 @@
 #define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
 #define X86_FEATURE_PCOMMIT	( 9*32+22) /* PCOMMIT instruction */
 #define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
+#define X86_FEATURE_CLWB	( 9*32+24) /* CLWB instruction */
 #define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
 #define X86_FEATURE_AVX512ER	( 9*32+27) /* AVX-512 Exponential and Reciprocal */
 #define X86_FEATURE_AVX512CD	( 9*32+28) /* AVX-512 Conflict Detection */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 1709a2e..8883cbc 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -199,6 +199,20 @@ static inline void clflushopt(volatile void *__p)
 		       "+m" (*(volatile char __force *)__p));
 }
 
+static inline void clwb(volatile void *__p)
+{
+	volatile struct { char x[64]; } *p = __p;
+
+	asm volatile(ALTERNATIVE_2(
+		".byte " __stringify(NOP_DS_PREFIX) "; clflush (%[pax])",
+		".byte 0x66; clflush (%[pax])", /* clflushopt (%%rax) */
+		X86_FEATURE_CLFLUSHOPT,
+		".byte 0x66, 0x0f, 0xae, 0x30",  /* clwb (%%rax) */
+		X86_FEATURE_CLWB)
+		: [p] "+m" (*p)
+		: [pax] "a" (p));
+}
+
 static inline void pcommit(void)
 {
 	alternative(ASM_NOP4, ".byte 0x66, 0x0f, 0xae, 0xf8",
-- 
1.9.3

