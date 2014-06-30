Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbaF3Vxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:53:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39534 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaF3Vx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:53:29 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, hpa@zytor.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 00/10] x86 and others: vsyscall and vdso cleanups
Date: Mon, 30 Jun 2014 14:53:11 -0700
Message-Id: <cover.1404164803.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2.  I'm resending it because the fallout from the 3.16 changes
seems to have settled down, and because arm is about to run in to the
same problem that I ran in to, which is fixed in the big cross-arch
patch.

Patch 1 fixes a minor bug; it might make sense to backport it.

Patch 3 removes the vsyscall mapping when vsyscall=none.

Patch 4 and 5 remove some unnecessary vvars.  gtod is the only one left now.

Patch 9 is a big cross-arch cleanup.  The old code was supposedly
generic, but it was only useful for ia64, and it was actively harmful
for lots of other architectures.

Patch 10 makes vsyscall emulation optional.  It's hidden under
CONFIG_EXPERT.

If this should be split or reordered, please let me know.

NB: I wouldn't be surprised if Nathan Lynch ends up wanting patch 9 for
ARM's upcoming vdso, so it would be nice to get at least that patch into
an upstream-pointing git tree somewhere.  I'm not sure what the
appropriate tree is.

Changes from v1:
 - Rebased to 3.16-rc3.
 - The last patch is new.

Andy Lutomirski (10):
  x86_64,vsyscall: Fix warn_bad_vsyscall log output
  x86_64,vsyscall: Move all of the gate_area code to vsyscall_64.c
  x86_64,vsyscall: Turn vsyscalls all the way off when vsyscall=none
  x86_64,vdso: Remove jiffies from the vvar page
  x86,vdso: Replace vgetcpu_mode with static_cpu_has
  x86_64: Move getcpu code from vsyscall_64.c to vdso/vma.c
  x86_64,vsyscall: Rewrite comment and clean up headers in vsyscall code
  x86_64,vdso: Clean up vgetcpu init and merge the vdso initcalls
  arm64,ia64,ppc,s390,sh,tile,um,x86,mm: Remove default gate area
  x86_64,vsyscall: Make vsyscall emulation configurable

 arch/arm64/include/asm/page.h      |   3 -
 arch/arm64/kernel/vdso.c           |  19 -----
 arch/ia64/include/asm/page.h       |   2 +
 arch/ia64/mm/init.c                |  26 +++++++
 arch/powerpc/include/asm/page.h    |   3 -
 arch/powerpc/kernel/vdso.c         |  16 ----
 arch/s390/include/asm/page.h       |   2 -
 arch/s390/kernel/vdso.c            |  15 ----
 arch/sh/include/asm/page.h         |   5 --
 arch/sh/kernel/vsyscall/vsyscall.c |  15 ----
 arch/tile/include/asm/page.h       |   6 --
 arch/tile/kernel/vdso.c            |  15 ----
 arch/um/include/asm/page.h         |   5 ++
 arch/x86/Kconfig                   |  18 +++++
 arch/x86/include/asm/fixmap.h      |   2 +
 arch/x86/include/asm/page.h        |   1 -
 arch/x86/include/asm/page_64.h     |   4 +
 arch/x86/include/asm/vgtod.h       |  21 +++++
 arch/x86/include/asm/vsyscall.h    |  33 ++------
 arch/x86/include/asm/vvar.h        |   2 -
 arch/x86/kernel/Makefile           |   3 +-
 arch/x86/kernel/cpu/common.c       |  10 ---
 arch/x86/kernel/setup.c            |   2 -
 arch/x86/kernel/time.c             |   2 +-
 arch/x86/kernel/vsyscall_64.c      | 155 ++++++++++++++++---------------------
 arch/x86/mm/init_64.c              |  49 ------------
 arch/x86/um/asm/elf.h              |   1 -
 arch/x86/um/mem_64.c               |  15 ----
 arch/x86/vdso/vclock_gettime.c     |   3 +
 arch/x86/vdso/vdso32-setup.c       |  19 +----
 arch/x86/vdso/vgetcpu.c            |   5 +-
 arch/x86/vdso/vma.c                |  81 ++++++++++++++-----
 arch/x86/xen/mmu.c                 |   6 +-
 include/linux/mm.h                 |  17 ++--
 mm/memory.c                        |  38 ---------
 mm/nommu.c                         |   5 --
 36 files changed, 239 insertions(+), 385 deletions(-)

-- 
1.9.3

