Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3ATV2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 16:28:36 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33608 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3ATV2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 16:28:35 -0500
Date: Sun, 20 Jan 2013 21:28:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130120212832.GP4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
 <20130120031253.GO4939@ZenIV.linux.org.uk>
 <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRMC43_H1hL5goAQxX4EdTuXOu5A9CoBk9fpGoJT_nig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:53:20PM -0800, Linus Torvalds wrote:
> On Sat, Jan 19, 2013 at 7:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK...  I think I understand what's going on.  We need asmlinkage_protect
> > in sys_clone() ;-/  For what it's worth, I really wonder if we ought to
> > treat that as syscall wrappers - i.e. have SYSCALL_DEFINEx on i386 add
> > a wrapper that would do asmlinkage_protect itself.  IMO it's the same kind
> > of thing as argument normalization handled by syscall wrappers - we make
> > sure that C function plays well with what asm glue is doing and expecting.
> 
> Actually, I think we should do it *unconditionally* in the syscall wrappers.

That's what I mean; sorry for bad wording - should be "use SYSCALL_DEFINEx on
i386, adding a wrapper that would do asmlinkage_protect".  And yes, i386 is
the only architecture that currently has a non-empty asmlinkage_protect(),
so all architecture dependencies would already be taken care of -
SYSCALL_DEFINEx should use asmlinkage_protect() unconditionally.

> But in the meantime, I guess I should just take the do_fork() one. Can
> I get a sign-off and a changelog?

See signal.git#for-linus; regression fixes (including this one) +
compat syscall fixes (discussed back in December) + a couple of "make
life easier for sigaltstack stuff by reducing inter-tree dependencies"
Please, pull from the usual place
git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal for-linus

Shortlog:
Al Viro (6):
      switch compat_sys_sigaltstack() to COMPAT_SYSCALL_DEFINE
      switch compat_sys_wait4() and compat_sys_waitid() to COMPAT_SYSCALL_DEFINE
      x32: fix waitid()
      x32: fix sigtimedwait
      make sure that /linuxrc has std{in,out,err}
      sys_clone() needs asmlinkage_protect

Vineet Gupta (2):
      Ensure that kernel_init_freeable() is not inlined into non __init code
      CONFIG_GENERIC_SIGALTSTACK build breakage with asm-generic/syscalls.h

Diffstat:
 include/asm-generic/syscalls.h |    2 ++
 init/do_mounts_initrd.c        |    4 ++++
 init/main.c                    |    4 ++--
 kernel/compat.c                |   23 +++++++++++++++--------
 kernel/fork.c                  |    6 ++++--
 kernel/signal.c                |    5 +++--
 6 files changed, 30 insertions(+), 14 deletions(-)

