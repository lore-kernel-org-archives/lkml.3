Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaGQSWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:22:45 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63203 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbaGQSWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:22:39 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: kvm@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, x86@kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        bsd@redhat.com, Andrew Honig <ahonig@google.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 3/5] x86,random: Add an x86 implementation of arch_get_rng_seed
Date: Thu, 17 Jul 2014 11:22:18 -0700
Message-Id: <ca9339079af07e9f598aa71ec77142ba72a0109b.1405620944.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1405620944.git.luto@amacapital.net>
References: <cover.1405620944.git.luto@amacapital.net>
In-Reply-To: <cover.1405620944.git.luto@amacapital.net>
References: <cover.1405620944.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is closer to Intel's recommended logic for using RDRAND and
RDSEED.  It will attempt to seed the entire internal state of the
RNG pool using RDSEED (with one bit of RDSEED output per bit of
state).  For any bits that can't be obtained using RDSEED (e.g. if
RDSEED is unavailable), it calculates the number of RDRAND reseeds
needed to obtain the missing bits from the internal NRBG and then
requests enough bits from RDRAND to obtain the full output from at
least that many reseeds.

Arguably, arch_get_random_seed could be removed now: I'm having some
trouble imagining a sensible non-architecture-specific use of it
that wouldn't be better served by arch_get_rng_seed.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/archrandom.h |  6 +++
 arch/x86/kernel/Makefile          |  2 +
 arch/x86/kernel/archrandom.c      | 79 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)
 create mode 100644 arch/x86/kernel/archrandom.c

diff --git a/arch/x86/include/asm/archrandom.h b/arch/x86/include/asm/archrandom.h
index 69f1366..88f9c5a 100644
--- a/arch/x86/include/asm/archrandom.h
+++ b/arch/x86/include/asm/archrandom.h
@@ -117,6 +117,12 @@ GET_SEED(arch_get_random_seed_int, unsigned int, RDSEED_INT, ASM_NOP4);
 #define arch_has_random()	static_cpu_has(X86_FEATURE_RDRAND)
 #define arch_has_random_seed()	static_cpu_has(X86_FEATURE_RDSEED)
 
+#define __HAVE_ARCH_GET_RNG_SEED
+extern void arch_get_rng_seed(void *ctx,
+			      void (*seed)(void *ctx, u32 data),
+			      int bits_per_source,
+			      const char *log_prefix);
+
 #else
 
 static inline int rdrand_long(unsigned long *v)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 047f9ff..0718bae 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -92,6 +92,8 @@ obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= paravirt-spinlocks.o
 obj-$(CONFIG_PARAVIRT_CLOCK)	+= pvclock.o
 
+obj-$(CONFIG_ARCH_RANDOM)	+= archrandom.o
+
 obj-$(CONFIG_PCSPKR_PLATFORM)	+= pcspeaker.o
 
 obj-$(CONFIG_X86_CHECK_BIOS_CORRUPTION) += check.o
diff --git a/arch/x86/kernel/archrandom.c b/arch/x86/kernel/archrandom.c
new file mode 100644
index 0000000..5515fc8
--- /dev/null
+++ b/arch/x86/kernel/archrandom.c
@@ -0,0 +1,79 @@
+/*
+ * This file is part of the Linux kernel.
+ *
+ * Copyright (c) 2014 Andy Lutomirski
+ * Authors: Andy Lutomirski <luto@amacapital.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <asm/archrandom.h>
+
+void arch_get_rng_seed(void *ctx,
+		       void (*seed)(void *ctx, u32 data),
+		       int bits_per_source,
+		       const char *log_prefix)
+{
+	int i, longs = (bits_per_source + BITS_PER_LONG - 1) / BITS_PER_LONG;
+	int rdseed_bits = 0, rdrand_bits = 0;
+	int rdrand_longs_wanted = 0;
+	char buf[128] = "";
+	char *msgptr = buf;
+
+	for (i = 0; i < longs; i++) {
+		unsigned long rv;
+
+		if (arch_get_random_seed_long(&rv)) {
+			seed(ctx, (u32)rv);
+#if BITS_PER_LONG > 32
+			seed(ctx, (u32)(rv >> 32));
+#endif
+			rdseed_bits += 8 * sizeof(rv);
+		}
+	}
+	if (rdseed_bits)
+		msgptr += sprintf(msgptr, ", %d bits from RDSEED", rdseed_bits);
+
+	/*
+	 * According to the Intel DRNG Software Implementation Guide 2.0,
+	 * the RDRAND hardware is guaranteed to provide at least 128 bits
+	 * of non-deterministic entropy per 511*128 bits of RDRAND output.
+	 * Nonetheless, the guide suggests using a 512:1 reduction for
+	 * generating seeds.
+	 *
+	 * We use one extra reseed, because we might not own the first
+	 * or last few samples.
+	 *
+	 * We skip using RDRAND for any bits already provided by RDSEED,
+	 * as they use the same underlying entropy source.
+	 */
+	if (rdseed_bits < bits_per_source && arch_has_random()) {
+		int nrbg_bits = bits_per_source - rdseed_bits;
+		int reseeds = (nrbg_bits + 127) / 128 + 1;
+
+		rdrand_longs_wanted = reseeds * 512 * 128 / BITS_PER_LONG;
+	}
+	for (i = 0; i < rdrand_longs_wanted; i++) {
+		unsigned long rv;
+
+		if (arch_get_random_long(&rv)) {
+			seed(ctx, (u32)rv);
+#if BITS_PER_LONG > 32
+			seed(ctx, (u32)(rv >> 32));
+#endif
+			rdrand_bits += 8 * sizeof(rv);
+		}
+	}
+	if (rdrand_bits)
+		msgptr += sprintf(msgptr, ", %d bits from RDRAND", rdrand_bits);
+
+	if (buf[0])
+		pr_info("%s with %s\n", log_prefix, buf + 2);
+}
-- 
1.9.3

