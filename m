Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaCQXiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:38:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:48988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaCQXgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:36:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500757068"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 1/4] x86, random: Enable the RDSEED instruction
Date: Mon, 17 Mar 2014 16:36:27 -0700
Message-Id: <1395099390-807-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
References: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upcoming Intel silicon adds a new RDSEED instruction, which is similar
to RDRAND but provides a stronger guarantee: unlike RDRAND, RDSEED
will always reseed the PRNG from the true random number source between
each read.  Thus, the output of RDSEED is guaranteed to be 100%
entropic, unlike RDRAND which is only architecturally guaranteed to be
1/512 entropic (although in practice is much more.)

The RDSEED instruction takes the same time to execute as RDRAND, but
RDSEED unlike RDRAND can legitimately return failure (CF=0) due to
entropy exhaustion if too many threads on too many cores are hammering
the RDSEED instruction at the same time.  Therefore, we have to be
more conservative and only use it in places where we can tolerate
failures.

This patch introduces the primitives arch_get_random_seed_{int,long}()
but does not use it yet.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/archrandom.h |  9 +++++++++
 arch/x86/include/asm/archrandom.h     | 34 +++++++++++++++++++++++++++++++++-
 include/linux/random.h                |  8 ++++++++
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index d853d16..801beba 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -27,6 +27,15 @@ static inline int arch_get_random_int(unsigned int *v)
 
 int powernv_get_random_long(unsigned long *v);
 
+static inline int arch_get_random_seed_long(unsigned long *v)
+{
+	return 0;
+}
+static inline int arch_get_random_seed_int(unsigned int *v)
+{
+	return 0;
+}
+
 #endif /* CONFIG_ARCH_RANDOM */
 
 #endif /* _ASM_POWERPC_ARCHRANDOM_H */
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 0d9ec77..ba064d5 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -1,7 +1,7 @@
 /*
  * This file is part of the Linux kernel.
  *
- * Copyright (c) 2011, Intel Corporation
+ * Copyright (c) 2011-2014, Intel Corporation
  * Authors: Fenghua Yu <fenghua.yu@intel.com>,
  *          H. Peter Anvin <hpa@linux.intel.com>
  *
@@ -31,14 +31,27 @@
 #define RDRAND_RETRY_LOOPS	10
 
 #define RDRAND_INT	".byte 0x0f,0xc7,0xf0"
+#define RDSEED_INT	".byte 0x0f,0xc7,0xf8"
 #ifdef CONFIG_X86_64
 # define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
+# define RDSEED_LONG	".byte 0x48,0x0f,0xc7,0xf8"
 #else
 # define RDRAND_LONG	RDRAND_INT
+# define RDSEED_LONG	RDSEED_INT
 #endif
 
 #ifdef CONFIG_ARCH_RANDOM
 
+/* A single attempt at RDSEED */
+static inline bool rdseed_long(unsigned long *v)
+{
+	unsigned char ok;
+	asm volatile(RDSEED_LONG "\n\t"
+		     "setc %0"
+		     : "=qm" (ok), "=a" (*v));
+	return ok;
+}
+
 #define GET_RANDOM(name, type, rdrand, nop)			\
 static inline int name(type *v)					\
 {								\
@@ -56,16 +69,35 @@ static inline int name(type *v)					\
 	return ok;						\
 }
 
+#define GET_SEED(name, type, rdseed, nop)			\
+static inline int name(type *v)					\
+{								\
+	unsigned char ok;					\
+	alternative_io("movb $0, %0\n\t"			\
+		       nop,					\
+		       rdseed "\n\t"				\
+		       "setc %0",				\
+		       X86_FEATURE_RDSEED,                      \
+		       ASM_OUTPUT2("=q" (ok), "=a" (*v)));	\
+	return ok;						\
+}
+
 #ifdef CONFIG_X86_64
 
 GET_RANDOM(arch_get_random_long, unsigned long, RDRAND_LONG, ASM_NOP5);
 GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP4);
 
+GET_SEED(arch_get_random_seed_long, unsigned long, RDSEED_LONG, ASM_NOP5);
+GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
+
 #else
 
 GET_RANDOM(arch_get_random_long, unsigned long, RDRAND_LONG, ASM_NOP3);
 GET_RANDOM(arch_get_random_int, unsigned int, RDRAND_INT, ASM_NOP3);
 
+GET_SEED(arch_get_random_seed_long, unsigned long, RDSEED_LONG, ASM_NOP4);
+GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
+
 #endif /* CONFIG_X86_64 */
 
 #endif  /* CONFIG_ARCH_RANDOM */
diff --git a/include/linux/random.h b/include/linux/random.h
index 4002b3d..ddaddec 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -72,6 +72,14 @@ static inline int arch_get_random_int(unsigned int *v)
 {
 	return 0;
 }
+static inline int arch_get_random_seed_long(unsigned long *v)
+{
+	return 0;
+}
+static inline int arch_get_random_seed_int(unsigned int *v)
+{
+	return 0;
+}
 #endif
 
 /* Pseudo random number generator from numerical recipes. */
-- 
1.8.5.3

