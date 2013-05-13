Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab3EMNDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:03:19 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39080 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3EMNDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:03:18 -0400
Date: Mon, 13 May 2013 15:03:13 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tony Jones <tonyj@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
        Ralf Baechle <ralf@linux-mips.org>, Wu Zhangjin <wuzhangjin@gmail.com>,
        David Daney <david.daney@cavium.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] s390/ftrace: fix mcount adjustment
Message-ID: <20130513130313.GB4290@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051312-0342-0000-0000-00000501386D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tony Jones reported a bug which _seems_ to be present on MIPS64 as
well: http://lkml.indiana.edu/hypermail/linux/kernel/1301.1/02107.html

(don't know if it was fixed in the meantime, the asm code wasn't changed
recently though).

So just for reference here the s390 fix:

>From 6a07176c14b6318667f1ebd8c09c7bb4c30d78a0 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Mon, 13 May 2013 14:48:52 +0200
Subject: [PATCH] s390/ftrace: fix mcount adjustment

Tony Jones reported that the ftrace self tests on s390 do not work:

<6>Testing dynamic ftrace ops #1: (0 0 0 0 0) FAILED!
<6>Testing tracer irqsoff:
<3>failed to start irqsoff tracer
<4>.. no entries found ..FAILED!
<6>Testing tracer wakeup:
<3>failed to start wakeup tracer
<4>.. no entries found ..FAILED!
<6>Testing tracer function_graph:
<4>Failed to init function_graph tracer, init returned -19
<4>FAILED!

This happens because we forgot to adjust the instruction pointer that gets
passed to the ftrace trace function by MCOUNT_INSN_SIZE.

In addition change MCOUNT_INSN_SIZE to the correct value on 31 bit.
It only worked so far because the to be patched instruction was identical.

Reported-by: Tony Jones <tonyj@suse.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/ftrace.h | 12 +++++++-----
 arch/s390/kernel/mcount.S      |  2 ++
 arch/s390/kernel/mcount64.S    |  2 ++
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index b7931fa..bf246da 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -9,11 +9,6 @@ struct dyn_arch_ftrace { };
 
 #define MCOUNT_ADDR ((long)_mcount)
 
-#ifdef CONFIG_64BIT
-#define MCOUNT_INSN_SIZE  12
-#else
-#define MCOUNT_INSN_SIZE  20
-#endif
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
@@ -21,4 +16,11 @@ static inline unsigned long ftrace_call_adjust(unsigned long addr)
 }
 
 #endif /* __ASSEMBLY__ */
+
+#ifdef CONFIG_64BIT
+#define MCOUNT_INSN_SIZE  12
+#else
+#define MCOUNT_INSN_SIZE  22
+#endif
+
 #endif /* _ASM_S390_FTRACE_H */
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 4567ce2..08dcf21 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -7,6 +7,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/ftrace.h>
 
 	.section .kprobes.text, "ax"
 
@@ -33,6 +34,7 @@ ENTRY(ftrace_caller)
 	la	%r2,0(%r14)
 	st	%r0,__SF_BACKCHAIN(%r15)
 	la	%r3,0(%r3)
+	ahi	%r2,-MCOUNT_INSN_SIZE
 	l	%r14,0b-0b(%r1)
 	l	%r14,0(%r14)
 	basr	%r14,%r14
diff --git a/arch/s390/kernel/mcount64.S b/arch/s390/kernel/mcount64.S
index 1133219..1c52eae 100644
--- a/arch/s390/kernel/mcount64.S
+++ b/arch/s390/kernel/mcount64.S
@@ -7,6 +7,7 @@
 
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
+#include <asm/ftrace.h>
 
 	.section .kprobes.text, "ax"
 
@@ -29,6 +30,7 @@ ENTRY(ftrace_caller)
 	stg	%r1,__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r14
 	lg	%r3,168(%r15)
+	aghi	%r2,-MCOUNT_INSN_SIZE
 	larl	%r14,ftrace_trace_function
 	lg	%r14,0(%r14)
 	basr	%r14,%r14
-- 
1.8.1.6

