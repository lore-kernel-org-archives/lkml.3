Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab3CLTjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:39:47 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48722 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755563Ab3CLTi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:38:26 -0400
Message-Id: <20130312193825.093571313@gulag1.americas.sgi.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 12 Mar 2013 14:38:35 -0500
From: Mike Travis <travis@sgi.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Alex Shi <alex.shi@intel.com>,
        Cliff Wickman <cpw@sgi.com>, Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: [PATCH 12/14] x86/UV: Add uvtrace support
Content-Disposition: inline; filename=uv-add-trace-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the uvtrace KDB module by providing a
skeleton call to the registered trace function.  It also provides
another separate 'NMI' tracer that is triggered by the system wide
'power nmi' command.

Cc: Alex Shi <alex.shi@intel.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Steffen Persvold <sp@numascale.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/include/asm/uv/uv.h  |   12 ++++++++++--
 arch/x86/platform/uv/uv_nmi.c |   10 +++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -14,24 +14,32 @@ extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
 extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
+extern void (*uv_trace_nmi_func)(int cpu, struct pt_regs *regs, int ignored);
+extern void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
+#define uvtrace(fmt, ...)						\
+do {									\
+	if (unlikely(uv_trace_func))					\
+		(uv_trace_func)(__func__, __LINE__, fmt, ##__VA_ARGS__);\
+} while (0)
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
 						 unsigned long end,
 						 unsigned int cpu);
 
-#else	/* X86_UV */
+#else	/* !X86_UV */
 
 static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
+static inline void uvtrace(void *fmt, ...)	{ }
 static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
 		    unsigned long start, unsigned long end, unsigned int cpu)
 { return cpumask; }
 
-#endif	/* X86_UV */
+#endif	/* !X86_UV */
 
 #endif	/* _ASM_X86_UV_UV_H */
--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -1,5 +1,5 @@
 /*
- * SGI NMI support routines
+ * SGI NMI/TRACE support routines
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -20,6 +20,7 @@
  */
 
 #include <linux/cpu.h>
+#include <linux/module.h>
 #include <linux/nmi.h>
 
 #include <asm/apic.h>
@@ -34,6 +35,13 @@
 DEFINE_PER_CPU(unsigned long, cpu_last_nmi_count);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
+EXPORT_SYMBOL(uv_trace_func);
+
+void (*uv_trace_nmi_func)(int cpu, struct pt_regs *regs, int ignored);
+EXPORT_SYMBOL(uv_trace_nmi_func);
+
+
 /*
  * When NMI is received, print a stack trace.
  */

-- 
