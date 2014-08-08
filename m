Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaHHRpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 13:45:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaHHRpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 13:45:07 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v4 0/17] x86: entry.S optimizations
Date: Fri,  8 Aug 2014 19:44:23 +0200
Message-Id: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 4 of the patchset.

Please consider applying at least two first patches, they are definitely safe,
and the second one fixes a latent bug.

Changes since v3:
= simplified iret stack handling on SYSCALL64 fastpath:
  got rid of FIXUP_TOP_OF_STACK and RESTORE_TOP_OF_STACK,
  got rid of thread_struct::usersp.
= save_paranoid cleaned up.
= folded test_in_nmi and IA32_ARG_FIXUP macros into their users.
= got rid of KERNEL_STACK_OFFSET.
= other small optimizations.
= fixed comments about SYSCALL from 32bit mode.

Changes since v2:
= fixed pre-existing latent bug: wrong symbolic constant usage: R11->ARGOFFSET
= per Oleg's request, added comments about various syscall instructions

Changes since v1 (mainly in patch 4/6):
= Reverted changes to "partial pt_regs saving" on interrupt path.
= Folded PARTIAL_FRAME macro into DEFAULT_FRAME. Patch v1
  had a bug (incorrect dwarf debug info generation).
= Corrected more comments.
= Added use of SAVE_* macros to error_entry and save_paranoid.
= Added another cleanup rename patch.

TODO:
= "idtentry" macro uses a subroutine to factor out a largish
  common code block. "interrupt" macro inlines a similar
  block every time (~20 instances). Maybe factor it out?

CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>
CC: Andy Lutomirski <luto@amacapital.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: X86 ML <x86@kernel.org>
CC: Alexei Starovoitov <ast@plumgrid.com>
CC: Will Drewry <wad@chromium.org>
CC: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org


Denys Vlasenko (17):
  x86: entry_64.S: delete unused code
  x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
  x86: open-code register save/restore in trace_hardirqs thunks
  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
  x86: entry_64.S: always allocate complete "struct pt_regs"
  x86: mass removal of ARGOFFSET
  x86: rename some macros and labels, no code changes
  x86: add comments about various syscall instructions, no code changes
  x86: entry_64.S: move save_paranoid and ret_from_fork closer to their
    users
  x86: entry_64.S: rename save_paranoid to paranoid_entry, no code
    changes
  x86: entry_64.S: fold test_in_nmi macro into its only user
  x86: get rid of KERNEL_STACK_OFFSET
  x86: ia32entry.S: fold IA32_ARG_FIXUP macro into its callers
  x86: ia32entry.S: use mov instead of push/pop where possible
  x86: code shrink in paranoid_exit
  x86: entry_64.S: trivial optimization for ENOSYS
  x86: simplify iret stack handling on SYSCALL64 fastpath

 arch/x86/ia32/ia32entry.S              | 366 +++++++++--------
 arch/x86/include/asm/calling.h         | 226 +++++------
 arch/x86/include/asm/compat.h          |   2 +-
 arch/x86/include/asm/irqflags.h        |   4 +-
 arch/x86/include/asm/processor.h       |   1 -
 arch/x86/include/asm/ptrace.h          |  21 +-
 arch/x86/include/asm/thread_info.h     |   8 +-
 arch/x86/include/uapi/asm/ptrace-abi.h |  16 +-
 arch/x86/include/uapi/asm/ptrace.h     |  13 +-
 arch/x86/kernel/cpu/common.c           |   2 +-
 arch/x86/kernel/entry_64.S             | 708 ++++++++++++++-------------------
 arch/x86/kernel/preempt.S              |  16 +-
 arch/x86/kernel/process_32.c           |   3 +-
 arch/x86/kernel/process_64.c           |  11 +-
 arch/x86/kernel/smpboot.c              |   3 +-
 arch/x86/lib/thunk_64.S                |  29 +-
 arch/x86/syscalls/syscall_64.tbl       |   2 +-
 arch/x86/um/sys_call_table_64.c        |   2 +-
 arch/x86/xen/smp.c                     |   3 +-
 19 files changed, 699 insertions(+), 737 deletions(-)

-- 
1.8.1.4

