Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbbAGIjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:39:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbbAGIjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:39:31 -0500
Date: Wed, 7 Jan 2015 09:39:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, acme@kernel.org,
        jolsa@kernel.org
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on
Message-ID: <20150107083920.GF6243@krava.brq.redhat.com>
References: <1419643571-62764-1-git-send-email-wangnan0@huawei.com>
 <20141229075607.GC6081@sejong>
 <54A10D53.2010800@huawei.com>
 <54AC9FC0.7050902@huawei.com>
 <20150107054004.GA849@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150107054004.GA849@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 02:40:04PM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Wed, Jan 07, 2015 at 10:53:52AM +0800, Wang Nan wrote:
> > Ping...
> 
> Sorry for long delay.
> 
> > 
> > On 2014/12/29 16:14, Wang Nan wrote:
> > > On 2014/12/29 15:56, Namhyung Kim wrote:
> > >> Hi Wang,
> > >>
> > >> (Adding Arnaldo and Jiri to CC)
> > >>
> > >> On Sat, Dec 27, 2014 at 09:26:11AM +0800, Wang Nan wrote:
> > >>> When build with 'make ARCH=x86' and dwarf unwind is on, there is a
> > >>> compiling error:
> > >>>
> > >>>    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
> > >>>    CC       /home/wn/perf/arch/x86/tests/regs_load.o
> > >>>  arch/x86/tests/regs_load.S: Assembler messages:
> > >>>  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
> > >>>  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
> > >>>  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
> > >>>  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
> > >>>  make: *** [all] Error 2
> > >>>  ...
> > >>>
> > >>> Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
> > >>> 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'. However,
> > >>> with 'ARCH=x86', the underlying compile may also be x86_64, which causes
> > >>> mismatching.
> > >>
> > >> Hmm.. how did you compile this?  I guess ARCH=x86 requires -m32 flag
> > >> to the gcc, did you pass it (like via EXTRA_CFLAGS=-m32)?
> > >>
> > >> I'm confused by 'underlying compile may also be x86_64' part..
> > >>
> > > 
> > > I hit this problem when building perf with Yocto (https://www.yoctoproject.org/), which
> > > is a famous building system for embeded system.
> > > 
> > > When building kernel, we can simply use 'make ARCH=x86' and select 'CONFIG_64BIT'
> > > in menuconfig to get a x86_64 kernel. As a result, there building framework
> > > like Yocto doesn't ever consider 'x86_64' as a valid ARCH option. See:
> > > https://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/classes/kernel-arch.bbclass
> > > Therefore, when building with such framework, it uses a x86_64 compiler and ARCH=x86.
> 
> Hmm.. okay.  I think that it should also be checked with the new build
> system for perf, Jiri? ;)

yea.. however the config/Makefile still stays as it was

but whatever change you'll make for Makefile.perf I need
to transform.. but this one does not seem too massive ;-)

> 
> Anyway, I cleaned up the code like below.. As __LP64__ is defined for
> x86_64 as well, we can consolidate the __x86_64__ check to the
> __LP64__ check and get rid of the IS_X86_64 IMHO.
> 
> Thanks,
> Namhyung
> 
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 67a03a825b3c..eb3e2f3e14b4 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -462,10 +462,12 @@ BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
>  # Benchmark modules
>  BUILTIN_OBJS += $(OUTPUT)bench/sched-messaging.o
>  BUILTIN_OBJS += $(OUTPUT)bench/sched-pipe.o
> +ifeq ($(ARCH),x86)
>  ifeq ($(RAW_ARCH),x86_64)
>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy-x86-64-asm.o
>  BUILTIN_OBJS += $(OUTPUT)bench/mem-memset-x86-64-asm.o
>  endif
> +endif

isn't the check for x86 superfluous here? the x86_64 check is stronger

otherwise it looks ok to me.. Wang Nan, could you please check
if it fixes the issue for you?

thanks,
jirka
