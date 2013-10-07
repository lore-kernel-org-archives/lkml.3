Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3JGQ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:29:57 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62273 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab3JGQ3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:29:49 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chris Zankel <chris@zankel.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, James Hogan <james.hogan@imgtec.com>,
        Jonas Bonn <jonas@southpole.se>, Mark Salter <msalter@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, Michal Simek <monstr@monstr.eu>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>, Will Deacon <will.deacon@arm.com>,
        x86@kernel.org
Subject: [PATCH v2 00/29] Early flattened DT init consolidation
Date: Mon,  7 Oct 2013 11:29:08 -0500
Message-Id: <1381163377-21044-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This is the first of 2 series to do some consolidation of per
architecture Device Tree code. We now have 12 architectures with DT
support. As new architectures have been added, much of the DT related
code for the early flattened DT scanning has been duplicated. Yet little
of this code is architecture specific. This series has 4 main parts:

- Create a common function to copy built-in dtb's out of init section
- Create a single, common function to scan the FDT
- Removal of early_init_dt_setup_initrd_arch
- Create common functions for machine matching with DT

The entire series with prom.h clean-up series is available here:
git://sources.calxeda.com/kernel/linux.git dt-cleanup

Compiled on arm, arm64, microblaze, mips, openrisc, powerpc, sparc,
xtensa.

Version 1 of this series is here:
http://www.spinics.net/lists/devicetree/msg04865.html

The prom.h clean-up series is here:
http://www.spinics.net/lists/devicetree/msg06175.html

Changes in v2:
- Rebase to v3.12-rc3
- add arm64 sanity checks to default early_init_dt_add_memory_arch
- drop x86 and metag from common early_init_dt_add_memory_arch
- move metag early_init_dt_scan support to separate patch
- metag fixes from James Hogan
- Add NULL checks in early_init_dt_scan
- Document proper use of unflatten_and_copy_device_tree
- fix section mismatches with of_flat_dt_get_machine_name
- fix non-DT boot on ARM

Rob


Rob Herring (29):
  c6x: use boot_command_line instead of private c6x_command_line
  openrisc: use boot_command_line instead of private cmd_line
  of: create unflatten_and_copy_device_tree
  arc: use unflatten_and_copy_device_tree
  openrisc: use unflatten_and_copy_device_tree
  x86: use unflatten_and_copy_device_tree
  xtensa: use unflatten_and_copy_device_tree
  metag: use unflatten_and_copy_device_tree
  of: Introduce common early_init_dt_scan
  arc: use early_init_dt_scan
  arm: use early_init_dt_scan
  arm64: use early_init_dt_scan
  c6x: use early_init_dt_scan
  metag: use early_init_dt_scan
  microblaze: use early_init_dt_scan
  mips: use early_init_dt_scan
  openrisc: use early_init_dt_scan
  xtensa: use early_init_dt_scan
  of: create default early_init_dt_add_memory_arch
  arm: set initrd_start/initrd_end for fdt scan
  arm64: set initrd_start/initrd_end for fdt scan
  of: remove early_init_dt_setup_initrd_arch
  openrisc: remove unnecessary prom.c includes
  of: introduce common FDT machine related functions
  arc: use common of_flat_dt_match_machine
  arm: use common of_flat_dt_match_machine
  arm64: use common of_flat_dt_get_machine_name
  metag: use common of_flat_dt_match_machine
  mips: use common of_flat_dt_get_machine_name

 arch/arc/include/asm/mach_desc.h   |   1 -
 arch/arc/kernel/devtree.c          |  94 +++++--------------------
 arch/arc/kernel/setup.c            |   3 +-
 arch/arc/mm/init.c                 |   7 --
 arch/arm/kernel/devtree.c          |  58 ++++++----------
 arch/arm/mm/init.c                 |  13 ++--
 arch/arm64/kernel/setup.c          |  60 ++--------------
 arch/arm64/mm/init.c               |  24 ++-----
 arch/c6x/include/asm/setup.h       |   2 -
 arch/c6x/kernel/devicetree.c       |  29 --------
 arch/c6x/kernel/setup.c            |  13 +---
 arch/c6x/kernel/vmlinux.lds.S      |   6 --
 arch/metag/include/asm/mach/arch.h |   2 +-
 arch/metag/include/asm/prom.h      |   2 +-
 arch/metag/kernel/devtree.c        |  83 ++++++----------------
 arch/metag/kernel/setup.c          |   6 +-
 arch/metag/mm/init.c               |   9 ---
 arch/microblaze/kernel/prom.c      |  31 +--------
 arch/microblaze/kernel/setup.c     |   2 +-
 arch/mips/include/asm/prom.h       |   3 -
 arch/mips/kernel/prom.c            |  60 +---------------
 arch/openrisc/kernel/prom.c        |  70 +------------------
 arch/openrisc/kernel/setup.c       |   6 +-
 arch/powerpc/kernel/prom.c         |   9 ---
 arch/x86/kernel/devicetree.c       |  32 +++------
 arch/xtensa/kernel/setup.c         |  55 ++++-----------
 drivers/of/fdt.c                   | 138 ++++++++++++++++++++++++++++++++++++-
 include/linux/of_fdt.h             |  18 +++--
 28 files changed, 256 insertions(+), 580 deletions(-)

-- 
1.8.1.2

