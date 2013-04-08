Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab3DHSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:10:19 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50440 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762858Ab3DHSKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:10:16 -0400
Date: Mon, 8 Apr 2013 19:10:06 +0100
From: Dave Martin <dave.martin@linaro.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Tim Bird <tim.bird@am.sony.com>, "Kleen, Andi" <andi.kleen@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        linux kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RFC: right way to conditional-ize some macros for LTO
Message-ID: <20130408181006.GC2176@linaro.org>
References: <5155E28A.30509@am.sony.com>
 <1364907037.3650.54.camel@linaro1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364907037.3650.54.camel@linaro1.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 01:50:37PM +0100, Jon Medhurst (Tixy) wrote:
> On Fri, 2013-03-29 at 11:50 -0700, Tim Bird wrote:
> > Hi all,
> > 
> > A while ago I was working on supporting link-time optimization
> > for ARM, and I'm just now getting around to submitting some of
> > the patches from my work.  I'll explain more below, but the
> > executive summary is this: Andi Kleen's LTO patches for Linux
> > almost work on ARM.  I ran into one issue in
> > arch/arm/include/asm/unified.h where various 'it'-related
> > macros are expanding multiple times, in C context, and causing
> > build errors.
> > 
> > As near as I can tell, these macros are not used except by
> > arch/arm/kernel/kprobes-test-thumb.c (and most are not used
> > at all).
> > 
> > When compiling with CONFIG_LTO=y, in Andi's 3.7.0 tree with LTO
> > patches, I got the messages below:
> > -----------------------------------------------
> > ...
> >   LD      drivers/tty/built-in.o
> >   LD      drivers/built-in.o
> >   LINK    vmlinux
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   UPD     include/generated/compile.h
> >   CC      init/version.o
> >   LD      init/built-in.o
> >   LDFINAL vmlinux.o
> > [Leaving LTRANS /tmp/ccsIMbQT.args]
> > [Leaving LTRANS vmlinux.o.ltrans.out]
> > In file included from /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/include/uapi/linux/swab.h:269:0,
> >                  from :872:
> > /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c: In function 'wp512_process_buffer':
> > /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c:987:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> > vmlinux.o.ltrans0.s: Assembler messages:
> > vmlinux.o.ltrans0.s:408: Error: Macro `it' was already defined
> > vmlinux.o.ltrans0.s:410: Error: Macro `itt' was already defined
> > vmlinux.o.ltrans0.s:412: Error: Macro `ite' was already defined
> > vmlinux.o.ltrans0.s:414: Error: Macro `ittt' was already defined
> > vmlinux.o.ltrans0.s:416: Error: Macro `itte' was already defined
> > vmlinux.o.ltrans0.s:418: Error: Macro `itet' was already defined
> > vmlinux.o.ltrans0.s:420: Error: Macro `itee' was already defined
> > vmlinux.o.ltrans0.s:422: Error: Macro `itttt' was already defined
> > vmlinux.o.ltrans0.s:424: Error: Macro `ittte' was already defined
> > vmlinux.o.ltrans0.s:426: Error: Macro `ittet' was already defined
> > vmlinux.o.ltrans0.s:428: Error: Macro `ittee' was already defined
> > vmlinux.o.ltrans0.s:430: Error: Macro `itett' was already defined
> > vmlinux.o.ltrans0.s:432: Error: Macro `itete' was already defined
> > vmlinux.o.ltrans0.s:434: Error: Macro `iteet' was already defined
> > vmlinux.o.ltrans0.s:436: Error: Macro `iteee' was already defined
> > vmlinux.o.ltrans0.s:968: Error: Macro `it' was already defined
> > vmlinux.o.ltrans0.s:970: Error: Macro `itt' was already defined
> > vmlinux.o.ltrans0.s:972: Error: Macro `ite' was already defined
> > vmlinux.o.ltrans0.s:974: Error: Macro `ittt' was already defined
> > vmlinux.o.ltrans0.s:976: Error: Macro `itte' was already defined
> > ...
> > [Leaving LTRANS vmlinux.o.ltrans30.ltrans.o]
> > [Leaving LTRANS vmlinux.o.ltrans31.o]
> > [Leaving LTRANS vmlinux.o.ltrans31.ltrans.o]
> > /a/home/tbird/work/auto-reduce/sony-yocto/lto-build2/tmp/sysroots/x86_64-linux/usr/libexec/armv5te-sony-linux-gnueabi/gcc/arm-sony-linux-gnueabi/4.7.3/arm-sony-linux-gnueabi-ld: lto-wrapper failed
> > collect2: error: ld returned 1 exit status
> > make[1]: *** [vmlinux] Error 1
> > make: *** [sub-make] Error 2
> > 
> > Error: Bad result 512, running "make -j 8 KALLSYMS_EXTRA_PASS=1 bzImage": (output follows)
> > Error:
> > ---------------------------------------------
> > 
> > The messages are repeated thousands of times (I'm guessing for every object
> > file after the first that included arch/arm/include/asm/unified.h)
> > 
> > Recognizing that LTO is currently incompatible with kprobes, and (so far)
> > finding that only kprobes appeared to use these macros, I did the following hack:
> > 
> > diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
> > index f5989f4..5179c13 100644
> > --- a/arch/arm/include/asm/unified.h
> > +++ b/arch/arm/include/asm/unified.h
> > @@ -92,6 +92,7 @@
> >  	.macro	iteee, cond
> >  	.endm
> >  #else	/* !__ASSEMBLY__ */
> > +#ifndef CONFIG_LTO
> >  __asm__(
> >  "	.macro	it, cond\n"
> >  "	.endm\n"
> > @@ -123,6 +124,7 @@ __asm__(
> >  "	.endm\n"
> >  "	.macro	iteee, cond\n"
> >  "	.endm\n");
> > +#endif  /* ! CONFIG_LTO */
> >  #endif	/* __ASSEMBLY__ */
> > 
> >  #endif	/* CONFIG_ARM_ASM_UNIFIED */
> > 
> > This the macros thus removed, I had no problems building the kernel
> > and running it on target.
> > 
> > While this works to remove the build error, it doesn't seem robust and I'd
> > like to either 1) find a better way to make these macro definitions conditional,
> > or 2) eliminate them completely.

This is one instance of a more general problem: anything in an asm()
which alters the state of the assembler is potentially unsafe when we
start attempting to merge compilation units together before passing them
through the assembler, because GCC does not take these side effects
into account at all.

This feels like a potential problem for every arch if my understanding
is correct.  But how much it hurts will depend to some extent on how
asm() is used in arch-specific headers.


LTO may completely reorder / remove stuff at external scope, so every
toplevel asm needs careful scrutiny, as does any code anywhere using
directives which permanently change the assembler state (like .arch etc.)
... otherwise we could end up with half the kernel assembled using
the wrong CPU or arch settings, because a random C file somewhere
happened to override them using asm directives.

An nasty hack which might work would be to add primitive multi-definition
prevention like

	.ifndef .L__UNIFIED_H_INCLUDED
	.equ .L__UNIFIED_H_INCLUDED
	
	.macro it cond
	.endm

	@ ...

	.endif

This only works because we know the macro definitions are supposed to
be the same everywhere.

(.L__UNIFIED_H_INCLUDED is anything sufficiently verbose to avoid
clashes with any custom or compiler-generated local symbol.  This symbol
will leak between compilation units too, but providing it doesn't clash
with anything emitted by the compiler, that shouldn't matter.  Because
of the .L prefix, gas will not emit the symbol in its output by default)


If LTO inlines some affected code before the first top-level asm
arising from unified.h then you still lose :(  AFAIK there's no
guarantee it won't, unless you pass -fno-toplevel-reorder, but I
believe that has undesirable side-effects, and somewhat defeats the
idea of LTO.) 


Two slightly more correct fixes I can think of:


1) Get of the "it" .macros for C files, as you suggested.  We can
provide C macros which provide equivalent functionality at the expense
of ugliness and non-standard syntax.  Since the use of these is so rare,
that could be acceptable.

For example:

#ifdef CONFIG_ARM_ASM_UNIFIED
#define U(x...) x
#else
#define U(x...)
#endif

	asm (
	 U(	"itee	eq\n\t"		)
		"moveq	%0, %2\n\t"
		"movne	%0, %3\n\t"
		"movne	%1, #1"
	);

(Silly example, but you get the idea)


.S files won't be LTO'd, so we can keep the macros there, conditional
on #ifdef __ASSEMBLY__, at least allowing the illusion of compliant
assembler syntax to be preserved.


2) Eliminate the toplevel asms for any compilation unit which will be
subjected to LTO, and re-inject them when assembling the LTO output, or
to inject them only when running the assembler.  Since the assembler has
no mechanism like the gcc -include option, that might require wrapping
the assembler in a script, which might slow down compilation noticeably,
depending on how many times the assembler is invoked.  I guess LTO
reduces the number of actual assembler invocations rather significantly,
though -- perhaps we would only do this when LTO is enabled.

This all feels complex and impractical, though.

> > 
> > The macros themselves seem empty.  Can someone tell me what they do?
> > What is the status of these macros?  Are they even needed?
> 
> The names of the macros are for Thumb2 instructions which are redundant
> when building for the ARM instruction set. Newer toolchains which
> support the unified assembler syntax will effectively ignore them and I
> guess these empty macros are there so people can write assembler which
> will compile with older toolchains.
> 
> > Could they be
> > made conditional on something like NEED_IT_MACROS, and then have that set only

This wouldn't solve the problem unless there is only ever one C file in
the entire kernel built with that define.  Even it it were true today,
it might not be true tomorrow.

> > in the arch/arm/kernel/kprobes-test-thumb.c, before the unified.h is included?
> 
> That file needs the real Thumb2 instructions, not empty macros, and
> indeed it doesn't use them, because it is only compiled when
> CONFIG_THUMB2_KERNEL=y and that selects CONFIG_ARM_ASM_UNIFIED and those
> 'it' macro's are guarded by #ifndef CONFIG_ARM_ASM_UNIFIED.
> 
> Note, there are other files which use the 'it' instructions, e.g.
> arch/arm/include/asm/futex.h.

For code which might be built using either the ARM or Thumb instruction set
(which is most of the kernel) the "it" directives are required in certain
situations as part of the assembler syntax.  Just because a particular one
is not needed right now does not mean some assembler that gets written
tomorrow won't need it.  gas can guess correctly which IT instructions to
insert most of the time, but there are some situations where it's
necessary to override the default guess, such as when a location in the
middle of a conditional sequence is a branch target.

Unfortunately, gas chokes on those directives in non-unified syntax, so
we have to make them disappear using macros... hence the problem.

> 
> > I would like get this minor issue resolved in mainline, to make it easier for Andi
> > to get his LTO work upstream and have it work with ARM.
> > 
> > Any suggestions are welcome.
> 
> If your toolchain supports the unified assembler syntax, you could try
> enabling CONFIG_ARM_ASM_UNIFIED in ARM builds.

This is the easiest fix for the immediate issue would be OK if older
toolchains are not LTO-capable anyway, providing there are no old boards
which this would break etc.

It doesn't solve any of the other problems with LTO and toplevel asm(),
so we'd still need to be vigilant about those.

Cheers
---Dave
