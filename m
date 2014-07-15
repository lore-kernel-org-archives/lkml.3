Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbaGOTcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:32:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34318 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171AbaGOTcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:32:42 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        James Morris <james.l.morris@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/7] Two-phase seccomp and x86 tracing changes
Date: Tue, 15 Jul 2014 12:32:29 -0700
Message-Id: <cover.1405452484.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is both a cleanup and a speedup.  It reduces overhead due to
installing a trivial seccomp filter by 87%.  The speedup comes from
avoiding the full syscall tracing mechanism for filters that don't
return SECCOMP_RET_TRACE.

This series works by splitting the seccomp hooks into two phases.
The first phase evaluates the filter; it can skip syscalls, allow
them, kill the calling task, or pass a u32 to the second phase.  The
second phase requires a full tracing context, and it sends ptrace
events if necessary.

Once this is done, I implemented a similar split for the x86 syscall
entry work.  The C callback is invoked in two phases: the first has
only a partial frame, and it can request phase 2 processing with a
full frame.

Finally, I switch the 64-bit system_call code to use the new split
entry work.  This is a net deletion of assembly code: it replaces
all of the audit entry muck.

In the process, I fixed some bugs.

If this is acceptable, someone can do the same tweak for the
ia32entry and entry_32 code.

This passes all seccomp tests that I know of, except for the ones
that don't work on current kernels.

Presumably, once everyone gets a chance to poke at this, it should
go in to some combination of James' and hpa's trees.

Changes from RFC version:
 - The first three patches are more or less the same
 - The rest is more or less a rewrite

Andy Lutomirski (7):
  seccomp,x86,arm,mips,s390: Remove nr parameter from secure_computing
  seccomp: Refactor the filter callback and the API
  seccomp: Allow arch code to provide seccomp_data
  x86,x32,audit: Fix x32's AUDIT_ARCH wrt audit
  x86: Split syscall_trace_enter into two phases
  x86_64,entry: Treat regs->ax the same in fastpath and slowpath
    syscalls
  x86_64,entry: Use split-phase syscall_trace_enter for 64-bit syscalls

 arch/arm/kernel/ptrace.c       |   7 +-
 arch/mips/kernel/ptrace.c      |   2 +-
 arch/s390/kernel/ptrace.c      |   2 +-
 arch/x86/include/asm/calling.h |   6 +-
 arch/x86/include/asm/ptrace.h  |   5 +
 arch/x86/kernel/entry_64.S     |  51 ++++-----
 arch/x86/kernel/ptrace.c       | 146 +++++++++++++++++++-----
 arch/x86/kernel/vsyscall_64.c  |   2 +-
 include/linux/seccomp.h        |  25 +++--
 kernel/seccomp.c               | 246 +++++++++++++++++++++++++++--------------
 10 files changed, 339 insertions(+), 153 deletions(-)

-- 
1.9.3

