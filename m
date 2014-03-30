Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaC3Qxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 12:53:40 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53713 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaC3Qxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 12:53:38 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/6] x86: Clean up and unify the vdso
Date: Sun, 30 Mar 2014 09:53:26 -0700
Message-Id: <cover.1396198036.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This rewrites a bunch of the vdso code.  After these patches, the vvar
and hpet pages are mapped directly after the vdso text on all five vdso
variants.  The fixmaps are gone on 64-bit systems.

It would be possible to build the x32 vdso the normal way on top of
these patches.

I haven't touched the pvclock code.  I'd want to understand why it
exists, why it isn't using rdtsc, and why it has two rdtsc_barrier calls
before rearranging it.

This is most likely 3.16 material.

Andy Lutomirski (6):
  x86: Clean up 32-bit vs 64-bit vdso params
  x86: Move syscall and sysenter setup into kernel/cpu/common.c
  x86: Reimplement vdso.so preparation in build-time C
  x86: Move the 32-bit vdso special pages after the text
  x86: Move the vvar and hpet mappings next to the 64-bit vDSO
  x86: Remove vestiges of VDSO_PRELINK and some outdated comments

 arch/x86/ia32/ia32_signal.c          |   8 +-
 arch/x86/include/asm/elf.h           |  35 +++---
 arch/x86/include/asm/fixmap.h        |  10 +-
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
 arch/x86/um/vdso/vma.c               |   2 +-
 arch/x86/vdso/.gitignore             |   5 +-
 arch/x86/vdso/Makefile               |  91 ++++++--------
 arch/x86/vdso/vclock_gettime.c       |  26 ++--
 arch/x86/vdso/vdso-layout.lds.S      |  49 ++++----
 arch/x86/vdso/vdso.S                 |   3 -
 arch/x86/vdso/vdso.lds.S             |   7 +-
 arch/x86/vdso/vdso2c.c               | 156 ++++++++++++++++++++++++
 arch/x86/vdso/vdso2c.h               | 154 ++++++++++++++++++++++++
 arch/x86/vdso/vdso32-setup.c         | 195 ++++--------------------------
 arch/x86/vdso/vdso32.S               |   9 --
 arch/x86/vdso/vdso32/vdso32.lds.S    |  15 +--
 arch/x86/vdso/vdsox32.S              |   3 -
 arch/x86/vdso/vdsox32.lds.S          |   7 +-
 arch/x86/vdso/vma.c                  | 222 +++++++++++++++++++----------------
 arch/x86/xen/mmu.c                   |   8 +-
 arch/x86/xen/setup.c                 |  11 +-
 kernel/sysctl.c                      |   5 +
 33 files changed, 650 insertions(+), 562 deletions(-)
 delete mode 100644 arch/x86/include/asm/vdso32.h
 delete mode 100644 arch/x86/vdso/vdso.S
 create mode 100644 arch/x86/vdso/vdso2c.c
 create mode 100644 arch/x86/vdso/vdso2c.h
 delete mode 100644 arch/x86/vdso/vdso32.S
 delete mode 100644 arch/x86/vdso/vdsox32.S

-- 
1.9.0

