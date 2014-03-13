Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaCMWsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:48:05 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:49591 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaCMWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:48:00 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, catalin.marinas@arm.com,
        matt.fleming@intel.com
Cc: msalter@redhat.com, roy.franz@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 00/14] UEFI support for arm(64)
Date: Thu, 13 Mar 2014 22:46:53 +0000
Message-Id: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since all prerequisites are not ready for the (32-bit) arm patches to
go in, I have broken these out of this set and will be resubmitting
them separately.

This set now provides arm64 support only - but includes the code that
is common between the ARM ports.

Prerequisites for this set are:
- Mark Salter's generic early_ioremap()
- Matt Fleming's efi_enabled() rework

Changes from the last upstream posting:
- Some cleanup based on feedback
- Fixed range test in create_id_mapping()
- Fixed name of guard ifdef in arch/arm64/include/asm/efi.h
- Fixed memory corruption bug caused by late use of
  create_id_mapping(). That function uses memblock_alloc()
  to allocate new pmd/pte pages and it was being called
  after slab allocator was initialized. This led to
  possibility that the allocated memory for pmd/pte was
  already in use by something else. Now, create_id_mapping()
  gets called just after paging_init() when it is still okay
  to use memblock_alloc().
- Fixed whitespace error in efi-entry.S
- Now support 64K pagesize in EFI runtime
- Undid the breakage I caused to Ard's dtb= SecureBoot patch

---

Ard Biesheuvel (1):
  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled

H. Peter Anvin (1):
  efi: x86: Improve cmdline conversion

Leif Lindholm (2):
  efi: delete stray ARM ifdef
  doc: arm: add UEFI support documentation

Mark Salter (7):
  efi: create memory map iteration helper
  lib: add fdt_empty_tree.c
  efi: add helper function to get UEFI params from FDT
  arm64: Add function to create identity mappings
  arm64: add EFI stub
  doc: arm64: add description of EFI stub support
  arm64: add EFI runtime services

Roy Franz (4):
  doc: efi-stub.txt updates for ARM
  efi: Add shared printk wrapper for consistent prefixing
  efi: Add get_dram_base() helper function
  efi: Add shared FDT related functions for ARM/ARM64

 Documentation/arm/00-INDEX             |    2 +
 Documentation/arm/uefi.txt             |   64 +++++
 Documentation/arm64/booting.txt        |    4 +
 Documentation/efi-stub.txt             |   33 ++-
 arch/arm64/Kconfig                     |   26 ++
 arch/arm64/include/asm/efi.h           |   14 +
 arch/arm64/include/asm/mmu.h           |    2 +
 arch/arm64/kernel/Makefile             |    4 +
 arch/arm64/kernel/efi-entry.S          |   93 +++++++
 arch/arm64/kernel/efi-stub.c           |   83 ++++++
 arch/arm64/kernel/efi.c                |  465 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S               |  112 ++++++++
 arch/arm64/kernel/setup.c              |    5 +
 arch/arm64/mm/mmu.c                    |   65 +++--
 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/Kconfig           |    7 +
 drivers/firmware/efi/arm-stub.c        |  149 ++++++++++
 drivers/firmware/efi/efi-stub-helper.c |  182 ++++++++++---
 drivers/firmware/efi/efi.c             |   79 ++++++
 drivers/firmware/efi/fdt.c             |  268 ++++++++++++++++++
 include/linux/efi.h                    |   18 ++
 init/main.c                            |    4 +
 lib/Makefile                           |    3 +-
 lib/fdt_empty_tree.c                   |    2 +
 24 files changed, 1615 insertions(+), 72 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-stub.c
 create mode 100644 drivers/firmware/efi/fdt.c
 create mode 100644 lib/fdt_empty_tree.c

-- 
1.7.10.4

