Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaCBX4a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:56:30 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaCBX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:56:28 -0500
From: Richard Weinberger <richard@nod.at>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, viro@zeniv.linux.org.uk, vgupta@synopsys.com,
        catalin.marinas@arm.com, will.deacon@arm.com, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, vapier@gentoo.org, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, rkuo@codeaurora.org, tony.luck@intel.com,
        fenghua.yu@intel.com, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu,
        yasutake.koichi@jp.panasonic.com, ralf@linux-mips.org,
        jonas@southpole.se, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, liqin.linux@gmail.com, lennox.wu@gmail.com,
        cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        linux-xtensa@linux-xtensa.org, akpm@linux-foundation.org,
        oleg@redhat.com, tj@kernel.org, hch@infradead.org
Subject: Global signal cleanup, take 2
Date: Mon,  3 Mar 2014 00:55:49 +0100
Message-Id: <1393804559-7701-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the global signal cleanup series.

This patch series moves all remaining archs to the get_signal() and
signal_setup_done() functions. Currently these archs use open coded
variants of the said functions.  Further, unused parameters get removed
from get_signal_to_deliver(), tracehook_signal_handler() and signal_delivered().

The following archs got zero build testing:
arc, c6x, cris-v32, hexagon, metag, score, unicore, sh64.

Changes since v1:
- Dropped "h8300: Use get_signal() signal_setup_done()", architecture got ripped out
- Dropped "openrisc: Use get_signal() signal_setup_done()", merged via openrisc tree
- Added ack to "c6x: Use get_signal() signal_setup_done()"
- Added ack to "hexagon: Use get_signal() signal_setup_done()"
- Added ack to "score: Use get_signal() signal_setup_done()"
- Added a common helper to translate signals
- Fixed some build issues
- Addressed comments

Signal translation using exec_domain is in a strange state.
Some archs support it, some not, some only kind of.
I fear mostly because of copy&paste developerment.
Here a small overview of my findings:

alpha:		no translation
arc:		supports translation
arm:		supports translation
arm64:		supports translation
avr32:		no translation
blackfin:	is confused, puts translated signal on stack frame, untranslated on regs->r0
c6x:		no translation
cris:		no translation, quote: /* TODO what is the current->exec_domain stuff and invmap ? */
frv:		is confused, puts translated signal on stack frame, untranslated on regs->gr8
hexagon:	no translation
ia64:		no translation
m32r:		supports translation
m68k:		supports translation
metag:		no translation
microblaze:	supports translation
mips:		no translation
mn10300:	is confused, puts translated signal on stack frame, untranslated on regs->d0
openrisc:	no translation, quote: /* TODO what is the current->exec_domain stuff and invmap ? */
parisc:		no translation
powerpc:	no translation
s390:		supports translation
score:		no translation
sh:		supports translation
sparc:		no translation
tile:		support translation
um:		support translation (only x86_64)
unicore32:	support translation
x86:		support translation (only ia32)
xtensa:		support translation

I'm wondering on which archs exec domains (and therefore signal translation)
are fully supported.
I guess we can remove the signal translation stuff from most archs.
Maybe hch can tell us more.

The whole series can also be found at:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v2

 arch/arc/kernel/signal.c            |   52 ++++-----------
 arch/arm/kernel/signal.c            |   14 ----
 arch/arm64/include/asm/signal32.h   |    7 --
 arch/arm64/kernel/signal.c          |   55 +++++-----------
 arch/arm64/kernel/signal32.c        |    8 +-
 arch/avr32/kernel/signal.c          |   43 +++++-------
 arch/blackfin/kernel/signal.c       |   42 ++++--------
 arch/c6x/kernel/signal.c            |   43 +++++-------
 arch/cris/arch-v10/kernel/signal.c  |   79 +++++++++--------------
 arch/cris/arch-v32/kernel/signal.c  |   77 ++++++++--------------
 arch/frv/kernel/signal.c            |  122 ++++++++++++------------------------
 arch/hexagon/kernel/signal.c        |   45 +++++--------
 arch/ia64/kernel/signal.c           |   46 ++++++-------
 arch/m32r/kernel/signal.c           |   52 +++++----------
 arch/m68k/kernel/signal.c           |   78 +++++++----------------
 arch/metag/kernel/signal.c          |   55 +++++++---------
 arch/microblaze/kernel/signal.c     |   56 +++++-----------
 arch/mips/include/asm/abi.h         |   10 +-
 arch/mips/kernel/signal.c           |   66 +++++++------------
 arch/mips/kernel/signal32.c         |   39 ++++-------
 arch/mips/kernel/signal_n32.c       |   20 ++---
 arch/mn10300/kernel/signal.c        |  112 +++++++++++----------------------
 arch/parisc/kernel/signal.c         |   58 +++++++----------
 arch/powerpc/kernel/signal.c        |   31 +++------
 arch/powerpc/kernel/signal.h        |   12 +--
 arch/powerpc/kernel/signal_32.c     |   36 ++++------
 arch/powerpc/kernel/signal_64.c     |   28 +++-----
 arch/s390/kernel/compat_signal.c    |   92 ++++++++++-----------------
 arch/s390/kernel/entry.h            |    4 -
 arch/s390/kernel/signal.c           |   92 +++++++++------------------
 arch/score/kernel/signal.c          |   43 +++++-------
 arch/sh/kernel/signal_32.c          |   94 +++++++++------------------
 arch/sh/kernel/signal_64.c          |   97 ++++++++++------------------
 arch/tile/include/asm/compat.h      |    3 
 arch/tile/kernel/compat_signal.c    |   37 ++++------
 arch/tile/kernel/signal.c           |   62 +++++++-----------
 arch/um/include/shared/frame_kern.h |   12 +--
 arch/um/kernel/signal.c             |   27 +++----
 arch/unicore32/kernel/signal.c      |   73 +++++++--------------
 arch/x86/kernel/signal.c            |    9 --
 arch/x86/um/signal.c                |   52 ++++++---------
 arch/xtensa/kernel/signal.c         |   51 +++++----------
 include/linux/signal.h              |   27 +++----
 include/linux/tracehook.h           |    8 --
 kernel/signal.c                     |   46 ++++++-------
 45 files changed, 800 insertions(+), 1315 deletions(-)

Thanks,
//richard
