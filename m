Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161284AbaKNPzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:55:42 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63798 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965707AbaKNPym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:54:42 -0500
From: Andre Przywara <andre.przywara@arm.com>
To: will.deacon@arm.com, catalin.marinas@arm.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] arm64: alternatives runtime patching
Date: Fri, 14 Nov 2014 15:54:06 +0000
Message-Id: <1415980452-20366-1-git-send-email-andre.przywara@arm.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces alternatives runtime patching to arm64.
This allows to patch assembly instruction at runtime to either
fix hardware bugs or optimize for certain hardware features. Look
at patch 5/6 for an example on how to use this.

The code is heavily based on the x86 implementation.
Currently this is focussed on fixing CPU errata, but in the future
runtime optimizations for new CPU features are planned.

Patch 1/6 introduces a new cpu_hwcaps bitmap, which holds kernel
internal CPU feature flags. Since elf_hwcaps is also a userspace ABI,
I refrained from tinkering with this (tried this, gets messy).

Based on bits in this bitmap, in patch 2/6 we provide a macro to
replace (inline) assembly instructions at runtime with alternative
instructions. As on x86, those bits go into separate ELF sections.
The patching is done using stop_machine() to avoid mayhem in SMP.

Patch 3/6 introduces means to set cpu_hwcaps bits based on detecting
a certain CPU revision. Currently this is based on the architectural
bits in the MIDR register, but the code is flexible enough to easily
introduce more advanced criteria.
To support a heterogenous CPU setup (e.g. big.LITTLE), we scan all
CPUs in the system.

Patch 4 and 5 use the new framework to introduce workarounds for two
ARM-Cortex errata. Patch 4 introduces some more framework for the
detection, while patch 5 should be used as a blueprint for how to add
workarounds for CPU errata in the future.

Patch 6/6 finally introduces Kconfig entries for the bugs.
Those are meant to
a) document the errata and workarounds and
b) to allow system vendors to remove certain workarounds for custom
build kernels.
Though this shouldn't be strictly necessary, experience shows that
people will do b) anyway and I deem it better to provide official
means rather than provoking random hacks.

The code can be found also in the alternatives/v1 branch of:
http://www.linux-arm.org/git?p=linux-ap.git
git://linux-arm.org/linux-ap.git


Please review and comment!

Cheers,
Andre.

Andre Przywara (6):
  arm64: add cpu_capabilities bitmap
  arm64: add alternative runtime patching
  arm64: detect silicon revisions and set cap bits accordingly
  arm64: add Cortex-A53 cache errata workaround
  arm64: add Cortex-A57 erratum 832075 workaround
  arm64: protect alternatives workarounds with Kconfig options

 arch/arm64/Kconfig                       |  107 +++++++++++++++++++++++++++++
 arch/arm64/include/asm/alternative-asm.h |   29 ++++++++
 arch/arm64/include/asm/alternative.h     |   43 ++++++++++++
 arch/arm64/include/asm/cpufeature.h      |   29 ++++++++
 arch/arm64/include/asm/cputype.h         |    5 ++
 arch/arm64/include/asm/io.h              |   23 +++++--
 arch/arm64/kernel/Makefile               |    2 +-
 arch/arm64/kernel/alternative.c          |   64 +++++++++++++++++
 arch/arm64/kernel/cpu_errata.c           |  110 ++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c              |    3 +
 arch/arm64/kernel/setup.c                |    3 +
 arch/arm64/kernel/smp.c                  |    2 +
 arch/arm64/kernel/vmlinux.lds.S          |   11 +++
 arch/arm64/mm/cache.S                    |    4 +-
 arch/arm64/mm/init.c                     |    2 +
 15 files changed, 431 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm64/include/asm/alternative-asm.h
 create mode 100644 arch/arm64/include/asm/alternative.h
 create mode 100644 arch/arm64/kernel/alternative.c
 create mode 100644 arch/arm64/kernel/cpu_errata.c

-- 
1.7.9.5

