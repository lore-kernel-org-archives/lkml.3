Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaIKImM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:42:12 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43890 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 00/10] MIPS O32 new FP ABI support
Date: Thu, 11 Sep 2014 08:30:13 +0100
Message-ID: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces support for reading the FP mode requirements of
ELF binaries from their .MIPS.abiflags section when present, and
configuring the system appropriately. The motivation for these new ABIs
is to enable O32 binaries to operate with a 64b FPU (Status.FR=1) and
therefore to run on systems where that is the only FPU available, allow
use of MSA & do so without rebuilding the world. For further details on
the new ABIs please see:

  https://dmz-portal.mips.com/wiki/MIPS_O32_ABI_-_FR0_and_FR1_Interlinking

The first 3 patches of the series extend binfmt_elf with hooks such that
the MIPS architecture code can access the FP mode information & reject
invalid FP modes.

Patches 4-7 introduce support for operating with "hybrid FPRs" - a
scheme in which odd single precision registers alias with the upper 32b
of the preceeding even double as is typical with FR=0, but where all
32 64b doubles are also available. This is implemented by trapping &
emulating single precision register accesses using a new Config5.FRE
bit.

Patches 8 & 9 introduce the .MIPS.abiflags section along with the kernel
support for reading it & treating binaries accordingly.

Patch 10 adds a simple debug option to test the implementation of hybrid
FPRs by forcing all code that can operate in that mode to do so, which
is usually avoided due to the overhead of trapping & emulating.

Paul Burton (10):
  binfmt_elf: hoist ELF program header loading to a function
  binfmt_elf: load interpreter program headers earlier
  binfmt_elf: allow arch code to examine PT_LOPROC ... PT_HIPROC headers
  MIPS: define bits introduced for hybrid FPRs
  MIPS: detect presence of the FRE & UFR bits
  MIPS: ensure Config5.UFE is clear on boot
  MIPS: support for hybrid FPRs
  MIPS: ELF: add definition for the .MIPS.abiflags section
  MIPS: ELF: set FP mode according to .MIPS.abiflags
  MIPS: Kconfig option to better exercise/debug hybrid FPRs

 arch/mips/Kconfig                    |   1 +
 arch/mips/Kconfig.debug              |  13 +++
 arch/mips/include/asm/cpu-features.h |   4 +
 arch/mips/include/asm/cpu.h          |   1 +
 arch/mips/include/asm/elf.h          |  74 +++++++++++---
 arch/mips/include/asm/fpu.h          |  49 ++++++++--
 arch/mips/include/asm/mipsregs.h     |   3 +
 arch/mips/include/asm/thread_info.h  |   2 +
 arch/mips/kernel/Makefile            |   7 +-
 arch/mips/kernel/cpu-probe.c         |   4 +-
 arch/mips/kernel/elf.c               | 181 +++++++++++++++++++++++++++++++++++
 arch/mips/kernel/traps.c             |  47 +++++++++
 arch/mips/math-emu/cp1emu.c          |   9 +-
 fs/Kconfig.binfmt                    |   3 +
 fs/binfmt_elf.c                      | 169 ++++++++++++++++++++------------
 include/linux/elf.h                  |  73 ++++++++++++++
 16 files changed, 549 insertions(+), 91 deletions(-)
 create mode 100644 arch/mips/kernel/elf.c

-- 
2.0.4

