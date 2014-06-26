Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaFZUfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaFZUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:35:08 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 00/15][V4] kexec: A new system call to allow in kernel loading
Date: Thu, 26 Jun 2014 16:33:29 -0400
Message-Id: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is V4 of the patchset. Previous versions were posted here.

V1: https://lkml.org/lkml/2013/11/20/540
V2: https://lkml.org/lkml/2014/1/27/331
V3: https://lkml.org/lkml/2014/6/3/432

Changes since v3:

- Took care of most of the review comments from V3.
- Stopped building purgatory for 32bit.
- If 64bit EFI is not enabled (EFI_64BIT) return error in kernel loading.
- If EFI OLD_MEMMAP is being used, do not do EFI setup and user space is
  expected to pass acpi_rsdp=<addr> param and boot second kernel in non
  efi mode.
- move machine_kexec.c code into kexec-bzimage64.c
- Renamed kexec-bzimage.c to kexec-bzimage64.c to reflect the fact that
  it is only 64bit bzimage loader.

This patch series is generated on top of 3.16.0-rc2.

This patch series does not do kernel signature verification yet. I plan
to post another patch series for that. Now distributions are already signing
PE/COFF bzImage with PKCS7 signature I plan to parse and verify those
signatures.

Primary goal of this patchset is to prepare groundwork so that kernel
image can be signed and signatures be verified during kexec load. This
should help with two things.

- It should allow kexec/kdump on secureboot enabled machines.

- In general it can help even without secureboot. By being able to verify
  kernel image signature in kexec, it should help with avoiding module
  signing restrictions. Matthew Garret showed how to boot into a custom
  kernel, modify first kernel's memory and then jump back to old kernel and
  bypass any policy one wants to.

I hope these patches can be queued up for 3.17. Even without signature
verification support, they provide new syscall functionality. But I
wil leave it to maintainers to decide if they want signature verification
support also be ready to merge before they merge this patchset.

Any feedback is welcome.

Thanks
Vivek

Vivek Goyal (15):
  bin2c: Move bin2c in scripts/basic
  kernel: Build bin2c based on config option CONFIG_BUILD_BIN2C
  kexec: rename unusebale_pages to unusable_pages
  kexec: Move segment verification code in a separate function
  kexec: Use common function for kimage_normal_alloc() and
    kimage_crash_alloc()
  resource: Provide new functions to walk through resources
  kexec: Make kexec_segment user buffer pointer a union
  kexec: New syscall kexec_file_load() declaration
  kexec: Implementation of new syscall kexec_file_load
  purgatory/sha256: Provide implementation of sha256 in purgaotory
    context
  purgatory: Core purgatory functionality
  kexec: Load and Relocate purgatory at kernel load time
  kexec-bzImage64: Support for loading bzImage using 64bit entry
  kexec: Support for kexec on panic using new system call
  kexec: Support kexec/kdump on EFI systems

 arch/x86/Kbuild                        |    4 +
 arch/x86/Kconfig                       |    3 +
 arch/x86/Makefile                      |    8 +
 arch/x86/include/asm/crash.h           |    9 +
 arch/x86/include/asm/kexec-bzimage64.h |    6 +
 arch/x86/include/asm/kexec.h           |   40 +
 arch/x86/kernel/Makefile               |    1 +
 arch/x86/kernel/crash.c                |  563 ++++++++++++++
 arch/x86/kernel/kexec-bzimage64.c      |  532 +++++++++++++
 arch/x86/kernel/machine_kexec_64.c     |  228 ++++++
 arch/x86/purgatory/Makefile            |   30 +
 arch/x86/purgatory/entry64.S           |  101 +++
 arch/x86/purgatory/purgatory.c         |   72 ++
 arch/x86/purgatory/setup-x86_64.S      |   58 ++
 arch/x86/purgatory/sha256.c            |  283 +++++++
 arch/x86/purgatory/sha256.h            |   22 +
 arch/x86/purgatory/stack.S             |   19 +
 arch/x86/purgatory/string.c            |   13 +
 arch/x86/syscalls/syscall_64.tbl       |    1 +
 drivers/firmware/efi/runtime-map.c     |   21 +
 include/linux/efi.h                    |   19 +
 include/linux/ioport.h                 |    6 +
 include/linux/kexec.h                  |  101 ++-
 include/linux/syscalls.h               |    4 +
 include/uapi/linux/kexec.h             |   11 +
 init/Kconfig                           |    5 +
 kernel/Makefile                        |    2 +-
 kernel/kexec.c                         | 1322 ++++++++++++++++++++++++++++----
 kernel/resource.c                      |  101 ++-
 kernel/sys_ni.c                        |    1 +
 scripts/.gitignore                     |    1 -
 scripts/Makefile                       |    1 -
 scripts/basic/.gitignore               |    1 +
 scripts/basic/Makefile                 |    1 +
 scripts/basic/bin2c.c                  |   35 +
 scripts/bin2c.c                        |   36 -
 36 files changed, 3463 insertions(+), 198 deletions(-)
 create mode 100644 arch/x86/include/asm/crash.h
 create mode 100644 arch/x86/include/asm/kexec-bzimage64.h
 create mode 100644 arch/x86/kernel/kexec-bzimage64.c
 create mode 100644 arch/x86/purgatory/Makefile
 create mode 100644 arch/x86/purgatory/entry64.S
 create mode 100644 arch/x86/purgatory/purgatory.c
 create mode 100644 arch/x86/purgatory/setup-x86_64.S
 create mode 100644 arch/x86/purgatory/sha256.c
 create mode 100644 arch/x86/purgatory/sha256.h
 create mode 100644 arch/x86/purgatory/stack.S
 create mode 100644 arch/x86/purgatory/string.c
 create mode 100644 scripts/basic/bin2c.c
 delete mode 100644 scripts/bin2c.c

-- 
1.9.0

