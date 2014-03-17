Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCQXhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:37:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:64364 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaCQXgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:36:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500757084"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 4/4] random: Add arch_has_random[_seed]()
Date: Mon, 17 Mar 2014 16:36:30 -0700
Message-Id: <1395099390-807-5-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
References: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add predicate functions for having arch_get_random[_seed]*().  The
only current use is to avoid the loop in arch_random_refill() when
arch_get_random_seed_long() is unavailable.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <michael@ellerman.id.au>
---
 arch/powerpc/include/asm/archrandom.h | 9 +++++++++
 arch/x86/include/asm/archrandom.h     | 3 +++
 drivers/char/random.c                 | 3 +++
 include/linux/random.h                | 8 ++++++++
 4 files changed, 23 insertions(+)

diff --git a/arch/powerpc/include/asm/archrandom.h b/arch/powerpc/include/asm/archrandom.h
index 801beba..bde5311 100644
--- a/arch/powerpc/include/asm/archrandom.h
+++ b/arch/powerpc/include/asm/archrandom.h
@@ -25,6 +25,11 @@ static inline int arch_get_random_int(unsigned int *v)
 	return rc;
 }
 
+static inline int arch_has_random(void)
+{
+	return !!ppc_md.get_random_long;
+}
+
 int powernv_get_random_long(unsigned long *v);
 
 static inline int arch_get_random_seed_long(unsigned long *v)
@@ -35,6 +40,10 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
+static inline int arch_has_random_seed(void)
+{
+	return 0;
+}
 
 #endif /* CONFIG_ARCH_RANDOM */
 
diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index ba064d5..c7ed4a6 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -100,6 +100,9 @@ GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
 
 #endif /* CONFIG_X86_64 */
 
+#define arch_has_random()	static_cpu_has(X86_FEATURE_RDRAND)
+#define arch_has_random_seed()	static_cpu_has(X86_FEATURE_RDSEED)
+
 #endif  /* CONFIG_ARCH_RANDOM */
 
 extern void x86_init_rdrand(struct cpuinfo_x86 *c);
diff --git a/drivers/char/random.c b/drivers/char/random.c
index c35cee2..6b75713 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1307,6 +1307,9 @@ static int arch_random_refill(void)
 	unsigned int i;
 	unsigned long buf[nlongs];
 
+	if (!arch_has_random_seed())
+		return 0;
+
 	for (i = 0; i < nlongs; i++) {
 		if (arch_get_random_seed_long(&buf[n]))
 			n++;
diff --git a/include/linux/random.h b/include/linux/random.h
index ddaddec..e7a221a 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -72,6 +72,10 @@ static inline int arch_get_random_int(unsigned int *v)
 {
 	return 0;
 }
+static inline int arch_has_random(void)
+{
+	return 0;
+}
 static inline int arch_get_random_seed_long(unsigned long *v)
 {
 	return 0;
@@ -80,6 +84,10 @@ static inline int arch_get_random_seed_int(unsigned int *v)
 {
 	return 0;
 }
+static inline int arch_has_random_seed(void)
+{
+	return 0;
+}
 #endif
 
 /* Pseudo random number generator from numerical recipes. */
-- 
1.8.5.3

