Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3AaVCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:02:52 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:12017
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab3AaVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:02:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz177df4h17326ah8275bh8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
Date: Thu, 31 Jan 2013 14:59:47 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
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
Message-ID: <20130131145947.f62474a0600848df86548b96@freescale.com>
In-Reply-To: <20130131092801.GV23505@n2100.arm.linux.org.uk>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
	<20130129083522.GA14302@pd.tnic>
	<1359478014.3529.157.camel@shinybook.infradead.org>
	<20130129174249.GB25415@pd.tnic>
	<1359482147.3529.161.camel@shinybook.infradead.org>
	<20130129181046.GC25415@pd.tnic>
	<1359541333.3529.186.camel@shinybook.infradead.org>
	<20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
	<20130131092801.GV23505@n2100.arm.linux.org.uk>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 09:28:01 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Jan 30, 2013 at 08:09:00PM -0600, Kim Phillips wrote:
> > The savings come mostly from device-tree related code, and some
> > from drivers.
> 
> You forget that IP networking is all big endian, so these will be using
> the byte swapping too (search it for htons/ntohs/htonl/ntohl).

As David mentioned, there isn't much gain from net/ code.

> > v2:
> > - at91 and lpd270 builds fixed by limiting to ARMv6 and above
> >   (i.e., ARM cores that have support for the 'rev' instruction).
> >   Otherwise, the compiler emits calls to libgcc's __bswapsi2 on
> >   these ARMv4/v5 builds (and arch ARM doesn't link with libgcc).
> 
> Which compiler version?  gcc 4.5.4 doesn't do this, except for the 16-bit
> swap, so I doubt that any later compiler does.

I've tried both gcc 4.6.3 [1] and 4.6.4 [2].  If you can point me to
a 4.5.x, I'll try that, too, but as it stands now, if one moves the
code added to swab.h below outside of its armv6 protection,
gcc adds calls to __bswapsi2.

> > --- a/arch/arm/include/uapi/asm/swab.h
> > +++ b/arch/arm/include/uapi/asm/swab.h
> > @@ -50,4 +50,14 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
> >  
> >  #endif
> >  
> > +#if defined(__KERNEL__) && __LINUX_ARM_ARCH__ >= 6
> > +#if GCC_VERSION >= 40600
> > +#define __HAVE_BUILTIN_BSWAP32__
> > +#define __HAVE_BUILTIN_BSWAP64__
> > +#endif
> > +#if GCC_VERSION >= 40800
> > +#define __HAVE_BUILTIN_BSWAP16__
> > +#endif
> > +#endif
> 
> If this is __KERNEL__ only, it should not be in a uapi header.  UAPI
> headers get exported to userland, this is not userland interface code.
> IT should be in arch/arm/include/asm/swab.h

right, I've fixed this and Boris' remove the help text comment, and
made a v3:

>From 18c86580efba42d2680f2947867722705292f80a Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Mon, 28 Jan 2013 19:30:33 -0600
Subject: [PATCH] arm: use built-in byte swap function

Enable the compiler intrinsic for byte swapping on arch ARM.  This
allows the compiler to detect and be able to optimize out byte
swappings, e.g. in big endian to big endian moves.

A ARCH_DEFINES_BUILTIN_BSWAP is added to allow an ARCH to select
it when it wants to control HAVE_BUILTIN_BSWAPxx definitions over
those in the generic compiler headers.  It can be dependent on a
combination of byte swapping instruction availability, the
instruction set version, and the state of support in different
compiler versions.

AFAICT, arm gcc got __builtin_bswap{32,64} support in 4.6,
and for the 16-bit version in 4.8.

This has a tiny benefit on vmlinux text size (gcc 4.6.4):

multi_v7_defconfig:
   text    data     bss     dec     hex filename
3135208  188396  203344 3526948  35d124 vmlinux
multi_v7_defconfig with builtin_bswap:
   text    data     bss     dec     hex filename
3135112  188396  203344 3526852  35d0c4 vmlinux

exynos_defconfig:
   text    data     bss     dec     hex filename
4286605  360564  223172 4870341  4a50c5 vmlinux
exynos_defconfig with builtin_bswap:
   text    data     bss     dec     hex filename
4286405  360564  223172 4870141  4a4ffd vmlinux

The savings come mostly from device-tree related code, and some
from drivers.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
akin to: http://comments.gmane.org/gmane.linux.kernel.cross-arch/16016

based on linux-next-20130128.  Depends on commit "compiler-gcc{3,4}.h:
Use GCC_VERSION macro" by Daniel Santos <daniel.santos@pobox.com>,
currently in the akpm branch.

v3:
- moved out of uapi swab.h into arch/arm/include/asm/swab.h
- moved ARCH_DEFINES_BUILTIN_BSWAP help text into commit message
- moved GCC_VERSION >= 40800 ifdef into GCC_VERSION >= 40600 block

v2:
- at91 and lpd270 builds fixed by limiting to ARMv6 and above
  (i.e., ARM cores that have support for the 'rev' instruction).
  Otherwise, the compiler emits calls to libgcc's __bswapsi2 on
  these ARMv4/v5 builds (and arch ARM doesn't link with libgcc).
  All ARM defconfigs now have the same build status as they did
  without this patch (some are broken on linux-next).

- move ARM check from generic compiler.h to arch ARM's swab.h.
  - pretty sure it should be limited to __KERNEL__ builds

- add new ARCH_DEFINES_BUILTIN_BSWAP (see Kconfig help).
  - if set, generic compiler header does not set HAVE_BUILTIN_BSWAPxx
  - not too sure about this having to be a new CONFIG_, but it's hard
    to find a place for it given linux/compiler.h doesn't include any
    arch-specific files.

- move new selects to end of CONFIG_ARM's Kconfig select list,
  as is done in David Woodhouse's original patchseries for ppc/x86.

 arch/Kconfig                  |    4 ++++
 arch/arm/Kconfig              |    2 ++
 arch/arm/include/asm/swab.h   |    8 ++++++++
 include/linux/compiler-gcc4.h |    3 ++-
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 40e2b12..bc5ed77 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -141,6 +141,10 @@ config ARCH_USE_BUILTIN_BSWAP
 	 instructions should set this. And it shouldn't hurt to set it
 	 on architectures that don't have such instructions.
 
+config ARCH_DEFINES_BUILTIN_BSWAP
+       depends on ARCH_USE_BUILTIN_BSWAP
+       bool
+
 config HAVE_SYSCALL_WRAPPERS
 	bool
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 73027aa..b5868c2 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -57,6 +57,8 @@ config ARM
 	select CLONE_BACKWARDS
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
+	select ARCH_USE_BUILTIN_BSWAP
+	select ARCH_DEFINES_BUILTIN_BSWAP
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index 537fc9b..e56acff 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -34,5 +34,13 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 }
 #define __arch_swab32 __arch_swab32
 
+#if GCC_VERSION >= 40600
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#if GCC_VERSION >= 40800
+#define __HAVE_BUILTIN_BSWAP16__
+#endif
+#endif
+
 #endif
 #endif
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 68b162d..fce39cb 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -66,7 +66,8 @@
 #endif
 
 
-#ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
+#if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP) && \
+    !defined(CONFIG_ARCH_DEFINES_BUILTIN_BSWAP)
 #if GCC_VERSION >= 40400
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
-- 
1.7.9.7

Thanks,

Kim

[1] http://kernel.org/pub/tools/crosstool/files/bin/x86_64/

[2] http://ftp.denx.de/pub/eldk/5.2.1/targets/armv7a/

