Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaKUV0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:26:19 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36942 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaKUV0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:26:17 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v4 0/5] x86: Rework IST interrupts
Date: Fri, 21 Nov 2014 13:26:06 -0800
Message-Id: <cover.1416604491.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following Linus' feedback, this series has grown.  When I say "IST
interrupt" below, I'm excluding NMIs.  They are their own thing.  This
patch does *not* change NMI handling.

This adds new functions ist_enter and ist_exit to handle entry to and
exit from ist handlers.  This is, I think, a bugfix for RCU handling,
and I've cc'd some RCU people on that patch.  It will also catch bugs
involving scheduling on the IST stack.

This series then changes the entry code to switch to the normal stack if
an IST interrupt came from userspace and wasn't a double-fault.  This
simplifies the exit logic.

Building on that, I add new functions ist_begin_non_atomic and
ist_end_non_atomic.  They next inside ist_enter and ist_exit, and they
allow scheduling if the right conditions are met and they BUG if not.
They're meant to be used in do_machine_check to handle userspace memory
failures.

NB: Tony has seen odd behavior when stress-testing injected machine
checks with earlier versions of this series applied.  I suspect that
it's a bug in something else, possibly his BIOS.  Bugs in this series
shouldn't be ruled out, though.

Changes from v3:
 - Reworked everything except the asm.

Changes from v2:
 - double_fault is no longer affected.
 - Other changes, but those are obsolete now.

Changes from RFC/v1: I forgot.  Sorry.

Andy Lutomirski (5):
  uprobes, x86: Fix _TIF_UPROBE vs _TIF_NOTIFY_RESUME
  x86, traps: Track entry into and exit from IST context
  x86, entry: Switch stacks on a paranoid entry from userspace
  x86: Clean up current_stack_pointer
  x86, traps: Add ist_begin_non_atomic and ist_end_non_atomic

 Documentation/x86/entry_64.txt         |  18 ++++--
 Documentation/x86/x86_64/kernel-stacks |   8 ++-
 arch/x86/include/asm/thread_info.h     |  13 +++-
 arch/x86/include/asm/traps.h           |   6 ++
 arch/x86/kernel/cpu/mcheck/mce.c       |   5 ++
 arch/x86/kernel/cpu/mcheck/p5.c        |   6 ++
 arch/x86/kernel/cpu/mcheck/winchip.c   |   5 ++
 arch/x86/kernel/entry_64.S             |  86 ++++++++++++++------------
 arch/x86/kernel/irq_32.c               |  13 +---
 arch/x86/kernel/traps.c                | 110 +++++++++++++++++++++++++--------
 kernel/events/uprobes.c                |   1 -
 11 files changed, 183 insertions(+), 88 deletions(-)

-- 
1.9.3

