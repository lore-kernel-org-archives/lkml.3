Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaBVR5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:57:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40877 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaBVR5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:57:43 -0500
Date: Sat, 22 Feb 2014 09:57:20 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-3c8b06f981091f91ee603768855e9739a8938296@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1389098853-14466-5-git-send-email-jolsa@redhat.com>
References: <1389098853-14466-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests x86: Introduce perf_regs_load function
Git-Commit-ID: 3c8b06f981091f91ee603768855e9739a8938296
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3c8b06f981091f91ee603768855e9739a8938296
Gitweb:     http://git.kernel.org/tip/3c8b06f981091f91ee603768855e9739a8938296
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Jan 2014 13:47:21 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Feb 2014 09:34:47 -0300

perf tests x86: Introduce perf_regs_load function

Introducing perf_regs_load function, which is going to be used for dwarf
unwind test in following patches.

It takes single argument as a pointer to the regs dump buffer and
populates it with current registers values.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Jean Pihet <jean.pihet@linaro.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1389098853-14466-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/Makefile            |  1 +
 tools/perf/arch/x86/include/perf_regs.h |  2 +
 tools/perf/arch/x86/tests/regs_load.S   | 92 +++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)

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
