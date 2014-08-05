Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaHEOxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:53:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaHEOxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:53:03 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/8] x86: entry_64.S: always allocate complete "struct pt_regs"
Date: Tue,  5 Aug 2014 16:52:26 +0200
Message-Id: <1407250354-29525-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 3 of the patchset.

Please consider applying at least two first patches, they are definitely safe,
and the second one fixes a latent bug.

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
= error_entry and save_paranoid have different CFI decorations.
  At least one of them is likely to be wrong...
= Move save_paranoid and ret_from_fork closer to their callers.
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

Denys Vlasenko (8):
  x86: entry_64.S: delete unused code
  x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
  x86: open-code register save/restore in trace_hardirqs thunks
  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
  x86: entry_64.S: always allocate complete "struct pt_regs"
  x86: mass removal of ARGOFFSET
  x86: rename some macros and labels, no code changes
  x86: add comments about various syscall instructions, no code changes

 arch/x86/ia32/ia32entry.S              | 302 ++++++++++++++------------
 arch/x86/include/asm/calling.h         | 216 +++++++++----------
 arch/x86/include/asm/irqflags.h        |   4 +-
 arch/x86/include/asm/ptrace.h          |  13 +-
 arch/x86/include/uapi/asm/ptrace-abi.h |  16 +-
 arch/x86/include/uapi/asm/ptrace.h     |  13 +-
 arch/x86/kernel/entry_64.S             | 379 +++++++++++++--------------------
 arch/x86/kernel/preempt.S              |  16 +-
 arch/x86/lib/thunk_64.S                |  29 ++-
 9 files changed, 489 insertions(+), 499 deletions(-)

-- 
1.8.1.4

