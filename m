Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaEXHBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:01:53 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:37907 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaEXHBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:01:52 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCHv2 00/24] ILP32 Support in ARM64
Date: Sat, 24 May 2014 00:01:21 -0700
Message-Id: <1400914905-9594-1-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New version of the patches with documentation, signal changes are simplified, using less compat syscalls and splitting up the patches so it is easier to review.  I have tested LTP on both LP64 and ILP32.  There is a few LTP failures but they are due to LTP being incorrect (sigaction structure in glibc is not the one which is used by the kernel)  I have not yet tested LTP for AARCH32 but I have done simple testing of AARCH32 so an executable still runs.  Each patch has been tested seperately though ILP32 won't fully work until the last patch has been added.

Thanks,
Andrew Pinski

Andrew Pinski (24):
  ARM64: Force LP64 to compile the kernel.
  ARM64: Rename COMPAT to AARCH32_EL0 in Kconfig.
  ARM64: Change some CONFIG_COMPAT over to use CONFIG_AARCH32_EL0
    instead.
  ARM64:ILP32: Set kernel_long to long long so we can reuse most of the
    same syscalls as LP64.
  ARM64:UAPI: Set the correct __BITS_PER_LONG for ILP32.
  Allow for some signal structures to be the same between a 32bit ABI
    and the 64bit ABI.
  ARM64:ILP32: Use the same size and layout of the signal structures
    for ILP32 as for LP64.
  Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to
    avoid confusion of not splitting the registers.
  ARM64:ILP32: Use the same syscall names as LP64.
  ARM64: Introduce is_a32_task and is_a32_thread. Use them in the
    correct locations.
  ARM64: Add ARM64_ILP32 to Kconfig.
  ARM64: Add is_ilp32_compat_task and is_ilp32_compat_thread and
    TIF_32BIT_AARCH64.
  Drivers:input: Use is_compat_task for ARM64 also.
  ARM64:ILP32: COMPAT_USE_64BIT_TIME is true for ILP32 tasks.
  ARM64:ILP32: Use the non compat HWCAP for ILP32.
  ARM64:ILP32 use the standard start_thread for ILP32 so the processor
    state is not AARCH32.
  ARM64:ILP32: Support core dump for ILP32.
  ARM64: Add loading of ILP32 binaries.
  ARM64: Add vdso for ILP32 and use it for the signal return.
  ptrace: Allow compat to use the native siginfo.
  ARM64:ILP32: The native siginfo is used instead of the compat
    siginfo.
  ARM64:ILP32: Use a seperate syscall table as a few syscalls need to
    be using the compat syscalls.
  ARM64:ILP32: Fix signal return for ILP32 when the user modified the
    signal stack.
  Add documentation about ARM64 ILP32 ABI.

 Documentation/arm64/ilp32.txt                 |   57 ++++++++
 arch/arm64/Kconfig                            |   15 ++-
 arch/arm64/Makefile                           |    4 +
 arch/arm64/include/asm/Kbuild                 |    1 -
 arch/arm64/include/asm/arch_timer.h           |    2 +-
 arch/arm64/include/asm/compat.h               |   65 +++++++++-
 arch/arm64/include/asm/elf.h                  |  101 +++++++++++++--
 arch/arm64/include/asm/fpsimd.h               |    2 +-
 arch/arm64/include/asm/hwcap.h                |   12 ++-
 arch/arm64/include/asm/memory.h               |    2 +-
 arch/arm64/include/asm/processor.h            |   11 ++-
 arch/arm64/include/asm/ptrace.h               |    2 +-
 arch/arm64/include/asm/signal32.h             |    2 +
 arch/arm64/include/asm/stat.h                 |    2 +
 arch/arm64/include/asm/syscalls.h             |    4 +
 arch/arm64/include/asm/thread_info.h          |    3 +-
 arch/arm64/include/asm/unistd.h               |    6 +-
 arch/arm64/include/asm/vdso.h                 |    4 +
 arch/arm64/include/uapi/asm/bitsperlong.h     |    7 +-
 arch/arm64/include/uapi/asm/posix_types.h     |   12 ++
 arch/arm64/include/uapi/asm/siginfo.h         |   21 +++
 arch/arm64/include/uapi/asm/signal.h          |   32 +++++
 arch/arm64/include/uapi/asm/unistd.h          |    7 +
 arch/arm64/kernel/Makefile                    |    8 +-
 arch/arm64/kernel/asm-offsets.c               |    2 +-
 arch/arm64/kernel/entry.S                     |   19 ++-
 arch/arm64/kernel/head.S                      |    2 +-
 arch/arm64/kernel/hw_breakpoint.c             |    6 +-
 arch/arm64/kernel/process.c                   |    6 +-
 arch/arm64/kernel/ptrace.c                    |   51 +++++---
 arch/arm64/kernel/signal.c                    |   33 +++++-
 arch/arm64/kernel/sys_ilp32.c                 |  175 +++++++++++++++++++++++++
 arch/arm64/kernel/traps.c                     |    4 +-
 arch/arm64/kernel/vdso-ilp32/.gitignore       |    2 +
 arch/arm64/kernel/vdso-ilp32/Makefile         |   72 ++++++++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     |   33 +++++
 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S |  100 ++++++++++++++
 arch/arm64/kernel/vdso.c                      |   59 +++++++--
 drivers/input/input-compat.h                  |    2 +-
 include/linux/compat.h                        |    4 +
 include/uapi/asm-generic/siginfo.h            |   17 ++-
 include/uapi/asm-generic/signal.h             |   27 ++++-
 include/uapi/asm-generic/unistd.h             |    5 +-
 kernel/ptrace.c                               |   24 +++-
 44 files changed, 935 insertions(+), 90 deletions(-)
 create mode 100644 Documentation/arm64/ilp32.txt
 create mode 100644 arch/arm64/include/uapi/asm/posix_types.h
 create mode 100644 arch/arm64/kernel/sys_ilp32.c
 create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
 create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
 create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S

-- 
1.7.2.5

