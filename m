Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab3BVDkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 22:40:15 -0500
Received: from relais.videotron.ca ([24.201.245.36]:32089 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab3BVDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 22:40:11 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Thu, 21 Feb 2013 22:40:08 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Kim Phillips <kim.phillips@freescale.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
In-reply-to: <20130221203327.6558f89277468f7ffffa6506@freescale.com>
Message-id: <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
 <1360363233.6066.283.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
 <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
 <1361356696.13482.269.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200835380.6419@syhkavp.arg>
 <1361367842.13482.279.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302200905300.6419@syhkavp.arg>
 <1361372008.13482.280.camel@i7.infradead.org>
 <alpine.LFD.2.03.1302201040460.6419@syhkavp.arg>
 <20130220214943.9b28a5b208da9f081387c55e@freescale.com>
 <alpine.LFD.2.03.1302202327370.6419@syhkavp.arg>
 <20130221005221.15279b1372501af12c1e4f32@freescale.com>
 <alpine.LFD.2.03.1302211134160.6419@syhkavp.arg>
 <20130221203327.6558f89277468f7ffffa6506@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Kim Phillips wrote:

> Here's the asm version I'm working on now, based on compiler
> output of the C version.  Haven't tested beyond defconfig builds,
> which pass ok.
> 
> Is there anything I have to do for thumb mode?  If so, how to test?

You just need to pick a config that uses some ARMv7 processor, and 
enable CONFIG_THUMB2_KERNEL.  I don't see any problem with your patch 
wrt Thumb2.

Still, I have minor comments below.

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index dedf02b..e8a41d0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -59,6 +59,7 @@ config ARM
>  	select CLONE_BACKWARDS
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
> +	select ARCH_USE_BUILTIN_BSWAP
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
>  	  licensed by ARM Ltd and targeted at embedded applications and
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 5cad8a6..a277e97 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -108,12 +108,12 @@ endif
>  
>  targets       := vmlinux vmlinux.lds \
>  		 piggy.$(suffix_y) piggy.$(suffix_y).o \
> -		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
> +		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \

Should be both bswapsdi2.o bswapsdi2.S

>  		 font.o font.c head.o misc.o $(OBJS)
>  
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
> -		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
> +		 lib1funcs.S ashldi3.S bswapsdi2.o $(libfdt) $(libfdt_hdrs)

Should be bswapsdi2.S.

>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -155,6 +155,12 @@ ashldi3 = $(obj)/ashldi3.o
>  $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
>  	$(call cmd,shipped)
>  
> +# For __bswapsi2, __bswapdi2
> +bswapsdi2 = $(obj)/bswapsdi2.o
> +
> +$(obj)/bswapsdi2.S: $(srctree)/arch/$(SRCARCH)/lib/bswapsdi2.S
> +	$(call cmd,shipped)
> +
>  # We need to prevent any GOTOFF relocs being used with references
>  # to symbols in the .bss section since we cannot relocate them
>  # independently from the rest at run time.  This can be achieved by
> @@ -176,7 +182,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
>  fi
>  
>  $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
> -		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) FORCE
> +		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) \
> +		$(bswapsdi2) FORCE
>  	@$(check_for_multiple_zreladdr)
>  	$(call if_changed,ld)
>  	@$(check_for_bad_syms)
> diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
> index 60d3b73..ba578f7 100644
> --- a/arch/arm/kernel/armksyms.c
> +++ b/arch/arm/kernel/armksyms.c
> @@ -35,6 +35,8 @@ extern void __ucmpdi2(void);
>  extern void __udivsi3(void);
>  extern void __umodsi3(void);
>  extern void __do_div64(void);
> +extern void __bswapsi2(void);
> +extern void __bswapdi2(void);
>  
>  extern void __aeabi_idiv(void);
>  extern void __aeabi_idivmod(void);
> @@ -114,6 +116,8 @@ EXPORT_SYMBOL(__ucmpdi2);
>  EXPORT_SYMBOL(__udivsi3);
>  EXPORT_SYMBOL(__umodsi3);
>  EXPORT_SYMBOL(__do_div64);
> +EXPORT_SYMBOL(__bswapsi2);
> +EXPORT_SYMBOL(__bswapdi2);
>  
>  #ifdef CONFIG_AEABI
>  EXPORT_SYMBOL(__aeabi_idiv);
> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index af72969..5383df7 100644
> --- a/arch/arm/lib/Makefile
> +++ b/arch/arm/lib/Makefile
> @@ -13,7 +13,7 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
>  		   ashldi3.o ashrdi3.o lshrdi3.o muldi3.o             \
>  		   ucmpdi2.o lib1funcs.o div64.o                      \
>  		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
> -		   call_with_stack.o
> +		   call_with_stack.o bswapsdi2.o
>  
>  mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
>  
> diff --git a/arch/arm/lib/bswapsdi2.S b/arch/arm/lib/bswapsdi2.S
> new file mode 100644
> index 0000000..e9c8ca7
> --- /dev/null
> +++ b/arch/arm/lib/bswapsdi2.S
> @@ -0,0 +1,36 @@
> +#include <linux/linkage.h>
> +
> +#if __LINUX_ARM_ARCH__ >= 6
> +ENTRY(__bswapsi2)
> +	rev	r0, r0
> +	bx	lr
> +ENDPROC(__bswapsi2)
> +
> +ENTRY(__bswapdi2)
> +	rev	r3, r0
> +	rev	r0, r1
> +	mov	r1, r3
> +	bx	lr
> +ENDPROC(__bswapdi2)
> +#else
> +ENTRY(__bswapsi2)
> +	eor     r3, r0, r0, ror #16
> +	lsr     r3, r3, #8

Some older binutils used with pre ARMv6 platforms don't understand the 
latest unified syntax.  So in this case it is better to use:

	mov	r3, r3, lsr #8

> +	bic     r3, r3, #65280  @ 0xff00

Please use #0xff00 directly rather than keeping it as a comment.

> +	eor     r0, r3, r0, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapsi2)
> +
> +ENTRY(__bswapdi2)
> +	mov     ip, r1
> +	eor     r3, ip, ip, ror #16
> +	eor     r1, r0, r0, ror #16
> +	lsr     r1, r1, #8
> +	lsr     r3, r3, #8
> +	bic     r3, r3, #65280  @ 0xff00
> +	bic     r1, r1, #65280  @ 0xff00

Same comments for the 4 instructions above.

> +	eor     r1, r1, r0, ror #8
> +	eor     r0, r3, ip, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapdi2)
> +#endif
> 
> Thanks,
> 
> Kim
> 
