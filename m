Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaJOVPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 17:15:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbaJOVPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 17:15:14 -0400
Message-ID: <1413407712.15099.16.camel@redhat.com>
Subject: [GIT PULL] Audit changes for 3.18
From: Eric Paris <eparis@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Date: Wed, 15 Oct 2014 17:15:12 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this change across a whole bunch of arches really solves one basic
problem.  We want to audit when seccomp is killing a process.  seccomp
hooks in before the audit syscall entry code.  audit_syscall_entry took
as an argument the arch of the given syscall.  Since the arch is part of
what makes a syscall number meaningful it's an important part of the
record, but it isn't available when seccomp shoots the syscall...

For most arch's we have a better way to get the arch (syscall_get_arch)
So the solution was two fold:  Implement syscall_get_arch() everywhere
there is audit which didn't have it.  Use syscall_get_arch() in the
seccomp audit code.  Having syscall_get_arch() everywhere meant it was a
useless flag on the stack and we could get rid of it for the typical
syscall entry.

This of course results in a couple of merge issues.  Pretty easy, x86_64
appears to have removed the assembly we were editing and did it in C
code in arch/x86/kernel/ptrace.c::do_audit_syscall_entry().  arm
conflict is also obvious.

The other changes inside the audit system aren't grand, fixed some
records that had invalid spaces.  Better locking around the task comm
field.  Removing some dead functions and structs.  Make some things
static.  Really minor stuff.


The following changes since commit 19583ca584d6f574384e17fe7613dfaeadcdc4a6:

  Linux 3.16 (2014-08-03 15:25:02 -0700)

are available in the git repository at:

  git://git.infradead.org/users/eparis/audit.git master

for you to fetch changes up to 2991dd2b0117e864f394c826af6df144206ce0db:

  audit: rename audit_log_remove_rule to disambiguate for trees (2014-10-10 15:30:25 -0400)

----------------------------------------------------------------
AKASHI Takahiro (1):
      arm64: audit: Add audit hook in syscall_trace_enter/exit()

Burn Alting (1):
      audit: invalid op= values for rules

Eric Paris (11):
      audit: drop unused struct audit_rule definition
      SH: define syscall_get_arch() for superh
      UM: implement syscall_get_arch()
      Alpha: define syscall_get_arch()
      ARCH: AUDIT: implement syscall_get_arch for all arches
      ARCH: AUDIT: audit_syscall_entry() should not require the arch
      audit: fix build error when asm/syscall.h does not exist
      sparc: simplify syscall_get_arch()
      sparc: implement is_32bit_task
      audit: arm64: Remove the audit arch argument to audit_syscall_entry
      audit: WARN if audit_rule_change called illegally

Fabian Frederick (1):
      kernel/audit.c: use ARRAY_SIZE instead of sizeof/sizeof[0]

Guenter Roeck (1):
      next: openrisc: Fix build

Richard Guy Briggs (15):
      syscall.h: fix doc text for syscall_get_arch()
      audit: __audit_syscall_entry: ignore arch arg and call syscall_get_arch() directly
      audit: add arch field to seccomp event log
      audit: x86: drop arch from __audit_syscall_entry() interface
      audit: reduce scope of audit_net_id
      audit: reduce scope of audit_log_fcaps
      audit: use atomic_t to simplify audit_serial()
      audit: use union for audit_field values since they are mutually exclusive
      audit: set nlmsg_len for multicast messages.
      audit: correct AUDIT_GET_FEATURE return message type
      audit: remove open_arg() function that is never used
      audit: get comm using lock to avoid race in string printing
      audit: put rule existence check in canonical order
      audit: cull redundancy in audit_rule_change
      audit: rename audit_log_remove_rule to disambiguate for trees

Stephen Rothwell (1):
      sparc: properly conditionalize use of TIF_32BIT

 arch/alpha/include/asm/syscall.h        | 11 +++++++
 arch/alpha/kernel/ptrace.c              |  2 +-
 arch/arm/kernel/ptrace.c                |  4 +--
 arch/arm64/kernel/ptrace.c              |  7 +++++
 arch/ia64/include/asm/syscall.h         |  6 ++++
 arch/ia64/kernel/ptrace.c               |  2 +-
 arch/microblaze/include/asm/syscall.h   |  5 +++
 arch/microblaze/kernel/ptrace.c         |  3 +-
 arch/mips/include/asm/syscall.h         |  2 +-
 arch/mips/kernel/ptrace.c               |  4 +--
 arch/openrisc/include/asm/syscall.h     |  5 +++
 arch/openrisc/include/uapi/asm/elf.h    |  3 +-
 arch/openrisc/kernel/ptrace.c           |  3 +-
 arch/parisc/include/asm/syscall.h       | 11 +++++++
 arch/parisc/kernel/ptrace.c             |  9 ++----
 arch/powerpc/include/asm/syscall.h      |  6 ++++
 arch/powerpc/kernel/ptrace.c            |  7 ++---
 arch/s390/kernel/ptrace.c               |  4 +--
 arch/sh/include/asm/syscall_32.h        | 10 ++++++
 arch/sh/include/asm/syscall_64.h        | 14 +++++++++
 arch/sh/kernel/ptrace_32.c              | 14 +--------
 arch/sh/kernel/ptrace_64.c              | 17 +---------
 arch/sparc/include/asm/syscall.h        |  7 +++++
 arch/sparc/include/asm/thread_info_32.h |  2 ++
 arch/sparc/include/asm/thread_info_64.h |  2 ++
 arch/sparc/kernel/ptrace_64.c           |  9 ++----
 arch/um/kernel/ptrace.c                 |  3 +-
 arch/x86/ia32/ia32entry.S               | 12 +++----
 arch/x86/kernel/entry_32.S              | 11 +++----
 arch/x86/kernel/entry_64.S              | 11 +++----
 arch/x86/kernel/ptrace.c                |  8 ++---
 arch/x86/um/asm/ptrace.h                |  4 ---
 arch/x86/um/asm/syscall.h               | 15 +++++++++
 arch/xtensa/kernel/ptrace.c             |  2 +-
 include/asm-generic/syscall.h           |  2 +-
 include/linux/audit.h                   | 25 +++++++++------
 include/uapi/linux/audit.h              | 14 +--------
 include/uapi/linux/elf-em.h             |  1 +
 kernel/audit.c                          | 30 ++++++------------
 kernel/audit.h                          |  1 -
 kernel/audit_tree.c                     |  6 ++--
 kernel/audit_watch.c                    |  4 +--
 kernel/auditfilter.c                    | 56 +++++++++++++++++++--------------
 kernel/auditsc.c                        | 28 ++++++-----------
 44 files changed, 214 insertions(+), 188 deletions(-)
 create mode 100644 arch/alpha/include/asm/syscall.h
 create mode 100644 arch/x86/um/asm/syscall.h


