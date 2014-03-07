Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaCGPPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:15:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:49596 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753055AbaCGPMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:06 -0500
Message-Id: <20140307151203.503340457@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [for-next][PATCH 16/20] ftrace: Pass retval through return in ftrace_dyn_arch_init()
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0016-ftrace-Pass-retval-through-return-in-ftrace_dyn_arch.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

No architecture uses the "data" parameter in ftrace_dyn_arch_init() in any
way, it just sets the value to 0. And this is used as a return value
in the caller -- ftrace_init, which just checks the retval against
zero.

Note there is also "return 0" in every ftrace_dyn_arch_init.  So it is
enough to check the retval and remove all the indirect sets of data on
all archs.

Link: http://lkml.kernel.org/r/1393268401-24379-3-git-send-email-jslaby@suse.cz

Cc: linux-arch@vger.kernel.org
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
index 79fcafc..1171688 100644
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
index 34e5664..5cd0d05 100644
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
index 9277905..f74c5ae 100644
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
index 7fc8c96..cfaa93a 100644
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
index a774f32..bf59393 100644
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
index e8a5e9c..ffa595c 100644
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
index 185ba25..013016b 100644
--- a/arch/mips/kernel/ftrace.c
+++ b/arch/mips/kernel/ftrace.c
@@ -206,9 +206,6 @@ int __init ftrace_dyn_arch_init(void *data)
 	/* Remove "b ftrace_stub" to ensure ftrace_caller() is executed */
 	ftrace_modify_code(MCOUNT_ADDR, INSN_NOP);
 
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif	/* CONFIG_DYNAMIC_FTRACE */
diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index 9b27b29..d059664 100644
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
index 224db03..77b2f3a 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -132,7 +132,6 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	*(unsigned long *) data = 0;
 	return 0;
 }
 
diff --git a/arch/sh/kernel/ftrace.c b/arch/sh/kernel/ftrace.c
index 30e1319..4939975 100644
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
index 03ab022..ee813b8 100644
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
index f1c4520..34d9ea0 100644
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
index 8cabf63..bbe5a5b8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -670,9 +670,6 @@ void arch_ftrace_update_code(int command)
 
 int __init ftrace_dyn_arch_init(void *data)
 {
-	/* The return code is retured via data */
-	*(unsigned long *)data = 0;
-
 	return 0;
 }
 #endif
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 76b6ed2..083c6d5 100644
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
1.8.5.3


