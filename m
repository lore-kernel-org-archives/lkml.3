Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3J0Clj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 22:41:39 -0400
Received: from relais.videotron.ca ([24.201.245.36]:42452 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3J0Cli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 22:41:38 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Sat, 26 Oct 2013 22:41:34 -0400 (EDT)
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
Subject: Re: [PATCH v7] arm: use built-in byte swap function
In-reply-to: <20130523114654.1f273241725205c6703b2226@freescale.com>
Message-id: <alpine.LFD.2.03.1310262235310.1951@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
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
 <alpine.LFD.2.03.1302212219100.6419@syhkavp.arg>
 <20130222194032.f7b44aefa5e2723d16767a1b@freescale.com>
 <1361661654.18110.102.camel@shinybook.infradead.org>
 <20130523114654.1f273241725205c6703b2226@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Kim Phillips wrote:

> Enable the compiler intrinsic for byte swapping on arch ARM.  This
> allows the compiler to detect and be able to optimize out byte
> swappings, and has a very modest benefit on vmlinux size (Linaro gcc
> 4.8):
> 
>    text	   data	    bss	    dec	    hex	filename
> 2840310	 123932	  61960	3026202	 2e2d1a	vmlinux-lart #orig
> 2840152	 123932	  61960	3026044	 2e2c7c	vmlinux-lart #builtin-bswap
> 
> 6473120	 314840	5616016	12403976 bd4508	vmlinux-mxs #orig
> 6472586	 314848	5616016	12403450 bd42fa	vmlinux-mxs #builtin-bswap
> 
> 7419872	 318372	 379556	8117800	 7bde28	vmlinux-imx_v6_v7 #orig
> 7419170	 318364	 379556	8117090	 7bdb62	vmlinux-imx_v6_v7 #builtin-bswap
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>

Did this ever go somewhere?

Russell suggested at the time to base it against a mainline kernel 
(since it was patching files which apparently were already patched with 
out-of-tree lz4 patches) and send it to his patch system.


> ---
> resending as v6 appears to have fallen though the cracks.  Russell?
> 
> v7: rebased onto next-20130521, re-ran above vmlinux sizes with
>     Linaro gcc 4.8, added Nicolas' Reviewed-by, and David's Acked-by.
> v6 and prior version information:
>     https://lkml.org/lkml/2013/2/22/475
> 
>  arch/arm/Kconfig                  |  1 +
>  arch/arm/boot/compressed/Makefile | 15 +++++++++++----
>  arch/arm/kernel/armksyms.c        |  4 ++++
>  arch/arm/lib/Makefile             |  2 +-
>  arch/arm/lib/bswapsdi2.S          | 36 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 53 insertions(+), 5 deletions(-)
>  create mode 100644 arch/arm/lib/bswapsdi2.S
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a7fc5ea..c2fe04d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -63,6 +63,7 @@ config ARM
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
>  	select HAVE_CONTEXT_TRACKING
> +	select ARCH_USE_BUILTIN_BSWAP
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
>  	  licensed by ARM Ltd and targeted at embedded applications and
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index 198a4ad..bd8a176 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -112,12 +112,12 @@ endif
>  
>  targets       := vmlinux vmlinux.lds \
>  		 piggy.$(suffix_y) piggy.$(suffix_y).o \
> -		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
> -		 font.o font.c head.o misc.o $(OBJS)
> +		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
> +		 bswapsdi2.S font.o font.c head.o misc.o $(OBJS)
>  
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern piggy.lz4 \
> -		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
> +		 lib1funcs.S ashldi3.S bswapsdi2.S $(libfdt) $(libfdt_hdrs)
>  
>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -159,6 +159,12 @@ ashldi3 = $(obj)/ashldi3.o
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
> @@ -180,7 +186,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
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
> index 0000000..2ba43a0
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
> +	mov     r3, r3, lsr #8
> +	bic     r3, r3, #0xff00
> +	eor     r0, r3, r0, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapsi2)
> +
> +ENTRY(__bswapdi2)
> +	mov     ip, r1
> +	eor     r3, ip, ip, ror #16
> +	eor     r1, r0, r0, ror #16
> +	mov     r1, r1, lsr #8
> +	mov     r3, r3, lsr #8
> +	bic     r3, r3, #0xff00
> +	bic     r1, r1, #0xff00
> +	eor     r1, r1, r0, ror #8
> +	eor     r0, r3, ip, ror #8
> +	mov     pc, lr
> +ENDPROC(__bswapdi2)
> +#endif
> -- 
> 1.8.1.5
> 
