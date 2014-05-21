Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbaEUF4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 01:56:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaEUF4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 01:56:03 -0400
Date: Tue, 20 May 2014 22:55:40 -0700
From: tip-bot for Jean Pihet <tipbot@zytor.com>
Message-ID: <tip-90fa9deb32b908fb258225ab562c4ef7ae8dd35a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        will.deacon@arm.com, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, will.deacon@arm.com,
        a.p.zijlstra@chello.nl, jean.pihet@linaro.org, acme@kernel.org,
        namhyung@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1400229672-16104-3-git-send-email-jean.pihet@linaro.org>
References: <1400229672-16104-3-git-send-email-jean.pihet@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add dwarf unwind test on ARM
Git-Commit-ID: 90fa9deb32b908fb258225ab562c4ef7ae8dd35a
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

Commit-ID:  90fa9deb32b908fb258225ab562c4ef7ae8dd35a
Gitweb:     http://git.kernel.org/tip/90fa9deb32b908fb258225ab562c4ef7ae8dd35a
Author:     Jean Pihet <jean.pihet@linaro.org>
AuthorDate: Fri, 16 May 2014 10:41:11 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 16 May 2014 11:39:18 +0200

perf tests: Add dwarf unwind test on ARM

Adding dwarf unwind test, that setups live machine data over
the perf test thread and does the remote unwind.

Need to use -fno-optimize-sibling-calls for test compilation,
otherwise 'krava_*' function calls are optimized into jumps
and omitted from the stack unwind.

So far it was enabled only for x86.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
Reviewed-by: Will Deacon <will.deacon@arm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1400229672-16104-3-git-send-email-jean.pihet@linaro.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Makefile.perf                          | 2 +-
 tools/perf/arch/arm/Makefile                      | 1 +
 tools/perf/arch/arm/include/perf_regs.h           | 3 +++
 tools/perf/arch/{x86 => arm}/tests/dwarf-unwind.c | 4 ++--
 tools/perf/config/Makefile                        | 4 ++--
 tools/perf/tests/builtin-test.c                   | 2 +-
 tools/perf/tests/tests.h                          | 2 +-
 7 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 2baf61c..dea2d633 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -411,7 +411,7 @@ LIB_OBJS += $(OUTPUT)tests/code-reading.o
 LIB_OBJS += $(OUTPUT)tests/sample-parsing.o
 LIB_OBJS += $(OUTPUT)tests/parse-no-sample-id-all.o
 ifndef NO_DWARF_UNWIND
-ifeq ($(ARCH),x86)
+ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
 LIB_OBJS += $(OUTPUT)tests/dwarf-unwind.o
 endif
 endif
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 9b8f87e..221f21d 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -5,4 +5,5 @@ endif
 ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/arm/include/perf_regs.h b/tools/perf/arch/arm/include/perf_regs.h
index 33abcfa..f619c9c 100644
--- a/tools/perf/arch/arm/include/perf_regs.h
+++ b/tools/perf/arch/arm/include/perf_regs.h
@@ -8,6 +8,9 @@
 void perf_regs_load(u64 *regs);
 
 #define PERF_REGS_MASK	((1ULL << PERF_REG_ARM_MAX) - 1)
+#define PERF_REGS_MAX	PERF_REG_ARM_MAX
+#define PERF_SAMPLE_REGS_ABI	PERF_SAMPLE_REGS_ABI_32
+
 #define PERF_REG_IP	PERF_REG_ARM_PC
 #define PERF_REG_SP	PERF_REG_ARM_SP
 
diff --git a/tools/perf/arch/x86/tests/dwarf-unwind.c b/tools/perf/arch/arm/tests/dwarf-unwind.c
similarity index 92%
copy from tools/perf/arch/x86/tests/dwarf-unwind.c
copy to tools/perf/arch/arm/tests/dwarf-unwind.c
index 9f89f89..9f870d2 100644
--- a/tools/perf/arch/x86/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -21,7 +21,7 @@ static int sample_ustack(struct perf_sample *sample,
 		return -1;
 	}
 
-	sp = (unsigned long) regs[PERF_REG_X86_SP];
+	sp = (unsigned long) regs[PERF_REG_ARM_SP];
 
 	map = map_groups__find(thread->mg, MAP__VARIABLE, (u64) sp);
 	if (!map) {
@@ -45,7 +45,7 @@ int test__arch_unwind_sample(struct perf_sample *sample,
 	struct regs_dump *regs = &sample->user_regs;
 	u64 *buf;
 
-	buf = malloc(sizeof(u64) * PERF_REGS_MAX);
+	buf = calloc(1, sizeof(u64) * PERF_REGS_MAX);
 	if (!buf) {
 		pr_debug("failed to allocate sample uregs data\n");
 		return -1;
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f2edc59..729bbdf 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -40,11 +40,11 @@ ifeq ($(ARCH),arm64)
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
 endif
 
-# So far there's only x86 libdw unwind support merged in perf.
+# So far there's only x86 and arm libdw unwind support merged in perf.
 # Disable it on all other architectures in case libdw unwind
 # support is detected in system. Add supported architectures
 # to the check.
-ifneq ($(ARCH),x86)
+ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 0d5afaf..5e0764b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -115,7 +115,7 @@ static struct test {
 		.desc = "Test parsing with no sample_id_all bit set",
 		.func = test__parse_no_sample_id_all,
 	},
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 	{
 		.desc = "Test dwarf unwind",
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index a9d7cb0..8f91fb0 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -45,7 +45,7 @@ int test__hists_filter(void);
 int test__mmap_thread_lookup(void);
 int test__thread_mg_share(void);
 
-#if defined(__x86_64__) || defined(__i386__)
+#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
 #ifdef HAVE_DWARF_UNWIND_SUPPORT
 struct thread;
 struct perf_sample;
