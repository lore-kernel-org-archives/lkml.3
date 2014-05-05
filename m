Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaEETTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:19:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49107 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaEETTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:19:42 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 0/7] Clean up and unify the vDSO
Date: Mon,  5 May 2014 12:19:30 -0700
Message-Id: <cover.1399317206.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rewrites a bunch of the vdso code.  After these patches, the vvar
and hpet pages are mapped directly after the vdso text on all five
vdso variants.  The fixmaps are gone on 64-bit systems.

It would be possible to build the x32 vdso the normal way on top of
these patches.

I haven't touched the pvclock code.  In a discussion with Marcello
Tosatti, I think we concluded that the kvmclock code could be
significantly simplified and sped up without breaking anything, but I
want to save that for later.

There's a further change for 32-bit in here: the fixmap is now always
aligned to a PMD (i.e. 4M) boundary.  This may waste up to 4M-4k of
address space if a hypervisor is in use.  If that's a problem, then that
part of this change could be reverted, but the existing code was asking
for trouble.

This should apply to -linus or to tip/x86/vdso.  It's also here:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=vdso/cleanups

Changed from v4: 
 - Fixed the alignment of fixmap (build / functionality fix)

Changes from v3:
 - Improve the changelog message for patch 2.

Changes from v2:
 - Fixed the 32-bit build.  Hopefully I didn't screw
up bisection.

Changes from v1:
 - Rebased
 - I think Gold is working (this is a side effect of the rebase)

Andy Lutomirski (7):
  x86,mm: Ensure correct alignment of the fixmap
  x86: Clean up 32-bit vs 64-bit vdso params
  x86: Move syscall and sysenter setup into kernel/cpu/common.c
  x86: Reimplement vdso.so preparation in build-time C
  x86: Move the 32-bit vdso special pages after the text
  x86: Move the vvar and hpet mappings next to the 64-bit vDSO
  x86: Remove vestiges of VDSO_PRELINK and some outdated comments

 arch/x86/ia32/ia32_signal.c          |   8 +-
 arch/x86/include/asm/elf.h           |  35 +++---
 arch/x86/include/asm/fixmap.h        |  11 +-
 arch/x86/include/asm/mmu.h           |   2 +-
 arch/x86/include/asm/proto.h         |   2 -
 arch/x86/include/asm/vdso.h          |  74 +++++-------
 arch/x86/include/asm/vdso32.h        |  11 --
 arch/x86/include/asm/vvar.h          |  20 +---
 arch/x86/include/uapi/asm/vsyscall.h |   7 +-
 arch/x86/kernel/cpu/common.c         |  33 ++++++
 arch/x86/kernel/hpet.c               |   3 -
 arch/x86/kernel/signal.c             |   6 +-
 arch/x86/kernel/vsyscall_64.c        |  15 +--
 arch/x86/mm/fault.c                  |   5 +-
 arch/x86/mm/init_64.c                |  13 +-
 arch/x86/mm/ioremap.c                |   6 +
 arch/x86/mm/pgtable.c                |   6 +-
 arch/x86/um/vdso/vma.c               |   2 +-
 arch/x86/vdso/.gitignore             |   5 +-
 arch/x86/vdso/Makefile               |  90 +++++---------
 arch/x86/vdso/vclock_gettime.c       |  26 ++--
 arch/x86/vdso/vdso-layout.lds.S      |  40 ++++---
 arch/x86/vdso/vdso.S                 |   3 -
 arch/x86/vdso/vdso.lds.S             |   7 +-
 arch/x86/vdso/vdso2c.c               | 156 ++++++++++++++++++++++++
 arch/x86/vdso/vdso2c.h               | 154 ++++++++++++++++++++++++
 arch/x86/vdso/vdso32-setup.c         | 196 ++++---------------------------
 arch/x86/vdso/vdso32.S               |   9 --
 arch/x86/vdso/vdso32/vdso32.lds.S    |  15 +--
 arch/x86/vdso/vdsox32.S              |   3 -
 arch/x86/vdso/vdsox32.lds.S          |   7 +-
 arch/x86/vdso/vma.c                  | 222 +++++++++++++++++++----------------
 arch/x86/xen/mmu.c                   |   8 +-
 arch/x86/xen/setup.c                 |  11 +-
 kernel/sysctl.c                      |   5 +
 35 files changed, 657 insertions(+), 559 deletions(-)
 delete mode 100644 arch/x86/include/asm/vdso32.h
 delete mode 100644 arch/x86/vdso/vdso.S
 create mode 100644 arch/x86/vdso/vdso2c.c
 create mode 100644 arch/x86/vdso/vdso2c.h
 delete mode 100644 arch/x86/vdso/vdso32.S
 delete mode 100644 arch/x86/vdso/vdsox32.S

-- 
1.9.0

