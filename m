Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbaAJDwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:52:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbaAJDwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:52:01 -0500
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Salter <msalter@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Dave Young <dyoung@redhat.com>
Subject: [PATCH v3 0/6] generic early_ioremap support
Date: Thu,  9 Jan 2014 22:50:27 -0500
Message-Id: <1389325833-16535-1-git-send-email-msalter@redhat.com>
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
were discussed here (and are in the akpm tree):

  http://lkml.org/lkml/2013/11/25/474

This is version 3 of the patch series. These patches (and underlying
fixmap patches) may be found at:

  git://github.com/mosalter/linux.git (early-ioremap-v3 branch)

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
 arch/arm/Kconfig                    |  11 ++
 arch/arm/include/asm/Kbuild         |   1 +
 arch/arm/include/asm/fixmap.h       |  18 +++
 arch/arm/include/asm/io.h           |   1 +
 arch/arm/kernel/setup.c             |   3 +
 arch/arm/mm/Makefile                |   1 +
 arch/arm/mm/early_ioremap.c         |  93 ++++++++++++++
 arch/arm/mm/mmu.c                   |   2 +
 arch/arm64/Kconfig                  |   1 +
 arch/arm64/include/asm/Kbuild       |   1 +
 arch/arm64/include/asm/fixmap.h     |  68 ++++++++++
 arch/arm64/include/asm/io.h         |   1 +
 arch/arm64/include/asm/memory.h     |   2 +-
 arch/arm64/include/asm/mmu.h        |   1 +
 arch/arm64/kernel/early_printk.c    |   8 +-
 arch/arm64/kernel/head.S            |   9 +-
 arch/arm64/kernel/setup.c           |   4 +
 arch/arm64/mm/ioremap.c             |  85 ++++++++++++
 arch/arm64/mm/mmu.c                 |  44 +------
 arch/x86/Kconfig                    |   1 +
 arch/x86/include/asm/Kbuild         |   1 +
 arch/x86/include/asm/fixmap.h       |   6 +
 arch/x86/include/asm/io.h           |  14 +-
 arch/x86/mm/ioremap.c               | 224 +-------------------------------
 arch/x86/mm/pgtable_32.c            |   2 +-
 include/asm-generic/early_ioremap.h |  41 ++++++
 mm/Kconfig                          |   3 +
 mm/Makefile                         |   1 +
 mm/early_ioremap.c                  | 249 ++++++++++++++++++++++++++++++++++++
 30 files changed, 611 insertions(+), 289 deletions(-)
 create mode 100644 arch/arm/mm/early_ioremap.c
 create mode 100644 arch/arm64/include/asm/fixmap.h
 create mode 100644 include/asm-generic/early_ioremap.h
 create mode 100644 mm/early_ioremap.c

-- 
1.8.3.1

