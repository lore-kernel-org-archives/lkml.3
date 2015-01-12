Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbbALD34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 22:29:56 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48602 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbbALD3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 22:29:55 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Mon, 12 Jan 2015 12:28:10 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: jolsa@redhat.com, mingo@redhat.com, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, acme@kernel.org
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on.
Message-ID: <20150112032810.GA25581@sejong>
References: <20150109144332.GB14750@krava.brq.redhat.com>
 <1421029255-23039-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421029255-23039-1-git-send-email-wangnan0@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:20:55AM +0800, Wang Nan wrote:
> From: Namhyung Kim <namhyung@kernel.org>
> 
> When build with 'make ARCH=x86' and dwarf unwind is on, there is a
> compiling error:
> 
>    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
>    CC       /home/wn/perf/arch/x86/tests/regs_load.o
>  arch/x86/tests/regs_load.S: Assembler messages:
>  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
>  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
>  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
>  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
>  make: *** [all] Error 2
>  ...
> 
> Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
> 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'.
> However, when building x86_64 kernel, ARCH=x86 is valid and commonly
> used. Building systems, such as yocto, uses x86_64 compiler with
> 'ARCH=x86' to build x86_64 perf, which causes mismatching.
> 
> As __LP64__ is defined for x86_64 as well, we can consolidate the
> __x86_64__ check to the __LP64__ check and get rid of the IS_X86_64
> IMHO.
> 
> (This patch is made by Namhyung Kim when replying my v1 patch:
> 
> https://lkml.org/lkml/2015/1/7/17
> 
> I modified the code to remove dependency on RAW_ARCH:
> 
> https://lkml.org/lkml/2015/1/7/865
> 
> Namhyung Kim didn't provide his SOB in his original email. I add
> mine only for my modification.)

Please feel free to add my SOB to this patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> ---
>  tools/perf/Makefile.perf        |  4 +++-
>  tools/perf/config/Makefile      |  2 +-
>  tools/perf/config/Makefile.arch | 26 +++++++++++++-------------
>  3 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 67a03a82..1f71a32 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
>  # Benchmark modules
>  BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
>  BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> -ifeq ($(RAW_ARCH),x86_64)
> +ifeq ($(ARCH), x86)
> +ifeq ($(IS_64_BIT), 1)
>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
>  endif
> +endif
>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
>  BUILTIN_OBJS += $(OUTPUT)bench/futex-hash.o
>  BUILTIN_OBJS += $(OUTPUT)bench/futex-wake.o
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 5d4b039..648e31f 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -20,7 +20,7 @@ NO_PERF_REGS := 1
>  
>  # Additional ARCH settings for x86
>  ifeq ($(ARCH),x86)
> -  ifeq (${IS_X86_64}, 1)
> +  ifeq (${IS_64_BIT}, 1)
>      CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
>      ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
>      LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
> diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
> index 851cd01..ff95a68 100644
> --- a/tools/perf/config/Makefile.arch
> +++ b/tools/perf/config/Makefile.arch
> @@ -1,7 +1,7 @@
>  
>  uname_M := $(shell uname -m 2>/dev/null || echo not)
>  
> -ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> +RAW_ARCH := $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>                                    -e s/arm.*/arm/ -e s/sa110/arm/ \
>                                    -e s/s390x/s390/ -e s/parisc64/parisc/ \
>                                    -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
> @@ -9,23 +9,23 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>                                    -e s/tile.*/tile/ )
>  
>  # Additional ARCH settings for x86
> -ifeq ($(ARCH),i386)
> -  override ARCH := x86
> +ifeq ($(RAW_ARCH),i386)
> +  ARCH ?= x86
>  endif
>  
> -ifeq ($(ARCH),x86_64)
> -  override ARCH := x86
> -  IS_X86_64 := 0
> -  ifeq (, $(findstring m32,$(CFLAGS)))
> -    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
> -    RAW_ARCH := x86_64
> +ifeq ($(RAW_ARCH),x86_64)
> +  ARCH ?= x86
> +
> +  ifneq (, $(findstring m32,$(CFLAGS)))
> +    RAW_ARCH := x86_32
>    endif
>  endif
>  
> -ifeq (${IS_X86_64}, 1)
> +ARCH ?= $(RAW_ARCH)
> +
> +LP64 := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
> +ifeq ($(LP64), 1)
>    IS_64_BIT := 1
> -else ifeq ($(ARCH),x86)
> -  IS_64_BIT := 0
>  else
> -  IS_64_BIT := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
> +  IS_64_BIT := 0
>  endif
> -- 
> 1.8.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
