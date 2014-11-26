Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaKZN5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:57:45 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:46737 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaKZN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:57:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141126005710.GE22670@titan.lakedaemon.net>
References: <CACRpkdYmJWy1_vs0tWRA7SvkQnvbXXKqf7pHpH5b5tZ6vR+KJg@mail.gmail.com>
	<1414961549-31666-1-git-send-email-jason@lakedaemon.net>
	<5474F78F.2060906@suse.cz>
	<20141125235150.GH3836@n2100.arm.linux.org.uk>
	<20141126005710.GE22670@titan.lakedaemon.net>
Date: Wed, 26 Nov 2014 14:57:42 +0100
Message-ID: <CACRpkdZJoWbQeuZ4ZXGbQr0+SNG_9ZA+cQkAA0C2F9rnZDYtyQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: kbuild: Fix forced rebuild after 'make dtbs'
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 1:57 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Tue, Nov 25, 2014 at 11:51:50PM +0000, Russell King - ARM Linux wrote:

>> I think this needs a bit more debugging to see why the whole kernel is
>> being rebuilt - the kernel build system has methods to tell you why stuff
>> is being built, which would be a good place to start.
>
> Linus, since you were the one experiencing the regression, care to take
> a whack at that?

OK this full example should be possible to repeat for anyone
with a cross compiler, and uses a separate build dir, and yeah
there was something fishy: the bug only appears if you specify
CONFIG_DEBUG_SECTION_MISMATCH=y:

make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 u300_defconfig
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage

-> no rebuild, just relink

make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 u300_defconfig
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y

-> no rebuild, just relink

make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 u300_defconfig
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 dtbs
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage

-> no rebuild, just relink

make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 u300_defconfig
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 dtbs
make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y

-> Rebuilds everything.

This doesn't occur before the offending commit. So it only happens
when specifying extra
environment variables on the command line.

So I can get rid of the rebuilding by making my scripts less
strict by removing CONFIG_DEBUG_SECTION_MISMATCH=y.

But is this really correct?

Two last examples with more detail:

make[1]: Entering directory `/home/linus/linux/build-u300'
  CHK     include/config/kernel.release
  GEN     ./Makefile
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  Using .. as source for kernel
make[2]: `include/generated/mach-types.h' is up to date.
  CALL    ../scripts/checksyscalls.sh - due to target missing
  CHK     include/generated/compile.h
  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready
make[1]: Leaving directory `/home/linus/linux/build-u300'

make -f Makefile -j5 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
KBUILD_OUTPUT=build-u300 zImage CONFIG_DEBUG_SECTION_MISMATCH=y V=2

make[1]: Entering directory `/home/linus/linux/build-u300'
  CHK     include/config/kernel.release
  GEN     ./Makefile
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  Using .. as source for kernel
  CC      scripts/mod/empty.o - due to command line change
  CC      scripts/mod/devicetable-offsets.s - due to command line change
  MKELF   scripts/mod/elfconfig.h - due to: scripts/mod/empty.o
  HOSTCC  scripts/mod/modpost.o - due to: scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/sumversion.o - due to: scripts/mod/elfconfig.h
  GEN     scripts/mod/devicetable-offsets.h - due to:
scripts/mod/devicetable-offsets.s
  HOSTCC  scripts/mod/file2alias.o - due to: scripts/mod/elfconfig.h
scripts/mod/devicetable-offsets.h
  HOSTLD  scripts/mod/modpost - due to: scripts/mod/modpost.o
scripts/mod/file2alias.o scripts/mod/sumversion.o
make[2]: `include/generated/mach-types.h' is up to date.
  CC      kernel/bounds.s - due to command line change
  GEN     include/generated/bounds.h - due to: kernel/bounds.s
  CC      arch/arm/kernel/asm-offsets.s - due to: include/generated/bounds.h
  GEN     include/generated/asm-offsets.h - due to:
arch/arm/kernel/asm-offsets.s
  CALL    ../scripts/checksyscalls.sh - due to target missing
  CC      init/main.o - due to: include/generated/bounds.h
  CC      arch/arm/common/firmware.o - due to: include/generated/bounds.h
  CC      arch/arm/mm/dma-mapping.o - due to: include/generated/bounds.h
  CC      arch/arm/kernel/elf.o - due to: include/generated/bounds.h
  CC      arch/arm/mach-u300/core.o - due to: include/generated/bounds.h
  AS      arch/arm/kernel/entry-common.o - due to:
include/generated/asm-offsets.h
  LD      arch/arm/common/built-in.o - due to: arch/arm/common/firmware.o
  CHK     include/generated/compile.h
  CC      arch/arm/kernel/irq.o - due to: include/generated/bounds.h
  CC      arch/arm/mach-u300/dummyspichip.o - due to: include/generated/bounds.h
  CC      init/do_mounts.o - due to: include/generated/bounds.h
  CC      arch/arm/mm/extable.o - due to: include/generated/bounds.h
  CC      arch/arm/kernel/opcodes.o - due to: include/generated/bounds.h
(...)

If I revert commit f4d4ffc03efc:

make[1]: Entering directory `/home/linus/linux/build-u300'
  CHK     include/config/kernel.release
  GEN     ./Makefile
  CHK     include/generated/uapi/linux/version.h
  Using .. as source for kernel
  CHK     include/generated/utsrelease.h
make[2]: `include/generated/mach-types.h' is up to date.
  CC      scripts/mod/empty.o - due to command line change
  CC      scripts/mod/devicetable-offsets.s - due to command line change
  CALL    ../scripts/checksyscalls.sh - due to target missing
  MKELF   scripts/mod/elfconfig.h - due to: scripts/mod/empty.o
  HOSTCC  scripts/mod/modpost.o - due to: scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/sumversion.o - due to: scripts/mod/elfconfig.h
  GEN     scripts/mod/devicetable-offsets.h - due to:
scripts/mod/devicetable-offsets.s
  HOSTCC  scripts/mod/file2alias.o - due to: scripts/mod/elfconfig.h
scripts/mod/devicetable-offsets.h
  HOSTLD  scripts/mod/modpost - due to: scripts/mod/modpost.o
scripts/mod/file2alias.o scripts/mod/sumversion.o
  CHK     include/generated/compile.h
  Kernel: arch/arm/boot/Image is ready
  Kernel: arch/arm/boot/zImage is ready
make[1]: Leaving directory `/home/linus/linux/build-u300'

So in both cases a changed command line is detected and
empty.o and devicetable-offsets.s is rebuilt.

But after the commit the rebuild goes on to rebuild
kernel/bounds.s which generates bounds.h which in
turn rebuilds the whole world.

I don't know why the behaviour changed like this :(

Yours,
Linus Walleij
