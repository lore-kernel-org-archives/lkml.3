Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LRJH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:07:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:2179 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667Ab3LRJHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:07:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="451879814"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 11/15] ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
Date: Wed, 18 Dec 2013 17:06:57 +0800
Message-Id: <e40a85582eb46ad8e10e49a5dc296af588e1965d.1387336613.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1387336613.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds default 64-bit mathematics in aclinux.h using do_div.  As
do_div can be used for all Linux architectures, this can also be used as
stub macros for ACPICA 64-bit mathematics.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 arch/ia64/include/asm/acenv.h   |    2 ++
 arch/x86/include/asm/acenv.h    |    4 ++++
 include/acpi/platform/aclinux.h |   29 +++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/ia64/include/asm/acenv.h b/arch/ia64/include/asm/acenv.h
index eb13318..f142a9d 100644
--- a/arch/ia64/include/asm/acenv.h
+++ b/arch/ia64/include/asm/acenv.h
@@ -66,6 +66,8 @@ ia64_acpi_release_global_lock (unsigned int *lock)
 #define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq)				\
 	((Acq) = ia64_acpi_release_global_lock(&facs->global_lock))
 
+#define ARCH_HAS_ACPI_GLOBAL_LOCK 1
+
 #endif
 
 #endif /* _ASM_IA64_ACENV_H */
diff --git a/arch/x86/include/asm/acenv.h b/arch/x86/include/asm/acenv.h
index 2359989..a85b478 100644
--- a/arch/x86/include/asm/acenv.h
+++ b/arch/x86/include/asm/acenv.h
@@ -45,6 +45,8 @@ int __acpi_release_global_lock(unsigned int *lock);
 #define ACPI_RELEASE_GLOBAL_LOCK(facs, Acq) \
 	((Acq) = __acpi_release_global_lock(&facs->global_lock))
 
+#define ARCH_HAS_ACPI_GLOBAL_LOCK 1
+
 /*
  * Math helper asm macros
  */
@@ -61,6 +63,8 @@ int __acpi_release_global_lock(unsigned int *lock);
 	    : "=r"(n_hi), "=r"(n_lo)	\
 	    : "0"(n_hi), "1"(n_lo))
 
+#define ARCH_HAS_ACPI_MATH64_HELPER 1
+
 #endif
 
 #endif /* _ASM_X86_ACENV_H */
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index e9e6374..8176181 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -221,6 +221,35 @@
 #define acpi_spinlock                       spinlock_t *
 #define acpi_cpu_flags                      unsigned long
 
+#if ACPI_MACHINE_WIDTH == 64
+
+#ifndef ARCH_HAS_ACPI_MATH64_HELPER
+
+/* Default to ACPI_USE_NATIVE_DIVIDE support */
+
+#define ARCH_HAS_ACPI_MATH64_HELPER
+
+#endif
+
+#endif
+
+#ifndef ARCH_HAS_ACPI_MATH64_HELPER
+
+#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
+	do { \
+		u64 __dividend = (((u64)(n_hi) << 32) | (n_lo)); \
+		(r32) = do_div(__dividend, (d32)); \
+		(q32) = (u32)__dividend; \
+	} while (0)
+
+#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
+	do { \
+		(n_lo) = ((n_lo) >> 1) | (((n_hi) & 1) << 31); \
+		(n_hi) >>= 1; \
+	} while (0)
+
+#endif
+
 #else				/* !__KERNEL__ */
 
 #include <stdarg.h>
-- 
1.7.10.4

