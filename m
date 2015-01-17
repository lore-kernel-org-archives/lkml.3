Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbbAQKLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 05:11:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbbAQKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 05:11:07 -0500
Date: Sat, 17 Jan 2015 02:10:49 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c6e5e9fbc3ea1c1a5648a3498d085fc3978df2d4@git.kernel.org>
Cc: lizefan@huawei.com, jolsa@redhat.com, namhyung@kernel.org,
        mingo@kernel.org, hpa@zytor.com, acme@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, wangnan0@huawei.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: jolsa@redhat.com, namhyung@kernel.org, lizefan@huawei.com,
        wangnan0@huawei.com, mingo@redhat.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, tglx@linutronix.de,
        mingo@kernel.org, hpa@zytor.com
In-Reply-To: <1421029255-23039-1-git-send-email-wangnan0@huawei.com>
References: <1421029255-23039-1-git-send-email-wangnan0@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix building error in x86_64 when dwarf unwind is on
Git-Commit-ID: c6e5e9fbc3ea1c1a5648a3498d085fc3978df2d4
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

Commit-ID:  c6e5e9fbc3ea1c1a5648a3498d085fc3978df2d4
Gitweb:     http://git.kernel.org/tip/c6e5e9fbc3ea1c1a5648a3498d085fc3978df2d4
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 12 Jan 2015 10:20:55 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Jan 2015 17:49:28 -0300

perf tools: Fix building error in x86_64 when dwarf unwind is on

When build with 'make ARCH=x86' and dwarf unwind is on, there is a
compiling error:

   CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
   CC       /home/wn/perf/arch/x86/tests/regs_load.o
 arch/x86/tests/regs_load.S: Assembler messages:
 arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
 arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
 make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
 make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
 make: *** [all] Error 2
 ...

Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'.
However, when building x86_64 kernel, ARCH=x86 is valid and commonly
used. Build systems, such as yocto, uses x86_64 compiler with 'ARCH=x86'
to build x86_64 perf, which causes mismatching.

As __LP64__ is defined for x86_64 as well, we can consolidate the
__x86_64__ check to the __LP64__ check and get rid of the IS_X86_64
IMHO.

(This patch is made by Namhyung Kim when replying my v1 patch:

https://lkml.org/lkml/2015/1/7/17

I modified the code to remove dependency on RAW_ARCH:

https://lkml.org/lkml/2015/1/7/865

Namhyung Kim didn't provide his SOB in his original email. I add
mine only for my modification.)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1421029255-23039-1-git-send-email-wangnan0@huawei.com
[ Namhyung provided his S-o-B on a followup to this patch thread on lkml ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf        |  4 +++-
 tools/perf/config/Makefile      |  2 +-
 tools/perf/config/Makefile.arch | 26 +++++++++++++-------------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 67a03a82..1f71a32 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
-ifeq ($(RAW_ARCH),x86_64)
+ifeq ($(ARCH), x86)
+ifeq ($(IS_64_BIT), 1)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039..648e31f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -20,7 +20,7 @@ NO_PERF_REGS := 1
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),x86)
-  ifeq (${IS_X86_64}, 1)
+  ifeq (${IS_64_BIT}, 1)
     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index 851cd01..ff95a68 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -1,7 +1,7 @@
 
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+RAW_ARCH := $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/arm.*/arm/ -e s/sa110/arm/ \
                                   -e s/s390x/s390/ -e s/parisc64/parisc/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
@@ -9,23 +9,23 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/tile.*/tile/ )
 
 # Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-  override ARCH := x86
+ifeq ($(RAW_ARCH),i386)
+  ARCH ?= x86
 endif
 
-ifeq ($(ARCH),x86_64)
-  override ARCH := x86
-  IS_X86_64 := 0
-  ifeq (, $(findstring m32,$(CFLAGS)))
-    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-    RAW_ARCH := x86_64
+ifeq ($(RAW_ARCH),x86_64)
+  ARCH ?= x86
+
+  ifneq (, $(findstring m32,$(CFLAGS)))
+    RAW_ARCH := x86_32
   endif
 endif
 
-ifeq (${IS_X86_64}, 1)
+ARCH ?= $(RAW_ARCH)
+
+LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+ifeq ($(LP64), 1)
   IS_64_BIT := 1
-else ifeq ($(ARCH),x86)
-  IS_64_BIT := 0
 else
-  IS_64_BIT := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+  IS_64_BIT := 0
 endif
