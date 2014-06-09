Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbaFIQOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:14:48 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46749 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675AbaFIQOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:14:45 -0400
Date: Mon, 9 Jun 2014 12:14:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata changes for v3.16-rc1
Message-ID: <20140609161441.GD22540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing too interesting - another ahci platform driver variant,
additional controller support, minor fixes and cleanups; however,
pulling will generate the following conflict in drivers/ata/ahci.h.

	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
<<<<<<< HEAD
	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
=======
	AHCI_HFLAG_NO_FBS		= (1 << 17), /* no FBS */
>>>>>>> d251836508fb26cd1a22b41381739835ee23728d

The conflict is from the following two commits, the former in
libata/for-3.15-fixes and the latter in libata/for-3.16.

  0cf4a7d6cf237152 ("ahci: disable DEVSLP for Intel Valleyview")
  888d91a08fa8e2be ("ata: ahci: append new hflag AHCI_HFLAG_NO_FBS")

Both add new AHCI_HFLAG_* flags causing the trivial conflict.  It can
be resolved by assigning consecutive flag bits to them like the
following.

	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
	AHCI_HFLAG_NO_FBS		= (1 << 18), /* no FBS */

Just in case, the merged result is available in the following branch.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git test-merge-for-3.16

Thanks.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.16

for you to fetch changes up to d251836508fb26cd1a22b41381739835ee23728d:

  ahci: Add Device ID for HighPoint RocketRaid 642L (2014-06-03 14:55:18 -0400)

----------------------------------------------------------------
Andreas Schrägle (1):
      ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Barry Song (1):
      ata: ep93xx: use dmaengine_prep_slave_sg api instead of internal callback

Bartlomiej Zolnierkiewicz (2):
      pata_octeon_cf: use devm_kzalloc() to allocate cf_port
      ata: use CONFIG_PM_SLEEP instead of CONFIG_PM where applicable in host drivers

Jérôme Carretero (1):
      ahci: Add Device ID for HighPoint RocketRaid 642L

Kefeng Wang (3):
      ata: ahci: append new hflag AHCI_HFLAG_NO_FBS
      libahci_platform: add host_flags parameter in ahci_platform_init_host()
      ahci: add support for Hisilicon sata

Keith Busch (1):
      ata: SATL compliance for Inquiry Product Revision

Paul Bolle (2):
      libata-sff: remove dead code
      sata_fsl: remove check for CONFIG_MPC8315_DS

Thomas Petazzoni (2):
      Documentation: dt-bindings: reformat and order list of ahci-platform compatibles
      ata: ahci_mvebu: new driver for Marvell Armada 380 AHCI interfaces

 .../devicetree/bindings/ata/ahci-platform.txt      |  14 ++-
 drivers/ata/Kconfig                                |   9 ++
 drivers/ata/Makefile                               |   1 +
 drivers/ata/acard-ahci.c                           |   6 +-
 drivers/ata/ahci.c                                 |   4 +
 drivers/ata/ahci.h                                 |   1 +
 drivers/ata/ahci_da850.c                           |   3 +-
 drivers/ata/ahci_imx.c                             |   3 +-
 drivers/ata/ahci_mvebu.c                           | 128 +++++++++++++++++++++
 drivers/ata/ahci_platform.c                        |   9 +-
 drivers/ata/ahci_st.c                              |   2 +-
 drivers/ata/ahci_sunxi.c                           |   9 +-
 drivers/ata/ahci_xgene.c                           |   7 +-
 drivers/ata/ata_generic.c                          |   2 +-
 drivers/ata/ata_piix.c                             |   4 +-
 drivers/ata/libahci.c                              |   5 +
 drivers/ata/libahci_platform.c                     |   5 +-
 drivers/ata/libata-scsi.c                          |   6 +-
 drivers/ata/libata-sff.c                           |   9 --
 drivers/ata/pata_acpi.c                            |   2 +-
 drivers/ata/pata_ali.c                             |   4 +-
 drivers/ata/pata_amd.c                             |   4 +-
 drivers/ata/pata_artop.c                           |   4 +-
 drivers/ata/pata_atiixp.c                          |   2 +-
 drivers/ata/pata_atp867x.c                         |   4 +-
 drivers/ata/pata_bf54x.c                           |   2 +-
 drivers/ata/pata_cmd640.c                          |   4 +-
 drivers/ata/pata_cmd64x.c                          |   4 +-
 drivers/ata/pata_cs5520.c                          |   6 +-
 drivers/ata/pata_cs5530.c                          |   6 +-
 drivers/ata/pata_cs5535.c                          |   2 +-
 drivers/ata/pata_cs5536.c                          |   2 +-
 drivers/ata/pata_cypress.c                         |   2 +-
 drivers/ata/pata_efar.c                            |   2 +-
 drivers/ata/pata_ep93xx.c                          |   4 +-
 drivers/ata/pata_hpt366.c                          |   4 +-
 drivers/ata/pata_hpt3x3.c                          |   4 +-
 drivers/ata/pata_imx.c                             |   4 +-
 drivers/ata/pata_it8213.c                          |   2 +-
 drivers/ata/pata_it821x.c                          |   4 +-
 drivers/ata/pata_jmicron.c                         |   2 +-
 drivers/ata/pata_macio.c                           |  22 ++--
 drivers/ata/pata_marvell.c                         |   2 +-
 drivers/ata/pata_mpc52xx.c                         |   8 +-
 drivers/ata/pata_mpiix.c                           |   2 +-
 drivers/ata/pata_netcell.c                         |   2 +-
 drivers/ata/pata_ninja32.c                         |   5 +-
 drivers/ata/pata_ns87410.c                         |   2 +-
 drivers/ata/pata_ns87415.c                         |   4 +-
 drivers/ata/pata_octeon_cf.c                       |  50 +++-----
 drivers/ata/pata_oldpiix.c                         |   2 +-
 drivers/ata/pata_opti.c                            |   2 +-
 drivers/ata/pata_optidma.c                         |   2 +-
 drivers/ata/pata_pdc2027x.c                        |   6 +-
 drivers/ata/pata_pdc202xx_old.c                    |   2 +-
 drivers/ata/pata_piccolo.c                         |   2 +-
 drivers/ata/pata_radisys.c                         |   2 +-
 drivers/ata/pata_rdc.c                             |   2 +-
 drivers/ata/pata_rz1000.c                          |   4 +-
 drivers/ata/pata_samsung_cf.c                      |   4 +-
 drivers/ata/pata_sc1200.c                          |   2 +-
 drivers/ata/pata_scc.c                             |   2 +-
 drivers/ata/pata_sch.c                             |   2 +-
 drivers/ata/pata_serverworks.c                     |   4 +-
 drivers/ata/pata_sil680.c                          |   4 +-
 drivers/ata/pata_sis.c                             |   4 +-
 drivers/ata/pata_sl82c105.c                        |   4 +-
 drivers/ata/pata_triflex.c                         |   4 +-
 drivers/ata/pata_via.c                             |   4 +-
 drivers/ata/sata_fsl.c                             |  18 +--
 drivers/ata/sata_inic162x.c                        |   4 +-
 drivers/ata/sata_mv.c                              |   8 +-
 drivers/ata/sata_nv.c                              |   6 +-
 drivers/ata/sata_rcar.c                            |   4 +-
 drivers/ata/sata_sil.c                             |   6 +-
 drivers/ata/sata_sil24.c                           |  10 +-
 drivers/ata/sata_sis.c                             |   2 +-
 drivers/ata/sata_via.c                             |   2 +-
 include/linux/ahci_platform.h                      |   1 +
 79 files changed, 324 insertions(+), 193 deletions(-)
 create mode 100644 drivers/ata/ahci_mvebu.c

-- 
tejun
