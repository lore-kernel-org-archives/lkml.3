Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaICVTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:19:36 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:43530 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaICVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:19:27 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCHv3 00/24] ILP32 support in ARM64
Date: Wed,  3 Sep 2014 14:18:54 -0700
Message-Id: <1409779158-30963-1-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version with all of the requested changes.  Updated to the latest sources.

Notable changes from the previous versions:
VDSO code has been factored out to be easier to understand and easier to maintain.
Move the config option to the last thing that gets added.
Added some extra COMPAT_* macros for core dumping for easier usage.


Andrew Pinski (24):
  ARM64: Force LP64 to compile the kernel
  ARM64: Rename COMPAT to AARCH32_EL0 in Kconfig
  ARM64: Change some CONFIG_COMPAT over to use CONFIG_AARCH32_EL0
    instead
  ARM64:ILP32: Set kernel_long to long long so we can reuse most of the
    same syscalls as LP64
  ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32
  Allow for some signal structures to be the same between a 32bit ABI
    and the 64bit ABI
  ARM64:ILP32: Use the same size and layout of the signal structures
    for ILP32 as for LP64
  Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to
    avoid confusion of not splitting the registers
  ARM64:ILP32: Use the same syscall names as LP64
  ARM64: Introduce is_a32_task/is_a32_thread and TIF_AARCH32 and use
    them in the correct locations
  ARM64: Add is_ilp32_compat_task and is_ilp32_compat_thread
  ARM64:ILP32: COMPAT_USE_64BIT_TIME is true for ILP32 tasks
  ARM64:ILP32: Use the non compat HWCAP for ILP32
  ARM64:ILP32 use the standard start_thread for ILP32 so the processor
    state is not AARCH32
  compat_binfmt_elf: coredump: Allow some core dump macros be
    overridden for compat.
  ARM64:ILP32: Support core dump for ILP32
  ARM64: Add loading of ILP32 binaries
  ARM64: Add vdso for ILP32 and use it for the signal return
  ptrace: Allow compat to use the native siginfo
  ARM64:ILP32: The native siginfo is used instead of the compat siginfo
  ARM64:ILP32: Use a seperate syscall table as a few syscalls need to
    be using the compat syscalls
  ARM64:ILP32: Fix signal return for ILP32 when the user modified the
    signal stack
  ARM64: Add ARM64_ILP32 to Kconfig
  Add documentation about ARM64 ILP32 ABI

 Documentation/arm64/ilp32.txt                 |   57 +++++++
 arch/arm64/Kconfig                            |   15 ++-
 arch/arm64/Makefile                           |    4 +
 arch/arm64/include/asm/arch_timer.h           |    2 +-
 arch/arm64/include/asm/compat.h               |   59 ++++++++
 arch/arm64/include/asm/elf.h                  |  100 ++++++++++++-
 arch/arm64/include/asm/fpsimd.h               |    2 +-
 arch/arm64/include/asm/hwcap.h                |    2 -
 arch/arm64/include/asm/processor.h            |   11 ++
 arch/arm64/include/asm/ptrace.h               |    2 +-
 arch/arm64/include/asm/signal32.h             |    4 +-
 arch/arm64/include/asm/stat.h                 |    4 +-
 arch/arm64/include/asm/syscalls.h             |    4 +
 arch/arm64/include/asm/thread_info.h          |    1 +
 arch/arm64/include/asm/unistd.h               |    6 +-
 arch/arm64/include/asm/vdso.h                 |    4 +
 arch/arm64/include/uapi/asm/bitsperlong.h     |    9 +-
 arch/arm64/include/uapi/asm/posix_types.h     |    8 +-
 arch/arm64/include/uapi/asm/siginfo.h         |   33 ++++
 arch/arm64/include/uapi/asm/signal.h          |   34 +++++
 arch/arm64/include/uapi/asm/unistd.h          |    6 +
 arch/arm64/kernel/Makefile                    |    8 +-
 arch/arm64/kernel/asm-offsets.c               |    2 +-
 arch/arm64/kernel/entry.S                     |   19 ++-
 arch/arm64/kernel/head.S                      |    2 +-
 arch/arm64/kernel/hw_breakpoint.c             |    7 +-
 arch/arm64/kernel/process.c                   |    6 +-
 arch/arm64/kernel/ptrace.c                    |   52 +++++--
 arch/arm64/kernel/signal.c                    |   38 +++++-
 arch/arm64/kernel/sys_ilp32.c                 |  195 +++++++++++++++++++++++++
 arch/arm64/kernel/traps.c                     |    4 +-
 arch/arm64/kernel/vdso-ilp32/.gitignore       |    2 +
 arch/arm64/kernel/vdso-ilp32/Makefile         |   72 +++++++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     |   33 ++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S |   98 +++++++++++++
 arch/arm64/kernel/vdso.c                      |   74 ++++++++--
 fs/compat_binfmt_elf.c                        |   17 ++
 include/linux/compat.h                        |    4 +
 include/uapi/asm-generic/siginfo.h            |   17 ++-
 include/uapi/asm-generic/signal.h             |   27 +++-
 include/uapi/asm-generic/unistd.h             |    6 +-
 kernel/ptrace.c                               |   25 +++-
 42 files changed, 989 insertions(+), 86 deletions(-)
 create mode 100644 Documentation/arm64/ilp32.txt
 create mode 100644 arch/arm64/kernel/sys_ilp32.c
 create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S

-- 
1.7.2.5

