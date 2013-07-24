Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab3GXH7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 03:59:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:35228 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3GXH7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 03:59:34 -0400
Message-ID: <1374652760.3916.124.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jul 2013 17:59:20 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here is a series of powerpc fixes. It's a bit big, mostly because of the
series of 11 "EEH" patches from Gavin. The EEH (Our IBM specific
PCI/PCIe Enhanced Error Handling) code had been rotting for a while and
this merge window saw a significant rework & fixing of it by Gavin Shan.

However, that wasn't complete and left some open issues. There were
still a few corner cases that didn't work properly, for example in
relation to hotplug and devices without explicit error handlers. We had
some patches but they weren't quite good enough yet so I left them off
the 3.11 merge window.

Gavin since then fixed it all up, we ran quite a few rounds of testing
and it seems fairly solid (at least probably more than it has ever
been). This should probably have made -rc1 but both Gavin and I took
some vacation so it had to wait for -rc2.

The rest is more bug fixes, mostly to new features recently added, for
example, we missed the cpu table entry for one of the two models of P8
(we didn't realize they had different PVR [Processor Version Register]
values), some module CRC issues, etc...

Please apply,

Cheers,
Ben.

The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to ff3d79dc12c2ed38483f6c1e0f26fde430f27c9d:

  powerpc/perf: BHRB filter configuration should follow the task (2013-07-24 14:42:34 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (2):
      powerpc/mm: Fix fallthrough bug in hpte_decode
      powerpc/mm: Use the correct SLB(LLP) encoding in tlbie instruction

Anshuman Khandual (2):
      powerpc/perf: Ignore separate BHRB privilege state filter request
      powerpc/perf: BHRB filter configuration should follow the task

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Bjorn Helgaas (1):
      powerpc/powernv: Mark pnv_pci_init_ioda2_phb() as __init

Denis Kirjanov (1):
      powerpc/pseries: Fix a typo in pSeries_lpar_hpte_insert()

Gavin Shan (11):
      powerpc/eeh: Remove reference to PCI device
      powerpc/eeh: Export functions for hotplug
      powerpc/pci: Override pcibios_release_device()
      powerpc/pci/hotplug: Don't need to remove from EEH cache twice
      powerpc/eeh: Keep PE during hotplug
      powerpc/eeh: Use safe list traversal when walking EEH devices
      powerpc/pci: Partial tree hotplug support
      powerpc/eeh: Use partial hotplug for EEH unaware drivers
      powerpc/eeh: Don't use pci_dev during BAR restore
      powerpc/eeh: Fix unbalanced enable for IRQ
      powerpc/eeh: Introdce flag to protect sysfs

Mahesh Salgaonkar (1):
      powerpc: Fix the corrupt r3 error during MCE handling.

Michael Ellerman (1):
      powerpc/perf: Set PPC_FEATURE2_EBB when we register the power8 PMU

Michael Neuling (1):
      powerpc: Add second POWER8 PVR entry

Paul Bolle (1):
      powerpc/pseries: Drop "select HOTPLUG"

Tiejun Chen (1):
      powerpc: Access local paca after hard irq disabled

 arch/powerpc/include/asm/eeh.h               | 30 ++++++++---
 arch/powerpc/include/asm/hw_irq.h            |  7 +--
 arch/powerpc/include/asm/module.h            |  5 +-
 arch/powerpc/include/asm/pci-bridge.h        |  1 -
 arch/powerpc/include/asm/reg.h               |  3 +-
 arch/powerpc/kernel/cputable.c               | 20 +++++++-
 arch/powerpc/kernel/eeh.c                    | 70 ++++++++++++-------------
 arch/powerpc/kernel/eeh_cache.c              | 18 ++-----
 arch/powerpc/kernel/eeh_driver.c             | 77 ++++++++++++++++++++++++++--
 arch/powerpc/kernel/eeh_pe.c                 | 58 +++++++++------------
 arch/powerpc/kernel/eeh_sysfs.c              | 21 ++++++++
 arch/powerpc/kernel/pci-common.c             |  2 +
 arch/powerpc/kernel/pci-hotplug.c            | 49 +++++++++---------
 arch/powerpc/kernel/pci_of_scan.c            | 56 ++++++++++++++------
 arch/powerpc/kernel/prom_init.c              |  5 +-
 arch/powerpc/kernel/vmlinux.lds.S            |  3 --
 arch/powerpc/mm/hash_native_64.c             | 12 ++++-
 arch/powerpc/perf/core-book3s.c              |  5 +-
 arch/powerpc/perf/power8-pmu.c               | 24 +++++----
 arch/powerpc/platforms/powernv/eeh-powernv.c | 17 ++++--
 arch/powerpc/platforms/powernv/pci-ioda.c    |  2 +-
 arch/powerpc/platforms/pseries/Kconfig       |  1 -
 arch/powerpc/platforms/pseries/eeh_pseries.c | 67 ++++++++++++++++++++++--
 arch/powerpc/platforms/pseries/lpar.c        |  2 +-
 arch/powerpc/platforms/pseries/ras.c         |  3 ++
 drivers/pci/hotplug/rpadlpar_core.c          |  1 -
 26 files changed, 390 insertions(+), 169 deletions(-)


