Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871AbbAUFzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:55:40 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:59307 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUFzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:55:39 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXCenu4UexZfV6HTq898JbXmZGU5KaCWCXrz7oikrA34g@mail.gmail.com>
References: <20150119170839.2c6b4b78@canb.auug.org.au> <20150119093501.GA4644@pd.tnic>
 <CALCETrW05f9nty5Sk8XA2DTsocqqOxp62aT9QXwta74Km+ZOng@mail.gmail.com>
 <20150121053410.GA15291@gmail.com> <CALCETrXCenu4UexZfV6HTq898JbXmZGU5KaCWCXrz7oikrA34g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 21:55:17 -0800
Message-ID: <CALCETrXZPOrGWOfPZRGz_cgmV6ZRvcdXwzjQJTdCmPq5gwaomw@mail.gmail.com>
Subject: Re: Fwd: linux-next: manual merge of the luto-misc tree with the tip tree
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 9:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jan 20, 2015 at 9:34 PM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>> Hi Ingo and Thomas-
>>>
>>> There's a trivial conflict in the pull request I sent last week.
>>
>> This is your x86 entry code rework pull request, right? The -tip
>> tree now has the RCU commit it depends on, so could you please
>> rebase it on top of tip:core/rcu so I can pull it? I'll resolve
>> any remaining conflicts with the rest of -tip.
>>
>
> Sure, I can do that in the morning.  The pull request merges cleanly
> with tip:core/rcu, though, so is the rebase needed?

The rebase was trivial.  If you prefer it:

The following changes since commit f49028292c13b958fdf4f36c8cc8119d0dde187b:

  Merge branch 'for-mingo' of
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into
core/rcu (2015-01-21 06:12:21 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
tags/pr-20150120-x86-entry

for you to fetch changes up to 0e5c6d1b97b194aa5cbb79ea3a73236a9de8811c:

  x86: entry_64.S: fold SAVE_ARGS_IRQ macro into its sole user
(2015-01-20 21:49:15 -0800)

----------------------------------------------------------------
[This is identical to pr-20150114-x86-entry, except rebased to tip:core/rcu]

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

--Andy
