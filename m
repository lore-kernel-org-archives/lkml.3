Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaGUORc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:17:32 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14388 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbaGUOD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:03:59 -0400
From: Richard Weinberger <richard@sigma-star.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Global signal cleanup, take 4
Date: Mon, 21 Jul 2014 16:02:46 +0200
Message-Id: <1405951409-16953-1-git-send-email-richard@sigma-star.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v4 of the global signal cleanup series.

This patch series moves all remaining archs to the get_signal(), signal_setup_done()
and sigsp() functions. Currently these archs use open coded
variants of the said functions. Further, unused parameters get removed
from get_signal_to_deliver(), tracehook_signal_handler() and signal_delivered().

The following archs got zero build testing:
c6x, cris-v32, score, unicore, sh64.

The whole series can also be found at:
git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git signal_v4

Andrew, can you please pickup this series?

Changes since v3:
- Rebased to v3.16-rc6
- Fixed arm64 build (v3 contained an old patch :-( )
- Added more acks (parisc, avr32, c6x)

Changes since v2:
- Added ack to arc bits
- Dropped "metag: Use get_signal() signal_setup_done()", merged via metag tree
- Dropped signal translation helper, this will be addressed in another series

Changes since v1:
- Dropped "h8300: Use get_signal() signal_setup_done()", architecture got ripped out
- Dropped "openrisc: Use get_signal() signal_setup_done()", merged via openrisc tree
- Added ack to "c6x: Use get_signal() signal_setup_done()"
- Added ack to "hexagon: Use get_signal() signal_setup_done()"
- Added ack to "score: Use get_signal() signal_setup_done()"
- Added a common helper to translate signals
- Fixed some build issues
- Addressed comments

 arch/arc/kernel/signal.c            |  47 ++++++---------
 arch/arm64/include/asm/signal32.h   |  11 ++--
 arch/arm64/kernel/signal.c          |  58 +++++++------------
 arch/arm64/kernel/signal32.c        |  24 +++-----
 arch/avr32/kernel/signal.c          |  50 +++++++---------
 arch/blackfin/kernel/signal.c       |  51 ++++++----------
 arch/c6x/kernel/signal.c            |  53 +++++++----------
 arch/cris/arch-v10/kernel/signal.c  |  89 +++++++++++-----------------
 arch/cris/arch-v32/kernel/signal.c  |  89 +++++++++++-----------------
 arch/frv/kernel/signal.c            | 112 ++++++++++++++----------------------
 arch/hexagon/kernel/signal.c        |  57 +++++++-----------
 arch/ia64/kernel/signal.c           |  46 +++++++--------
 arch/m32r/kernel/signal.c           |  57 +++++++-----------
 arch/m68k/kernel/signal.c           |  75 +++++++++---------------
 arch/metag/kernel/signal.c          |  10 +---
 arch/microblaze/kernel/signal.c     |  55 ++++++------------
 arch/mips/include/asm/abi.h         |  10 ++--
 arch/mips/kernel/signal-common.h    |   2 +-
 arch/mips/kernel/signal.c           |  72 +++++++++--------------
 arch/mips/kernel/signal32.c         |  39 +++++--------
 arch/mips/kernel/signal_n32.c       |  20 +++----
 arch/mn10300/kernel/signal.c        | 102 ++++++++++++--------------------
 arch/openrisc/kernel/signal.c       |  20 +------
 arch/parisc/kernel/signal.c         |  58 ++++++++-----------
 arch/powerpc/kernel/signal.c        |  41 +++++--------
 arch/powerpc/kernel/signal.h        |  14 ++---
 arch/powerpc/kernel/signal_32.c     |  36 ++++++------
 arch/powerpc/kernel/signal_64.c     |  28 +++++----
 arch/s390/kernel/compat_signal.c    |  79 +++++++++++--------------
 arch/s390/kernel/entry.h            |   4 +-
 arch/s390/kernel/signal.c           |  78 +++++++++++--------------
 arch/score/kernel/signal.c          |  43 ++++++--------
 arch/sh/kernel/signal_32.c          |  79 +++++++++++--------------
 arch/sh/kernel/signal_64.c          |  82 +++++++++++---------------
 arch/tile/include/asm/compat.h      |   3 +-
 arch/tile/kernel/compat_signal.c    |  29 +++++-----
 arch/tile/kernel/signal.c           |  54 ++++++++---------
 arch/um/include/shared/frame_kern.h |  12 ++--
 arch/um/kernel/signal.c             |  27 ++++-----
 arch/unicore32/kernel/signal.c      |  48 +++++++---------
 arch/x86/um/signal.c                |  45 +++++++--------
 arch/xtensa/kernel/signal.c         |  43 ++++++--------
 include/linux/sched.h               |   6 +-
 include/linux/signal.h              |  15 +----
 include/linux/tracehook.h           |   8 +--
 kernel/signal.c                     |  46 +++++++--------
 46 files changed, 789 insertions(+), 1238 deletions(-)

[PATCH 01/43] arc: Use get_signal() signal_setup_done()
[PATCH 02/43] arm64: Use get_signal() signal_setup_done()
[PATCH 03/43] avr32: Use get_signal() signal_setup_done()
[PATCH 04/43] blackfin: Use get_signal() signal_setup_done()
[PATCH 05/43] c6x: Use get_signal() signal_setup_done()
[PATCH 06/43] cris: Use get_signal() signal_setup_done()
[PATCH 07/43] frv: Use get_signal() signal_setup_done()
[PATCH 08/43] hexagon: Use get_signal() signal_setup_done()
[PATCH 09/43] ia64: Use get_signal() signal_setup_done()
[PATCH 10/43] m32r: Use get_signal() signal_setup_done()
[PATCH 11/43] m68k: Use get_signal() signal_setup_done()
[PATCH 12/43] microblaze: Use get_signal() signal_setup_done()
[PATCH 13/43] mips: Use get_signal() signal_setup_done()
[PATCH 14/43] mn10300: Use get_signal() signal_setup_done()
[PATCH 15/43] parisc: Use get_signal() signal_setup_done()
[PATCH 16/43] powerpc: Use get_signal() signal_setup_done()
[PATCH 17/43] s390: Use get_signal() signal_setup_done()
[PATCH 18/43] score: Use get_signal() signal_setup_done()
[PATCH 19/43] sh: Use get_signal() signal_setup_done()
[PATCH 20/43] tile: Use get_signal() signal_setup_done()
[PATCH 21/43] um: Use get_signal() signal_setup_done()
[PATCH 22/43] unicore32: Use get_signal() signal_setup_done()
[PATCH 23/43] xtensa: Use get_signal() signal_setup_done()
[PATCH 24/43] tracehook_signal_handler: Remove sig, info, ka and regs
[PATCH 25/43] Clean up signal_delivered()
[PATCH 26/43] Rip out get_signal_to_deliver()
[PATCH 27/43] sas_ss_flags: Remove nested ternary if
[PATCH 28/43] arc: Use sigsp()
[PATCH 29/43] arm64: Use sigsp()
[PATCH 30/43] avr32: Use sigsp()
[PATCH 31/43] blackfin: Use sigsp()
[PATCH 32/43] c6x: Use sigsp()
[PATCH 33/43] cris: Use sigsp()
[PATCH 34/43] frv: Use sigsp()
[PATCH 35/43] hexagon: Use sigsp()
[PATCH 36/43] m32r: Use sigsp()
[PATCH 37/43] m68k: Use sigsp()
[PATCH 38/43] metag: Use sigsp()
[PATCH 39/43] microblaze: Use sigsp()
[PATCH 40/43] mips: Use sigsp()
[PATCH 41/43] mn10300: Use sigsp()
[PATCH 42/43] openrisc: Use sigsp()
[PATCH 43/43] powerpc: Use sigsp()
