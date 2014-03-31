Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaCaFkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 01:40:53 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:33127 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaCaFkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 01:40:51 -0400
Date: Mon, 31 Mar 2014 07:40:46 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [GIT PULL] s390 compat wrapper rework
Message-ID: <20140331054046.GA5079@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033105-8372-0000-0000-000009273AEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git compat

to get the s390 compat system call wrapper simplification work.

The intention of this work is to get rid of all hand written assembly compat
system call wrappers on s390, which perform proper sign or zero extension, or
pointer conversion of compat system call parameters.  Instead all of this
should be done with C code e.g. by using Al's COMPAT_SYSCALL_DEFINEx() macro.

Therefore all common code and s390 specific compat system calls have been
converted to the COMPAT_SYSCALL_DEFINEx() macro.

In order to generate correct code all compat system calls may only have e.g.
compat_ulong_t parameters, but no unsigned long parameters. Those patches
which change parameter types from unsigned long to compat_ulong_t parameters
are separate in this series, but shouldn't cause any harm.

The only compat system calls which intentionally have 64 bit parameters
(preadv64 and pwritev64) in support of the x86/32 ABI haven't been changed,
but are now only available if an architecture defines
__ARCH_WANT_COMPAT_SYS_PREADV64/PWRITEV64.

System calls which do not have a compat variant but still need proper zero
extension on s390, like e.g. "long sys_brk(unsigned long brk)" will get a
proper wrapper function with the new s390 specific COMPAT_SYSCALL_WRAPx()
macro:

COMPAT_SYSCALL_WRAP1(brk, unsigned long, brk);

which generates the following code (simplified):

asmlinkage long sys_brk(unsigned long brk);
asmlinkage long compat_sys_brk(long brk)
{
	return sys_brk((u32)brk);
}

Given that the C file which contains all the COMPAT_SYSCALL_WRAP lines
includes both linux/syscall.h and linux/compat.h, it will generate build
errors, if the declaration of sys_brk() doesn't match, or if there exists a
non-matching compat_sys_brk() declaration.
In addition this will intentionally result in a link error if somewhere else a
compat_sys_brk() function exists, which probably should have been used
instead.
Two more BUILD_BUG_ONs make sure the size and type of each compat syscall
parameter can be handled correctly with the s390 specific macros.

I converted the compat system calls step by step to verify the generated code
is correct and matches the previous code. In fact it did not always match,
however that was always a bug in the hand written asm code.

In result we get less code, less bugs, and much more sanity checking.

Thanks,
Heiko


Heiko Carstens (44):
      compat: let architectures define __ARCH_WANT_COMPAT_SYS_GETDENTS64
      compat: add COMPAT_SYSCALL_DEFINE0 macro
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 1
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 2
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 3
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 4
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 5
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 6
      s390/compat: convert to COMPAT_SYSCALL_DEFINEx part 7
      s390/compat: convert system call wrappers to C part 01
      s390/compat: convert system call wrappers to C part 02
      s390/compat: convert system call wrappers to C part 03
      s390/compat: convert system call wrappers to C part 04
      s390/compat: convert system call wrappers to C part 05
      s390/compat: convert system call wrappers to C part 06
      s390/compat: convert system call wrappers to C part 07
      s390/compat: convert system call wrappers to C part 08
      s390/compat: convert system call wrappers to C part 09
      s390/compat: convert system call wrappers to C part 10
      s390/compat: convert system call wrappers to C part 11
      s390/compat: convert system call wrappers to C part 12
      s390/compat: convert system call wrappers to C part 13
      s390/compat: convert system call wrappers to C part 14
      s390/compat: convert system call wrappers to C part 15
      s390/compat: add sync_file_range and fallocate compat syscalls
      s390/compat: automatic zero, sign and pointer conversion of syscalls
      s390/compat: partial parameter conversion within syscall wrappers
      ipc/compat_sys_msgrcv: change msgtyp type from long to compat_long_t
      fs/compat: optional preadv64/pwrite64 compat system calls
      kernel/compat: convert to COMPAT_SYSCALL_DEFINE
      net/compat: convert to COMPAT_SYSCALL_DEFINE
      mm/compat: convert to COMPAT_SYSCALL_DEFINE
      security/compat: convert to COMPAT_SYSCALL_DEFINE
      fs/compat: convert to COMPAT_SYSCALL_DEFINE
      ipc/compat: convert to COMPAT_SYSCALL_DEFINE
      fs/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter types
      ipc/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter types
      net/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter types
      kexec/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter types
      mm/compat: convert to COMPAT_SYSCALL_DEFINE with changing parameter types
      s390/compat: build error for large compat syscall args
      s390/compat: get rid of compat wrapper assembly code
      compat: include linux/unistd.h within linux/compat.h
      s390/compat: add copyright statement

 arch/arm64/include/asm/unistd.h   |    1 +
 arch/mips/include/asm/unistd.h    |    1 -
 arch/s390/include/asm/compat.h    |    6 +-
 arch/s390/kernel/compat_linux.c   |  116 +--
 arch/s390/kernel/compat_linux.h   |   81 +--
 arch/s390/kernel/compat_signal.c  |    4 +-
 arch/s390/kernel/compat_wrapper.S | 1425 -------------------------------------
 arch/s390/kernel/compat_wrapper.c |  215 ++++++
 arch/s390/kernel/entry.h          |    6 +-
 arch/s390/kernel/syscalls.S       |  504 ++++++-------
 arch/x86/include/asm/unistd.h     |    3 +
 fs/compat.c                       |  121 ++--
 fs/compat_ioctl.c                 |    5 +-
 fs/exec.c                         |    6 +-
 fs/read_write.c                   |   36 +-
 include/linux/compat.h            |   63 +-
 include/linux/kexec.h             |    6 -
 include/linux/syscalls.h          |    2 +
 include/uapi/asm-generic/unistd.h |    1 +
 ipc/compat.c                      |   13 +-
 ipc/compat_mq.c                   |   32 +-
 kernel/compat.c                   |  100 +--
 kernel/kexec.c                    |    8 +-
 kernel/ptrace.c                   |    4 +-
 mm/mempolicy.c                    |   18 +-
 mm/process_vm_access.c            |   26 +-
 net/compat.c                      |   32 +-
 security/keys/compat.c            |    4 +-
 28 files changed, 835 insertions(+), 2004 deletions(-)
 delete mode 100644 arch/s390/kernel/compat_wrapper.S
 create mode 100644 arch/s390/kernel/compat_wrapper.c

