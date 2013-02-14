Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965319Ab3BNBZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:25:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44094 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3BNBZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:25:55 -0500
Date: Thu, 14 Feb 2013 01:25:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Jonas Bonn <jonas@southpole.se>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Lennox Wu <lennox.wu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Mundt <lethal@linux-sh.org>, Chris Zankel <chris@zankel.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC][CFT] what's in signal.git queue
Message-ID: <20130214012539.GQ4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly it's a unification of signal-related syscalls, both native and compat
ones; by the end of it we shouldn't have syscalls left in normal
arch/*/kernel/signal*.c - there are some exceptions due to genuine weirdness
of arch-specific calling conventions, but that's rare.  Another (somewhat
related) story in there is more compat_sys_something() getting switched to
COMPAT_SYSCALL_DEFINE, giving us proper argument validation wrappers.  Not
everything got switched, of course, but a lot of those guys has been.

FWIW, right now the queue is at -3.5KLoc.  Tree topology: common stem,
splitting into a bunch of per-architecture branches.  Those branches then
are octopus-merged and followed by a short linear piece.

In the stem:
	* a bunch of compat syscalls switched to COMPAT_SYSCALL_DEFINE*
	* definitions of struct k_sigaction and struct sigaction consolidated;
pretty much everything had identical definitions.  The few exceptions:
		+ alpha and sparc have k_sigaction.ka_restorer; selected by
		  having __ARCH_HAS_KA_RESTORER
		+ some architectures have sigaction.sa_restorer, some do not;
		  selected by having __ARCH_HAS_SA_RESTORER
		+ one architecture (mips) has sa_flags and sa_handler in
		  unusual order (IRIX compat legacy?); selected by having
		  __ARCH_HAS_ODD_SIGACTION
	* definition of struct compat_sigaction consolidated as well; quirks
are controlled by the same __ARCH_HAS_... as for struct sigaction.
	* definitions of struct old_sigaction and struct compat_old_sigaction
consolidated.
	* rt_sigprocmask(), rt_sigpending(), rt_sigqueueinfo(), sigsuspend(),
sigaction(), compat rt_sigaction(), compat sigaction() are ready to be
switched to generic versions (and so's sigaltstack(), but that had been in
mainline for a while already).  All of them got matching CONFIG_GENERIC_... 
config symbols, to be selected by an architecture that wants the suckers.
As the matter of fact, old sigsuspend() has *two* such symbols, what with
two variants of calling conventions we have.  Most of that zoo of selects
is introduced only to be killed once every architecture switches to generics;
of course, ones that aren't really universal are going to stay.  That way
we can do switching to generics independenty for different architectures.
	* new helpers for simplifying the paths from get_signal_to_deliver() -
the thing is, all callers pass it a couple of pointers to their local
variables (k_sigaction and siginfo) and then pass the addresses of these
variables in tandem to functions that do actual signal delivery; we could
as well put them into a single object and deal with pointer to it.  See
struct ksignal (that single object), get_signal() (get_signal_to_deliver()
wrapper filling struct ksignal), signal_setup_done() (the usual end of
sigframe building - "signal_delivered() if everything had been OK,
force_sigsegv() otherwise" logics) and sigsp() (usual altstack handling,
for use by get_sigframe() instances).

At that point the common stem ends; as far as I'm concerned, this part is
in never-rebase mode by now.  Then comes a bunch of per-architecture branches;
all subject to ACK by maintainers (ones who are not MIA, that is ;-/).  Once
maintainer(s) are OK with a branch, it's in no-rebase mode as well.  Branch
names are of form arch-<arch name>, same as the last time around.

What happens in those is conversions to generic versions of signal-related
syscalls introduced in the common stem.  For quite a few architectures that's
all that happens - arm, arm64, avr32, blackfin, c6x, frv, ia64, m32r, m68k,
mn10300, openrisc, parisc, score, sh, tile, unicore32 and xtensa fall into
that category.  Below is the description of additional stuff happening for
the rest of architectures (additional to conversions to generic implementations
of syscalls, that is):
	* alpha: trivial cleanup in copy_process() (unused variable killed)
	* cris: bugfix - since sigreturn uses ->uc_stack, we'd better not leave
it uninitialized.  Plus getting rid of pointless passing of pt_regs to
sigreturn - it's cheaper and simpler to use current_pt_regs() there.
	* h8300: get rid of sigreturn wrappers
	* hexagon: same bugfixe as on cris.
	* microblaze: a bunch of old fixes for multiple signals delivered
simultaneously. ACKed by Michal.
	* mips: in addition to usual conversions to generics, some n32 syscall
variants could've been switched to existing compat_sys_...() for quite a while
(they got missed somehow); done that now.  Got rid of magic arguments to
pipe(2) (current_pt_regs() used instead).  Switched to generic
fork()/clone()/vfork().
	* ppc: a bunch of compat wrappers had been pointless since
the introduction of CONFIG_HAVE_SYSCALL_WRAPPERS; kill 'em.  Also trim
asm/syscalls.h a bit.
	* s390: 32bit wrappers are not needed for anything defined
via COMPAT_SYSCALL_DEFINE*; kill the useless ones.
	* sparc: bury some dead code (sys_sigpause() remnants).  Kill
sign-extending wrappers for native syscalls - SYSCALL_DEFINE will do all
sanitizing we need.  So will COMPAT_SYSCALL_DEFINE, so the stuff using it
also doesn't need a wrapper in sys32.S; killed those off as well.
	* x86: get rid of pt_regs * passing to vm86, vm86old, iopl and
{rt_,}sigreturn, kill pointless wrappers.

There are several commits going after these branches rejoin.  Some conversion
detritus gets killed (some symbols are true everywhere now, do_sigaltstack()
can be made static).  Then there are examples of struct ksignal use - alpha,
x86 and sparc converted to it; the rest of architectures are left as is - if
somebody is willing to do conversions, more power to you, but as far as I'm
concerned that's next cycle fodder.

Fortunately, the arch-specific stuff in this round hadn't been as low-level as 
for kernel_thread/kernel_execve/sys_execve unification, so I'm a lot more
optimistic about it.  *Please*, review and yell if are unhappy with anything
in there.  This had sat unchanged in linux-next for quite a while, plus it got
some local testing and most of the likely breakage is of "the sucker doesn't
compile anymore" variety, but...
