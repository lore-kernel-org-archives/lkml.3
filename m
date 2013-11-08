Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3KHSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:09:59 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53882 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757371Ab3KHSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:09:56 -0500
Date: Fri, 8 Nov 2013 18:09:06 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Russ Dill <Russ.Dill@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, mans@mansr.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kbuild@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [RFC PATCH 00/11] Embeddable Position Independent Executable
Message-ID: <20131108180905.GC2602@localhost.localdomain>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 05:43:26AM -0700, Russ Dill wrote:
> This patch adds support for and demonstrates the usage of an embedded
> position independent executable (PIE). The goal is to allow the use of C
> code in situations where carefully written position independent assembly
> was previously required.
> 
> The example used is the suspend/resume code for the am335x, a Texas
> Instruments ARM SoC. In order to save the maximum amount of power during
> suspend, the am335x has to perform several power saving operations after
> SDRAM has been disabled, and undo those steps at resume time. The am335x
> provides an SRAM region for the processor to execute such code.
> 
> A PIE executable was chosen because it limits the types of relocations
> that must be performed before the code is executed. In the case of ARM,
> the only required relocation type is a relative relocation of pointers.


I meant to review this series ages ago -- so, apologies for the delay.

Overall, this looks like a pretty nice framework to have, and a fair
amount of effort has clearly been put into it.

However, if this is to be a general framework I think it would be good
to step back a bit, to understand how well the framework fits, and how
much needs to be invented.


Some points that occur to me are as follows -- it would be good to get
some discussion of these.



  * Assuming the same definitions of libpie functions work in all PIE
    scenarios may be unsafe.

    For example, because ARM's lib1funcs are only used after the MMU is
    turned on, there is no reason for code in there not to rely on this.
    The string functions could assume that unaligned accesses will not
    fault, for example. (I don't know if this is true -- but it's a risk.)

    We also need to watch out for position-dependence creeping in if
    we import code from the main kernel.  I'm assuming that can mostly
    be detected at link-time, though.


  * Pasting the same libpie into every PIE will tend to waste space.

    Particularly in multiplatform kernels, each PIE my only want
    a small subset of the libpie content.

    Using prewritten code like lib1funcs in libpie may also suffer
    directly from large code size, because these implementations are all
    optimised for speed: for example, arch/arm's memset is pretty
    unrolled, many times larger, and probably not that much faster than
    a simple hand-written alternative that may run with the MMU off
    anyway.


  * The kernel already has a static relocator for every arch, in the
    module loader.  Do we need another one?

    If we compile and link PIEs statically instead, that may be both
    more efficient and more compact (particularly with tricks like
    -ffunction-sections -fdata-sections -Wl,--gc-sections etc.)  Modules
    are statically linked, so the module loader should implement nearly
    all of the necessary heavy lifting already.

    Just-in-time relocation doesn't work well with this approach, since
    the relocations become a lot more complex, but if the relocation can
    all be done ahead of time it should work well.

    I suspect that it may be possible to shrink the am33xx PIE code
    enough using these approaches that we could simply fix up two copies
    of it in the SRAM: one for MMU-on and one for MMU-off.  Since those
    two situations involve different code paths, it might also be
    possible to discard some extra code from each, but I've not
    investigated.  Maybe I'm too optimistic.


  * Repeatedly relocating single a PIE between two address spaces is
    only going to be feasible / necessary in certain situations, so we
    shouldn't assume that all PIEs are going to work this way.

    If the affected code needs to run in an SMP environment, it may be
    better to fix up the same PIE twice instead, one for each address
    space -- otherwise you would need locking which would introduce
    unnecessary inefficiency.

    This probably doesn't apply to the OMAP-like case where the DRAM
    is being configured (there had better not be other CPUs running
    anyway) -- but could apply to plenty of other scenarios connected
    with low-level suepend/resume code on recent platforms.


  * We should try to avoid having to maintain lists of things in a file
    somewhere, because that leads to merge headaches.

    Instead of hacking linker scripts to describe every PIE, would it be
    better to have a common build rule for embedding PIEs which just
    wraps the PIE data in a .o file with appropriate symbols, section
    annotations, and table entries as appropriate?  The global linker
    script just needs to slurp those sections somewhere appropriate.

    If each PIE is a blob of data, we should be able to link PIEs
    into modules just as easily as linking them into vmlinux, which
    might be valuable in the future for large multiplatform kernels.


Cheers
---Dave
   

> 
> The kernel is provided symbols into the PIE executable by way of exporting
> those symbols from the PIE and then importing them into vmlinux at final
> link time. Because the PIE is loaded dynamically at runtime, any access
> to PIE functions or data must pass through special accessor macros that
> apply the necessary offset. Code within the PIE does not have access to
> symbols outside of the PIE, but it still can access code and data outside
> the PIE so long as it is passed pointers to that code/data.
> 
> The PIE executable is provided its own set of functions required by gcc,
> such as memcpy, memmove, etc. The different PIE sections are collected
> together in the linker script as an overlay so that the kernel only needs
> one copy of these functions. When the PIE is loaded, the library functions
> and appropriate sections are copied into a genalloc pool (in the case of
> the example, backed by SRAM). The PIE code then applies the necessary
> relocations to the loaded code. Because the relocations are just relative
> offsets to pointers, the relocations can be reapplied to allow the code
> to run with the MMU enabled or disabled.
> 
> This patchset is a complete rethinking of an earlier patchset [1]. Ard
> Biesheuvel provided the suggestion to use the PIE executable format for
> storing the relocatable code within the kernel. Russell King and Dave
> Martin pointed out the shortcomings of my initial naive approach.
> 
> This patchset depends on Rajendra Nayak's SRAM DT-ification patch series
> [2], Suman Anna's am335x mailbox series [3], and a portion of Dave
> Gerlach's am335x suspend/resume patchset [4]. I've collected together
> the necessary dependances and applied this patch series on top of them
> here [5].
> 
> Because special ioremap variants are required on ARM for io mappings
> that allow code execution, the first two patches provide generic
> accessors for those variants. The third patch provides a DT and pdata
> method for instructing misc/sram to map the memory in such a way that
> allows code execution.
> 
> The 4th patch provides a generic set of functions for handling function
> pointers as addresses and vice versa. This is necessary on ARM because
> of the way that Thumb2 function pointers are handled by gcc. The PIE
> framework requires this functionality because it performs translations
> of function pointers.
> 
> The 5th patch is the general PIE framework. The 6th patch is the addition
> of ARM support for PIE. The 7th patch provides the ability of ARM to
> fixup PIE code on the fly. This is necessary since at suspend time the
> MMU will be working, but at resume time, it will be off. The 8th patch
> provides a predefined trampoline that utilizes the on the fly fixup.
> 
> The 9th patch configures the SRAM DT entries for am335x so that they can
> be easily found by the PM code, and so that they are mapped with exec
> enabled. The 10th patch adds PIE entries for am335x, and the 11th patch
> finally adds suspend/resume support for am33xx utilizing C code for
> suspend/resume paths.
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg271525.html
> [2] http://comments.gmane.org/gmane.linux.ports.arm.omap/103774
> [3] http://www.spinics.net/lists/devicetree/msg00227.html
> [4] http://www.spinics.net/lists/linux-omap/msg95305.html
> [5] https://github.com/russdill/linux/commits/sram
> 
> Russ Dill (10):
>   asm-generic: io: Add exec versions of ioremap
>   lib: devres: Add exec versions of devm_ioremap_resource and friends
>   misc: SRAM: Add option to map SRAM to allow code execution
>   asm-generic: fncpy: Add function copying macros
>   PIE: Support embedding position independent executables
>   ARM: PIE: Add position independent executable embedding to ARM
>   ARM: PIE: Add support for updating PIE relocations
>   ARM: PIE: Add macro for generating PIE resume trampoline
>   ARM: dts: AM33XX: Associate SRAM with MPU and mark it exec
>   ARM: OMAP2+: AM33XX: Add PIE support for AM33XX
> 
> Vaibhav Bedia (1):
>   ARM: OMAP2+: AM33XX: Basic suspend resume support
> 
>  Documentation/devicetree/bindings/misc/sram.txt |   4 +
>  Documentation/pie.txt                           | 167 ++++++++
>  Makefile                                        |  17 +-
>  arch/alpha/include/asm/fncpy.h                  |   1 +
>  arch/arc/include/asm/fncpy.h                    |   1 +
>  arch/arm/Kconfig                                |   1 +
>  arch/arm/Makefile                               |   5 +
>  arch/arm/boot/dts/am33xx.dtsi                   |   2 +
>  arch/arm/configs/omap2plus_defconfig            |   1 +
>  arch/arm/include/asm/elf.h                      |   1 +
>  arch/arm/include/asm/fncpy.h                    |  76 +---
>  arch/arm/include/asm/io.h                       |   2 +
>  arch/arm/include/asm/pie.h                      |  42 ++
>  arch/arm/include/asm/suspend.h                  |  25 ++
>  arch/arm/kernel/.gitignore                      |   1 +
>  arch/arm/kernel/Makefile                        |   4 +-
>  arch/arm/kernel/pie.c                           |  92 +++++
>  arch/arm/kernel/pie.lds.S                       |  41 ++
>  arch/arm/kernel/vmlinux.lds.S                   |   2 +
>  arch/arm/libpie/.gitignore                      |   3 +
>  arch/arm/libpie/Makefile                        |  32 ++
>  arch/arm/libpie/empty.S                         |  12 +
>  arch/arm/libpie/relocate.S                      |  76 ++++
>  arch/arm/mach-omap2/Kconfig                     |   7 +-
>  arch/arm/mach-omap2/Makefile                    |   2 +
>  arch/arm/mach-omap2/board-generic.c             |   1 +
>  arch/arm/mach-omap2/common.h                    |  10 +
>  arch/arm/mach-omap2/io.c                        |   5 +
>  arch/arm/mach-omap2/pm.c                        |   3 +-
>  arch/arm/mach-omap2/pm33xx.c                    | 486 ++++++++++++++++++++++++
>  arch/arm/mach-omap2/pm33xx.h                    |  68 ++++
>  arch/arm/mach-omap2/sleep33xx.c                 | 314 +++++++++++++++
>  arch/arm/mach-omap2/wkup_m3.c                   | 183 +++++++++
>  arch/arm/plat-omap/sram.c                       |   2 +-
>  arch/arm64/include/asm/fncpy.h                  |   1 +
>  arch/avr32/include/asm/fncpy.h                  |   1 +
>  arch/blackfin/include/asm/fncpy.h               |   1 +
>  arch/c6x/include/asm/fncpy.h                    |   1 +
>  arch/cris/include/asm/fncpy.h                   |   1 +
>  arch/frv/include/asm/fncpy.h                    |   1 +
>  arch/h8300/include/asm/fncpy.h                  |   1 +
>  arch/hexagon/include/asm/fncpy.h                |   1 +
>  arch/ia64/include/asm/fncpy.h                   |   1 +
>  arch/m32r/include/asm/fncpy.h                   |   1 +
>  arch/m68k/include/asm/fncpy.h                   |   1 +
>  arch/metag/include/asm/fncpy.h                  |   1 +
>  arch/microblaze/include/asm/fncpy.h             |   1 +
>  arch/mips/include/asm/fncpy.h                   |   1 +
>  arch/mn10300/include/asm/fncpy.h                |   1 +
>  arch/openrisc/include/asm/fncpy.h               |   1 +
>  arch/parisc/include/asm/fncpy.h                 |   1 +
>  arch/powerpc/include/asm/fncpy.h                |   1 +
>  arch/s390/include/asm/fncpy.h                   |   1 +
>  arch/score/include/asm/fncpy.h                  |   1 +
>  arch/sh/include/asm/fncpy.h                     |   1 +
>  arch/sparc/include/asm/fncpy.h                  |   1 +
>  arch/tile/include/asm/fncpy.h                   |   1 +
>  arch/um/include/asm/fncpy.h                     |   1 +
>  arch/unicore32/include/asm/fncpy.h              |   1 +
>  arch/x86/include/asm/fncpy.h                    |   1 +
>  arch/xtensa/include/asm/fncpy.h                 |   1 +
>  drivers/misc/sram.c                             |  13 +-
>  include/asm-generic/fncpy.h                     | 104 +++++
>  include/asm-generic/iomap.h                     |   5 +
>  include/asm-generic/pie.lds.h                   |  82 ++++
>  include/asm-generic/vmlinux.lds.h               |   1 +
>  include/linux/device.h                          |  17 +-
>  include/linux/io.h                              |   4 +
>  include/linux/pie.h                             | 196 ++++++++++
>  include/linux/platform_data/sram.h              |   8 +
>  lib/Kconfig                                     |  14 +
>  lib/Makefile                                    |   2 +
>  lib/devres.c                                    |  97 ++++-
>  lib/pie.c                                       | 138 +++++++
>  pie/.gitignore                                  |   3 +
>  pie/Makefile                                    |  85 +++++
>  scripts/link-vmlinux.sh                         |  11 +-
>  77 files changed, 2425 insertions(+), 71 deletions(-)
>  create mode 100644 Documentation/pie.txt
>  create mode 100644 arch/alpha/include/asm/fncpy.h
>  create mode 100644 arch/arc/include/asm/fncpy.h
>  create mode 100644 arch/arm/include/asm/pie.h
>  create mode 100644 arch/arm/kernel/pie.c
>  create mode 100644 arch/arm/kernel/pie.lds.S
>  create mode 100644 arch/arm/libpie/.gitignore
>  create mode 100644 arch/arm/libpie/Makefile
>  create mode 100644 arch/arm/libpie/empty.S
>  create mode 100644 arch/arm/libpie/relocate.S
>  create mode 100644 arch/arm/mach-omap2/pm33xx.c
>  create mode 100644 arch/arm/mach-omap2/pm33xx.h
>  create mode 100644 arch/arm/mach-omap2/sleep33xx.c
>  create mode 100644 arch/arm/mach-omap2/wkup_m3.c
>  create mode 100644 arch/arm64/include/asm/fncpy.h
>  create mode 100644 arch/avr32/include/asm/fncpy.h
>  create mode 100644 arch/blackfin/include/asm/fncpy.h
>  create mode 100644 arch/c6x/include/asm/fncpy.h
>  create mode 100644 arch/cris/include/asm/fncpy.h
>  create mode 100644 arch/frv/include/asm/fncpy.h
>  create mode 100644 arch/h8300/include/asm/fncpy.h
>  create mode 100644 arch/hexagon/include/asm/fncpy.h
>  create mode 100644 arch/ia64/include/asm/fncpy.h
>  create mode 100644 arch/m32r/include/asm/fncpy.h
>  create mode 100644 arch/m68k/include/asm/fncpy.h
>  create mode 100644 arch/metag/include/asm/fncpy.h
>  create mode 100644 arch/microblaze/include/asm/fncpy.h
>  create mode 100644 arch/mips/include/asm/fncpy.h
>  create mode 100644 arch/mn10300/include/asm/fncpy.h
>  create mode 100644 arch/openrisc/include/asm/fncpy.h
>  create mode 100644 arch/parisc/include/asm/fncpy.h
>  create mode 100644 arch/powerpc/include/asm/fncpy.h
>  create mode 100644 arch/s390/include/asm/fncpy.h
>  create mode 100644 arch/score/include/asm/fncpy.h
>  create mode 100644 arch/sh/include/asm/fncpy.h
>  create mode 100644 arch/sparc/include/asm/fncpy.h
>  create mode 100644 arch/tile/include/asm/fncpy.h
>  create mode 100644 arch/um/include/asm/fncpy.h
>  create mode 100644 arch/unicore32/include/asm/fncpy.h
>  create mode 100644 arch/x86/include/asm/fncpy.h
>  create mode 100644 arch/xtensa/include/asm/fncpy.h
>  create mode 100644 include/asm-generic/fncpy.h
>  create mode 100644 include/asm-generic/pie.lds.h
>  create mode 100644 include/linux/pie.h
>  create mode 100644 include/linux/platform_data/sram.h
>  create mode 100644 lib/pie.c
>  create mode 100644 pie/.gitignore
>  create mode 100644 pie/Makefile
> 
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
