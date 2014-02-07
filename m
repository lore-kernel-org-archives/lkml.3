Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaBGKTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:19:19 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37680 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaBGKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:19:17 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        gkulkarni@caviumnetworks.com, tim.bird@sonymobile.com
Cc: arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v3 0/6] arm64: Add ftrace support
Date: Fri,  7 Feb 2014 19:18:50 +0900
Message-Id: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my third version of patchset for ftrace support.
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

AKASHI Takahiro (6):
  arm64: Add ftrace support
  arm64: ftrace: Add dynamic ftrace support
  arm64: ftrace: Add CALLER_ADDRx macros
  ftrace: Add arm64 support to recordmcount
  arm64: ftrace: Add system call tracepoint
  arm64: Add 'notrace' attribute to unwind_frame() for ftrace

 arch/arm64/Kconfig                 |    6 +
 arch/arm64/include/asm/ftrace.h    |   54 +++++++++
 arch/arm64/include/asm/syscall.h   |    1 +
 arch/arm64/include/asm/unistd.h    |    2 +
 arch/arm64/kernel/Makefile         |    9 +-
 arch/arm64/kernel/arm64ksyms.c     |    4 +
 arch/arm64/kernel/entry-ftrace.S   |  215 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/ftrace.c         |  177 +++++++++++++++++++++++++++++
 arch/arm64/kernel/ptrace.c         |    5 +
 arch/arm64/kernel/return_address.c |   55 +++++++++
 arch/arm64/kernel/stacktrace.c     |    2 +-
 scripts/recordmcount.c             |    4 +
 scripts/recordmcount.pl            |    5 +
 13 files changed, 537 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/include/asm/ftrace.h
 create mode 100644 arch/arm64/kernel/entry-ftrace.S
 create mode 100644 arch/arm64/kernel/ftrace.c
 create mode 100644 arch/arm64/kernel/return_address.c

-- 
1.7.9.5

