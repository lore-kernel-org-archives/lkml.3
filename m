Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbaCDWk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:40:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:62908 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaCDWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:40:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,588,1389772800"; 
   d="scan'208";a="494106883"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 1/3] x86, random: Enable the RDSEED instruction
Date: Tue,  4 Mar 2014 14:40:13 -0800
Message-Id: <1393972815-16689-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

Upcoming Intel silicon adds a new RDSEED instruction.  Whereas RDRAND
returns output from a PRNG, the RDSEED instruction returns fully
conditioned entropy that is suitable for use as seeds to a PRNG.

The RDSEED instruction takes the same time to execute as RDRAND, but
RDSEED unlike RDRAND can legitimately return failure (CF=0) due to
entropy exhaustion if too many threads on too many cores are hammering
the RDSEED instruction at the same time.  Therefore, we have to be
more conservative and only use it in places where we can tolerate
failures.

This patch introduces the primitives arch_get_random_seed_{int,long}()
but does not use it yet.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/archrandom.h | 34 +++++++++++++++++++++++++++++++++-
 include/linux/random.h            | 16 ++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index e6a9245..6e97683 100644
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
@@ -31,10 +31,13 @@
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
@@ -53,6 +56,16 @@ static inline int rdrand_long(unsigned long *v)
 	return ok;
 }
 
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
@@ -70,16 +83,35 @@ static inline int name(type *v)					\
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
 
 #else
diff --git a/include/linux/random.h b/include/linux/random.h
index 1cfce0e..4417693 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -88,6 +88,22 @@ static inline int arch_get_random_int(unsigned int *v)
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
1.8.3.1

