Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab3AaWaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:30:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3AaWaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:30:02 -0500
Date: Thu, 31 Jan 2013 14:29:50 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-a8ebf6d1d6971b90a20f5bd0465e6d520377e33b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-6-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-6-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/microcode_core_early.c:
  Define interfaces for early loading ucode
Git-Commit-ID: a8ebf6d1d6971b90a20f5bd0465e6d520377e33b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:29:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a8ebf6d1d6971b90a20f5bd0465e6d520377e33b
Gitweb:     http://git.kernel.org/tip/a8ebf6d1d6971b90a20f5bd0465e6d520377e33b
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:25 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:19:12 -0800

x86/microcode_core_early.c: Define interfaces for early loading ucode

Define interfaces load_ucode_bsp() and load_ucode_ap() to load ucode on BSP and
AP in early boot time. These are generic interfaces. Internally they call
vendor specific implementations.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-6-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/microcode.h       | 14 +++++++
 arch/x86/kernel/microcode_core_early.c | 76 ++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 43d921b..6825e2e 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -57,4 +57,18 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 static inline void __exit exit_amd_microcode(void) {}
 #endif
 
+#ifdef CONFIG_MICROCODE_EARLY
+#define MAX_UCODE_COUNT 128
+extern void __init load_ucode_bsp(void);
+extern __init void load_ucode_ap(void);
+extern int __init save_microcode_in_initrd(void);
+#else
+static inline void __init load_ucode_bsp(void) {}
+static inline __init void load_ucode_ap(void) {}
+static inline int __init save_microcode_in_initrd(void)
+{
+	return 0;
+}
+#endif
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
new file mode 100644
index 0000000..577db84
--- /dev/null
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -0,0 +1,76 @@
+/*
+ *	X86 CPU microcode early update for Linux
+ *
+ *	Copyright (C) 2012 Fenghua Yu <fenghua.yu@intel.com>
+ *			   H Peter Anvin" <hpa@zytor.com>
+ *
+ *	This driver allows to early upgrade microcode on Intel processors
+ *	belonging to IA-32 family - PentiumPro, Pentium II,
+ *	Pentium III, Xeon, Pentium 4, etc.
+ *
+ *	Reference: Section 9.11 of Volume 3, IA-32 Intel Architecture
+ *	Software Developer's Manual.
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <asm/microcode_intel.h>
+#include <asm/processor.h>
+
+#define QCHAR(a, b, c, d) ((a) + ((b) << 8) + ((c) << 16) + ((d) << 24))
+#define CPUID_INTEL1 QCHAR('G', 'e', 'n', 'u')
+#define CPUID_INTEL2 QCHAR('i', 'n', 'e', 'I')
+#define CPUID_INTEL3 QCHAR('n', 't', 'e', 'l')
+#define CPUID_AMD1 QCHAR('A', 'u', 't', 'h')
+#define CPUID_AMD2 QCHAR('e', 'n', 't', 'i')
+#define CPUID_AMD3 QCHAR('c', 'A', 'M', 'D')
+
+#define CPUID_IS(a, b, c, ebx, ecx, edx)	\
+		(!((ebx ^ (a))|(edx ^ (b))|(ecx ^ (c))))
+
+/*
+ * In early loading microcode phase on BSP, boot_cpu_data is not set up yet.
+ * x86_vendor() gets vendor id for BSP.
+ *
+ * In 32 bit AP case, accessing boot_cpu_data needs linear address. To simplify
+ * coding, we still use x86_vendor() to get vendor id for AP.
+ *
+ * x86_vendor() gets vendor information directly through cpuid.
+ */
+static int __cpuinit x86_vendor(void)
+{
+	u32 eax = 0x00000000;
+	u32 ebx, ecx = 0, edx;
+
+	if (!have_cpuid_p())
+		return X86_VENDOR_UNKNOWN;
+
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	if (CPUID_IS(CPUID_INTEL1, CPUID_INTEL2, CPUID_INTEL3, ebx, ecx, edx))
+		return X86_VENDOR_INTEL;
+
+	if (CPUID_IS(CPUID_AMD1, CPUID_AMD2, CPUID_AMD3, ebx, ecx, edx))
+		return X86_VENDOR_AMD;
+
+	return X86_VENDOR_UNKNOWN;
+}
+
+void __init load_ucode_bsp(void)
+{
+	int vendor = x86_vendor();
+
+	if (vendor == X86_VENDOR_INTEL)
+		load_ucode_intel_bsp();
+}
+
+void __cpuinit load_ucode_ap(void)
+{
+	int vendor = x86_vendor();
+
+	if (vendor == X86_VENDOR_INTEL)
+		load_ucode_intel_ap();
+}
