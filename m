Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaDWBSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 21:18:53 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65081 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaDWBSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 21:18:49 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Aurelien Jacquiot <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chris Zankel <chris@zankel.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, James Hogan <james.hogan@imgtec.com>,
        Jonas Bonn <jonas@southpole.se>, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux@openrisc.net,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux-xtensa@linux-xtensa.org,
        Mark Salter <msalter@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Michal Simek <monstr@monstr.eu>, Paul Mackerras <paulus@samba.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>, x86@kernel.org
Subject: [PATCH v2 00/21] FDT clean-ups and libfdt support
Date: Tue, 22 Apr 2014 20:18:00 -0500
Message-Id: <1398215901-25609-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This is a series of clean-ups of architecture FDT code and converts the
core FDT code over to using libfdt functions. This is in preparation
to add FDT based address translation parsing functions for early
console support. This series removes direct access to FDT data from all
arches except powerpc.

The current MIPS lantiq and xlp DT code is buggy as built-in DTBs need
to be copied out of init section. Patches 2 and 3 should be applied to
3.15.

Changes in v2 are relatively minor. There was a bug in the unflattening
code where walking up the tree was not being handled correctly (thanks
to Michal Simek). I re-worked things a bit to avoid globally adding
libfdt include paths.

A branch is available here[1], and I plan to put into linux-next in a few
days. Please test! I've compiled on arm, arm64, mips, microblaze, xtensa,
and powerpc and booted on arm and arm64.

Rob

[1] git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git libfdt

Rob Herring (21):
  mips: octeon: convert to use unflatten_and_copy_device_tree
  mips: lantiq: copy built-in DTB out of init section
  mips: xlp: copy built-in DTB out of init section
  mips: ralink: convert to use unflatten_and_copy_device_tree
  ARM: dt: use default early_init_dt_alloc_memory_arch
  c6x: convert fdt pointers to opaque pointers
  mips: convert fdt pointers to opaque pointers
  of/fdt: consolidate built-in dtb section variables
  of/fdt: remove some unneeded includes
  of/fdt: remove unused of_scan_flat_dt_by_path
  of/fdt: update of_get_flat_dt_prop in prep for libfdt
  of/fdt: Convert FDT functions to use libfdt
  of/fdt: use libfdt accessors for header data
  of/fdt: create common debugfs
  of/fdt: move memreserve and dtb memory reservations into core
  of/fdt: fix phys_addr_t related print size warnings
  of/fdt: introduce of_get_flat_dt_size
  powerpc: use libfdt accessors for header data
  x86: use FDT accessors for FDT blob header data
  of/fdt: convert initial_boot_params to opaque pointer
  of: push struct boot_param_header and defines into powerpc

 arch/arc/include/asm/sections.h             |   1 -
 arch/arc/kernel/devtree.c                   |   2 +-
 arch/arm/include/asm/prom.h                 |   2 -
 arch/arm/kernel/devtree.c                   |  34 +--
 arch/arm/mach-exynos/exynos.c               |   2 +-
 arch/arm/mach-vexpress/platsmp.c            |   2 +-
 arch/arm/mm/init.c                          |   1 -
 arch/arm/plat-samsung/s5p-dev-mfc.c         |   4 +-
 arch/arm64/mm/init.c                        |  21 --
 arch/c6x/kernel/setup.c                     |   4 +-
 arch/metag/kernel/setup.c                   |   4 -
 arch/microblaze/kernel/prom.c               |  39 +--
 arch/mips/cavium-octeon/setup.c             |  20 +-
 arch/mips/include/asm/mips-boards/generic.h |   4 -
 arch/mips/include/asm/prom.h                |   6 +-
 arch/mips/kernel/prom.c                     |   2 +-
 arch/mips/lantiq/prom.c                     |  15 +-
 arch/mips/lantiq/prom.h                     |   2 -
 arch/mips/mti-sead3/sead3-setup.c           |   8 +-
 arch/mips/netlogic/xlp/dt.c                 |  19 +-
 arch/mips/ralink/of.c                       |  29 +-
 arch/openrisc/kernel/vmlinux.h              |   2 -
 arch/powerpc/include/asm/prom.h             |  39 +++
 arch/powerpc/kernel/Makefile                |   1 +
 arch/powerpc/kernel/epapr_paravirt.c        |   2 +-
 arch/powerpc/kernel/fadump.c                |   4 +-
 arch/powerpc/kernel/prom.c                  |  78 ++----
 arch/powerpc/kernel/rtas.c                  |   2 +-
 arch/powerpc/mm/hash_utils_64.c             |  22 +-
 arch/powerpc/platforms/52xx/efika.c         |   4 +-
 arch/powerpc/platforms/chrp/setup.c         |   4 +-
 arch/powerpc/platforms/powernv/opal.c       |  12 +-
 arch/powerpc/platforms/pseries/setup.c      |   4 +-
 arch/x86/kernel/devicetree.c                |  12 +-
 arch/xtensa/kernel/setup.c                  |   3 +-
 drivers/of/Kconfig                          |   1 +
 drivers/of/Makefile                         |   2 +
 drivers/of/fdt.c                            | 398 ++++++++++------------------
 drivers/of/of_reserved_mem.c                |   4 +-
 include/linux/of_fdt.h                      |  63 +----
 40 files changed, 280 insertions(+), 598 deletions(-)

-- 
1.9.1

