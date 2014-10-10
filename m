Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaJJVsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:48:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:3740 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbaJJVsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:48:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="603614776"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, rostedt@goodmis.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/4] x86: Move msr accesses out of line
Date: Fri, 10 Oct 2014 14:47:50 -0700
Message-Id: <1412977673-13500-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

To add trace points to msr accesses we need to include
linux/tracepoint.h. Unfortunately this causes hellish include loops
when done in asm/msr.h, which is included all over. I tried to fix
several of them, but eventually gave up.

This patch moves the MSR functions out of line. A MSR access is typically
40-100 cycles or even slower, a call is a few cycles at best, so the
additional function call is not really significant.

Kernel text size is neutral:
11852945	1671656	1822720	15347321	 ea2e79	vmlinux-no-msr
11852969	1671656	1822720	15347345	 ea2e91	vmlinux-msr

Another advantage is that we can now use the function_graph tracer
to see how expensive MSR accesses are.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/msr.h | 51 ++++-----------------------------------------
 arch/x86/lib/msr.c         | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index de36f22..99d6864 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -57,53 +57,10 @@ static inline unsigned long long native_read_tscp(unsigned int *aux)
 #define EAX_EDX_RET(val, low, high)	"=A" (val)
 #endif
 
-static inline unsigned long long native_read_msr(unsigned int msr)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("rdmsr" : EAX_EDX_RET(val, low, high) : "c" (msr));
-	return EAX_EDX_VAL(val, low, high);
-}
-
-static inline unsigned long long native_read_msr_safe(unsigned int msr,
-						      int *err)
-{
-	DECLARE_ARGS(val, low, high);
-
-	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
-		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), [fault] "i" (-EIO));
-	return EAX_EDX_VAL(val, low, high);
-}
-
-static inline void native_write_msr(unsigned int msr,
-				    unsigned low, unsigned high)
-{
-	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
-}
-
-/* Can be uninlined because referenced by paravirt */
-notrace static inline int native_write_msr_safe(unsigned int msr,
-					unsigned low, unsigned high)
-{
-	int err;
-	asm volatile("2: wrmsr ; xor %[err],%[err]\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
-		     : [err] "=a" (err)
-		     : "c" (msr), "0" (low), "d" (high),
-		       [fault] "i" (-EIO)
-		     : "memory");
-	return err;
-}
+extern unsigned long long native_read_msr(unsigned int msr);
+extern unsigned long long native_read_msr_safe(unsigned int msr, int *err);
+extern int native_write_msr_safe(unsigned int msr, unsigned low, unsigned high);
+extern void native_write_msr(unsigned int msr, unsigned low, unsigned high);
 
 extern unsigned long long native_read_tsc(void);
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4362373..dc857b8 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -108,3 +108,55 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
+
+inline unsigned long long native_read_msr(unsigned int msr)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("rdmsr" : EAX_EDX_RET(val, low, high) : "c" (msr));
+	return EAX_EDX_VAL(val, low, high);
+}
+EXPORT_SYMBOL(native_read_msr);
+
+inline unsigned long long native_read_msr_safe(unsigned int msr,
+						      int *err)
+{
+	DECLARE_ARGS(val, low, high);
+
+	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     _ASM_EXTABLE(2b, 3b)
+		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
+		     : "c" (msr), [fault] "i" (-EIO));
+	return EAX_EDX_VAL(val, low, high);
+}
+EXPORT_SYMBOL(native_read_msr_safe);
+
+inline void native_write_msr(unsigned int msr,
+				    unsigned low, unsigned high)
+{
+	asm volatile("wrmsr" : : "c" (msr), "a"(low), "d" (high) : "memory");
+}
+EXPORT_SYMBOL(native_write_msr);
+
+/* Can be uninlined because referenced by paravirt */
+notrace inline int native_write_msr_safe(unsigned int msr,
+					unsigned low, unsigned high)
+{
+	int err;
+	asm volatile("2: wrmsr ; xor %[err],%[err]\n"
+		     "1:\n\t"
+		     ".section .fixup,\"ax\"\n\t"
+		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
+		     ".previous\n\t"
+		     _ASM_EXTABLE(2b, 3b)
+		     : [err] "=a" (err)
+		     : "c" (msr), "0" (low), "d" (high),
+		       [fault] "i" (-EIO)
+		     : "memory");
+	return err;
+}
+EXPORT_SYMBOL(native_write_msr_safe);
-- 
1.9.3

