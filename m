Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3KKTHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:07:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab3KKTG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:06:57 -0500
Date: Mon, 11 Nov 2013 11:06:27 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-b5dfcb09debc38582c3cb72a3c1a88b919b07f2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jason.wessel@windriver.com, a.p.zijlstra@chello.nl,
        travis@sgi.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, travis@sgi.com, a.p.zijlstra@chello.nl,
        jason.wessel@windriver.com, acme@ghostprotocols.net, hedi@sgi.com,
        sivanich@sgi.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] Revert "x86/UV: Add uvtrace support"
Git-Commit-ID: b5dfcb09debc38582c3cb72a3c1a88b919b07f2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 11:06:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5dfcb09debc38582c3cb72a3c1a88b919b07f2d
Gitweb:     http://git.kernel.org/tip/b5dfcb09debc38582c3cb72a3c1a88b919b07f2d
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 11 Nov 2013 19:53:42 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 19:53:42 +0100

Revert "x86/UV: Add uvtrace support"

This reverts commit 8eba18428ac926f436064ac281e76d36d51bd631.

uv_trace() is not used by anything, nor is uv_trace_nmi_func, nor
uv_trace_func.

That's not how we do instrumentation code in the kernel: we add
tracepoints, printk()s, etc. so that everyone not just those with
magic kernel modules can debug a system.

So remove this unused (and misguied) piece of code.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Hedi Berriche <hedi@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: http://lkml.kernel.org/n/tip-tumfBffmr4jmnt8Gyxanoblg@git.kernel.org
---
 arch/x86/include/asm/uv/uv.h  |  8 --------
 arch/x86/platform/uv/uv_nmi.c | 13 +------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
index 8b1283d..6b964a0 100644
--- a/arch/x86/include/asm/uv/uv.h
+++ b/arch/x86/include/asm/uv/uv.h
@@ -14,13 +14,6 @@ extern void uv_cpu_init(void);
 extern void uv_nmi_init(void);
 extern void uv_register_nmi_notifier(void);
 extern void uv_system_init(void);
-extern void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
-extern void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
-#define uv_trace(fmt, ...)						\
-do {									\
-	if (unlikely(uv_trace_func))					\
-		(uv_trace_func)(__func__, __LINE__, fmt, ##__VA_ARGS__);\
-} while (0)
 extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
 						 struct mm_struct *mm,
 						 unsigned long start,
@@ -33,7 +26,6 @@ static inline enum uv_system_type get_uv_system_type(void) { return UV_NONE; }
 static inline int is_uv_system(void)	{ return 0; }
 static inline void uv_cpu_init(void)	{ }
 static inline void uv_system_init(void)	{ }
-static inline void uv_trace(void *fmt, ...)	{ }
 static inline void uv_register_nmi_notifier(void) { }
 static inline const struct cpumask *
 uv_flush_tlb_others(const struct cpumask *cpumask, struct mm_struct *mm,
diff --git a/arch/x86/platform/uv/uv_nmi.c b/arch/x86/platform/uv/uv_nmi.c
index 9b8ac60..2e863ad 100644
--- a/arch/x86/platform/uv/uv_nmi.c
+++ b/arch/x86/platform/uv/uv_nmi.c
@@ -1,5 +1,5 @@
 /*
- * SGI NMI/TRACE support routines
+ * SGI NMI support routines
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -39,13 +39,6 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_mmrs.h>
 
-void (*uv_trace_func)(const char *f, const int l, const char *fmt, ...);
-EXPORT_SYMBOL(uv_trace_func);
-
-void (*uv_trace_nmi_func)(unsigned int reason, struct pt_regs *regs);
-EXPORT_SYMBOL(uv_trace_nmi_func);
-
-
 /*
  * UV handler for NMI
  *
@@ -599,10 +592,6 @@ int uv_handle_nmi(unsigned int reason, struct pt_regs *regs)
 		return NMI_DONE;
 	}
 
-	/* Call possible NMI trace function */
-	if (unlikely(uv_trace_nmi_func))
-		(uv_trace_nmi_func)(reason, regs);
-
 	/* Indicate we are the first CPU into the NMI handler */
 	master = (atomic_read(&uv_nmi_cpu) == cpu);
 
