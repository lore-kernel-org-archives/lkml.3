Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758419AbaD3Jz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:55:26 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57172 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbaD3JzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:55:23 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v8 0/8] arm64: Add ftrace support
Date: Wed, 30 Apr 2014 18:54:28 +0900
Message-Id: <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements a function tracer on arm64.
There was another implementation from Cavium network, but both of us agreed
to use my patchset as future base. He is supposed to review this code, too.

The only issue that I had some concern on was "fault protection" code
in prepare_ftrace_return(). With discussions with Steven and Tim (as author
of arm ftrace), I removed that code since I'm not quite sure about possibility
of "fault" occurrences in this function.

The code is tested on ARMv8 Fast Model with the following tracers & events:
     function tracer with dynamic ftrace
     function graph tracer with dynamic ftrace
     syscall tracepoint (but only for AArch64 tasks)
     irqsoff & preemptirqsoff (which use CALLER_ADDRx)
and also verified with in-kernel tests, FTRACE_SELFTEST, FTRACE_STARTUP_TEST
and EVENT_TRACE_TEST_SYSCALLS.

Prerequisites are:
 * "arm64: make a single hook to syscall_trace() for all syscall features" patch
 * "arm64: split syscall_trace() into separate functions for enter/exit" patch
 * "arm64: Add regs_return_value() in syscall.h" patch
 * "arm64: is_compat_task is defined both in asm/compat.h and
    linux/compat.h" patch

Please be careful:
* Patch [3/7] gets warnings from checkpatch, but they are based on the
  original's coding style.
* Patch [7/7] may conflict with my audit patch because both changes the same
  location in syscall_trace_enter/exit(). I expect the functions are called
  in this order:
  On entry,
     * tracehook_report_syscall(ENTER)
     * trace_sys_enter()
     * audit_syscall_entry()
  On exit,
     * audit_sysscall_exit()
     * trace_sys_exit()
     * tracehook_report_syscall(EXIT) 

Changes from v7 to v8:
* rebased on 3.15-rc
* untabified the ascii art in entry-ftrace.S [5/8]
* added patch [1/8] in order to make CALLER_ADDRx() macro more generic across
  most architectures [1,7/8]

Changes from v6 to v7:
* changed to use gpfx variable instead of defining altmcount in recordmcount.c
  [3/7]
* declared return_to_handler using ENTRY/END macros [4/7]
* changed to use u32 instead of int as instruction words, and simplified
  ftrace_modify_graph_caller() [5/7]
* simplified arch_trace_is_compat_call() for readability [7/7]
* added the following patch to prerequisite list,
  "arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h"
  and changed to use linux/compat.h instead of asm/compat.h in asm/ftrace.h
  to avoid compile errors against some files (ie. do_mounts.c and etc) if
  FTRACE & !COMPAT. [7/7]

Changes from v5 to v6:
* changed the order of patches to avoid any bisect error (I have not tried
  though)
* added EM_AARCH64 and R_AARCH64_ABS64 definitions in scripts/recordmcount.c
  just in case elf.h on host machine doesn't have them. [3/7]
* updated a frame pointer (x29) in _mcount() to make it look like a normal
  function [4/7]
* aligned with the patch, "arm64: split syscall_trace() into separate
  functions for enter/exit" [7/7]
* defined ARCH_TRACE_IGNORE_COMPAT_SYSCALLS in order not to trace compat
  syscalls [7/7]

Chnages from v4 to v5:
* improved the description of stack layout [1/7]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v3 [5/7]

Changes from v3 to v4:
* removed unnecessary "#ifdef" [1,2/7]
* changed stack depth from 48B to 16B in mcount()/ftrace_caller() (a bug) [1/7]
* changed MCOUNT_INSN_SIZE to AARCH64_INSN_SIZE [1,7/7]
* added a guard againt TIF_SYSCALL_TRACEPOINT [5/7]
* corrected the second argument passed to trace_sys_exit() (a bug) [5/7]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v2 [5/7]

Changes from v2 to v3:
* optimized register usages in asm (by not saving x0, x1, and x2)
* removed "fault protection" code in prepare_ftrace_return()
* rewrote ftrace_modify_code() using "hotpatch" interfaces
* revised descriptions in comments

Changes from v1 to v2:
* splitted one patch into some pieces for easier review
  (especially function tracer + dynamic ftrace + CALLER_ADDRx)
* put return_address() in a separate file
* renamed __mcount to _mcount (it was my mistake)
* changed stackframe handling to get parent's frame pointer
* removed ARCH_SUPPORTS_FTRACE_OPS
* switched to "hotpatch" interfaces from Huawai
* revised descriptions in comments

AKASHI Takahiro (7):
  arm64: add __ASSEMBLY__ in asm/insn.h
  arm64: Add 'notrace' attribute to unwind_frame() for ftrace
  ftrace: Add arm64 support to recordmcount
  arm64: Add ftrace support
  arm64: ftrace: Add dynamic ftrace support
  arm64: ftrace: Add CALLER_ADDRx macros
  arm64: ftrace: Add system call tracepoint

AKASHI Takahiro (8):
  ftrace: make CALLER_ADDRx macros more generic
  arm64: add __ASSEMBLY__ in asm/insn.h
  arm64: Add 'notrace' attribute to unwind_frame() for ftrace
  ftrace: Add arm64 support to recordmcount
  arm64: Add ftrace support
  arm64: ftrace: Add dynamic ftrace support
  arm64: ftrace: Add CALLER_ADDRx macros
  arm64: ftrace: Add system call tracepoint

 arch/arm/include/asm/ftrace.h      |   10 +-
 arch/arm64/Kconfig                 |    6 +
 arch/arm64/include/asm/ftrace.h    |   59 ++++++++++
 arch/arm64/include/asm/insn.h      |    2 +
 arch/arm64/include/asm/syscall.h   |    1 +
 arch/arm64/include/asm/unistd.h    |    2 +
 arch/arm64/kernel/Makefile         |    7 +-
 arch/arm64/kernel/arm64ksyms.c     |    4 +
 arch/arm64/kernel/entry-ftrace.S   |  218 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/ftrace.c         |  176 +++++++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c         |    9 ++
 arch/arm64/kernel/return_address.c |   55 +++++++++
 arch/arm64/kernel/stacktrace.c     |    2 +-
 arch/blackfin/include/asm/ftrace.h |   11 +-
 arch/parisc/include/asm/ftrace.h   |   10 +-
 arch/sh/include/asm/ftrace.h       |   10 +-
 arch/xtensa/include/asm/ftrace.h   |   14 +--
 include/linux/ftrace.h             |   34 +++---
 scripts/recordmcount.c             |    7 ++
 scripts/recordmcount.pl            |    5 +
 20 files changed, 577 insertions(+), 65 deletions(-)
 create mode 100644 arch/arm64/include/asm/ftrace.h
 create mode 100644 arch/arm64/kernel/entry-ftrace.S
 create mode 100644 arch/arm64/kernel/ftrace.c
 create mode 100644 arch/arm64/kernel/return_address.c

-- 
1.7.9.5

