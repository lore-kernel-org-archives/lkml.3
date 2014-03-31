Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbaCaTxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:53:51 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:52858 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaCaTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:53:47 -0400
Date: Mon, 31 Mar 2014 15:53:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.15-rc1
Message-ID: <20140331195342.GC28901@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

A lot of activities on libata side this time.

* A lot of changes around ahci.  Various embedded platforms are
  implementing ahci controllers.  Some were built atop ahci_platform,
  others were doing their own things.  Hans made some structural
  changes to libahci and librarized ahci_platform so that ahci
  platform drivers can share more common code.  A couple platform
  drivers are added on top of that and several are added to replace
  older drivers which were doing their own things (older ones are
  scheduled to be removed).

* Dan finishes the patchset to make libata PM operations asynchronous.
  Combined with one patch being routed through scsi, this should speed
  resume measurably.

* Various fixes and cleanups from Bartlomiej and others.

Pulling causes the following conflict in drivers/ata/Kconfig

  config SATA_MV
	  tristate "Marvell SATA support"
  <<<<<<< HEAD
	  select GENERIC_PHY
  =======
	  depends on PCI || ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
		     ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
  >>>>>>> 03803ef66d22702af124d21552f90ac32da9fef5
	  help

It's a trivial context conflict between 03803ef66d22 ("ata: fix
Marvell SATA driver dependencies") and 49c8f1ffe26f ("ATA: SATA_MV:
Add missing Kconfig select statememnt") which can be resolved like the
following.

  config SATA_MV
	  tristate "Marvell SATA support"
	  depends on PCI || ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
		     ARCH_MVEBU || ARCH_ORION5X || COMPILE_TEST
	  select GENERIC_PHY
	  help

Just in case, the merged result is available in test-merge-3.15
branch.

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.15

for you to fetch changes up to 03803ef66d22702af124d21552f90ac32da9fef5:

  ata: fix Marvell SATA driver dependencies (2014-03-27 10:50:33 -0400)

Thanks.

----------------------------------------------------------------
Aaron Lu (3):
      libata: zpodd: should depend on PM_RUNTIME
      libata: acpi: avoid passing NULL to ACPI evaluation method
      libata: zpodd: eliminate odd_can_poweroff

Bartlomiej Zolnierkiewicz (15):
      ata: ahci_st: build fixes
      ata: ahci_st: remove deprecated struct ahci_platform_data usage
      ata: pata_imx: fix devm_ioremap_resource() return value checking
      ata: ahci_platform: fix devm_ioremap_resource() return value checking
      ata: ahci_sunxi: make ahci_sunxi_resume() static
      ata: ahci_sunxi: fix code formatting
      ata: ahci_platform: fix ahci_platform_data->suspend method handling
      ata: move library code from ahci_platform.c to libahci_platform.c
      ata: add new-style AHCI platform driver for DaVinci DA850 AHCI controller
      ARM: davinci: da850: update SATA AHCI support
      ata: fix R-Car SATA driver dependencies
      ata: fix Calxeda Highbank SATA driver dependencies
      ata: sata_highbank: remove superfluous cast
      ata: fix ARASAN CompactFlash PATA driver dependencies
      ata: fix Marvell SATA driver dependencies

Daeseok Youn (2):
      ata: libahci: make ahci_pmp_retry_softreset() as static
      ata: libahci: replace obsolete simple_strtoul() with kstrtouint()

Dan Williams (3):
      libata: end the r-word
      libata, libsas: kill pm_result and related cleanup
      libata: remove unused ata_sas_port_async_resume() stub

Fabio Estevam (2):
      pata_imx: Use devm_ioremap_resource() to simplify code
      pata_imx: Propagate the real error code on platform_get_irq() failure

Hans de Goede (12):
      libahci: Allow drivers to override start_engine
      ahci-platform: Add support for devices with more then 1 clock
      ahci-platform: Add support for an optional regulator for sata-target power
      ahci-platform: Add enable_ / disable_resources helper functions
      ahci-platform: "Library-ise" ahci_probe functionality
      ahci-platform: "Library-ise" suspend / resume functionality
      ahci-imx: Port to library-ised ahci_platform
      ahci_platform: Drop support for ahci-strict platform device type
      ahci_platform: Drop support for imx53-ahci platform device type
      ahci_platform: Drop unused ahci_platform_data members
      ahci_sunxi: Use msleep instead of mdelay
      ahci_imx: Put #ifdef CONFIG_PM_SLEEP around suspend / resume functions

Jean Delvare (2):
      ata: Fix CS55xx dependencies
      ata: Fix SC1200 dependencies

Joe Perches (1):
      ata: remove superfluous casts

Lee Jones (6):
      ahci: st: Add support for ST's SATA IP
      ahci: st: Standardise naming conventions
      ahci: st: Remove legacy dependencies on PHY
      ahci: st: Utilise ata_platform_remove_one() call
      ahci: st: Only build for ST-Micro h/w
      ahci: st: Invoke AHCI Platform Suspend/Resume

Loc Ho (5):
      arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries
      Documentation: Add documentation for the APM X-Gene SoC SATA host controller DTS binding
      ata: Add APM X-Gene SoC AHCI SATA host controller driver
      arm64: Add APM X-Gene SoC AHCI SATA host controller DTS entries
      ata: Fix compiler warning with APM X-Gene host controller driver

Olliver Schinagl (1):
      ARM: sunxi: Add support for Allwinner SUNXi SoCs sata to ahci_platform

Paul Gortmaker (1):
      ata: delete non-required instances of include <linux/init.h>

Randy Dunlap (2):
      ata: CONFIG_ATA is libata
      libata.h: add stub for ata_sas_port_resume

Roger Quadros (4):
      ata: ahci_platform: Add DT compatible for Synopsis DWC AHCI controller
      ata: ahci_platform: Update DT compatible list
      ata: ahci_platform: Manage SATA PHY
      ata: ahci_platform: runtime resume the device before use

Silvan Jegen (1):
      pata_legacy: Remove dead code

Todd Brandt (1):
      libata: async resume

 .../devicetree/bindings/ata/ahci-platform.txt      |  22 +-
 .../devicetree/bindings/ata/apm-xgene.txt          |  76 +++
 arch/arm/mach-davinci/da850.c                      |   2 +-
 arch/arm/mach-davinci/devices-da8xx.c              |  99 +---
 arch/arm64/boot/dts/apm-storm.dtsi                 | 152 ++++++
 drivers/ata/Kconfig                                |  56 ++-
 drivers/ata/Makefile                               |   8 +-
 drivers/ata/acard-ahci.c                           |   1 -
 drivers/ata/ahci.c                                 |   7 +-
 drivers/ata/ahci.h                                 |  14 +-
 drivers/ata/ahci_da850.c                           | 114 +++++
 drivers/ata/ahci_imx.c                             | 333 +++++--------
 drivers/ata/ahci_platform.c                        | 291 +----------
 drivers/ata/ahci_st.c                              | 245 ++++++++++
 drivers/ata/ahci_sunxi.c                           | 249 ++++++++++
 drivers/ata/ahci_xgene.c                           | 486 ++++++++++++++++++
 drivers/ata/ata_generic.c                          |   1 -
 drivers/ata/libahci.c                              |  38 +-
 drivers/ata/libahci_platform.c                     | 541 +++++++++++++++++++++
 drivers/ata/libata-acpi.c                          |   1 +
 drivers/ata/libata-core.c                          | 135 +++--
 drivers/ata/libata-eh.c                            |  18 +-
 drivers/ata/libata-zpodd.c                         |  21 +-
 drivers/ata/pata_acpi.c                            |   1 -
 drivers/ata/pata_amd.c                             |   1 -
 drivers/ata/pata_arasan_cf.c                       |   2 +-
 drivers/ata/pata_artop.c                           |   1 -
 drivers/ata/pata_at91.c                            |   1 -
 drivers/ata/pata_atiixp.c                          |   1 -
 drivers/ata/pata_atp867x.c                         |   1 -
 drivers/ata/pata_cmd640.c                          |   1 -
 drivers/ata/pata_cmd64x.c                          |   1 -
 drivers/ata/pata_cs5520.c                          |   1 -
 drivers/ata/pata_cs5530.c                          |   1 -
 drivers/ata/pata_cs5535.c                          |   1 -
 drivers/ata/pata_cs5536.c                          |   1 -
 drivers/ata/pata_cypress.c                         |   1 -
 drivers/ata/pata_efar.c                            |   1 -
 drivers/ata/pata_ep93xx.c                          |   1 -
 drivers/ata/pata_hpt366.c                          |   1 -
 drivers/ata/pata_hpt37x.c                          |   1 -
 drivers/ata/pata_hpt3x2n.c                         |   1 -
 drivers/ata/pata_hpt3x3.c                          |   1 -
 drivers/ata/pata_imx.c                             |  18 +-
 drivers/ata/pata_it8213.c                          |   1 -
 drivers/ata/pata_it821x.c                          |   1 -
 drivers/ata/pata_jmicron.c                         |   1 -
 drivers/ata/pata_legacy.c                          |   1 -
 drivers/ata/pata_marvell.c                         |   1 -
 drivers/ata/pata_mpiix.c                           |   1 -
 drivers/ata/pata_netcell.c                         |   1 -
 drivers/ata/pata_ninja32.c                         |   1 -
 drivers/ata/pata_ns87410.c                         |   1 -
 drivers/ata/pata_ns87415.c                         |   1 -
 drivers/ata/pata_oldpiix.c                         |   1 -
 drivers/ata/pata_opti.c                            |   1 -
 drivers/ata/pata_optidma.c                         |   1 -
 drivers/ata/pata_pcmcia.c                          |   1 -
 drivers/ata/pata_pdc2027x.c                        |   1 -
 drivers/ata/pata_pdc202xx_old.c                    |   1 -
 drivers/ata/pata_piccolo.c                         |   1 -
 drivers/ata/pata_platform.c                        |   1 -
 drivers/ata/pata_pxa.c                             |   1 -
 drivers/ata/pata_radisys.c                         |   1 -
 drivers/ata/pata_rdc.c                             |   1 -
 drivers/ata/pata_rz1000.c                          |   1 -
 drivers/ata/pata_sc1200.c                          |   1 -
 drivers/ata/pata_scc.c                             |   1 -
 drivers/ata/pata_sch.c                             |   1 -
 drivers/ata/pata_serverworks.c                     |   1 -
 drivers/ata/pata_sil680.c                          |   1 -
 drivers/ata/pata_sis.c                             |   1 -
 drivers/ata/pata_sl82c105.c                        |   1 -
 drivers/ata/pata_triflex.c                         |   1 -
 drivers/ata/pata_via.c                             |   1 -
 drivers/ata/pdc_adma.c                             |   1 -
 drivers/ata/sata_dwc_460ex.c                       |   4 +-
 drivers/ata/sata_highbank.c                        |   6 +-
 drivers/ata/sata_nv.c                              |   1 -
 drivers/ata/sata_promise.c                         |   1 -
 drivers/ata/sata_qstor.c                           |   1 -
 drivers/ata/sata_sil.c                             |   1 -
 drivers/ata/sata_sis.c                             |   1 -
 drivers/ata/sata_svw.c                             |   1 -
 drivers/ata/sata_sx4.c                             |  10 +-
 drivers/ata/sata_uli.c                             |   1 -
 drivers/ata/sata_via.c                             |   1 -
 drivers/ata/sata_vsc.c                             |   1 -
 drivers/scsi/libsas/sas_ata.c                      |  35 +-
 include/linux/ahci_platform.h                      |  28 +-
 include/linux/libata.h                             |  11 +-
 include/scsi/libsas.h                              |   1 -
 92 files changed, 2249 insertions(+), 836 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/ahci_da850.c
 create mode 100644 drivers/ata/ahci_st.c
 create mode 100644 drivers/ata/ahci_sunxi.c
 create mode 100644 drivers/ata/ahci_xgene.c
 create mode 100644 drivers/ata/libahci_platform.c

-- 
tejun
