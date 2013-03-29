Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3C2SrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:47:00 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:38626
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390Ab3C2Sq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:46:59 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.230;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail03v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z10d0kz98bI1469K4015I14ffIzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1b0ah1155h)
Message-ID: <5155E28A.30509@am.sony.com>
Date: Fri, 29 Mar 2013 11:50:50 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Russell King <rmk@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: RFC: right way to conditional-ize some macros for LTO
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A while ago I was working on supporting link-time optimization
for ARM, and I'm just now getting around to submitting some of
the patches from my work.  I'll explain more below, but the
executive summary is this: Andi Kleen's LTO patches for Linux
almost work on ARM.  I ran into one issue in
arch/arm/include/asm/unified.h where various 'it'-related
macros are expanding multiple times, in C context, and causing
build errors.

As near as I can tell, these macros are not used except by
arch/arm/kernel/kprobes-test-thumb.c (and most are not used
at all).

When compiling with CONFIG_LTO=y, in Andi's 3.7.0 tree with LTO
patches, I got the messages below:
-----------------------------------------------
...
  LD      drivers/tty/built-in.o
  LD      drivers/built-in.o
  LINK    vmlinux
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LDFINAL vmlinux.o
[Leaving LTRANS /tmp/ccsIMbQT.args]
[Leaving LTRANS vmlinux.o.ltrans.out]
In file included from /a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/include/uapi/linux/swab.h:269:0,
                 from :872:
/a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c: In function 'wp512_process_buffer':
/a/home/tbird/work/auto-reduce/lto-work/linux-misc-andi-kleen/crypto/wp512.c:987:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
vmlinux.o.ltrans0.s: Assembler messages:
vmlinux.o.ltrans0.s:408: Error: Macro `it' was already defined
vmlinux.o.ltrans0.s:410: Error: Macro `itt' was already defined
vmlinux.o.ltrans0.s:412: Error: Macro `ite' was already defined
vmlinux.o.ltrans0.s:414: Error: Macro `ittt' was already defined
vmlinux.o.ltrans0.s:416: Error: Macro `itte' was already defined
vmlinux.o.ltrans0.s:418: Error: Macro `itet' was already defined
vmlinux.o.ltrans0.s:420: Error: Macro `itee' was already defined
vmlinux.o.ltrans0.s:422: Error: Macro `itttt' was already defined
vmlinux.o.ltrans0.s:424: Error: Macro `ittte' was already defined
vmlinux.o.ltrans0.s:426: Error: Macro `ittet' was already defined
vmlinux.o.ltrans0.s:428: Error: Macro `ittee' was already defined
vmlinux.o.ltrans0.s:430: Error: Macro `itett' was already defined
vmlinux.o.ltrans0.s:432: Error: Macro `itete' was already defined
vmlinux.o.ltrans0.s:434: Error: Macro `iteet' was already defined
vmlinux.o.ltrans0.s:436: Error: Macro `iteee' was already defined
vmlinux.o.ltrans0.s:968: Error: Macro `it' was already defined
vmlinux.o.ltrans0.s:970: Error: Macro `itt' was already defined
vmlinux.o.ltrans0.s:972: Error: Macro `ite' was already defined
vmlinux.o.ltrans0.s:974: Error: Macro `ittt' was already defined
vmlinux.o.ltrans0.s:976: Error: Macro `itte' was already defined
...
[Leaving LTRANS vmlinux.o.ltrans30.ltrans.o]
[Leaving LTRANS vmlinux.o.ltrans31.o]
[Leaving LTRANS vmlinux.o.ltrans31.ltrans.o]
/a/home/tbird/work/auto-reduce/sony-yocto/lto-build2/tmp/sysroots/x86_64-linux/usr/libexec/armv5te-sony-linux-gnueabi/gcc/arm-sony-linux-gnueabi/4.7.3/arm-sony-linux-gnueabi-ld: lto-wrapper failed
collect2: error: ld returned 1 exit status
make[1]: *** [vmlinux] Error 1
make: *** [sub-make] Error 2

Error: Bad result 512, running "make -j 8 KALLSYMS_EXTRA_PASS=1 bzImage": (output follows)
Error:
---------------------------------------------

The messages are repeated thousands of times (I'm guessing for every object
file after the first that included arch/arm/include/asm/unified.h)

Recognizing that LTO is currently incompatible with kprobes, and (so far)
finding that only kprobes appeared to use these macros, I did the following hack:

diff --git a/arch/arm/include/asm/unified.h b/arch/arm/include/asm/unified.h
index f5989f4..5179c13 100644
--- a/arch/arm/include/asm/unified.h
+++ b/arch/arm/include/asm/unified.h
@@ -92,6 +92,7 @@
 	.macro	iteee, cond
 	.endm
 #else	/* !__ASSEMBLY__ */
+#ifndef CONFIG_LTO
 __asm__(
 "	.macro	it, cond\n"
 "	.endm\n"
@@ -123,6 +124,7 @@ __asm__(
 "	.endm\n"
 "	.macro	iteee, cond\n"
 "	.endm\n");
+#endif  /* ! CONFIG_LTO */
 #endif	/* __ASSEMBLY__ */

 #endif	/* CONFIG_ARM_ASM_UNIFIED */

This the macros thus removed, I had no problems building the kernel
and running it on target.

While this works to remove the build error, it doesn't seem robust and I'd
like to either 1) find a better way to make these macro definitions conditional,
or 2) eliminate them completely.

The macros themselves seem empty.  Can someone tell me what they do?
What is the status of these macros?  Are they even needed?  Could they be
made conditional on something like NEED_IT_MACROS, and then have that set only
in the arch/arm/kernel/kprobes-test-thumb.c, before the unified.h is included?

I would like get this minor issue resolved in mainline, to make it easier for Andi
to get his LTO work upstream and have it work with ARM.

Any suggestions are welcome.

Thanks,
 -- Tim

P.S.  For anyone interested, here are some stats about LTO from
my testing on a kernel build for a pandaboard.  Note that I was
primarily interested in using LTO to reduce image size, for
this project.

vmlinux.non-lto  =>  vmlinux.lto
       baseline   other   change  percent
       --------   -----   ------  -------
 text:  5242000  4869340  -372660  -7%
 data:   490184   476200   -13984  -2%
  bss:   121824   122112      288   0%
total:  5854008  5467652  -386356  -6%

Kernel:                         non-lto         lto
---------------------------	-------		--------
time for full build:            1m5.87s         3m22s
time for incremental build:     0m5.24s         2m12s
kernel image size:              5854008         5467652
compressed uImage size:         2849920         2694224
system meminfo MemTotal:        17804 kB        18188 kB
system meminfo MemFree:         11020 kB        11260 kB
boot time:                      2.466369        2.414428

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

