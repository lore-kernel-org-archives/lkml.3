Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbbA0Qyu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:54:50 -0500
Received: from mga14.intel.com ([192.55.52.115]:50861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758682AbbA0Qyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:54:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,475,1418112000"; 
   d="scan'208";a="518431627"
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 2/2] x86: Add support for the clwb instruction
Date: Tue, 27 Jan 2015 09:53:51 -0700
Message-Id: <1422377631-8986-3-git-send-email-ross.zwisler@linux.intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the new clwb (cache line write back) instruction.  This
instruction was announced in the document "Intel Architecture
Instruction Set Extensions Programming Reference" with reference number
319433-022.

https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf

The clwb instruction is used to write back the contents of dirtied cache
lines to memory without evicting the cache lines from the processor's
cache hierarchy.  This should be used in favor of clflushopt or clflush
in cases where you require the cache line to be written to memory but
plan to access the data again in the near future.

One of the main use cases for this is with persistent memory where clwb
can be used with pcommit to ensure that data has been accepted to memory
and is durable on the DIMM.

This function shows how to properly use clwb/clflushopt/clflush and
pcommit with appropriate fencing:

void flush_and_commit_buffer(void *vaddr, unsigned int size)
{
	void *vend = vaddr + size - 1;

	for (; vaddr < vend; vaddr += boot_cpu_data.x86_clflush_size)
		clwb(vaddr);

	/* Flush any possible final partial cacheline */
	clwb(vend);

	/*
	 * sfence to order clwb/clflushopt/clflush cache flushes
	 * mfence via mb() also works
	 */
	wmb();

	/* pcommit and the required sfence for ordering */
	pcommit_sfence();
}

After this function completes the data pointed to by vaddr is has been
accepted to memory and will be durable if the vaddr points to
persistent memory.

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
index d686f9b..0772365 100644
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
 static inline void pcommit_sfence(void)
 {
 	alternative(ASM_NOP7,
-- 
1.9.3

