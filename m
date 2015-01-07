Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbbAGFmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:42:32 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:54585 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbbAGFmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:42:11 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Wed, 7 Jan 2015 14:40:04 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        acme@kernel.org, jolsa@kernel.org
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on
Message-ID: <20150107054004.GA849@sejong>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
 <20141229075607.GC6081@sejong>
 <54A10D53.2010800@huawei.com>
 <54AC9FC0.7050902@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54AC9FC0.7050902@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 07, 2015 at 10:53:52AM +0800, Wang Nan wrote:
> Ping...

Sorry for long delay.

> 
> On 2014/12/29 16:14, Wang Nan wrote:
> > On 2014/12/29 15:56, Namhyung Kim wrote:
> >> Hi Wang,
> >>
> >> (Adding Arnaldo and Jiri to CC)
> >>
> >> On Sat, Dec 27, 2014 at 09:26:11AM +0800, Wang Nan wrote:
> >>> When build with 'make ARCH=x86' and dwarf unwind is on, there is a
> >>> compiling error:
> >>>
> >>>    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
> >>>    CC       /home/wn/perf/arch/x86/tests/regs_load.o
> >>>  arch/x86/tests/regs_load.S: Assembler messages:
> >>>  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
> >>>  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
> >>>  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
> >>>  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
> >>>  make: *** [all] Error 2
> >>>  ...
> >>>
> >>> Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
> >>> 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'. However,
> >>> with 'ARCH=x86', the underlying compile may also be x86_64, which causes
> >>> mismatching.
> >>
> >> Hmm.. how did you compile this?  I guess ARCH=x86 requires -m32 flag
> >> to the gcc, did you pass it (like via EXTRA_CFLAGS=-m32)?
> >>
> >> I'm confused by 'underlying compile may also be x86_64' part..
> >>
> > 
> > I hit this problem when building perf with Yocto (https://www.yoctoproject.org/), which
> > is a famous building system for embeded system.
> > 
> > When building kernel, we can simply use 'make ARCH=x86' and select 'CONFIG_64BIT'
> > in menuconfig to get a x86_64 kernel. As a result, there building framework
> > like Yocto doesn't ever consider 'x86_64' as a valid ARCH option. See:
> > https://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/classes/kernel-arch.bbclass
> > Therefore, when building with such framework, it uses a x86_64 compiler and ARCH=x86.

Hmm.. okay.  I think that it should also be checked with the new build
system for perf, Jiri? ;)

Anyway, I cleaned up the code like below.. As __LP64__ is defined for
x86_64 as well, we can consolidate the __x86_64__ check to the
__LP64__ check and get rid of the IS_X86_64 IMHO.

Thanks,
Namhyung


diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 67a03a825b3c..eb3e2f3e14b4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
 # Benchmark modules
 BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
 BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
+ifeq ($(ARCH),x86)
 ifeq ($(RAW_ARCH),x86_64)
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
 endif
+endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
 BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5d4b039fe1ed..648e31ff4021 100644
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
index 851cd0172a76..ff95a68741d1 100644
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
