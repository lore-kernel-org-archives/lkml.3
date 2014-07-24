Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198AbaGXE55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:57:57 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47982 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179AbaGXE5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:57:53 -0400
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
Subject: [PATCH v5 3/5] x86,random: Add an x86 implementation of arch_get_rng_seed
Date: Wed, 23 Jul 2014 21:57:29 -0700
Message-Id: <66fd3430747ae8f7864ce2d0059a8cc881bb9d6a.1406177531.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
In-Reply-To: <cover.1406177531.git.luto@amacapital.net>
References: <cover.1406177531.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This does the same thing as the generic implementation, except
that it logs how many bits of each type it collected.  I want to
know whether the initial seeding is working and, if so, whether
the RNG is fast enough.

(I know that hpa assures me that the hardware RNG is more than
 fast enough, but I'd still like a direct way to verify this.)

Arguably, arch_get_random_seed could be removed now: I'm having some
trouble imagining a sensible non-architecture-specific use of it
that wouldn't be better served by arch_get_rng_seed.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/archrandom.h |  6 +++++
 arch/x86/kernel/Makefile          |  2 ++
 arch/x86/kernel/archrandom.c      | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)
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
index 0000000..47d13b0
--- /dev/null
+++ b/arch/x86/kernel/archrandom.c
@@ -0,0 +1,51 @@
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
+	int i;
+	int rdseed_bits = 0, rdrand_bits = 0;
+	char buf[128] = "";
+	char *msgptr = buf;
+
+	for (i = 0; i < bits_per_source; i += 8 * sizeof(long)) {
+		unsigned long rv;
+
+		if (arch_get_random_seed_long(&rv))
+			rdseed_bits += 8 * sizeof(rv);
+		else if (arch_get_random_long(&rv))
+			rdrand_bits += 8 * sizeof(rv);
+		else
+			continue;	/* Don't waste time mixing. */
+
+		seed(ctx, (u32)rv);
+#if BITS_PER_LONG > 32
+		seed(ctx, (u32)(rv >> 32));
+#endif
+	}
+
+	if (rdseed_bits)
+		msgptr += sprintf(msgptr, ", %d bits from RDSEED", rdseed_bits);
+	if (rdrand_bits)
+		msgptr += sprintf(msgptr, ", %d bits from RDRAND", rdrand_bits);
+	if (buf[0])
+		pr_info("%s with %s\n", log_prefix, buf + 2);
+}
-- 
1.9.3

