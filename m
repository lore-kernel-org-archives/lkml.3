Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab3IEWvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:51:25 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51633 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753093Ab3IEWug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:50:36 -0400
Message-Id: <20130905225034.187504361@asylum.americas.sgi.com>
References: <20130905225032.879120272@asylum.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 05 Sep 2013 17:50:40 -0500
From: Mike Travis <travis@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] x86/UV: Add uvtrace support
Content-Disposition: inline; filename=uv-add-trace-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the uvtrace module by providing a skeleton
call to the registered trace function.  It also provides another separate
'NMI' tracer that is triggered by the system wide 'power nmi' command.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Reviewed-by: Hedi Berriche <hberrich@sgi.com>
---
 arch/x86/include/asm/uv/uv.h  |    8 ++++++++
 arch/x86/platform/uv/uv_nmi.c |   13 ++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/include/asm/uv/uv.h
+++ linux/arch/x86/include/asm/uv/uv.h
@@ -14,6 +14,13 @@ extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
 extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
+extern void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
+extern void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
+#define uv_trace(fmt, ...)						\
+do {									\
+	if (unlikely(uv_trace_func))					\
+		(uv_trace_func)(__func__, __LINE__, fmt, ##__VA_ARGS__);\
+} while (0)
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
@@ -26,6 +33,7 @@ static inline enum uv_system_type get_uv
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
+static inline void uv_trace(void *fmt, ...)	{ }
 static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
--- linux.orig/arch/x86/platform/uv/uv_nmi.c
+++ linux/arch/x86/platform/uv/uv_nmi.c
@@ -1,5 +1,5 @@
 /*
- * SGI NMI support routines
+ * SGI NMI/TRACE support routines
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -39,6 +39,13 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 
+void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
+EXPORT_SYMBOL(uv_trace_func);
+
+void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
+EXPORT_SYMBOL(uv_trace_nmi_func);
+
+
 /*
  * UV handler for NMI
  *
@@ -592,6 +599,10 @@ int uv_handle_nmi(unsigned int reason, s
 		return NMI_DONE;
 	}
 
+	/* Call possible NMI trace function */
+	if (unlikely(uv_trace_nmi_func))
+		(uv_trace_nmi_func)(reason, regs);
+
 	/* Indicate we are the first CPU into the NMI handler */
 	master = (atomic_read(&uv_nmi_cpu) == cpu);
 

-- 
