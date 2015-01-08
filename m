Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbbAHFLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 00:11:23 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49438 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbbAHFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 00:11:22 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 14:09:20 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on
Message-ID: <20150108050920.GA7268@sejong>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
 <20141229075607.GC6081@sejong>
 <54A10D53.2010800@huawei.com>
 <54AC9FC0.7050902@huawei.com>
 <20150107054004.GA849@sejong>
 <20150107083920.GF6243@krava.brq.redhat.com>
 <54AD2672.1010009@huawei.com>
 <CAM9d7chGXX68B54igX5O+3ZEu322cW-Xfoz6Wen8=D8iQpyH6g@mail.gmail.com>
 <54ADDDAF.8060704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54ADDDAF.8060704@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 09:30:23AM +0800, Wang Nan wrote:
> On 2015/1/7 21:50, Namhyung Kim wrote:
> > On Wed, Jan 7, 2015 at 9:28 PM, Wang Nan <wangnan0@huawei.com> wrote:
> >> On 2015/1/7 16:39, Jiri Olsa wrote:
> >>> On Wed, Jan 07, 2015 at 02:40:04PM +0900, Namhyung Kim wrote:
> >>>> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> >>>> index 67a03a825b3c..eb3e2f3e14b4 100644
> >>>> --- a/tools/perf/Makefile.perf
> >>>> +++ b/tools/perf/Makefile.perf
> >>>> @@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
> >>>>  # Benchmark modules
> >>>>  BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
> >>>>  BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> >>>> +ifeq ($(ARCH),x86)
> >>>>  ifeq ($(RAW_ARCH),x86_64)
> >>>>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
> >>>>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
> >>>>  endif
> >>>> +endif
> >>>
> >>> isn't the check for x86 superfluous here? the x86_64 check is stronger
> >>>
> >>> otherwise it looks ok to me.. Wang Nan, could you please check
> >>> if it fixes the issue for you?
> >>>
> >>
> >> Sorry, although Namhyung Kim's patch solves my ARCH=x86 problem, it breaks ARM building:
> >>
> >> ...
> >> | bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> >> | bench/../../../arch/x86/lib/memcpy_64.S:27: Error: junk at end of line, first unrecognized character is `,'
> >> | bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad instruction `movq %rdi,%rax'
> >> | bench/../../../arch/x86/lib/memcpy_64.S:30: Error: bad instruction `movq %rdx,%rcx'
> >> | bench/../../../arch/x86/lib/memcpy_64.S:31: Error: bad instruction `shrq $3,%rcx'
> >> | bench/../../../arch/x86/lib/memcpy_64.S:32: Error: bad instruction `andl $7,%edx'
> >> ...
> > 
> > Strange.. this code is included only if ARCH=x86 in config/Makefile:
> > 
> > # Additional ARCH settings for x86
> > ifeq ($(ARCH),x86)
> >   ifeq (${IS_64_BIT}, 1)
> >     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
> >     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
> >     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
> >   else
> >     LIBUNWIND_LIBS = -lunwind -lunwind-x86
> >   endif
> >   NO_PERF_REGS := 0
> > endif
> > 
> > Did your original patch build it without a problem?
> > 
> 
> My original patch is free from this problem.
> 
> bench/mem-memset-x86-64-asm.S doesn't use ARCH_INCLUDE, it direct include "../../../arch/x86/lib/memset_64.S".

Ah, got it.


> 
> > 
> >>
> >> It builds x86_64 bench when I corss compiling perf for arm (use ARCH=arm). This is caused by Makefile.perf:
> >>
> >> ...
> >> BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> >> ifeq ($(RAW_ARCH),x86_64)
> >> BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
> >> BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
> >> endif
> >> BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
> >> ...
> >>
> >> Which rely on RAW_ARCH, but RAW_ARCH is not a cross-compiling-friendly variable now.
> > 
> > That's why I added the extra ARCH check.
> > 
> 
> With your additional ARCH check, ARM compiling is passed. However I suggest you not to
> use $(RAW_ARCH) directly, because it is get from "uname -m", which reflects the arch of
> build machine, not the arch of host machine (the machine perf will run on).
> 
> What about this:
> 
> ---
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

Looks good to me!

Thanks,
Namhyung
