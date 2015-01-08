Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbbAHSsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:48:55 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45672 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbbAHSsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:48:54 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: leif.lindholm@linaro.org, roy.franz@linaro.org, matt.fleming@intel.com,
        will.deacon@arm.com, catalin.marinas@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        bp@alien8.de, msalter@redhat.com, geoff.levand@linaro.org,
        dyoung@redhat.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 0/8] arm64: stable UEFI virtual mappings for kexec
Date: Thu,  8 Jan 2015 18:48:26 +0000
Message-Id: <1420742914-2404-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v5 of the series to update the UEFI memory map handling for the arm64
architecture so that virtual mappings of UEFI Runtime Services are stable across
kexec.

Changes between v5 and v4:
- rebased onto v3.19-rc3 + the early_ioremap() fix we sent out today
- patches #1 and #2: unchanged
- patch #3: added Matt's ack, addressed Boris's review comments
- patch #4: added Boris's ack
- patch #5: added Leif's ack
- patch #6: addressed review comments from Mark Rutland, Leif and Matt (see
  below)
- patch #7 and #8: added Leif's ack

I have tried to address Matt's concern about drivers/firmware/efi/fdt.c becoming
a dumping ground for ARM specific stuff by moving the virtmap creation to
arm-stub.c. However, EFI is not the only place where sharing code between ARM
and arm64 should be dealt with in a better way, so this remains a concern IMO.

Regarding the duplicated version of efi_get_memory_map(): I dropped it and now
call the original version twice, where the first call is actually only used to
get an allocation whose size is an upper bound for all runtime region
descriptors combined. I have posted a separate patch to improve the original
as there are some concerns there as well.

Regarding EFI_VIRTMAP/EFI_ARCH_1: I added an elaborate comment about it, and
I think there is a case for retaining it next to EFI_RUNTIME_SERVICES.

To de-risk the adoption of the subset of patches that are essential to get kexec
working on UEFI systems, in v4 I dropped all the patches related to the iomem
resource table, /dev/mem permissions and memory attributes etc. These topics
have been addressed in a separate series.

The primary changes between v4 and v3 in the patches that were kept are:
- instead of reording the memory map so that part of it can double as input
  argument to SetVirtualAddressMap(), increase the allocation size for the
  memory map so that we can use some of it as scratch space and use that to
  prepare the input to SVAM() instead. UPDATE: now a separate allocation (v5)
- added some acks
- rebased onto v3.19-rc1

NOTE: these changes trigger an issue on AMD Seattle that we (Mark Rutland and I)
consider a firmware bug. It appears that, during the call to SVAM() (which is
called with a 1:1 mapping as per the UEFI spec) the virtual mapping being
installed is dereferenced prematurely. This went unnoticed in the original
situation, as the virtual mappings were just kernel mappings that are always
accessible. However, in the new situation, those mappings are only active
during Runtime Service invocations, and performing any kind of access through
them at any other time triggers a fault.
UPDATE: this issue has been fixed but obviously requires those affected to
install a new version of the firmware

============== v1 blurb ==================

The main premise of these patches is that, in order to support kexec, we need
to add code to the kernel that is able to deal with the state of the firmware
after SetVirtualAddressMap() [SVAM] has been called. However, if we are going to
deal with that anyway, why not make that the default state, and have only a
single code path for both cases.

This means SVAM() needs to move to the stub, and hence the code that invents
the virtual layout needs to move with it. The result is that the kernel proper
is entered with the virt_addr members of all EFI_MEMORY_RUNTIME regions
assigned, and the mapping installed into the firmware. The kernel proper needs
to set up the page tables, and switch to them while performing the runtime
services calls. Note that there is also an efi_to_phys() to translate the values
of the fw_vendor and tables fields of the EFI system table. Again, this is
something we need to do anyway under kexec, or we end up handing over state
between one kernel and the next, which implies different code paths between
non-kexec and kexec.

The layout is chosen such that it used the userland half of the virtual address
space (TTBR0), which means no additional alignment or reservation is required
to ensure that it will always be available.

One thing that may stand out is the reordering of the memory map. The reason
for doing this is that we can use the same memory map as input to SVAM(). The
alternative is allocating memory for it using boot services, but that clutters
up the existing logic a bit between getting the memory map, populating the fdt,
and loop again if it didn't fit.

Ard Biesheuvel (8):
  arm64/mm: add explicit struct_mm argument to __create_mapping()
  arm64/mm: add create_pgd_mapping() to create private page tables
  efi: split off remapping code from efi_config_init()
  efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
  arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
  arm64/efi: move SetVirtualAddressMap() to UEFI stub
  arm64/efi: remove free_boot_services() and friends
  arm64/efi: remove idmap manipulations from UEFI code

 arch/arm64/include/asm/efi.h                   |  38 ++-
 arch/arm64/include/asm/mmu.h                   |   5 +-
 arch/arm64/include/asm/pgtable.h               |   5 +
 arch/arm64/kernel/efi.c                        | 369 ++++++++-----------------
 arch/arm64/kernel/setup.c                      |   2 +-
 arch/arm64/mm/mmu.c                            |  60 ++--
 drivers/firmware/efi/efi.c                     |  56 ++--
 drivers/firmware/efi/libstub/arm-stub.c        |  59 ++++
 drivers/firmware/efi/libstub/efi-stub-helper.c |  25 +-
 drivers/firmware/efi/libstub/efistub.h         |   4 +
 drivers/firmware/efi/libstub/fdt.c             |  62 ++++-
 include/linux/efi.h                            |   2 +
 12 files changed, 362 insertions(+), 325 deletions(-)

-- 
1.8.3.2

