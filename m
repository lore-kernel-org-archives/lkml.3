Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaBLU5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:57:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316AbaBLU52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:57:28 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Dave Young <dyoung@redhat.com>,
        Rob Herring <robherring2@gmail.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, patches@linaro.org
Subject: [PATCH v4 0/6] generic early_ioremap support
Date: Wed, 12 Feb 2014 15:56:09 -0500
Message-Id: <1392238575-10000-1-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series takes the common bits from the x86 early ioremap
implementation and creates a generic implementation which may be used
by other architectures. The early ioremap interfaces are intended for
situations where boot code needs to make temporary virtual mappings
before the normal ioremap interfaces are available. Typically, this
means before paging_init() has run.

These patches are layered on top of generic fixmap patches which
were pulled into 3.14-rc with the exception of the arm patch:

  https://lkml.org/lkml/2013/11/25/477

The arm fixmap patch is currently in the akpm tree and has been
part of linux-next for a while.

This is version 4 of the patch series. These patches (and underlying
fixmap patches) may be found at:

  git://github.com/mosalter/linux.git (early-ioremap-v4 branch)

Changes from version 3:

  * Removed dependency on MMU. In the case of no-MMU, the early remap
    functions return the address passed in. This helps simplify use of
    early_ioremap functions on architectures such as ARM which have
    optional MMU support.

  * Added L_PTE_XN to arm page flags so mappings are non-executable.

  * Include linux/io.h rather than asm/io.h in arm setup.c

  * Moved early_ioremap_init() before setup_machine_fdt() in arm
    setup_arch().

  * Fixed mispelling in config EARLY_IOREMAP help text.

Changes from version 2:

  * Added some Acks

  * Incorporated a patch from Dave Young to change the signature
    of early_memremap() (dropping __iomem from returned pointer)
    which is the first patch in a larger series:

        https://lkml.org/lkml/2013/12/22/69

    This allows the change of just the x86 function signature
    to be bisected.

Changes from version 1:

  * Moved the generic code into linux/mm instead of linux/lib

  * Have early_memremap() return normal pointer instead of __iomem
    This is in response to sparse warning cleanups being made in
    an unrelated patch series:

        https://lkml.org/lkml/2013/12/22/69

  * Added arm64 patch to call init_mem_pgprot() earlier so that
    the pgprot macros are valid in time for early_ioremap use

  * Added validity checking for early_ioremap pgd, pud, and pmd
    in arm64

Dave Young (1):
  x86/mm: sparse warning fix for early_memremap

Mark Salter (5):
  mm: create generic early_ioremap() support
  x86: use generic early_ioremap
  arm: add early_ioremap support
  arm64: initialize pgprot info earlier in boot
  arm64: add early_ioremap support

 Documentation/arm64/memory.txt      |   4 +-
 arch/arm/Kconfig                    |  10 ++
 arch/arm/include/asm/Kbuild         |   1 +
 arch/arm/include/asm/fixmap.h       |  20 +++
 arch/arm/include/asm/io.h           |   1 +
 arch/arm/kernel/setup.c             |   2 +
 arch/arm/mm/Makefile                |   4 +
 arch/arm/mm/early_ioremap.c         |  93 +++++++++++++
 arch/arm/mm/mmu.c                   |   2 +
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/Kbuild       |   1 +
 arch/arm64/include/asm/fixmap.h     |  67 +++++++++
 arch/arm64/include/asm/io.h         |   1 +
 arch/arm64/include/asm/memory.h     |   2 +-
 arch/arm64/include/asm/mmu.h        |   1 +
 arch/arm64/kernel/early_printk.c    |   8 +-
 arch/arm64/kernel/head.S            |   9 +-
 arch/arm64/kernel/setup.c           |   4 +
 arch/arm64/mm/ioremap.c             |  85 +++++++++++
 arch/arm64/mm/mmu.c                 |  44 +-----
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/fixmap.h       |   6 +
 arch/x86/include/asm/io.h           |  14 +-
 arch/x86/mm/ioremap.c               | 224 +----------------------------
 arch/x86/mm/pgtable_32.c            |   2 +-
 include/asm-generic/early_ioremap.h |  42 ++++++
 mm/Kconfig                          |   3 +
 mm/Makefile                         |   1 +
 mm/early_ioremap.c                  | 271 ++++++++++++++++++++++++++++++++++++
 30 files changed, 636 insertions(+), 289 deletions(-)
 create mode 100644 arch/arm/mm/early_ioremap.c
 create mode 100644 arch/arm64/include/asm/fixmap.h
 create mode 100644 include/asm-generic/early_ioremap.h
 create mode 100644 mm/early_ioremap.c

-- 
1.8.5.3

