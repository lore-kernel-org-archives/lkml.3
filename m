Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935442Ab3BTCej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 21:34:39 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:13217
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934991Ab3BTCeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 21:34:36 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -6
X-BigFish: VS-6(zz98dI936eI1b0bI1432I444fM4015Ib922lzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275ch17326ah8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Tue, 19 Feb 2013 20:31:15 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Nicolas Pitre <nico@fluxnic.net>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
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
Message-ID: <20130219203115.114eab79e8d2099c6306d921@freescale.com>
In-Reply-To: <alpine.LFD.2.02.1302082102380.6300@xanadu.home>
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
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2013 22:16:47 -0500
Nicolas Pitre <nico@fluxnic.net> wrote:

> On Fri, 8 Feb 2013, Kim Phillips wrote:
> 
> > On Fri, 8 Feb 2013 17:47:33 -0500
> > Nicolas Pitre <nico@fluxnic.net> wrote:
> > 
> > > On Fri, 8 Feb 2013, Woodhouse, David wrote:
> > > 
> > > > On Fri, 2013-02-08 at 15:04 -0500, Nicolas Pitre wrote:
> > > > > On Fri, 8 Feb 2013, Woodhouse, David wrote:
> > > > > 
> > > > > > On Thu, 2013-02-07 at 18:13 +0000, Russell King - ARM Linux wrote:
> > > > > > > 
> > > > > > > However, the biggest reason not to use libgcc is that we want to control
> > > > > > > what gets used in the kernel - for example, no floating point, and no
> > > > > > > use of 64 x 64bit division.
> > > > > > 
> > > > > > Which is all very sensible. But there's no particular reason we couldn't
> > > > > > add a __bswap[sd]i2 to the kernel's version of libgcc if we wanted to.
> > > > > 
> > > > > Absolutely.
> > > > 
> > > > And then ARM can just set ARCH_USE_BUILTIN_BSWAP like other
> > > > architectures do, right?
> > > 
> > > If that turns out to be beneficial over what we have now, then yes.
> > > I didn't read back the whole thread to form an opinion though.
> > 
> > The diff below implements __bswap[sd]i2 in arch/arm/lib, and
> > results in the following savings in vmlinux size:
> > 
> > column 1: name of defconfig
> > column 2: text+data+bss, linux-next-20130207 vanilla, gcc 4.6.3
> > column 3: text+data+bss, linux-next-20130207+below diff, gcc 4.6.3
> > column 4: col. 3 - col. 2 (ie., -ve numbers represent savings)
> > 
> [...]
> > imx_v6_v7_defconfig: 	7672373 	7667089 	-5284
> > lart_defconfig:	2941150		2941054         -96
> > mxs_defconfig: 	11091983 	11095679 	3696
> 
> The savings are good, with some impressive cases.  However the 
> mxs_defconfig is completely the opposite and by far.  Any idea?

Unfortunately, I don't seem to be able to reproduce this anymore.
Same linux-next, with three different compilers always produces
smaller binaries:

   text	   data	    bss	    dec	    hex	filename
5239363	 280576	5569648	11089587	 a936b3	linux-next-mxs-orig-gcc4.7/vmlinux
5239169	 280556	5569648	11089373	 a935dd	linux-next-mxs-bswap-gcc4.7/vmlinux

5262223	 280592	5569648	11112463	 a9900f	linux-next-mxs-orig-gcc4.6.3/vmlinux
5261909	 280584	5569648	11112141	 a98ecd	linux-next-mxs-bswap-gcc4.6.3/vmlinux

5241379	 280580	5569648	11091607	 a93e97	linux-next-mxs-orig-gcc4.6ubuntu/vmlinux
5241189	 280600	5569648	11091437	 a93ded	linux-next-mxs-bswap-gcc4.6ubuntu/vmlinux

So I've since made a more consistent cross-build environment, using
cross tools from Linaro [1,2] instead of via Ubuntu [3].

> > gcc 4.7.3 runs haven't been as good across the board as gcc 4.6.3,
> > however:
> 
> Not only that, but in many cases the results are wildly different given 
> the same config:
> 
> > imx_v6_v7_defconfig:	7637605		7636935		-670
> > lart_defconfig: 	2922550 	2926600 	4050
> > mxs_defconfig: 	11071139 	11070893 	-246
> 
> The mxs_defconfig became much better while lart_defconfig regressed a 
> lot.
> 
> > Haven't looked at why.
> 
> Would be a good idea since this is rather weird and gcc could benefit 
> from your findings.

The following is next-20130207 built with Linaro gcc 4.7.1 [1], and
before and after the diff at the bottom of this email (and with
normalized linux version string sizes):

lart_defconfig:		2752106 120864 56444 2929414 2cb306 vmlinux
lart_defconfig:		2756092 120864 56444 2933400 2cc298 vmlinux	#builtin-bswap

mxs_defconfig:		5229115 280572 5569648 11079335 a90ea7 vmlinux
mxs_defconfig:		5228969 280552 5569648 11079169 a90e01 vmlinux	#builtin-bswap

imx_v6_v7_defconfig:	6935025 356172 360648 7651845 74c205 vmlinux
imx_v6_v7_defconfig:	6934091 356180 360648 7650919 74be67 vmlinux	#builtin-bswap


so builtin-bswap improved mxs and imx_v6_v7 but in lart, it _added_
3986 bytes to .text -> not good.

Getting a closer look at lart, bloat-o-meter says the code actually
shrunk:

add/remove: 7/1 grow/shrink: 11/19 up/down: 298/-356 (-58)
function                                     old     new   delta
inet_abc_len                                   -      96     +96
__bswapdi2                                     -      52     +52
__bswapsi2                                     -      32     +32
icmp_unreach                                 472     492     +20
xfrm_selector_match                          988    1000     +12
fib_table_insert                            2176    2188     +12
__kstrtab___bswapsi2                           -      11     +11
__kstrtab___bswapdi2                           -      11     +11
__ksymtab___bswapsi2                           -       8      +8
__ksymtab___bswapdi2                           -       8      +8
vermagic                                      51      57      +6
linux_banner                                 230     236      +6
xfrm_replay_check_esn                        320     324      +4
xfrm_replay_check_bmp                        200     204      +4
xfrm_replay_check                            152     156      +4
static.tcp_parse_aligned_timestamp            80      84      +4
fib_table_delete                             708     712      +4
cookie_v4_check                             1316    1320      +4
tcp_tso_segment                              728     724      -4
tcp_options_write                            724     720      -4
ip_rt_ioctl                                 1152    1148      -4
fib_trie_seq_show                            724     720      -4
crc32_be                                     448     444      -4
xfrm_stateonly_find                          640     632      -8
tcp_finish_connect                           276     268      -8
static.tcp_v4_send_ack                       480     472      -8
__xfrm_state_lookup                          356     348      -8
__xfrm_state_bump_genids                     436     428      -8
__find_acq_core                             1256    1248      -8
cookie_v4_init_sequence                      272     260     -12
__xfrm_state_insert                          616     600     -16
sys_swapon                                  2500    2480     -20
xfrm_state_find                             2420    2396     -24
xfrm_hash_resize                            1620    1596     -24
fib_route_seq_show                           560     536     -24
fib_table_dump                               704     676     -28
devinet_ioctl                               1856    1796     -60
static.inet_abc_len                           80       -     -80

Comparing System.maps, .rodata starts at the same address:

c020a000 R __start_rodata
c020a000 R __start_rodata	#builtin-bswap

however, changes including the __bswap[sd]i2 implementation pushes
the .rodata section size just over the 4KiB alignment boundary
specified in arm/kernel/vmlinux.lds:

no builtin_bswap:

c028ffc4 R __stop___modver
c0290000 R __end_rodata
c0290000 R __start___ex_table

with builtin_bswap:

c0290068 R __stop___modver
c0291000 R __end_rodata
c0291000 R __start___ex_table

So, AFAICT, that's why we see a total increase in .text for lart,
and, looking at both numbers being a little less than 4KiB, I
suspect the same with whatever happened with mxs above.

FYI, here are the same platforms with Linaro gcc 4.7.3 [2]:

lart_defconfig:		2745218 120888 56444 2922550 2c9836 vmlinux
lart_defconfig:		2749300 120888 56444 2926632 2ca828 vmlinux	#builtin-bswap

mxs_defconfig: 		5220919 280572 5569648 11071139 a8eea3 vmlinux
mxs_defconfig:		5220725 280552 5569648 11070925 a8edcd vmlinux	#builtin-bswap

imx_v6_v7_defconfig:	6920769 356188 360648 7637605 748a65 vmlinux
imx_v6_v7_defconfig:	6920091 356196 360648 7636935 7487c7 vmlinux	#builtin-bswap

so lart is still mostly affected by the .rodata alignment:

add/remove: 7/1 grow/shrink: 11/16 up/down: 330/-308 (22)
function                                     old     new   delta
inet_abc_len                                   -      96     +96
__bswapdi2                                     -      52     +52
fib_table_insert                            2152    2196     +44
__bswapsi2                                     -      32     +32
icmp_unreach                                 472     492     +20
xfrm_selector_match                          988    1000     +12
__kstrtab___bswapsi2                           -      11     +11
__kstrtab___bswapdi2                           -      11     +11
__ksymtab___bswapsi2                           -       8      +8
__ksymtab___bswapdi2                           -       8      +8
vermagic                                      51      57      +6
linux_banner                                 232     238      +6
xfrm_replay_check_esn                        320     324      +4
xfrm_replay_check_bmp                        200     204      +4
xfrm_replay_check                            152     156      +4
static.tcp_parse_aligned_timestamp            80      84      +4
fib_table_delete                             708     712      +4
cookie_v4_check                             1316    1320      +4
tcp_options_write                            724     720      -4
ip_rt_ioctl                                 1152    1148      -4
fib_trie_seq_show                            724     720      -4
crc32_be                                     448     444      -4
xfrm_stateonly_find                          640     632      -8
tcp_finish_connect                           276     268      -8
static.tcp_v4_send_ack                       480     472      -8
__xfrm_state_lookup                          356     348      -8
__xfrm_state_bump_genids                     436     428      -8
__find_acq_core                             1252    1244      -8
cookie_v4_init_sequence                      272     260     -12
__xfrm_state_insert                          616     600     -16
xfrm_state_find                             2420    2396     -24
xfrm_hash_resize                            1620    1596     -24
fib_table_dump                               704     676     -28
devinet_ioctl                               1856    1796     -60
static.inet_abc_len                           80       -     -80

> > In any case, some questions I have are:
> > 
> > (a) are the __bswap[sd]i2 implementations acceptable written in C,
> > as in the diff?  I don't speak ARM asm (yet at least).  The
> > generated code looks pretty optimal in both armv5 and 6+.
> 
> It looks pretty nice indeed:
> 
> __bswapsi2:
>         eor     r2, r0, r0, ror #16
>         mov     r1, r2, lsr #8
>         bic     r3, r1, #65280
>         eor     r0, r3, r0, ror #8
>         bx      lr
> 
> There is no way to do better than that.  But that's true only if -Os is 
> _not_ used.  With -Os we get the following output:
> 
> __bswapsi2:
>         mov     r3, r0, asl #24
>         and     r2, r0, #65280
>         orr     r3, r3, r0, lsr #24
>         orr     r3, r3, r2, asl #8
>         and     r0, r0, #16711680
>         orr     r0, r3, r0, lsr #8
>         bx      lr
> 
> I really don't get why gcc thinks the above is shorter.  I'm saving you 
> from pasting the __bswapdi2 result which is also way way worse.
> That was with Linaro gcc v4.6.2.
> 
> With Sourcery gcc v4.5.1 we get:
> 
> __bswapsi2:
>         stmfd   sp!, {r3, lr}
>         bl      __bswapsi2
>         ldmfd   sp!, {r3, pc}
> 
> This is indeed shorter, but much less useful.  So you better enforce -O2 
> for this file.  And the nice thing with C code is that it is fully 
> optimized with the rev instruction when compiling for ARMv6+ if it is 
> ever used in that case.

ok, so to avoid recursion, I've enforced a -O2 on bswapsdi2.o.

> > (c) testing allyesconfigs is proving to be a pain - lots of
> > breakeage - other than defconfig testing, is there any more I can do?
> 
> The defconfigs provide wildly different results and that is a good 
> thing for further investigation.  You may concentrate on a small 
> interesting sample such as those I kept above.
> 
> With allyesconfig the good configs would cancel out the bad ones making 
> the bad ones invisible.

ok, thanks for your comments, Nicolas.

Here's the new diff:

changes from last diff:
- enforce -O2 for bswapsdi2.o
- fix building out-of-source tree

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4265a26..5e8b735 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -58,6 +58,7 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select ARCH_USE_BUILTIN_BSWAP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index c9865f6..8ef97c4 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -111,12 +111,12 @@ endif
 
 targets       := vmlinux vmlinux.lds \
 		 piggy.$(suffix_y) piggy.$(suffix_y).o \
-		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S \
+		 lib1funcs.o lib1funcs.S ashldi3.o ashldi3.S bswapsdi2.o \
 		 font.o font.c head.o misc.o $(OBJS)
 
 # Make sure files are removed during clean
 extra-y       += piggy.gzip piggy.lzo piggy.lzma piggy.xzkern \
-		 lib1funcs.S ashldi3.S $(libfdt) $(libfdt_hdrs)
+		 lib1funcs.S ashldi3.S bswapsdi2.o $(libfdt) $(libfdt_hdrs)
 
 ifeq ($(CONFIG_FUNCTION_TRACER),y)
 ORIG_CFLAGS := $(KBUILD_CFLAGS)
@@ -158,6 +158,12 @@ ashldi3 = $(obj)/ashldi3.o
 $(obj)/ashldi3.S: $(srctree)/arch/$(SRCARCH)/lib/ashldi3.S
 	$(call cmd,shipped)
 
+# For __bswapsi2, __bswapdi2
+bswapsdi2 = $(obj)/bswapsdi2.o
+
+$(obj)/bswapsdi2.o: $(obj)/../../../../arch/$(SRCARCH)/lib/bswapsdi2.o
+	$(call cmd,shipped)
+
 # We need to prevent any GOTOFF relocs being used with references
 # to symbols in the .bss section since we cannot relocate them
 # independently from the rest at run time.  This can be achieved by
@@ -179,7 +185,8 @@ if [ $(words $(ZRELADDR)) -gt 1 -a "$(CONFIG_AUTO_ZRELADDR)" = "" ]; then \
 fi
 
 $(obj)/vmlinux: $(obj)/vmlinux.lds $(obj)/$(HEAD) $(obj)/piggy.$(suffix_y).o \
-		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) FORCE
+		$(addprefix $(obj)/, $(OBJS)) $(lib1funcs) $(ashldi3) \
+		$(bswapsdi2) FORCE
 	@$(check_for_multiple_zreladdr)
 	$(call if_changed,ld)
 	@$(check_for_bad_syms)
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 60d3b73..ba578f7 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -35,6 +35,8 @@ extern void __ucmpdi2(void);
 extern void __udivsi3(void);
 extern void __umodsi3(void);
 extern void __do_div64(void);
+extern void __bswapsi2(void);
+extern void __bswapdi2(void);
 
 extern void __aeabi_idiv(void);
 extern void __aeabi_idivmod(void);
@@ -114,6 +116,8 @@ EXPORT_SYMBOL(__ucmpdi2);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
 EXPORT_SYMBOL(__do_div64);
+EXPORT_SYMBOL(__bswapsi2);
+EXPORT_SYMBOL(__bswapdi2);
 
 #ifdef CONFIG_AEABI
 EXPORT_SYMBOL(__aeabi_idiv);
diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index af72969..dbee639 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -13,7 +13,7 @@ lib-y		:= backtrace.o changebit.o csumipv6.o csumpartial.o   \
 		   ashldi3.o ashrdi3.o lshrdi3.o muldi3.o             \
 		   ucmpdi2.o lib1funcs.o div64.o                      \
 		   io-readsb.o io-writesb.o io-readsl.o io-writesl.o  \
-		   call_with_stack.o
+		   call_with_stack.o bswapsdi2.o
 
 mmu-y	:= clear_user.o copy_page.o getuser.o putuser.o
 
@@ -45,3 +45,5 @@ lib-$(CONFIG_ARCH_SHARK)	+= io-shark.o
 
 $(obj)/csumpartialcopy.o:	$(obj)/csumpartialcopygeneric.S
 $(obj)/csumpartialcopyuser.o:	$(obj)/csumpartialcopygeneric.S
+
+CFLAGS_bswapsdi2.o = -O2
diff --git a/arch/arm/lib/bswapsdi2.c b/arch/arm/lib/bswapsdi2.c
new file mode 100644
index 0000000..1923b2f
--- /dev/null
+++ b/arch/arm/lib/bswapsdi2.c
@@ -0,0 +1,19 @@
+unsigned int __bswapsi2(unsigned int x)
+{
+	return ((x & 0x000000ffUL) << 24) |
+	       ((x & 0x0000ff00UL) <<  8) |
+	       ((x & 0x00ff0000UL) >>  8) |
+	       ((x & 0xff000000UL) >> 24);
+}
+
+unsigned long long __bswapdi2(unsigned long long x)
+{
+	return ((x & 0x00000000000000ffULL) << 56) |
+	       ((x & 0x000000000000ff00ULL) << 40) |
+	       ((x & 0x0000000000ff0000ULL) << 24) |
+	       ((x & 0x00000000ff000000ULL) <<  8) |
+	       ((x & 0x000000ff00000000ULL) >>  8) |
+	       ((x & 0x0000ff0000000000ULL) >> 24) |
+	       ((x & 0x00ff000000000000ULL) >> 40) |
+	       ((x & 0xff00000000000000ULL) >> 56);
+}

Thanks,

Kim

[1] arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.06-20120625 - Linaro GCC 2012.06) 4.7.1 20120531 (prerelease)

[2] arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.7-2013.01-20130125 - Linaro GCC 2013.01) 4.7.3 20130102 (prerelease)

[3] gcc version 4.6.3 20120624 (prerelease) (Ubuntu/Linaro 4.6.3-8ubuntu1)
 (deb http://mirrors.us.kernel.org/ubuntu/ precise main universe)

