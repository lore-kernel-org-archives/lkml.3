Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab3AaCLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 21:11:45 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:28602
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751365Ab3AaCLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 21:11:42 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h1155h)
Date: Wed, 30 Jan 2013 20:09:00 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Rientjes <rientjes@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [RFC] arm: use built-in byte swap function
Message-ID: <20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
In-Reply-To: <1359541333.3529.186.camel@shinybook.infradead.org>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
	<20130129083522.GA14302@pd.tnic>
	<1359478014.3529.157.camel@shinybook.infradead.org>
	<20130129174249.GB25415@pd.tnic>
	<1359482147.3529.161.camel@shinybook.infradead.org>
	<20130129181046.GC25415@pd.tnic>
	<1359541333.3529.186.camel@shinybook.infradead.org>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013 10:22:15 +0000
"Woodhouse, David" <david.woodhouse@intel.com> wrote:

> On Tue, 2013-01-29 at 19:10 +0100, Borislav Petkov wrote:
> > So, IMHO it sounds to me like we want to explicitly state for each arch
> > separately that it is ok to use the __builtin_bswapXX things. This also
> > takes care of the case where the compiler is doing something suboptimal
> > by excluding the affected versions.
> 
> Well, if it really does end up being different for every architecture,
> then that means I probably made the wrong decision when I chose to make
> it "generic", and override the __arch_swabXX() macros. I could have just
> pushed all the architectures to use the builtins in their __arch_swabXX
> macros instead, as appropriate.
> 
> Let's see how many special cases we actually end up with, and perhaps
> we'll end up switching that round. For now, let's just make ARM set
> __HAVE_BUILTIN_BSWAPxx__ for the appropriate sizes in <asm/swab.h>,
> according to whatever criteria it needs.

thanks - I've attempted to do this - see v2 patch below.

> It's not entirely clear how much of a win it is on ARM anyway; we don't
> have load-and-swap or store-and-swap instructions so there are only a
> few added opportunities for optimisation that we get by letting the
> compiler see what's going on.

I've added some text size figures to the patch description.  
They are indeed very small, but it should help drivers for
big-endian devices.

>From 31df859be202f00d017b707649e7709281994d15 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Mon, 28 Jan 2013 19:30:33 -0600
Subject: [PATCH] arm: use built-in byte swap function

Enable the compiler intrinsic for byte swapping on arch ARM.  This
allows the compiler to detect and be able to optimize out byte
swappings, e.g. in big endian to big endian moves.

AFAICT, arm gcc got __builtin_bswap{32,64} support in 4.6,
and for the 16-bit version in 4.8.

This has a tiny benefit on vmlinux text size:

multi_v7_defconfig:
   text    data     bss     dec     hex filename
3135208  188396  203344 3526948  35d124 vmlinux
multi_v7_defconfig with builtin_bswap:
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

 arch/Kconfig                     |   10 ++++++++++
 arch/arm/Kconfig                 |    2 ++
 arch/arm/include/uapi/asm/swab.h |   10 ++++++++++
 include/linux/compiler-gcc4.h    |    3 ++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 40e2b12..c8798b9 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -141,6 +141,16 @@ config ARCH_USE_BUILTIN_BSWAP
 	 instructions should set this. And it shouldn't hurt to set it
 	 on architectures that don't have such instructions.
 
+config ARCH_DEFINES_BUILTIN_BSWAP
+       depends on ARCH_USE_BUILTIN_BSWAP
+       bool
+       help
+	 ARCH selects this when it wants to control HAVE_BUILTIN_BSWAPxx
+	 definitions over those in the generic compiler headers.  It
+	 can be dependent on a combination of byte swapping instruction
+	 availability, the instruction set version, and the state
+	 of support in different compiler versions.
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
diff --git a/arch/arm/include/uapi/asm/swab.h b/arch/arm/include/uapi/asm/swab.h
index 6fcb32a..5d86ed0 100644
--- a/arch/arm/include/uapi/asm/swab.h
+++ b/arch/arm/include/uapi/asm/swab.h
@@ -50,4 +50,14 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 
 #endif
 
+#if defined(__KERNEL__) && __LINUX_ARM_ARCH__ >= 6
+#if GCC_VERSION >= 40600
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#endif
+#if GCC_VERSION >= 40800
+#define __HAVE_BUILTIN_BSWAP16__
+#endif
+#endif
+
 #endif /* _UAPI__ASM_ARM_SWAB_H */
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


