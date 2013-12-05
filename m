Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3LEXcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:32:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44695 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3LEXcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:32:32 -0500
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Kim Naru <kim.naru@amd.com>, Thomas Renninger <trenn@suse.de>
Subject: [PATCH 0/4] x86, microcode, AMD: Fix early loading
Date: Fri,  6 Dec 2013 00:32:24 +0100
Message-Id: <1386286348-5144-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

A couple of openSUSE bugzillas made me look at the early ucode loading
on AMD.

The problem is, we're doing memory allocation too early with IRQs
disabled and we really want to avoid that. Also, 32-bit has other
problems like calling rd/wrmsr*/cpuid functions at their virtual
addresses while paging is not enabled yet. Bah.

So, fix that by *always* using the initrd image handed in from the
bootloader and cache the ucode patches only late, right before the
initrd is jettisoned. This avoids the allocation issue completely. While
at it, take care of the 32-bit issues too.

Testing on 32-bit and 64-bit passes here.

@Kim: I'd appreciate it if you guys ran those patches too,
by creating an early ucode initrd as it is described in
Documentation/x86/early-microcode.txt.

Thanks.

Borislav Petkov (4):
  x86, ramdisk: Export relocated ramdisk VA
  x86, microcode: Share native MSR accessing variants
  x86, microcode, AMD: Fix early ucode loading
  x86, microcode: Move to a proper location

 arch/x86/include/asm/microcode.h                   |  15 ++
 arch/x86/include/asm/microcode_amd.h               |   7 +-
 arch/x86/include/asm/setup.h                       |   3 +-
 arch/x86/kernel/Makefile                           |   9 -
 arch/x86/kernel/cpu/Makefile                       |   1 +
 arch/x86/kernel/cpu/microcode/Makefile             |  11 +
 .../{microcode_amd.c => cpu/microcode/amd.c}       |  13 +-
 .../microcode/amd_early.c}                         | 239 ++++++++++++++-------
 .../{microcode_core.c => cpu/microcode/core.c}     |   0
 .../microcode/core_early.c}                        |   0
 .../{microcode_intel.c => cpu/microcode/intel.c}   |   0
 .../microcode/intel_early.c}                       |  10 -
 .../microcode/intel_lib.c}                         |   0
 arch/x86/kernel/setup.c                            |  19 +-
 14 files changed, 209 insertions(+), 118 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/microcode/Makefile
 rename arch/x86/kernel/{microcode_amd.c => cpu/microcode/amd.c} (96%)
 rename arch/x86/kernel/{microcode_amd_early.c => cpu/microcode/amd_early.c} (55%)
 rename arch/x86/kernel/{microcode_core.c => cpu/microcode/core.c} (100%)
 rename arch/x86/kernel/{microcode_core_early.c => cpu/microcode/core_early.c} (100%)
 rename arch/x86/kernel/{microcode_intel.c => cpu/microcode/intel.c} (100%)
 rename arch/x86/kernel/{microcode_intel_early.c => cpu/microcode/intel_early.c} (98%)
 rename arch/x86/kernel/{microcode_intel_lib.c => cpu/microcode/intel_lib.c} (100%)

-- 
1.8.4

