Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964794AbaD1WOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:14:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:38582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560AbaD1WMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="522615332"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/7] x86: Enumerate kernel FSGS capability in AT_HWCAP2
Date: Mon, 28 Apr 2014 15:12:40 -0700
Message-Id: <1398723161-21968-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The kernel needs to explicitely enable RD/WRFSBASE to handle context
switch correctly. So the application needs to know if it can safely use
these instruction. Just looking at the CPUID bit is not enough because it
may be running in a kernel that does not enable the instructions.

One way for the application would be to just try and catch the SIGILL.
But that is difficult to do in libraries which may not want
to overwrite the signal handlers of the main application.

So we need to provide a way for the application to discover the kernel
capability.

I used AT_HWCAP2 in the ELF aux vector which is already used by
PPC for similar things. We define a new Linux defined bitmap
returned in AT_HWCAP.  Currently it has only one bit set,
for kernel is FSGSBASE capable.

The application can then access it manually or using
the getauxval() function in newer glibc.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/elf.h        | 7 +++++++
 arch/x86/include/uapi/asm/hwcap.h | 7 +++++++
 arch/x86/kernel/cpu/common.c      | 7 ++++++-
 3 files changed, 20 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/uapi/asm/hwcap.h

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 9c999c1..0fbc9e0 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -251,6 +251,13 @@ extern int force_personality32;
 
 #define ELF_HWCAP		(boot_cpu_data.x86_capability[0])
 
+extern unsigned kernel_enabled_features;
+
+/* HWCAP2 supplies kernel enabled CPU feature, so that the application
+   can know that it can safely use them. The bits are defined in
+   uapi/asm/hwcap.h. */
+#define ELF_HWCAP2		kernel_enabled_features;
+
 /* This yields a string that ld.so will use to load implementation
    specific libraries for optimization.  This is more specific in
    intent than poking at uname or /proc/cpuinfo.
diff --git a/arch/x86/include/uapi/asm/hwcap.h b/arch/x86/include/uapi/asm/hwcap.h
new file mode 100644
index 0000000..d9c54f8
--- /dev/null
+++ b/arch/x86/include/uapi/asm/hwcap.h
@@ -0,0 +1,7 @@
+#ifndef _ASM_HWCAP_H
+#define _ASM_HWCAP_H 1
+
+#define HWCAP2_FSGSBASE	(1 << 0) 	/* Kernel enabled RD/WR FS/GS BASE */
+/* upto bit 31 free */
+
+#endif
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0fb8767..a4e4aa6 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -31,6 +31,7 @@
 #include <asm/i387.h>
 #include <asm/fpu-internal.h>
 #include <asm/mtrr.h>
+#include <asm/hwcap.h>
 #include <linux/numa.h>
 #include <asm/asm.h>
 #include <asm/cpu.h>
@@ -46,6 +47,8 @@
 
 #include "cpu.h"
 
+unsigned kernel_enabled_features __read_mostly;
+
 /* all of these masks are initialized in setup_cpu_local_masks() */
 cpumask_var_t cpu_initialized_mask;
 cpumask_var_t cpu_callout_mask;
@@ -939,8 +942,10 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	numa_add_cpu(smp_processor_id());
 #endif
 
-	if (cpu_has(c, X86_FEATURE_FSGSBASE))
+	if (cpu_has(c, X86_FEATURE_FSGSBASE)) {
+		kernel_enabled_features |= HWCAP2_FSGSBASE;
 		set_in_cr4(X86_CR4_FSGSBASE);
+	}
 }
 
 #ifdef CONFIG_X86_64
-- 
1.9.0

