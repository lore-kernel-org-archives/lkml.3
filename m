Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbaK1F1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 00:27:08 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:46985 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaK1F1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 00:27:06 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com
Cc: dsaxena@linaro.org, arndb@arndb.de, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v10 0/6] arm64: add seccomp support
Date: Fri, 28 Nov 2014 14:26:33 +0900
Message-Id: <1417152399-32717-1-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series enables secure computing (system call filtering) on arm64,
and contains related enhancements and bug fixes.

  NOTE: This versions contain a workaround against possible BUG_ON() failure
  at audit_syscall_exit(), but doesn't contain an extra optimization, as I
  submitted for arm, of excluding syscall enter/exit tracing against invalid
  system calls due to an issue that I reported in:
       http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/292170.html

The code was tested on ARMv8 fast model with 64-bit/32-bit userspace using:
 * libseccomp v2.1.1 with modifications for arm64, especially its "live"
   tests: No.20, 21 and 24.
 * modified version of Kees' seccomp test for 'changing/skipping a syscall'
   and seccomp() system call
 * in-house tests for 'changing/skipping a system call' by tracing with
   ptrace(SETREGSET, NT_SYSTEM_CALL) (that is, not via seccomp filter)'
with and without audit tracing.


Changes v9 -> v10:
* modified system_call_get() for big-endian build [1/6]
* modified the way to check for syscall(-1) on syscall entry [2/6]

Changes v8 -> v9:
* removed a restriction on syscall(-1) by setting a default errno [2/6]

Changes v7 -> v8:
* changed an interface of changing a syscall number from ptrace(SET_SYSCALL)
  to ptrace(SETREGSET, NT_ARM_SYSTEM_CALL) [1/6]
* removed IS_SKILL_SYSCALL macro [2/6]
* clarified comments in syscall_trace_enter() [2/6]
* changed unsigned int to compat_uint_t in compat_siginfo._sigsys [5/6]
* moved to a new calling interface of secure_computing(void) [6/6]

Changes v6 -> v7:
* simplified the condition of checking for user-issued syscall(-1) at
  syscall_trace_enter() [2/6]
* defines __NR_seccomp_sigreturn only if arch-specific def doesn't exist.
  As Kees suggests, this is necessary for x86 and others. [3/6]
* removed "#ifdef __ARCH_SIGSYS" which is always true on arm64. [5/6]
* changed to call syscall_trace_exit() even if secure_computing fails. [6/6]
  In v6, syscall_trace_enter() returns RET_SYSCALL_SKIP_TRACE (== -2) and
  skips syscall_trace_exit() to minimize the overhead, but this case can be
  easily confused with user-issued (and invalid) syscall(-2).
  Anyway, this is now a consistent behavior with arm and other archs.

Changes v5 -> v6:
* rebased to v3.17-rc
* changed the interface of changing/skipping a system call from re-writing
  x8 register [v5 1/3] to using dedicated PTRACE_SET_SYSCALL command
  [1/6, 2/6]
  Patch [1/6] contains a checkpatch error around a switch statement, but it
  won't be fixed as in compat_arch_ptrace().
* added a new system call, seccomp(), for compat task [4/6]
* added SIGSYS siginfo for compat task [5/6]
* changed to always execute audit exit tracing to avoid OOPs [2/6, 6/6]

Changes v4 -> v5:
* rebased to v3.16-rc
* add patch [1/3] to allow ptrace to change a system call
  (please note that this patch should be applied even without seccomp.)

Changes v3 -> v4:
* removed the following patch and moved it to "arm64: prerequisites for
  audit and ftrace" patchset since it is required for audit and ftrace in
  case of !COMPAT, too.
  "arm64: is_compat_task is defined both in asm/compat.h and linux/compat.h"

Changes v2 -> v3:
* removed unnecessary 'type cast' operations [2/3]
* check for a return value (-1) of secure_computing() explicitly [2/3]
* aligned with the patch, "arm64: split syscall_trace() into separate
  functions for enter/exit" [2/3]
* changed default of CONFIG_SECCOMP to n [2/3]

Changes v1 -> v2:
* added generic seccomp.h for arm64 to utilize it [1,2/3] 
* changed syscall_trace() to return more meaningful value (-EPERM)
  on seccomp failure case [2/3]
* aligned with the change in "arm64: make a single hook to syscall_trace()
  for all syscall features" v2 [2/3]
* removed is_compat_task() definition from compat.h [3/3]

AKASHI Takahiro (6):
  arm64: ptrace: add NT_ARM_SYSTEM_CALL regset
  arm64: ptrace: allow tracer to skip a system call
  asm-generic: add generic seccomp.h for secure computing mode 1
  arm64: add seccomp syscall for compat task
  arm64: add SIGSYS siginfo for compat task
  arm64: add seccomp support

 arch/arm64/Kconfig                |   14 +++++++++++++
 arch/arm64/include/asm/compat.h   |    7 +++++++
 arch/arm64/include/asm/seccomp.h  |   25 +++++++++++++++++++++++
 arch/arm64/include/asm/unistd.h   |    3 +++
 arch/arm64/include/asm/unistd32.h |    3 ++-
 arch/arm64/kernel/entry.S         |   12 +++++++++--
 arch/arm64/kernel/ptrace.c        |   40 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/signal32.c      |    6 ++++++
 include/asm-generic/seccomp.h     |   30 ++++++++++++++++++++++++++++
 include/uapi/linux/elf.h          |    1 +
 10 files changed, 138 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/seccomp.h
 create mode 100644 include/asm-generic/seccomp.h

-- 
1.7.9.5

