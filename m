Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaBXTAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:00:10 -0500
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59742 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752421AbaBXTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:00:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rostedt@goodmis.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 3/6] ftrace: Pass retval through return in ftrace_dyn_arch_init
Date: Mon, 24 Feb 2014 19:59:58 +0100
Message-Id: <1393268401-24379-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
References: <1393268401-24379-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No ftrace_dyn_arch_init uses the value in the "data" parameter in any
way, it just sets the value to 0. And this is used as a return value
in the caller -- ftrace_init, which just checks the retval against
zero.

Note there is also "return 0" in every ftrace_dyn_arch_init.  So it is
enough to check the retval and remove all the indirect sets of data on
all archs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 Documentation/trace/ftrace-design.txt | 3 ---
 arch/arm/kernel/ftrace.c              | 2 --
 arch/blackfin/kernel/ftrace.c         | 3 ---
 arch/ia64/kernel/ftrace.c             | 2 --
 arch/metag/kernel/ftrace.c            | 3 ---
 arch/microblaze/kernel/ftrace.c       | 3 ---
 arch/mips/kernel/ftrace.c             | 3 ---
 arch/powerpc/kernel/ftrace.c          | 5 -----
 arch/s390/kernel/ftrace.c             | 1 -
 arch/sh/kernel/ftrace.c               | 3 ---
 arch/sparc/kernel/ftrace.c            | 4 ----
 arch/tile/kernel/ftrace.c             | 2 --
 arch/x86/kernel/ftrace.c              | 3 ---
 kernel/trace/ftrace.c                 | 6 ++----
 14 files changed, 2 insertions(+), 41 deletions(-)

diff --git a/Documentation/trace/ftrace-design.txt b/Documentation/trace/ftrace-design.txt
index 79fcafc7fd64..117168884023 100644
--- a/Documentation/trace/ftrace-design.txt
+++ b/Documentation/trace/ftrace-design.txt
@@ -360,9 +360,6 @@ function below should be sufficient for most people:
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* return value is done indirectly via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 34e56647dcee..5cd0d05edf35 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -158,8 +158,6 @@ int ftrace_make_nop(struct module *mod,
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/blackfin/kernel/ftrace.c b/arch/blackfin/kernel/ftrace.c
index 9277905b82cf..f74c5ae6a25b 100644
--- a/arch/blackfin/kernel/ftrace.c
+++ b/arch/blackfin/kernel/ftrace.c
@@ -67,9 +67,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* return value is done indirectly via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/ia64/kernel/ftrace.c b/arch/ia64/kernel/ftrace.c
index 7fc8c961b1f7..cfaa93a8bbdf 100644
--- a/arch/ia64/kernel/ftrace.c
+++ b/arch/ia64/kernel/ftrace.c
@@ -200,7 +200,5 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 /* run from kstop_machine */
 int __init ftrace_dyn_arch_init(void *data)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
diff --git a/arch/metag/kernel/ftrace.c b/arch/metag/kernel/ftrace.c
index a774f321643f..bf593932b353 100644
--- a/arch/metag/kernel/ftrace.c
+++ b/arch/metag/kernel/ftrace.c
@@ -119,8 +119,5 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 /* run from kstop_machine */
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* The return code is returned via data */
-	writel(0, data);
-
 	return 0;
 }
diff --git a/arch/microblaze/kernel/ftrace.c b/arch/microblaze/kernel/ftrace.c
index e8a5e9cf4ed1..ffa595c7fec2 100644
--- a/arch/microblaze/kernel/ftrace.c
+++ b/arch/microblaze/kernel/ftrace.c
@@ -173,9 +173,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 
diff --git a/arch/mips/kernel/ftrace.c b/arch/mips/kernel/ftrace.c
index ddcc3500248d..42a675ae0155 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -210,9 +210,6 @@ int __init ftrace_dyn_arch_init(void *data)
 	/* Remove "b ftrace_stub" to ensure ftrace_caller() is executed */
 	ftrace_modify_code(MCOUNT_ADDR, INSN_NOP);
 
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif	/* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 9b27b293a922..d059664cdf16 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -533,11 +533,6 @@ void arch_ftrace_update_code(int command)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* caller expects data to be zero */
-	unsigned long *p = data;
-
-	*p = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 224db03e9518..77b2f3a1f50a 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -132,7 +132,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	*(unsigned long *) data = 0;
 	return 0;
 }
 
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 30e13196d35b..493997541d2c 100644
--- a/arch/sh/kernel/ftrace.c
+++ b/arch/sh/kernel/ftrace.c
@@ -274,9 +274,6 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* The return code is retured via data */
-	__raw_writel(0, (unsigned long)data);
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/sparc/kernel/ftrace.c b/arch/sparc/kernel/ftrace.c
index 03ab022e51c5..ee813b82da49 100644
--- a/arch/sparc/kernel/ftrace.c
+++ b/arch/sparc/kernel/ftrace.c
@@ -84,10 +84,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	unsigned long *p = data;
-
-	*p = 0;
-
 	return 0;
 }
 #endif
diff --git a/arch/tile/kernel/ftrace.c b/arch/tile/kernel/ftrace.c
index f1c452092eeb..34d9ea0bca9f 100644
--- a/arch/tile/kernel/ftrace.c
+++ b/arch/tile/kernel/ftrace.c
@@ -169,8 +169,6 @@ int ftrace_make_nop(struct module *mod,
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e6253195a301..a41f31f1cdc1 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -680,9 +680,6 @@ void arch_ftrace_update_code(int command)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 76b6ed29d856..083c6d5fce25 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4379,11 +4379,9 @@ void __init ftrace_init(void)
 	addr = (unsigned long)ftrace_stub;
 
 	local_irq_save(flags);
-	ftrace_dyn_arch_init(&addr);
+	ret = ftrace_dyn_arch_init(&addr);
 	local_irq_restore(flags);
-
-	/* ftrace_dyn_arch_init places the return code in addr */
-	if (addr)
+	if (ret)
 		goto failed;
 
 	count = __stop_mcount_loc - __start_mcount_loc;
-- 
1.8.5.2

