Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbbAGNuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:50:44 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40723 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbAGNum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:50:42 -0500
MIME-Version: 1.0
In-Reply-To: <54AD2672.1010009@huawei.com>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
 <20141229075607.GC6081@sejong> <54A10D53.2010800@huawei.com>
 <54AC9FC0.7050902@huawei.com> <20150107054004.GA849@sejong>
 <20150107083920.GF6243@krava.brq.redhat.com> <54AD2672.1010009@huawei.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 7 Jan 2015 22:50:22 +0900
X-Google-Sender-Auth: WUI6XgoqEhQKb9sMNXp8-HL3Bx0
Message-ID: <CAM9d7chGXX68B54igX5O+3ZEu322cW-Xfoz6Wen8=D8iQpyH6g@mail.gmail.com>
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is on
To: Wang Nan <wangnan0@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lizefan@huawei.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 9:28 PM, Wang Nan <wangnan0@huawei.com> wrote:
> On 2015/1/7 16:39, Jiri Olsa wrote:
>> On Wed, Jan 07, 2015 at 02:40:04PM +0900, Namhyung Kim wrote:
>>> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
>>> index 67a03a825b3c..eb3e2f3e14b4 100644
>>> --- a/tools/perf/Makefile.perf
>>> +++ b/tools/perf/Makefile.perf
>>> @@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
>>>  # Benchmark modules
>>>  BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
>>>  BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
>>> +ifeq ($(ARCH),x86)
>>>  ifeq ($(RAW_ARCH),x86_64)
>>>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
>>>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
>>>  endif
>>> +endif
>>
>> isn't the check for x86 superfluous here? the x86_64 check is stronger
>>
>> otherwise it looks ok to me.. Wang Nan, could you please check
>> if it fixes the issue for you?
>>
>
> Sorry, although Namhyung Kim's patch solves my ARCH=x86 problem, it breaks ARM building:
>
> ...
> | bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> | bench/../../../arch/x86/lib/memcpy_64.S:27: Error: junk at end of line, first unrecognized character is `,'
> | bench/../../../arch/x86/lib/memcpy_64.S:29: Error: bad instruction `movq %rdi,%rax'
> | bench/../../../arch/x86/lib/memcpy_64.S:30: Error: bad instruction `movq %rdx,%rcx'
> | bench/../../../arch/x86/lib/memcpy_64.S:31: Error: bad instruction `shrq $3,%rcx'
> | bench/../../../arch/x86/lib/memcpy_64.S:32: Error: bad instruction `andl $7,%edx'
> ...

Strange.. this code is included only if ARCH=x86 in config/Makefile:

# Additional ARCH settings for x86
ifeq ($(ARCH),x86)
  ifeq (${IS_64_BIT}, 1)
    CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
    ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
    LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
  else
    LIBUNWIND_LIBS = -lunwind -lunwind-x86
  endif
  NO_PERF_REGS := 0
endif

Did your original patch build it without a problem?


>
> It builds x86_64 bench when I corss compiling perf for arm (use ARCH=arm). This is caused by Makefile.perf:
>
> ...
> BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> ifeq ($(RAW_ARCH),x86_64)
> BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
> BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
> endif
> BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
> ...
>
> Which rely on RAW_ARCH, but RAW_ARCH is not a cross-compiling-friendly variable now.

That's why I added the extra ARCH check.

Thanks,
Namhyung
