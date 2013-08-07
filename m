Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3HGDpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:45:23 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:61179 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757008Ab3HGDpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:45:20 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V2 00/17] EFI stub for ARM
Date: Tue,  6 Aug 2013 20:44:56 -0700
Message-Id: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds EFI stub support for the ARM architecture.
Some code that was previously only used by x86/x86_64 is now shared
and has been made more general.  The stub for ARM is implemented in
a similar manner to x86 in that it is a shim layer between EFI and
the normal zImage/bzImage boot process, and that an image with the
stub configured is bootable as both a zImage and EFI application.

This patchset depends (trivially) on a separately submitted bugfix to the
EFI stub: "correct call to free_pages"
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=df981edcb9bce00b9c5e4f3cc33f3f98bc9a2394


Changes since V1:
* Updated head.S based on feedback from Dave Martin.  ARM/THUMB
  switches now much cleaner.
* Broke up changes to x86 and common code into more patches.
  10 more patches in this series.



Roy Franz (17):
  EFI stub documentation updates
  Move common EFI stub code from x86 arch code to common location
  Add system pointer argument to shared EFI stub related     functions
    so they no longer use global system table     pointer as they did
    when part of eboot.c.
  Rename memory allocation/free functions
  Add minimum address parameter to efi_low_alloc()
  rename __get_map() to efi_get_memory_map(), add parameter     to
    optionally return mmap key. The mmap key is required     to exit
    EFI boot services, and allows efi_get_memory_map()     to be used
    for getting final memory map.
  Enforce minimum alignment of 1 page on allocations.     The
    efi_high_alloc() and efi_low_alloc() functions     use the
    EFI_ALLOCATE_ADDRESS option to the EFI     function
    allocate_pages(), which requires a minimum     of page alignment,
    and rejects all other requests.
  Allow efi_free() to be called with size of 0, and do nothing in that
    case.
  Generalize handle_ramdisks() and rename to handle_cmdline_files().
  Renames in handle_cmdline_files() to complete generalization.
  Move EFI_READ_CHUNK_SIZE define to shared location.
  Add proper definitions for some EFI function pointers.
  Fix types in EFI calls to match EFI function definitions.
  resolve warnings found on ARM compile
  Add strstr to compressed string.c for ARM.
  Add EFI stub for ARM
  Add config EFI_STUB for ARM to Kconfig

 Documentation/efi-stub.txt             |   78 +++++
 Documentation/x86/efi-stub.txt         |   65 ----
 arch/arm/Kconfig                       |   10 +
 arch/arm/boot/compressed/Makefile      |   18 +-
 arch/arm/boot/compressed/efi-header.S  |  114 +++++++
 arch/arm/boot/compressed/efi-stub.c    |  514 ++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/head.S        |   90 +++++-
 arch/arm/boot/compressed/string.c      |   21 ++
 arch/x86/Kconfig                       |    2 +-
 arch/x86/boot/compressed/eboot.c       |  490 ++----------------------------
 arch/x86/boot/compressed/eboot.h       |    7 -
 drivers/firmware/efi/efi-stub-helper.c |  505 +++++++++++++++++++++++++++++++
 include/linux/efi.h                    |   48 ++-
 13 files changed, 1405 insertions(+), 557 deletions(-)
 create mode 100644 Documentation/efi-stub.txt
 delete mode 100644 Documentation/x86/efi-stub.txt
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 drivers/firmware/efi/efi-stub-helper.c

-- 
1.7.10.4

