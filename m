Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbbAOB7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 20:59:50 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40203 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbAOB7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 20:59:48 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 Jan 2015 17:59:26 -0800
Message-ID: <CALCETrVCmoEP-Ha937VurRVxYYmSG==QL=twMBUWgzOAxc4uRA@mail.gmail.com>
Subject: [GIT PULL] x86/entry changes for 3.20, round 1
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and Thomas,

At Linus' suggestion, I'm trying out some maintainerish stuff for x86
entry code.  Please consider pulling to an appropriate branch *after
Paul sends his RCU pull request*, only if 734d16801349 is included in
that pull request.  If this goes well, maybe I'll submit a MAINTAINERS
patch, too.

IMPORTANT: This is based on an RCU change that you don't have yet.  I
think that Paul is planning on sending a pull request with that change
fairly soon.  The code in here would compile without that fix, but it
would introduce a nasty regression, so, to avoid breaking bisection, I
based this off of the relevant change in Paul's tree.  (It's the very
first change for 3.20 in his current queue.)

If you want me to structure this differently, let me know.

I may have one more entry pull request before the merge window if I
can get my sysret stuff reviewed in time.  Not sure yet.  I may also
be comfortable with some more of Denys' cleanups in time.

The following changes since commit 734d16801349fbe951d2f780191d32c5b8a892d1:

  rcu: Make rcu_nmi_enter() handle nesting (2014-12-30 17:40:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
tags/pr-20150114-x86-entry

for you to fetch changes up to f6f64681d9d87ded48a90b644b2991c6ee05da2d:

  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
(2015-01-13 14:18:08 -0800)

----------------------------------------------------------------
This is my accumulated x86 entry work, part 1, for 3.20.  The meat
of this is an IST rework.  When an IST exception interrupts user
space, we will handle it on the per-thread kernel stack instead of
on the IST stack.  This sounds messy, but it actually simplifies the
IST entry/exit code, because it eliminates some ugly games we used
to play in order to handle rescheduling, signal delivery, etc on the
way out of an IST exception.

The IST rework introduces proper context tracking to IST exception
handlers.  I haven't seen any bug reports, but the old code could
have incorrectly treated an IST exception handler as an RCU extended
quiescent state.

The memory failure change (included in this pull request with
Borislav and Tony's permission) eliminates a bunch of code that
is no longer needed now that user memory failure handlers are
called in process context.

Finally, this includes a few on Denys' uncontroversial and Obviously
Correct (tm) cleanups.

The IST and memory failure changes have been in -next for a while.

LKML references:

IST rework:
http://lkml.kernel.org/r/cover.1416604491.git.luto@amacapital.net

Memory failure change:
http://lkml.kernel.org/r/54ab2ffa301102cd6e@agluck-desk.sc.intel.com

Denys' cleanups:
http://lkml.kernel.org/r/1420927210-19738-1-git-send-email-dvlasenk@redhat.com

----------------------------------------------------------------
Andy Lutomirski (4):
      x86, entry: Switch stacks on a paranoid entry from userspace
      x86, traps: Track entry into and exit from IST context
      x86: Clean up current_stack_pointer
      x86, traps: Add ist_begin_non_atomic and ist_end_non_atomic

Denys Vlasenko (3):
      x86: entry_64.S: delete unused code
      x86: ia32entry.S: fix wrong symbolic constant usage: R11->ARGOFFSET
      x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user

Tony Luck (1):
      x86, mce: Get rid of TIF_MCE_NOTIFY and associated mce tricks

 Documentation/x86/entry_64.txt         |  18 ++-
 Documentation/x86/x86_64/kernel-stacks |   8 +-
 arch/x86/ia32/ia32entry.S              |   4 +-
 arch/x86/include/asm/calling.h         |   1 -
 arch/x86/include/asm/mce.h             |   1 -
 arch/x86/include/asm/thread_info.h     |  15 ++-
 arch/x86/include/asm/traps.h           |   6 +
 arch/x86/kernel/cpu/mcheck/mce.c       | 114 +++++-------------
 arch/x86/kernel/cpu/mcheck/p5.c        |   6 +
 arch/x86/kernel/cpu/mcheck/winchip.c   |   5 +
 arch/x86/kernel/entry_64.S             | 208 ++++++++++++++-------------------
 arch/x86/kernel/irq_32.c               |  13 +--
 arch/x86/kernel/signal.c               |   6 -
 arch/x86/kernel/traps.c                | 108 +++++++++++++----
 14 files changed, 252 insertions(+), 261 deletions(-)
