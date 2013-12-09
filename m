Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169Ab3LIJnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab3LIJn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:43:28 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v5 00/14] kexec kernel efi runtime support
Date: Mon,  9 Dec 2013 17:42:13 +0800
Message-Id: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the V5 patchset for supporting kexec kernel efi runtime.
Per pervious discussion I pass the 1st kernel efi runtime mapping
via setup_data to 2nd kernel. Besides of the runtime mapping
info I also pass the fw_vendor, runtime, config table, smbios
physical address in setup_data. EFI spec mentioned fw_vendor,
runtime, config table addresses will be converted to virt address
after entering virtual mode, but we will use it as physical address
in efi_init. For smbios EFI spec did not mention about the address
updating, but during my test on a HP workstation, the bios will
convert it to Virt addr, thus pass it in setup_data as well.

For fw_vendor, runtime, config table, I export them in /sys/firmware/
efi/, smbios is already in /sys/firmware/efi/systab.

For efi runtime mapping I add a new directory /sys/firmware/efi/
runtime-map/ like below
[dave@darkstar ~]$ tree /sys/firmware/efi/runtime-map/
/sys/firmware/efi/runtime-map/
|__ 0
|   |__ attribute
|   |__ num_pages
|   |__ phys_addr
|   |__ type
|   |__ virt_addr
|__ 1
[snip]
 
kexec-tools will assemble them as setup_data and pass to 2nd kernel.
I will send userspace patches as well.

Limitation is I only write support for x86_64, test on below machines:
Lenovo thinkpad t420
Dell inspiron 14 - 3421
HP Z420 workstation
Qemu + OVMF

The patches are based on linus tree + matt's efi master tree

Changes from v1:
add one flag in xloadflags, so kexec-tools can safely load old kernel
without efi support.
coding style fixes
function name for map phys_addr to fixed virt_addr
Add ABI documentation for sysfs files

Changes from v2:
01/09: a new patch to remove unused variables in __map_region function
       catched by Toshi Kani
09/09: a new patch to export x86 boot_params to sysfs instead of use
       debugfs files
Matt: reuse __map_region instead do same thing in another function.
      add a wrapper function efi_map_region_fixed [02/09]
      check return value of krealloc
      sysfs dir name s/efi-runtime-map/runtime-map [06/09]
      use desc_size in efi_runtime_map
      for the xloadflags defination: +&& defined(CONFIG_KEXEC)
Greg: sysfs : one file one value for fw_vendor, runtime, tables. [05/09]
      Document them in ABI testing
HPA:  Document the new xloadflag
Also there's other function cleanup and improvement for error handling.

Changes from v3:
Greg: sysfs code move to use __ATTR_RO and attr_group
Boris: comments and code alignment

Added 3 new patches below
10-print-efi-runtime-memmap.patch
  - 10/12: print only runtime ranges in case EFI_DEBUG printing
11-reserve-setup-data-late.patch
  - fix a bug of kdump kernel, move function for reserving setup data
    ranges late after parsing memmap= cmdline params because kdump kernel
    will pass exact memmap late.
12-x86-kdebugfs-use-ioremap.patch
  - fix a bug of x86/kernel/kdebugfs.c, use ioremap instead of __va for
    low mem because __va does not work for exact memmap=

Changes from V4:
 - variable efi_setup in 09/14 is changed to the physical address instead of the virtual address
because it will be not iounmapped until entering virtual mode, it's too long and could cause
leak.
 - sparse warnings fixes (Matt):
   Added 2 new patches to addressing sparse warnings:
   01/14: x86-mm-sparse-warning-fix-for-early_memremap.patch
   02/14: efi-use-early_memremap-and-early_memunmap.patch
 - krealloc fixes (Boris)
 - rebase on top of Linus tree + Matt's efi master tree (Boris)
 - a lot of documention/spelling fixes (Boris)
 - share function save_runtime_map in 1st/2nd kernel code (Matt)
 - style and other fixes detail see the patch changelog themselves.

Boris: I still use the function name efi_reuse_config because it could be not only a problem for
HP workstation, also because we will later split them to another file so efi_ is acceptable for me.

The patches stay in kexec-efi-testing branch of below repo for testing:
https://github.com/daveyoung/linux.git

Dave Young (14):
  x86/mm: sparse warning fix for early_memremap
  efi: use early_memremap and early_memunmap
  efi: remove unused variables in __map_region
  efi: add a wrapper function efi_map_region_fixed
  efi: reserve boot service fix
  efi: cleanup efi_enter_virtual_mode function
  efi: export more efi table variable to sysfs
  efi: export efi runtime memory mapping to sysfs
  efi: passing kexec necessary efi data via setup_data
  efi: only print saved efi runtime maps instead of all memmap ranges
    for kexec
  x86: add xloadflags bit for efi runtime support on kexec
  x86: export x86 boot_params to sysfs
  x86: reserve setup_data ranges late after parsing memmap cmdline
  x86: kdebugfs do not use __va for getting setup_data virt addr

 Documentation/ABI/testing/sysfs-firmware-efi       |  24 ++
 .../ABI/testing/sysfs-firmware-efi-runtime-map     |  36 ++
 Documentation/ABI/testing/sysfs-kernel-boot_params |  39 +++
 Documentation/x86/boot.txt                         |   3 +
 arch/x86/boot/header.S                             |   9 +-
 arch/x86/include/asm/efi.h                         |  12 +
 arch/x86/include/asm/io.h                          |   3 +-
 arch/x86/include/uapi/asm/bootparam.h              |   2 +
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/kdebugfs.c                         |  35 +-
 arch/x86/kernel/ksysfs.c                           | 339 ++++++++++++++++++
 arch/x86/kernel/setup.c                            |   7 +-
 arch/x86/mm/ioremap.c                              |  10 +-
 arch/x86/platform/efi/efi.c                        | 378 ++++++++++++++++-----
 arch/x86/platform/efi/efi_32.c                     |   2 +
 arch/x86/platform/efi/efi_64.c                     |  16 +-
 drivers/firmware/efi/Kconfig                       |  11 +
 drivers/firmware/efi/Makefile                      |   1 +
 drivers/firmware/efi/efi.c                         |  47 ++-
 drivers/firmware/efi/runtime-map.c                 | 176 ++++++++++
 include/linux/efi.h                                |   9 +
 21 files changed, 1038 insertions(+), 122 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-boot_params
 create mode 100644 arch/x86/kernel/ksysfs.c
 create mode 100644 drivers/firmware/efi/runtime-map.c

-- 
1.8.3.1

