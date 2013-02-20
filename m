Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616Ab3BTDRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:17:55 -0500
Received: from relais.videotron.ca ([24.201.245.36]:51135 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962Ab3BTDRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:17:54 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Tue, 19 Feb 2013 22:17:52 -0500 (EST)
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
In-reply-to: <20130219203115.114eab79e8d2099c6306d921@freescale.com>
Message-id: <alpine.LFD.2.03.1302192151280.6419@syhkavp.arg>
References: <20130129181046.GC25415@pd.tnic>
 <1359541333.3529.186.camel@shinybook.infradead.org>
 <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
 <20130131092801.GV23505@n2100.arm.linux.org.uk>
 <20130131145947.f62474a0600848df86548b96@freescale.com>
 <20130201011712.GF23505@n2100.arm.linux.org.uk>
 <1359703995.23531.6.camel@shinybook.infradead.org>
 <20130205210436.670c62e26d2121330e87af35@freescale.com>
 <1360141322.6066.4.camel@shinybook.infradead.org>
 <20130206191905.ac8eb6743e69425f30888704@freescale.com>
 <20130207181315.GM17833@n2100.arm.linux.org.uk>
 <1360344301.6066.263.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081503430.6300@xanadu.home>
 <1360363233.6066.283.camel@shinybook.infradead.org>
 <alpine.LFD.2.02.1302081745500.6300@xanadu.home>
 <20130208191208.2ef3d78bda71aa7b44d00d7b@freescale.com>
 <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
 <20130219203115.114eab79e8d2099c6306d921@freescale.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Kim Phillips wrote:

> On Fri, 8 Feb 2013 22:16:47 -0500
> Nicolas Pitre <nico@fluxnic.net> wrote:
> 
> > Not only that, but in many cases the results are wildly different given 
> > the same config:
> > 
> > > imx_v6_v7_defconfig:	7637605		7636935		-670
> > > lart_defconfig: 	2922550 	2926600 	4050
> > > mxs_defconfig: 	11071139 	11070893 	-246
> > 
> > The mxs_defconfig became much better while lart_defconfig regressed a 
> > lot.
> > 
> > > Haven't looked at why.
> > 
> > Would be a good idea since this is rather weird and gcc could benefit 
> > from your findings.
> 
> The following is next-20130207 built with Linaro gcc 4.7.1 [1], and
> before and after the diff at the bottom of this email (and with
> normalized linux version string sizes):
> 
> lart_defconfig:		2752106 120864 56444 2929414 2cb306 vmlinux
> lart_defconfig:		2756092 120864 56444 2933400 2cc298 vmlinux	#builtin-bswap
> 
> mxs_defconfig:		5229115 280572 5569648 11079335 a90ea7 vmlinux
> mxs_defconfig:		5228969 280552 5569648 11079169 a90e01 vmlinux	#builtin-bswap
> 
> imx_v6_v7_defconfig:	6935025 356172 360648 7651845 74c205 vmlinux
> imx_v6_v7_defconfig:	6934091 356180 360648 7650919 74be67 vmlinux	#builtin-bswap
> 
> 
> so builtin-bswap improved mxs and imx_v6_v7 but in lart, it _added_
> 3986 bytes to .text -> not good.
> 
> Getting a closer look at lart, bloat-o-meter says the code actually
> shrunk:
> 
> add/remove: 7/1 grow/shrink: 11/19 up/down: 298/-356 (-58)
> function                                     old     new   delta
> inet_abc_len                                   -      96     +96
> __bswapdi2                                     -      52     +52
> __bswapsi2                                     -      32     +32
> icmp_unreach                                 472     492     +20
> xfrm_selector_match                          988    1000     +12
> fib_table_insert                            2176    2188     +12
> __kstrtab___bswapsi2                           -      11     +11
> __kstrtab___bswapdi2                           -      11     +11
> __ksymtab___bswapsi2                           -       8      +8
> __ksymtab___bswapdi2                           -       8      +8
> vermagic                                      51      57      +6
> linux_banner                                 230     236      +6
> xfrm_replay_check_esn                        320     324      +4
> xfrm_replay_check_bmp                        200     204      +4
> xfrm_replay_check                            152     156      +4
> static.tcp_parse_aligned_timestamp            80      84      +4
> fib_table_delete                             708     712      +4
> cookie_v4_check                             1316    1320      +4
> tcp_tso_segment                              728     724      -4
> tcp_options_write                            724     720      -4
> ip_rt_ioctl                                 1152    1148      -4
> fib_trie_seq_show                            724     720      -4
> crc32_be                                     448     444      -4
> xfrm_stateonly_find                          640     632      -8
> tcp_finish_connect                           276     268      -8
> static.tcp_v4_send_ack                       480     472      -8
> __xfrm_state_lookup                          356     348      -8
> __xfrm_state_bump_genids                     436     428      -8
> __find_acq_core                             1256    1248      -8
> cookie_v4_init_sequence                      272     260     -12
> __xfrm_state_insert                          616     600     -16
> sys_swapon                                  2500    2480     -20
> xfrm_state_find                             2420    2396     -24
> xfrm_hash_resize                            1620    1596     -24
> fib_route_seq_show                           560     536     -24
> fib_table_dump                               704     676     -28
> devinet_ioctl                               1856    1796     -60
> static.inet_abc_len                           80       -     -80
> 
> Comparing System.maps, .rodata starts at the same address:
> 
> c020a000 R __start_rodata
> c020a000 R __start_rodata	#builtin-bswap
> 
> however, changes including the __bswap[sd]i2 implementation pushes
> the .rodata section size just over the 4KiB alignment boundary
> specified in arm/kernel/vmlinux.lds:
> 
> no builtin_bswap:
> 
> c028ffc4 R __stop___modver
> c0290000 R __end_rodata
> c0290000 R __start___ex_table
> 
> with builtin_bswap:
> 
> c0290068 R __stop___modver
> c0291000 R __end_rodata
> c0291000 R __start___ex_table
> 
> So, AFAICT, that's why we see a total increase in .text for lart,
> and, looking at both numbers being a little less than 4KiB, I
> suspect the same with whatever happened with mxs above.

OK.  At least we do have a plausible explanation now.  The actual code 
being smaller should compensate for section alignment loss.

> ok, so to avoid recursion, I've enforced a -O2 on bswapsdi2.o.

Not only recursion, but the horrible assembly output from -Os.

> Here's the new diff:
> 
> changes from last diff:
> - enforce -O2 for bswapsdi2.o
> - fix building out-of-source tree
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 4265a26..5e8b735 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -58,6 +58,7 @@ config ARM
>  	select CLONE_BACKWARDS
>  	select OLD_SIGSUSPEND3
>  	select OLD_SIGACTION
> +	select ARCH_USE_BUILTIN_BSWAP
>  	help
>  	  The ARM series is a line of low-power-consumption RISC chip designs
>  	  licensed by ARM Ltd and targeted at embedded applications and
> diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
> index c9865f6..8ef97c4 100644
> --- a/arch/arm/boot/compressed/Makefile
> +++ b/arch/arm/boot/compressed/Makefile
> @@ -111,12 +111,12 @@ endif
>  
>  targets       := vmlinux vmlinux.lds \
>  		 piggy.$(suffix_y) piggy.$(suffix_y).o \
> -		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
> +		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
>  		 font.o font.c head.o misc.o $(OBJS)
>  
>  # Make sure files are removed during clean
>  extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
> -		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
> +		 lib1funcs.S ashldi3.S bswapsdi2.o $(libfdt) $(libfdt_hdrs)
>  
>  ifeq ($(CONFIG_FUNCTION_TRACER),y)
>  ORIG_CFLAGS := $(KBUILD_CFLAGS)
> @@ -158,6 +158,12 @@ ashldi3 = $(obj)/ashldi3.o
>  $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
>  	$(call cmd,shipped)
>  
> +# For __bswapsi2, __bswapdi2
> +bswapsdi2 = $(obj)/bswapsdi2.o
> +
> +$(obj)/bswapsdi2.o: $(obj)/../../../../arch/$(SRCARCH)/lib/bswapsdi2.o
> +	$(call cmd,shipped)
> +

I don't think you can get away with this.  The decompressor code is 
compiled with -fpic and the main kernel is not.  Most toolchains do mark 
object files with some flags to prevent the link of incompatible objects 
together (normally pic and non pic objects are not compatible even if in 
this very simple case that would not matter).  Maybe you are able to 
link zImage successfully simply because no references to __bswap* needed 
to be resolved and therefore the linker didn't need to search/include 
that object?

> diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
> index af72969..dbee639 100644
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
> @@ -45,3 +45,5 @@ lib-$(CONFIG_ARCH_SHARK)	+= io-shark.o
>  
>  $(obj)/csumpartialcopy.o:	$(obj)/csumpartialcopygeneric.S
>  $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
> +
> +CFLAGS_bswapsdi2.o = -O2

Please insert a small comment to explain why this is done.  Adding some 
more elaborate explanation in the commit log would be good too.


Nicolas
