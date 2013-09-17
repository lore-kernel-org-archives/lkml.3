Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3IQMnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:43:53 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52429 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3IQMnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:43:51 -0400
From: Russ Dill <Russ.Dill@ti.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        mans@mansr.com, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [RFC PATCH 00/11] Embeddable Position Independent Executable
Date: Tue, 17 Sep 2013 05:43:26 -0700
Message-Id: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for and demonstrates the usage of an embedded
position independent executable (PIE). The goal is to allow the use of C
code in situations where carefully written position independent assembly
was previously required.

The example used is the suspend/resume code for the am335x, a Texas
Instruments ARM SoC. In order to save the maximum amount of power during
suspend, the am335x has to perform several power saving operations after
SDRAM has been disabled, and undo those steps at resume time. The am335x
provides an SRAM region for the processor to execute such code.

A PIE executable was chosen because it limits the types of relocations
that must be performed before the code is executed. In the case of ARM,
the only required relocation type is a relative relocation of pointers.

The kernel is provided symbols into the PIE executable by way of exporting
those symbols from the PIE and then importing them into vmlinux at final
link time. Because the PIE is loaded dynamically at runtime, any access
to PIE functions or data must pass through special accessor macros that
apply the necessary offset. Code within the PIE does not have access to
symbols outside of the PIE, but it still can access code and data outside
the PIE so long as it is passed pointers to that code/data.

The PIE executable is provided its own set of functions required by gcc,
such as memcpy, memmove, etc. The different PIE sections are collected
together in the linker script as an overlay so that the kernel only needs
one copy of these functions. When the PIE is loaded, the library functions
and appropriate sections are copied into a genalloc pool (in the case of
the example, backed by SRAM). The PIE code then applies the necessary
relocations to the loaded code. Because the relocations are just relative
offsets to pointers, the relocations can be reapplied to allow the code
to run with the MMU enabled or disabled.

This patchset is a complete rethinking of an earlier patchset [1]. Ard
Biesheuvel provided the suggestion to use the PIE executable format for
storing the relocatable code within the kernel. Russell King and Dave
Martin pointed out the shortcomings of my initial naive approach.

This patchset depends on Rajendra Nayak's SRAM DT-ification patch series
[2], Suman Anna's am335x mailbox series [3], and a portion of Dave
Gerlach's am335x suspend/resume patchset [4]. I've collected together
the necessary dependances and applied this patch series on top of them
here [5].

Because special ioremap variants are required on ARM for io mappings
that allow code execution, the first two patches provide generic
accessors for those variants. The third patch provides a DT and pdata
method for instructing misc/sram to map the memory in such a way that
allows code execution.

The 4th patch provides a generic set of functions for handling function
pointers as addresses and vice versa. This is necessary on ARM because
of the way that Thumb2 function pointers are handled by gcc. The PIE
framework requires this functionality because it performs translations
of function pointers.

The 5th patch is the general PIE framework. The 6th patch is the addition
of ARM support for PIE. The 7th patch provides the ability of ARM to
fixup PIE code on the fly. This is necessary since at suspend time the
MMU will be working, but at resume time, it will be off. The 8th patch
provides a predefined trampoline that utilizes the on the fly fixup.

The 9th patch configures the SRAM DT entries for am335x so that they can
be easily found by the PM code, and so that they are mapped with exec
enabled. The 10th patch adds PIE entries for am335x, and the 11th patch
finally adds suspend/resume support for am33xx utilizing C code for
suspend/resume paths.

[1] http://www.spinics.net/lists/arm-kernel/msg271525.html
[2] http://comments.gmane.org/gmane.linux.ports.arm.omap/103774
[3] http://www.spinics.net/lists/devicetree/msg00227.html
[4] http://www.spinics.net/lists/linux-omap/msg95305.html
[5] https://github.com/russdill/linux/commits/sram

Russ Dill (10):
  asm-generic: io: Add exec versions of ioremap
  lib: devres: Add exec versions of devm_ioremap_resource and friends
  misc: SRAM: Add option to map SRAM to allow code execution
  asm-generic: fncpy: Add function copying macros
  PIE: Support embedding position independent executables
  ARM: PIE: Add position independent executable embedding to ARM
  ARM: PIE: Add support for updating PIE relocations
  ARM: PIE: Add macro for generating PIE resume trampoline
  ARM: dts: AM33XX: Associate SRAM with MPU and mark it exec
  ARM: OMAP2+: AM33XX: Add PIE support for AM33XX

Vaibhav Bedia (1):
  ARM: OMAP2+: AM33XX: Basic suspend resume support

 Documentation/devicetree/bindings/misc/sram.txt |   4 +
 Documentation/pie.txt                           | 167 ++++++++
 Makefile                                        |  17 +-
 arch/alpha/include/asm/fncpy.h                  |   1 +
 arch/arc/include/asm/fncpy.h                    |   1 +
 arch/arm/Kconfig                                |   1 +
 arch/arm/Makefile                               |   5 +
 arch/arm/boot/dts/am33xx.dtsi                   |   2 +
 arch/arm/configs/omap2plus_defconfig            |   1 +
 arch/arm/include/asm/elf.h                      |   1 +
 arch/arm/include/asm/fncpy.h                    |  76 +---
 arch/arm/include/asm/io.h                       |   2 +
 arch/arm/include/asm/pie.h                      |  42 ++
 arch/arm/include/asm/suspend.h                  |  25 ++
 arch/arm/kernel/.gitignore                      |   1 +
 arch/arm/kernel/Makefile                        |   4 +-
 arch/arm/kernel/pie.c                           |  92 +++++
 arch/arm/kernel/pie.lds.S                       |  41 ++
 arch/arm/kernel/vmlinux.lds.S                   |   2 +
 arch/arm/libpie/.gitignore                      |   3 +
 arch/arm/libpie/Makefile                        |  32 ++
 arch/arm/libpie/empty.S                         |  12 +
 arch/arm/libpie/relocate.S                      |  76 ++++
 arch/arm/mach-omap2/Kconfig                     |   7 +-
 arch/arm/mach-omap2/Makefile                    |   2 +
 arch/arm/mach-omap2/board-generic.c             |   1 +
 arch/arm/mach-omap2/common.h                    |  10 +
 arch/arm/mach-omap2/io.c                        |   5 +
 arch/arm/mach-omap2/pm.c                        |   3 +-
 arch/arm/mach-omap2/pm33xx.c                    | 486 ++++++++++++++++++++++++
 arch/arm/mach-omap2/pm33xx.h                    |  68 ++++
 arch/arm/mach-omap2/sleep33xx.c                 | 314 +++++++++++++++
 arch/arm/mach-omap2/wkup_m3.c                   | 183 +++++++++
 arch/arm/plat-omap/sram.c                       |   2 +-
 arch/arm64/include/asm/fncpy.h                  |   1 +
 arch/avr32/include/asm/fncpy.h                  |   1 +
 arch/blackfin/include/asm/fncpy.h               |   1 +
 arch/c6x/include/asm/fncpy.h                    |   1 +
 arch/cris/include/asm/fncpy.h                   |   1 +
 arch/frv/include/asm/fncpy.h                    |   1 +
 arch/h8300/include/asm/fncpy.h                  |   1 +
 arch/hexagon/include/asm/fncpy.h                |   1 +
 arch/ia64/include/asm/fncpy.h                   |   1 +
 arch/m32r/include/asm/fncpy.h                   |   1 +
 arch/m68k/include/asm/fncpy.h                   |   1 +
 arch/metag/include/asm/fncpy.h                  |   1 +
 arch/microblaze/include/asm/fncpy.h             |   1 +
 arch/mips/include/asm/fncpy.h                   |   1 +
 arch/mn10300/include/asm/fncpy.h                |   1 +
 arch/openrisc/include/asm/fncpy.h               |   1 +
 arch/parisc/include/asm/fncpy.h                 |   1 +
 arch/powerpc/include/asm/fncpy.h                |   1 +
 arch/s390/include/asm/fncpy.h                   |   1 +
 arch/score/include/asm/fncpy.h                  |   1 +
 arch/sh/include/asm/fncpy.h                     |   1 +
 arch/sparc/include/asm/fncpy.h                  |   1 +
 arch/tile/include/asm/fncpy.h                   |   1 +
 arch/um/include/asm/fncpy.h                     |   1 +
 arch/unicore32/include/asm/fncpy.h              |   1 +
 arch/x86/include/asm/fncpy.h                    |   1 +
 arch/xtensa/include/asm/fncpy.h                 |   1 +
 drivers/misc/sram.c                             |  13 +-
 include/asm-generic/fncpy.h                     | 104 +++++
 include/asm-generic/iomap.h                     |   5 +
 include/asm-generic/pie.lds.h                   |  82 ++++
 include/asm-generic/vmlinux.lds.h               |   1 +
 include/linux/device.h                          |  17 +-
 include/linux/io.h                              |   4 +
 include/linux/pie.h                             | 196 ++++++++++
 include/linux/platform_data/sram.h              |   8 +
 lib/Kconfig                                     |  14 +
 lib/Makefile                                    |   2 +
 lib/devres.c                                    |  97 ++++-
 lib/pie.c                                       | 138 +++++++
 pie/.gitignore                                  |   3 +
 pie/Makefile                                    |  85 +++++
 scripts/link-vmlinux.sh                         |  11 +-
 77 files changed, 2425 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/pie.txt
 create mode 100644 arch/alpha/include/asm/fncpy.h
 create mode 100644 arch/arc/include/asm/fncpy.h
 create mode 100644 arch/arm/include/asm/pie.h
 create mode 100644 arch/arm/kernel/pie.c
 create mode 100644 arch/arm/kernel/pie.lds.S
 create mode 100644 arch/arm/libpie/.gitignore
 create mode 100644 arch/arm/libpie/Makefile
 create mode 100644 arch/arm/libpie/empty.S
 create mode 100644 arch/arm/libpie/relocate.S
 create mode 100644 arch/arm/mach-omap2/pm33xx.c
 create mode 100644 arch/arm/mach-omap2/pm33xx.h
 create mode 100644 arch/arm/mach-omap2/sleep33xx.c
 create mode 100644 arch/arm/mach-omap2/wkup_m3.c
 create mode 100644 arch/arm64/include/asm/fncpy.h
 create mode 100644 arch/avr32/include/asm/fncpy.h
 create mode 100644 arch/blackfin/include/asm/fncpy.h
 create mode 100644 arch/c6x/include/asm/fncpy.h
 create mode 100644 arch/cris/include/asm/fncpy.h
 create mode 100644 arch/frv/include/asm/fncpy.h
 create mode 100644 arch/h8300/include/asm/fncpy.h
 create mode 100644 arch/hexagon/include/asm/fncpy.h
 create mode 100644 arch/ia64/include/asm/fncpy.h
 create mode 100644 arch/m32r/include/asm/fncpy.h
 create mode 100644 arch/m68k/include/asm/fncpy.h
 create mode 100644 arch/metag/include/asm/fncpy.h
 create mode 100644 arch/microblaze/include/asm/fncpy.h
 create mode 100644 arch/mips/include/asm/fncpy.h
 create mode 100644 arch/mn10300/include/asm/fncpy.h
 create mode 100644 arch/openrisc/include/asm/fncpy.h
 create mode 100644 arch/parisc/include/asm/fncpy.h
 create mode 100644 arch/powerpc/include/asm/fncpy.h
 create mode 100644 arch/s390/include/asm/fncpy.h
 create mode 100644 arch/score/include/asm/fncpy.h
 create mode 100644 arch/sh/include/asm/fncpy.h
 create mode 100644 arch/sparc/include/asm/fncpy.h
 create mode 100644 arch/tile/include/asm/fncpy.h
 create mode 100644 arch/um/include/asm/fncpy.h
 create mode 100644 arch/unicore32/include/asm/fncpy.h
 create mode 100644 arch/x86/include/asm/fncpy.h
 create mode 100644 arch/xtensa/include/asm/fncpy.h
 create mode 100644 include/asm-generic/fncpy.h
 create mode 100644 include/asm-generic/pie.lds.h
 create mode 100644 include/linux/pie.h
 create mode 100644 include/linux/platform_data/sram.h
 create mode 100644 lib/pie.c
 create mode 100644 pie/.gitignore
 create mode 100644 pie/Makefile

-- 
1.8.3.2

