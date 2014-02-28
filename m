Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaB1FTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 00:19:15 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44343 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaB1FTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 00:19:14 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v5 0/7] arm64: Add ftrace support
Date: Fri, 28 Feb 2014 14:18:37 +0900
Message-Id: <1393564724-3966-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
References: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
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
     syscall tracepoint
     irqsoff & preemptirqsoff (which use CALLER_ADDRx)
and also verified with in-kernel tests, FTRACE_SELFTEST, FTRACE_STARTUP_TEST
and EVENT_TRACE_TEST_SYSCALLS.

Prerequisites are:
 * "arm64: Add regs_return_value() in syscall.h"
 * "arm64: make a single hook to syscall_trace() for all syscall features" patch

Please be careful:
* elf.h on cross-build host must have AArch64 definitions, EM_AARCH64 and
  R_AARCH64_ABS64, to compile recordmcount utility. See [4/6].
  [4/6] also gets warnings from checkpatch, but they are based on the
  original's coding style.
* This patch may conflict with my audit patch because both changes the same
  location in syscall_trace(). I expect the functions are called in this
  order:
  On entry,
     * tracehook_report_syscall(ENTER)
     * trace_sys_enter()
     * audit_syscall_entry()
  On exit,
     * audit_sysscall_exit()
     * trace_sys_exit()
     * tracehook_report_syscall(EXIT) 

Changes from v1 to v2:
* splitted one patch into some pieces for easier review
  (especially function tracer + dynamic ftrace + CALLER_ADDRx)
* put return_address() in a separate file
* renamed __mcount to _mcount (it was my mistake)
* changed stackframe handling to get parent's frame pointer
* removed ARCH_SUPPORTS_FTRACE_OPS
* switched to "hotpatch" interfaces from Huawai
* revised descriptions in comments

Changes from v2 to v3:
* optimized register usages in asm (by not saving x0, x1, and x2)
* removed "fault protection" code in prepare_ftrace_return()
* rewrote ftrace_modify_code() using "hotpatch" interfaces
* revised descriptions in comments

Changes from v3 to v4:
* removed unnecessary "#ifdef" [1,2/7]
* changed stack depth from 48B to 16B in mcount()/ftrace_caller() (a bug) [1/7]
* changed MCOUNT_INSN_SIZE to AARCH64_INSN_SIZE [1,7/7]
* added a guard againt TIF_SYSCALL_TRACEPOINT [5/7]
* corrected the second argument passed to trace_sys_exit() (a bug) [5/7]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v2 [5/7]

Chnages from v4 to v5:
* improved the description of stack layout [1/7]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v3 [5/7]

AKASHI Takahiro (7):
  arm64: Add ftrace support
  arm64: ftrace: Add dynamic ftrace support
  arm64: ftrace: Add CALLER_ADDRx macros
  ftrace: Add arm64 support to recordmcount
  arm64: ftrace: Add system call tracepoint
  arm64: Add 'notrace' attribute to unwind_frame() for ftrace
  arm64: add __ASSEMBLY__ in asm/insn.h

 arch/arm64/Kconfig                 |    6 +
 arch/arm64/include/asm/ftrace.h    |   52 +++++++++
 arch/arm64/include/asm/insn.h      |    2 +
 arch/arm64/include/asm/syscall.h   |    1 +
 arch/arm64/include/asm/unistd.h    |    2 +
 arch/arm64/kernel/Makefile         |    7 +-
 arch/arm64/kernel/arm64ksyms.c     |    4 +
 arch/arm64/kernel/entry-ftrace.S   |  217 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/ftrace.c         |  177 +++++++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c         |   52 +++++----
 arch/arm64/kernel/return_address.c |   55 +++++++++
 arch/arm64/kernel/stacktrace.c     |    2 +-
 scripts/recordmcount.c             |    4 +
 scripts/recordmcount.pl            |    5 +
 14 files changed, 562 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm64/include/asm/ftrace.h
 create mode 100644 arch/arm64/kernel/entry-ftrace.S
 create mode 100644 arch/arm64/kernel/ftrace.c
 create mode 100644 arch/arm64/kernel/return_address.c

-- 
1.7.9.5

