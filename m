Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaA0S65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:58:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753926AbaA0S6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:58:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [RFC PATCH 00/11][V2] kexec: A new system call to allow in kernel loading 
Date: Mon, 27 Jan 2014 13:57:40 -0500
Message-Id: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is V2 of new system call patches. Previous version was posted here.

https://lkml.org/lkml/2013/11/20/540

V2 primarily does following changes

- Creates a binary object (called purgatory) which runs between two kernels.
  This is a stand alone relocatable object (it is not linked with kernel) and
  it is loaded and relocated by kexec syscall.

- Provided kexec support for loading ELF of type ET_EXEC. This only works for
  kexec case and not kexec on panic case. More about it patch changelog.

- Took care of feedback received during first round.

Primary goal of this patchset is to prepare groundwork so that kernel
image can be signed and signatures be verified during kexec load. This
should help with two things.

- It should allow kexec/kdump on secureboot enabled machines.

- In general it can help even without secureboot. By being able to verify
  kernel image signature in kexec, it should help with avoiding module
  signing restrictions. Matthew Garret showed how to boot into a custom
  kernel, modify first kernel's memory and then jump back to old kernel and
  bypass any policy one wants to. 

I have not taken care of signing part yet. First I want to get to a stage
where all the required pieces of kexec are re-implemented in kernel. And
then I want to look into signing part. Also only 64bit bzImage entry is
supported, no EFI/UEFI support, no x86_32 support. Trying to first come
up with minimum functionality which matters most.

Posting patches for early reiew. Your feedback and comments are welcome.

Thanks
Vivek
 

Vivek Goyal (11):
  kexec: Move segment verification code in a separate function
  resource: Provide new functions to walk through resources
  bin2c: Move bin2c in scripts/basic
  kernel: Build bin2c based on config option CONFIG_BUILD_BIN2C
  kexec: Make kexec_segment user buffer pointer a union
  kexec: A new system call, kexec_file_load, for in kernel kexec
  kexec: Create a relocatable object called purgatory
  kexec-bzImage: Support for loading bzImage using 64bit entry
  kexec: Provide a function to add a segment at fixed address
  kexec: Support for loading ELF x86_64 images
  kexec: Support for Kexec on panic using new system call

 arch/x86/Kbuild                      |    1 +
 arch/x86/Kconfig                     |    2 +
 arch/x86/Makefile                    |    6 +
 arch/x86/include/asm/crash.h         |    9 +
 arch/x86/include/asm/kexec-bzimage.h |   11 +
 arch/x86/include/asm/kexec-elf.h     |   11 +
 arch/x86/include/asm/kexec.h         |   51 ++
 arch/x86/kernel/Makefile             |    3 +
 arch/x86/kernel/crash.c              |  574 ++++++++++++++
 arch/x86/kernel/kexec-bzimage.c      |  255 +++++++
 arch/x86/kernel/kexec-elf.c          |  231 ++++++
 arch/x86/kernel/machine_kexec.c      |  149 ++++
 arch/x86/kernel/machine_kexec_64.c   |  173 +++++
 arch/x86/purgatory/Makefile          |   35 +
 arch/x86/purgatory/entry64.S         |  111 +++
 arch/x86/purgatory/purgatory.c       |  103 +++
 arch/x86/purgatory/setup-x86_32.S    |   29 +
 arch/x86/purgatory/setup-x86_64.S    |   68 ++
 arch/x86/purgatory/sha256.c          |  315 ++++++++
 arch/x86/purgatory/sha256.h          |   33 +
 arch/x86/purgatory/stack.S           |   29 +
 arch/x86/syscalls/syscall_64.tbl     |    1 +
 include/linux/ioport.h               |    6 +
 include/linux/kexec.h                |  102 ++-
 include/linux/syscalls.h             |    3 +
 include/uapi/linux/kexec.h           |    4 +
 init/Kconfig                         |    5 +
 kernel/Makefile                      |    2 +-
 kernel/kexec.c                       | 1356 +++++++++++++++++++++++++++++++---
 kernel/resource.c                    |  108 ++-
 kernel/sys_ni.c                      |    1 +
 scripts/Makefile                     |    1 -
 scripts/basic/Makefile               |    1 +
 scripts/basic/bin2c.c                |   36 +
 scripts/bin2c.c                      |   36 -
 35 files changed, 3701 insertions(+), 160 deletions(-)
 create mode 100644 arch/x86/include/asm/crash.h
 create mode 100644 arch/x86/include/asm/kexec-bzimage.h
 create mode 100644 arch/x86/include/asm/kexec-elf.h
 create mode 100644 arch/x86/kernel/kexec-bzimage.c
 create mode 100644 arch/x86/kernel/kexec-elf.c
 create mode 100644 arch/x86/kernel/machine_kexec.c
 create mode 100644 arch/x86/purgatory/Makefile
 create mode 100644 arch/x86/purgatory/entry64.S
 create mode 100644 arch/x86/purgatory/purgatory.c
 create mode 100644 arch/x86/purgatory/setup-x86_32.S
 create mode 100644 arch/x86/purgatory/setup-x86_64.S
 create mode 100644 arch/x86/purgatory/sha256.c
 create mode 100644 arch/x86/purgatory/sha256.h
 create mode 100644 arch/x86/purgatory/stack.S
 create mode 100644 scripts/basic/bin2c.c
 delete mode 100644 scripts/bin2c.c

-- 
1.8.4.2

