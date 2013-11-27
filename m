Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3K0XcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:32:09 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:41814 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3K0XcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:32:05 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V5 0/6] Add ARM EFI stub
Date: Wed, 27 Nov 2013 15:31:49 -0800
Message-Id: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds EFI stub support for the ARM architecture.  The 
stub for ARM is implemented in a similar manner to x86 in that it is a 
shim layer between EFI and the normal zImage/bzImage boot process, and 
that an image with the stub configured is bootable as both a zImage and 
EFI application.

This patch depends on Leif Lindholm's v7 runtime services patchset, which 
in turn depends on Mark Salter's early_io_remap() patchset.  This EFI stub 
patchset can be tested without those by simply modifying the Kconfig for 
EFI_STUB to not depend on EFI.  The kernel will boot using the stub, 
however no EFI support will be available in the kernel.  Updated versions
of these other patchsets should be posted in the near future.

Changes since v4:
* Common and x86 EFI stub changes that this patch depends on were merged
  in 3.13.
* Updated FDT bindings to match agreed upon bindings in Leif's runtime
  services patchset.  This includes adding the kernel_banner version string,
  and changing how the EFI memory map is passed.  The EFI memory map is now
  allocated as EFI_RUNTIME_SERVICES_DATA since it may be passed to the kernel.
  The FDT bindings for arm/arm64 are identical.
* Added space in PE/COFF header for signature to allow signing of the image
  for EFI secure boot.
* Moved shared FDT function to drivers/firmware/efi/fdt.c.  This will be shared
  with arm64.  (Mark Salter has a patchset for the arm64 stub.)


Changes since v3:
* Common and x86 EFI stub changes have been broken out and submitted separately.
  This patch series depends on the "[PATCH V5 00/18] ARM EFI stub common code"
  series as merged by Matt Fleming. (Patch 10 of that series omitted)
* Re-added -fno-stack-protector.  Needed for compilation with 
  CONFIG_CC_STACKPROTECTOR option.  Cannot easily add support for stack 
  protection since there are no functions in stub that never return, which 
  is a requirement for use.  (x86 stub also disables stack protector.)
  Note that even in the absense of -fno-stack-protector, stack protection
  was never present in the decompressor, as the required functions are not
  implemented.
* Fixed long summaries in commit messages.
* Further cleanups of assembly in head.S


Changes since v2:
* Now depends on "arm: Add [U]EFI runtime services support" patches by leif.lindholm@linaro.org.
  The EFI memory map is the only memory map passed to the kernel, so EFI support
  is now required.
* remove "-fno-stack-protector" from decompressor Makefile.  The current code doesn't
  trigger the stack protection, so the decompressor now compiles with it still
  on.  Note that there has never been any stack protection in the decompressor
  since the stack usage doesn't trigger the heuristic in GCC, so right now
  the "-fno-stack-protector" is a noop.
* Changed EFI command line handling to not have a fixed limit.
* Change FDT memory allocation to retry with a larger allocation if
  first educated guess is inadequate.
* Correctly set 'SizeOfCode' in PE/COFF header.
* Reviewed ".setup" section that is in x86 PE/COFF header.  This is used for x86
  to account for code that is not in the .text section.  We don't need this
  for ARM, as all of our code is in the .text section, or in the PE/COFF header
  itself.
* Moved EFI_STUB_ERROR #define to header file to share between stub C and ASM.
* Variety of cleanups and fixes in head.S.
* Changed update_fdt_and_exit_boot() to just update the device tree, and
  renamed appropriately.  Memory allocations moved out of this function as
  well, which enables the retries if the initial FDT size is too small.
  Note that in order to do the retried allocations, the original FDT and 
  command line memory regions are left allocated.  This is OK since the kernel
  has the memory map and will free these allocations along with the initrd
  and new fdt allocations.
* Added prefix to all prints, reduced number of prints, and reviewed all
  messages.
* Change mixed usage of dtb/fdt to all be fdt or "device tree" in efi-stub.c
* remove unnecessary zimage_size variable from relocate_kernel()
* correct return types on EFI functions - should be efi_status_t, not int.

Roy Franz (6):
  efi-stub.txt updates for ARM
  Add shared update_fdt() function for ARM/ARM64
  Add strstr to compressed string.c for ARM.
  Add EFI stub for ARM
  Disable stack protection for decompressor/stub
  Add config EFI_STUB for ARM to Kconfig

 Documentation/efi-stub.txt             |   27 ++-
 arch/arm/Kconfig                       |   10 ++
 arch/arm/boot/compressed/Makefile      |   17 +-
 arch/arm/boot/compressed/efi-header.S  |  117 +++++++++++++
 arch/arm/boot/compressed/efi-stub.c    |  291 ++++++++++++++++++++++++++++++++
 arch/arm/boot/compressed/efi-stub.h    |    5 +
 arch/arm/boot/compressed/head.S        |   83 ++++++++-
 arch/arm/boot/compressed/string.c      |   21 +++
 drivers/firmware/efi/efi-stub-helper.c |    9 +-
 drivers/firmware/efi/fdt.c             |  115 +++++++++++++
 10 files changed, 678 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/boot/compressed/efi-stub.h
 create mode 100644 drivers/firmware/efi/fdt.c

-- 
1.7.10.4

