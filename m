Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab3DBMuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:50:44 -0400
Received: from smarthost02.mail.zen.net.uk ([212.23.1.2]:47954 "EHLO
	smarthost02.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757921Ab3DBMun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:50:43 -0400
X-Greylist: delayed 5475 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 08:50:43 EDT
Message-ID: <1364907037.3650.54.camel@linaro1.home>
Subject: Re: RFC: right way to conditional-ize some macros for LTO
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Date: Tue, 02 Apr 2013 13:50:37 +0100
In-Reply-To: <5155E28A.30509@am.sony.com>
References: <5155E28A.30509@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost02-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 11:50 -0700, Tim Bird wrote:
> Hi all,
> 
> A while ago I was working on supporting link-time optimization
> for ARM, and I'm just now getting around to submitting some of
> the patches from my work.  I'll explain more below, but the
> executive summary is this: Andi Kleen's LTO patches for Linux
> almost work on ARM.  I ran into one issue in
> arch/arm/include/asm/unified.h where various 'it'-related
> macros are expanding multiple times, in C context, and causing
> build errors.
> 
> As near as I can tell, these macros are not used except by
> arch/arm/kernel/kprobes-test-thumb.c (and most are not used
> at all).
> 
> When compiling with CONFIG_LTO=y, in Andi's 3.7.0 tree with LTO
> patches, I got the messages below:
> -----------------------------------------------
> ...
>   LD      drivers/tty/built-in.o
>   LD      drivers/built-in.o
>   LINK    vmlinux
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LDFINAL vmlinux.o
> [Leaving LTRANS /tmp/ccsIMbQT.args]
> [Leaving LTRANS vmlinux.o.ltrans.out]
> In file included from /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/include/uapi/linux/swab.h:269:0,
>                  from :872:
> /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c: In function 'wp512_process_buffer':
> /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c:987:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> vmlinux.o.ltrans0.s: Assembler messages:
> vmlinux.o.ltrans0.s:408: Error: Macro `it' was already defined
> vmlinux.o.ltrans0.s:410: Error: Macro `itt' was already defined
> vmlinux.o.ltrans0.s:412: Error: Macro `ite' was already defined
> vmlinux.o.ltrans0.s:414: Error: Macro `ittt' was already defined
> vmlinux.o.ltrans0.s:416: Error: Macro `itte' was already defined
> vmlinux.o.ltrans0.s:418: Error: Macro `itet' was already defined
> vmlinux.o.ltrans0.s:420: Error: Macro `itee' was already defined
> vmlinux.o.ltrans0.s:422: Error: Macro `itttt' was already defined
> vmlinux.o.ltrans0.s:424: Error: Macro `ittte' was already defined
> vmlinux.o.ltrans0.s:426: Error: Macro `ittet' was already defined
> vmlinux.o.ltrans0.s:428: Error: Macro `ittee' was already defined
> vmlinux.o.ltrans0.s:430: Error: Macro `itett' was already defined
> vmlinux.o.ltrans0.s:432: Error: Macro `itete' was already defined
> vmlinux.o.ltrans0.s:434: Error: Macro `iteet' was already defined
> vmlinux.o.ltrans0.s:436: Error: Macro `iteee' was already defined
> vmlinux.o.ltrans0.s:968: Error: Macro `it' was already defined
> vmlinux.o.ltrans0.s:970: Error: Macro `itt' was already defined
> vmlinux.o.ltrans0.s:972: Error: Macro `ite' was already defined
> vmlinux.o.ltrans0.s:974: Error: Macro `ittt' was already defined
> vmlinux.o.ltrans0.s:976: Error: Macro `itte' was already defined
> ...
> [Leaving LTRANS vmlinux.o.ltrans30.ltrans.o]
> [Leaving LTRANS vmlinux.o.ltrans31.o]
> [Leaving LTRANS vmlinux.o.ltrans31.ltrans.o]
> /a/home/tbird/work/auto-reduce/sony-yocto/lto-build2/tmp/sysroots/x86_64-linux/usr/libexec/armv5te-sony-linux-gnueabi/gcc/arm-sony-linux-gnueabi/4.7.3/arm-sony-linux-gnueabi-ld: lto-wrapper failed
> collect2: error: ld returned 1 exit status
> make[1]: *** [vmlinux] Error 1
> make: *** [sub-make] Error 2
> 
> Error: Bad result 512, running "make -j 8 KALLSYMS_EXTRA_PASS=1 bzImage": (output follows)
> Error:
> ---------------------------------------------
> 
> The messages are repeated thousands of times (I'm guessing for every object
> file after the first that included arch/arm/include/asm/unified.h)
> 
> Recognizing that LTO is currently incompatible with kprobes, and (so far)
> finding that only kprobes appeared to use these macros, I did the following hack:
> 
> diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
> index f5989f4..5179c13 100644
> --- a/arch/arm/include/asm/unified.h
> +++ b/arch/arm/include/asm/unified.h
> @@ -92,6 +92,7 @@
>  	.macro	iteee, cond
>  	.endm
>  #else	/* !__ASSEMBLY__ */
> +#ifndef CONFIG_LTO
>  __asm__(
>  "	.macro	it, cond\n"
>  "	.endm\n"
> @@ -123,6 +124,7 @@ __asm__(
>  "	.endm\n"
>  "	.macro	iteee, cond\n"
>  "	.endm\n");
> +#endif  /* ! CONFIG_LTO */
>  #endif	/* __ASSEMBLY__ */
> 
>  #endif	/* CONFIG_ARM_ASM_UNIFIED */
> 
> This the macros thus removed, I had no problems building the kernel
> and running it on target.
> 
> While this works to remove the build error, it doesn't seem robust and I'd
> like to either 1) find a better way to make these macro definitions conditional,
> or 2) eliminate them completely.
> 
> The macros themselves seem empty.  Can someone tell me what they do?
> What is the status of these macros?  Are they even needed?

The names of the macros are for Thumb2 instructions which are redundant
when building for the ARM instruction set. Newer toolchains which
support the unified assembler syntax will effectively ignore them and I
guess these empty macros are there so people can write assembler which
will compile with older toolchains.

> Could they be
> made conditional on something like NEED_IT_MACROS, and then have that set only
> in the arch/arm/kernel/kprobes-test-thumb.c, before the unified.h is included?

That file needs the real Thumb2 instructions, not empty macros, and
indeed it doesn't use them, because it is only compiled when
CONFIG_THUMB2_KERNEL=y and that selects CONFIG_ARM_ASM_UNIFIED and those
'it' macro's are guarded by #ifndef CONFIG_ARM_ASM_UNIFIED.

Note, there are other files which use the 'it' instructions, e.g.
arch/arm/include/asm/futex.h.

> I would like get this minor issue resolved in mainline, to make it easier for Andi
> to get his LTO work upstream and have it work with ARM.
> 
> Any suggestions are welcome.

If your toolchain supports the unified assembler syntax, you could try
enabling CONFIG_ARM_ASM_UNIFIED in ARM builds.

-- 
Tixy



