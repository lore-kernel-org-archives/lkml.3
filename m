Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaAGMwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:52:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbaAGMr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:47:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 04/16] perf tests x86: Introduce perf_regs_load function
Date: Tue,  7 Jan 2014 13:47:21 +0100
Message-Id: <1389098853-14466-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf_regs_load function, which is going
to be used for dwarf unwind test in following patches.

It takes single argument as a pointer to the regs dump
buffer and populates it with current registers values.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/arch/x86/Makefile            |  1 +
 tools/perf/arch/x86/include/perf_regs.h |  2 +
 tools/perf/arch/x86/tests/regs_load.S   | 92 +++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)
 create mode 100644 tools/perf/arch/x86/tests/regs_load.S

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 8801fe0..1cbef73 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -4,6 +4,7 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index e84ca76..f3435d62 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -5,6 +5,8 @@
 #include "../../util/types.h"
 #include <asm/perf_regs.h>
 
+void perf_regs_load(u64 *regs);
+
 #ifndef HAVE_ARCH_X86_64_SUPPORT
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
 #else
diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
new file mode 100644
index 0000000..99167bf
--- /dev/null
+++ b/tools/perf/arch/x86/tests/regs_load.S
@@ -0,0 +1,92 @@
+
+#include <linux/linkage.h>
+
+#define AX	 0
+#define BX	 1 * 8
+#define CX	 2 * 8
+#define DX	 3 * 8
+#define SI	 4 * 8
+#define DI	 5 * 8
+#define BP	 6 * 8
+#define SP	 7 * 8
+#define IP	 8 * 8
+#define FLAGS	 9 * 8
+#define CS	10 * 8
+#define SS	11 * 8
+#define DS	12 * 8
+#define ES	13 * 8
+#define FS	14 * 8
+#define GS	15 * 8
+#define R8	16 * 8
+#define R9	17 * 8
+#define R10	18 * 8
+#define R11	19 * 8
+#define R12	20 * 8
+#define R13	21 * 8
+#define R14	22 * 8
+#define R15	23 * 8
+
+.text
+#ifdef HAVE_ARCH_X86_64_SUPPORT
+ENTRY(perf_regs_load)
+	movq %rax, AX(%rdi)
+	movq %rbx, BX(%rdi)
+	movq %rcx, CX(%rdi)
+	movq %rdx, DX(%rdi)
+	movq %rsi, SI(%rdi)
+	movq %rdi, DI(%rdi)
+	movq %rbp, BP(%rdi)
+
+	leaq 8(%rsp), %rax /* exclude this call.  */
+	movq %rax, SP(%rdi)
+
+	movq 0(%rsp), %rax
+	movq %rax, IP(%rdi)
+
+	movq $0, FLAGS(%rdi)
+	movq $0, CS(%rdi)
+	movq $0, SS(%rdi)
+	movq $0, DS(%rdi)
+	movq $0, ES(%rdi)
+	movq $0, FS(%rdi)
+	movq $0, GS(%rdi)
+
+	movq %r8,  R8(%rdi)
+	movq %r9,  R9(%rdi)
+	movq %r10, R10(%rdi)
+	movq %r11, R11(%rdi)
+	movq %r12, R12(%rdi)
+	movq %r13, R13(%rdi)
+	movq %r14, R14(%rdi)
+	movq %r15, R15(%rdi)
+	ret
+ENDPROC(perf_regs_load)
+#else
+ENTRY(perf_regs_load)
+	push %edi
+	movl 8(%esp), %edi
+	movl %eax, AX(%edi)
+	movl %ebx, BX(%edi)
+	movl %ecx, CX(%edi)
+	movl %edx, DX(%edi)
+	movl %esi, SI(%edi)
+	pop %eax
+	movl %eax, DI(%edi)
+	movl %ebp, BP(%edi)
+
+	leal 4(%esp), %eax /* exclude this call.  */
+	movl %eax, SP(%edi)
+
+	movl 0(%esp), %eax
+	movl %eax, IP(%edi)
+
+	movl $0, FLAGS(%edi)
+	movl $0, CS(%edi)
+	movl $0, SS(%edi)
+	movl $0, DS(%edi)
+	movl $0, ES(%edi)
+	movl $0, FS(%edi)
+	movl $0, GS(%edi)
+	ret
+ENDPROC(perf_regs_load)
+#endif
-- 
1.8.3.1

