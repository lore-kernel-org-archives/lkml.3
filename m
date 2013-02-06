Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751Ab3BFDHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 22:07:25 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:5144 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754322Ab3BFDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 22:07:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1432I4015Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
Date: Tue, 5 Feb 2013 21:04:36 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: "Woodhouse, David" <david.woodhouse@intel.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Message-ID: <20130205210436.670c62e26d2121330e87af35@freescale.com>
In-Reply-To: <1359703995.23531.6.camel@shinybook.infradead.org>
References: <20130128193033.8a0b0a871150c99247f05a95@freescale.com>
	<20130129083522.GA14302@pd.tnic>
	<1359478014.3529.157.camel@shinybook.infradead.org>
	<20130129174249.GB25415@pd.tnic>
	<1359482147.3529.161.camel@shinybook.infradead.org>
	<20130129181046.GC25415@pd.tnic>
	<1359541333.3529.186.camel@shinybook.infradead.org>
	<20130130200900.9d7cf7908caeaef4ecee1d61@freescale.com>
	<20130131092801.GV23505@n2100.arm.linux.org.uk>
	<20130131145947.f62474a0600848df86548b96@freescale.com>
	<20130201011712.GF23505@n2100.arm.linux.org.uk>
	<1359703995.23531.6.camel@shinybook.infradead.org>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013 07:33:17 +0000
"Woodhouse, David" <david.woodhouse@intel.com> wrote:

> On Fri, 2013-02-01 at 01:17 +0000, Russell King - ARM Linux wrote:
> > 
> > > I've tried both gcc 4.6.3 [1] and 4.6.4 [2].  If you can point me to
> > > a 4.5.x, I'll try that, too, but as it stands now, if one moves the
> > > code added to swab.h below outside of its armv6 protection,
> > > gcc adds calls to __bswapsi2.
> > 
> > Take a look at the message I sent on the 29th towards the beginning of
> > this thread for details of gcc 4.5.4 behaviour.
> 
> I'd like to see a comment (with PR# if appropriate) explaining clearly
> *why* it isn't enabled for <ARMv6 even with a bleeding-edge compiler.

ok I think I've figured it out: the difference in the defconfigs that
fail (at91_dt, at91sam9g45, and lpc32xx) is that they are ARM9's
(armv4/5), have CC_OPTIMIZE_FOR_SIZE set, and have code with
multiple swaps ready for space optimization: gcc -Os emits calls
to __bswapsi2 on those platforms to save space because they don't
have the single rev byte swap instruction.

> Russell's test also seemed to indicate that the 32-bit and 64-bit swap
> support was present and functional in GCC 4.5.4 (as indeed it should
> have been since 4.4), so I'm still not quite sure why you require 4.6
> for that.

initially it was based at looking at gcc commit history for the
'rev' instruction implementation, but now I've got 4.4, 4.5, 4.6 and
4.7 compilers to perform Russell's test:

$ for cc in 4.4 4.5 4.6 4.7; do \
    arm-linux-gnueabi-gcc-$cc --version | grep gcc ; \
    for a in armv3 armv4 armv4t armv5t armv5te armv6k armv6 armv7-a; do \
      echo -n $a:; \
      for f in 16 32 64; do \
         echo 'unsigned foo(unsigned val) { return __builtin_bswap'$f'(val); }' | arm-linux-gnueabi-gcc-$cc -w -x c -S -o - - -march=$a | grep 'bl'; \
      done; \
    done; \
done

whose output is:

arm-linux-gnueabi-gcc-4.4 (Ubuntu/Linaro 4.4.7-1ubuntu2) 4.4.7
armv3:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv4:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv4t:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv5t:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv5te:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv6k:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv6:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
armv7-a:   	bl	__builtin_bswap16
	bl	__bswapsi2
	bl	__bswapdi2
arm-linux-gnueabi-gcc-4.5 (Ubuntu/Linaro 4.5.3-12ubuntu2) 4.5.3
armv3:   	bl	__builtin_bswap16
armv4:   	bl	__builtin_bswap16
armv4t:   	bl	__builtin_bswap16
armv5t:   	bl	__builtin_bswap16
armv5te:   	bl	__builtin_bswap16
armv6k:   	bl	__builtin_bswap16
armv6:   	bl	__builtin_bswap16
armv7-a:   	bl	__builtin_bswap16
arm-linux-gnueabi-gcc-4.6 (Ubuntu/Linaro 4.6.3-8ubuntu1) 4.6.3 20120624 (prerelease)
armv3:   	bl	__builtin_bswap16
armv4:   	bl	__builtin_bswap16
armv4t:   	bl	__builtin_bswap16
armv5t:   	bl	__builtin_bswap16
armv5te:   	bl	__builtin_bswap16
armv6k:   	bl	__builtin_bswap16
armv6:   	bl	__builtin_bswap16
armv7-a:   	bl	__builtin_bswap16
arm-linux-gnueabi-gcc-4.7 (Ubuntu/Linaro 4.7.2-1ubuntu1) 4.7.2
armv3:   	bl	__builtin_bswap16
armv4:   	bl	__builtin_bswap16
armv4t:   	bl	__builtin_bswap16
armv5t:   	bl	__builtin_bswap16
armv5te:   	bl	__builtin_bswap16
armv6k:   	bl	__builtin_bswap16
armv6:   	bl	__builtin_bswap16
armv7-a:   	bl	__builtin_bswap16

So 4.4 should be exempt from using the built-ins because it always
emits __bswapsi2 calls: it doesn't matter whether or not -Os or -O2
are added as options in the test.

gcc 4.5, 4.6, and 4.7 all support 32 & 64-bit versions, so we
should check for gcc >= 4.5 instead of gcc >= 4.6.

I've added a new check for !CC_OPTIMIZE_FOR_SIZE and build-tested all
defconfigs with gcc 4.6.3 - here's v5:

>From 11aa942a84fe94d204424a19b6b13fdb2b359ee6 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Mon, 28 Jan 2013 19:30:33 -0600
Subject: [PATCH] arm: use built-in byte swap function

Enable the compiler intrinsic for byte swapping on arch ARM.  This
allows the compiler to detect and be able to optimize out byte
swappings.

__builtin_bswap{32,64} support was added in gcc 4.4, but until
gcc 4.5, it emitted calls to libgcc's __bswap[sd]i2 (even
with -O2).

All gcc versions tested (4.[4567]) emit calls to __bswap[sd]i2 when
optimizing for size, so we add the !CC_OPTIMIZE_FOR_SIZE check.

Support for 16-bit built-ins will be in gcc version 4.8.

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

v5: re-work based on new gcc version test data:
  - moved outside armv6 protection
  - check for gcc 4.6+ demoted to gcc 4.5+ with:
    !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE)

v4:
- undo v2-2's addition of ARCH_DEFINES_BUILTIN_BSWAP per Boris
  and David - object is to find arches that define _HAVE_BSWAP
  and clean it up in the future: patch is much less intrusive. :)

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

 arch/arm/include/asm/swab.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index 537fc9b..159ab16 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -35,4 +35,13 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
 #define __arch_swab32 __arch_swab32
 
 #endif
+
+#if !defined(CONFIG_CC_OPTIMIZE_FOR_SIZE) && GCC_VERSION >= 40500
+#define __HAVE_BUILTIN_BSWAP32__
+#define __HAVE_BUILTIN_BSWAP64__
+#if GCC_VERSION >= 40800
+#define __HAVE_BUILTIN_BSWAP16__
+#endif
+#endif
+
 #endif
-- 
1.7.9.7

Thanks,

Kim

[1] http://gcc.gnu.org/bugzilla/show_bug.cgi?id=44392
[2] http://gcc.gnu.org/onlinedocs/gcc/Other-Builtins.html#Other-Builtins

