Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab3DAFBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:01:30 -0400
Received: from mail.pr.hu ([87.242.0.5]:33391 "EHLO mail.pr.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756953Ab3DAFB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:01:27 -0400
Message-ID: <51591493.20009@pr.hu>
Date: Mon, 01 Apr 2013 07:01:07 +0200
From: Boszormenyi Zoltan <zboszor@pr.hu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: New architecture for the Linux kernel
Content-Type: multipart/mixed;
 boundary="------------030601030506030904090502"
X-Spam-Score: -2.1 (--)
X-Scan-Signature: f8ce64351844b91b218feff1ac55a82b
X-Spam-Tracer: backend.mail.pr.hu -2.1 20130401045931Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030601030506030904090502
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

the attached WIP patch implements a new hardware architecture for the Linux kernel.

Currently, the new platform is x86 hosted, the real support code only exists in theory.

The patch applies to 3.7.x and configuration can be done using "make ARCH=tm xconfig".

Driver support is only sensible for tape drives, so only those are included.
WIP support for 8-track tape recorders (currently, configuration entry only)is also exposed.

Comments?

Best regards and Happy Easter,
Zoltán Böszörményi


--------------030601030506030904090502
Content-Type: text/x-patch;
 name="tm-support-v1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tm-support-v1.patch"

diff -durp --unidirectional-new-file linux-3.7.10/arch/tm/configs/tm_defconfig linux-3.7.10.tm/arch/tm/configs/tm_defconfig
--- linux-3.7.10/arch/tm/configs/tm_defconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.10.tm/arch/tm/configs/tm_defconfig	2013-03-30 20:36:29.139284906 +0100
@@ -0,0 +1,14 @@
+#
+# Automatically generated file; DO NOT EDIT.
+# Linux/  Kernel Configuration
+#
+CONFIG_NODES=8
+
+#
+# SCSI device support
+#
+# CONFIG_SCSI is not set
+# CONFIG_ATA is not set
+CONFIG_8TRAK=y
+CONFIG_REWIND=y
+CONFIG_INFINITE_TAPE=y
diff -durp --unidirectional-new-file linux-3.7.10/arch/tm/Kconfig linux-3.7.10.tm/arch/tm/Kconfig
--- linux-3.7.10/arch/tm/Kconfig	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.10.tm/arch/tm/Kconfig	2013-03-30 20:31:59.914793083 +0100
@@ -0,0 +1,34 @@
+config NODES
+	int "Number of state nodes"
+	default 8
+	---help---
+	  Configure the number of state nodes for the Turing Machine.
+	  The nodes may have different semantic meaning for a
+	  particular build in a different use case.
+
+source arch/tm/Kconfig.scsi
+
+source arch/tm/Kconfig.ata
+
+config 8TRAK
+	tristate "8-track tape recorder support"
+	select REWIND
+	---help---
+	  Support for legacy hi-fi audio device used as data storage
+	  for the Turing Machine. This device needs less manual labour
+	  than some newer tape devices, since the tape is both longer
+	  and contains more tracks for recording data. It builds on
+	  auto-rewind support to make it more convenient to use.
+
+config REWIND
+	bool "Tape rewind support"
+	---help---
+	  Auto-rewind support for tape drives. It makes users' life easier.
+
+config INFINITE_TAPE
+	bool "Infinite tape"
+	---help---
+	  Whether the tape read by the Turing Machine is infinite.
+	  An infinite tape needs manual intervention to feed more data
+	  (i.e. change a tape in the tape reader) it adds a new implicit
+	  state so stopping of the Turing Machine doesn't mean program end.
diff -durp --unidirectional-new-file linux-3.7.10/arch/tm/Kconfig.ata linux-3.7.10.tm/arch/tm/Kconfig.ata
--- linux-3.7.10/arch/tm/Kconfig.ata	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.10.tm/arch/tm/Kconfig.ata	2013-03-30 20:32:58.675151181 +0100
@@ -0,0 +1,636 @@
+#
+# SATA/PATA driver configuration
+#
+
+config HAVE_PATA_PLATFORM
+	bool
+	help
+	  This is an internal configuration node for any machine that
+	  uses pata-platform driver to enable the relevant driver in the
+	  configuration structure without having to submit endless patches
+	  to update the PATA_PLATFORM entry.
+
+menuconfig ATA
+	tristate "Serial ATA and Parallel ATA drivers"
+	select SCSI
+	select CHR_DEV_ST
+	---help---
+	  If you want to use a ATA hard disk, ATA tape drive, ATA CD-ROM or
+	  any other ATA device under Linux, say Y and make sure that you know
+	  the name of your ATA host adapter (the card inside your computer
+	  that "speaks" the ATA protocol, also called ATA controller),
+	  because you will be asked for it.
+
+	  NOTE: ATA enables basic SCSI support; *however*,
+	  'SCSI disk support', 'SCSI tape support', or
+	  'SCSI CDROM support' may also be needed,
+	  depending on your hardware configuration.
+
+if ATA
+
+config ATA_NONSTANDARD
+       bool
+       default n
+
+config ATA_VERBOSE_ERROR
+	bool "Verbose ATA error reporting"
+	default y
+	help
+	  This option adds parsing of ATA command descriptions and error bits
+	  in libata kernel output, making it easier to interpret.
+	  This option will enlarge the kernel by approx. 6KB. Disable it only
+	  if kernel size is more important than ease of debugging.
+
+	  If unsure, say Y.
+
+config SATA_PMP
+	bool "SATA Port Multiplier support"
+	default y
+	help
+	  This option adds support for SATA Port Multipliers
+	  (the SATA version of an ethernet hub, or SAS expander).
+
+comment "Controllers with non-SFF native interface"
+
+config SATA_AHCI
+	tristate "AHCI SATA support"
+	help
+	  This option enables support for AHCI Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_AHCI_PLATFORM
+	tristate "Platform AHCI SATA support"
+	help
+	  This option enables support for Platform AHCI Serial ATA
+	  controllers.
+
+	  If unsure, say N.
+
+config SATA_FSL
+	tristate "Freescale 3.0Gbps SATA support"
+	help
+	  This option enables support for Freescale 3.0Gbps SATA controller.
+	  It can be found on MPC837x and MPC8315.
+
+	  If unsure, say N.
+
+config SATA_INIC162X
+	tristate "Initio 162x SATA support"
+	help
+	  This option enables support for Initio 162x Serial ATA.
+
+config SATA_ACARD_AHCI
+	tristate "ACard AHCI variant (ATP 8620)"
+	help
+	  This option enables support for Acard.
+
+	  If unsure, say N.
+
+config SATA_SIL24
+	tristate "Silicon Image 3124/3132 SATA support"
+	help
+	  This option enables support for Silicon Image 3124/3132 Serial ATA.
+
+	  If unsure, say N.
+
+config ATA_SFF
+	bool "ATA SFF support (for legacy IDE and PATA)"
+	default y
+	help
+	  This option adds support for ATA controllers with SFF
+	  compliant or similar programming interface.
+
+	  SFF is the legacy IDE interface that has been around since
+	  the dawn of time.  Almost all PATA controllers have an
+	  SFF interface.  Many SATA controllers have an SFF interface
+	  when configured into a legacy compatibility mode.
+
+	  For users with exclusively modern controllers like AHCI,
+	  Silicon Image 3124, or Marvell 6440, you may choose to
+	  disable this unneeded SFF support.
+
+	  If unsure, say Y.
+
+if ATA_SFF
+
+comment "SFF controllers with custom DMA interface"
+
+config PDC_ADMA
+	tristate "Pacific Digital ADMA support"
+	help
+	  This option enables support for Pacific Digital ADMA controllers
+
+	  If unsure, say N.
+
+config PATA_OCTEON_CF
+	tristate "OCTEON Boot Bus Compact Flash support"
+	help
+	  This option enables a polled compact flash driver for use with
+	  compact flash cards attached to the OCTEON boot bus.
+
+	  If unsure, say N.
+
+config SATA_QSTOR
+	tristate "Pacific Digital SATA QStor support"
+	help
+	  This option enables support for Pacific Digital Serial ATA QStor.
+
+	  If unsure, say N.
+
+config SATA_SX4
+	tristate "Promise SATA SX4 support (Experimental)"
+	help
+	  This option enables support for Promise Serial ATA SX4.
+
+	  If unsure, say N.
+
+config ATA_BMDMA
+	bool "ATA BMDMA support"
+	default y
+	help
+	  This option adds support for SFF ATA controllers with BMDMA
+	  capability.  BMDMA stands for bus-master DMA and is the
+	  de facto DMA interface for SFF controllers.
+
+	  If unsure, say Y.
+
+if ATA_BMDMA
+
+comment "SATA SFF controllers with BMDMA"
+
+config ATA_PIIX
+	tristate "Intel ESB, ICH, PIIX3, PIIX4 PATA/SATA support"
+	help
+	  This option enables support for ICH5/6/7/8 Serial ATA
+	  and support for PATA on the Intel ESB/ICH/PIIX3/PIIX4 series
+	  host controllers.
+
+	  If unsure, say N.
+
+config SATA_DWC
+	tristate "DesignWare Cores SATA support"
+	depends on 460EX
+	help
+	  This option enables support for the on-chip SATA controller of the
+	  AppliedMicro processor 460EX.
+
+	  If unsure, say N.
+
+config SATA_DWC_DEBUG
+	bool "Debugging driver version"
+	depends on SATA_DWC
+	help
+	  This option enables debugging output in the driver.
+
+config SATA_DWC_VDEBUG
+	bool "Verbose debug output"
+	depends on SATA_DWC_DEBUG
+	help
+	  This option enables the taskfile dumping and NCQ debugging.
+
+config SATA_HIGHBANK
+	tristate "Calxeda Highbank SATA support"
+	help
+	  This option enables support for the Calxeda Highbank SoC's
+	  onboard SATA.
+
+	  If unsure, say N.
+
+config SATA_MV
+	tristate "Marvell SATA support"
+	help
+	  This option enables support for the Marvell Serial ATA family.
+	  Currently supports 88SX[56]0[48][01] PCI(-X) chips,
+	  as well as the newer [67]042 PCI-X/PCIe and SOC devices.
+
+	  If unsure, say N.
+
+config SATA_NV
+	tristate "NVIDIA SATA support"
+	help
+	  This option enables support for NVIDIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_PROMISE
+	tristate "Promise SATA TX2/TX4 support"
+	help
+	  This option enables support for Promise Serial ATA TX2/TX4.
+
+	  If unsure, say N.
+
+config SATA_SIL
+	tristate "Silicon Image SATA support"
+	help
+	  This option enables support for Silicon Image Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_SIS
+	tristate "SiS 964/965/966/180 SATA support"
+	select PATA_SIS
+	help
+	  This option enables support for SiS Serial ATA on
+	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
+	  The PATA support for SiS 180 requires additionally to
+	  enable the PATA_SIS driver in the config.
+	  If unsure, say N.
+
+config SATA_SVW
+	tristate "ServerWorks Frodo / Apple K2 SATA support"
+	help
+	  This option enables support for Broadcom/Serverworks/Apple K2
+	  SATA support.
+
+	  If unsure, say N.
+
+config SATA_ULI
+	tristate "ULi Electronics SATA support"
+	help
+	  This option enables support for ULi Electronics SATA.
+
+	  If unsure, say N.
+
+config SATA_VIA
+	tristate "VIA SATA support"
+	help
+	  This option enables support for VIA Serial ATA.
+
+	  If unsure, say N.
+
+config SATA_VITESSE
+	tristate "VITESSE VSC-7174 / INTEL 31244 SATA support"
+	help
+	  This option enables support for Vitesse VSC7174 and Intel 31244 Serial ATA.
+
+	  If unsure, say N.
+
+comment "PATA SFF controllers with BMDMA"
+
+config PATA_ALI
+	tristate "ALi PATA support"
+	help
+	  This option enables support for the ALi ATA interfaces
+	  found on the many ALi chipsets.
+
+	  If unsure, say N.
+
+config PATA_AMD
+	tristate "AMD/NVidia PATA support"
+	help
+	  This option enables support for the AMD and NVidia PATA
+	  interfaces found on the chipsets for Athlon/Athlon64.
+
+	  If unsure, say N.
+
+config PATA_ARTOP
+	tristate "ARTOP 6210/6260 PATA support"
+	help
+	  This option enables support for ARTOP PATA controllers.
+
+	  If unsure, say N.
+
+config PATA_ATIIXP
+	tristate "ATI PATA support"
+	help
+	  This option enables support for the ATI ATA interfaces
+	  found on the many ATI chipsets.
+
+	  If unsure, say N.
+
+config PATA_ATP867X
+	tristate "ARTOP/Acard ATP867X PATA support"
+	help
+	  This option enables support for ARTOP/Acard ATP867X PATA
+	  controllers.
+
+	  If unsure, say N.
+
+config PATA_CMD64X
+	tristate "CMD64x PATA support"
+	help
+	  This option enables support for the CMD64x series chips
+	  except for the CMD640.
+
+	  If unsure, say N.
+
+config PATA_CS5520
+	tristate "CS5510/5520 PATA support"
+	help
+	  This option enables support for the Cyrix 5510/5520
+	  companion chip used with the MediaGX/Geode processor family.
+
+	  If unsure, say N.
+
+config PATA_CS5530
+	tristate "CS5530 PATA support"
+	help
+	  This option enables support for the Cyrix/NatSemi/AMD CS5530
+	  companion chip used with the MediaGX/Geode processor family.
+
+	  If unsure, say N.
+
+config PATA_CS5535
+	tristate "CS5535 PATA support (Experimental)"
+	help
+	  This option enables support for the NatSemi/AMD CS5535
+	  companion chip used with the Geode processor family.
+
+	  If unsure, say N.
+
+config PATA_CS5536
+	tristate "CS5536 PATA support"
+	help
+	  This option enables support for the AMD CS5536
+	  companion chip used with the Geode LX processor family.
+
+	  If unsure, say N.
+
+config PATA_CYPRESS
+	tristate "Cypress CY82C693 PATA support (Very Experimental)"
+	help
+	  This option enables support for the Cypress/Contaq CY82C693
+	  chipset found in some Alpha systems
+
+	  If unsure, say N.
+
+config PATA_EFAR
+	tristate "EFAR SLC90E66 support"
+	help
+	  This option enables support for the EFAR SLC90E66
+	  IDE controller found on some older machines.
+
+	  If unsure, say N.
+
+config PATA_HPT366
+	tristate "HPT 366/368 PATA support"
+	help
+	  This option enables support for the HPT 366 and 368
+	  PATA controllers via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_HPT37X
+	tristate "HPT 370/370A/371/372/374/302 PATA support"
+	help
+	  This option enables support for the majority of the later HPT
+	  PATA controllers via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_HPT3X2N
+	tristate "HPT 371N/372N/302N PATA support"
+	help
+	  This option enables support for the N variant HPT PATA
+	  controllers via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_HPT3X3
+	tristate "HPT 343/363 PATA support"
+	help
+	  This option enables support for the HPT 343/363
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_HPT3X3_DMA
+	bool "HPT 343/363 DMA support"
+	depends on PATA_HPT3X3
+	help
+	  This option enables DMA support for the HPT343/363
+	  controllers. Enable with care as there are still some
+	  problems with DMA on this chipset.
+
+config PATA_IT8213
+	tristate "IT8213 PATA support (Experimental)"
+	help
+	  This option enables support for the ITE 821 PATA
+          controllers via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_IT821X
+	tristate "IT8211/2 PATA support"
+	help
+	  This option enables support for the ITE 8211 and 8212
+	  PATA controllers via the new ATA layer, including RAID
+	  mode.
+
+	  If unsure, say N.
+
+config PATA_JMICRON
+	tristate "JMicron PATA support"
+	help
+	  Enable support for the JMicron IDE controller, via the new
+	  ATA layer.
+
+	  If unsure, say N.
+
+config PATA_MARVELL
+	tristate "Marvell PATA support via legacy mode"
+	help
+	  This option enables limited support for the Marvell 88SE61xx ATA
+	  controllers. If you wish to use only the SATA ports then select
+	  the AHCI driver alone. If you wish to the use the PATA port or
+	  both SATA and PATA include this driver.
+
+	  If unsure, say N.
+
+config PATA_NETCELL
+	tristate "NETCELL Revolution RAID support"
+	help
+	  This option enables support for the Netcell Revolution RAID
+	  PATA controller.
+
+	  If unsure, say N.
+
+config PATA_NINJA32
+	tristate "Ninja32/Delkin Cardbus ATA support"
+	help
+	  This option enables support for the Ninja32, Delkin and
+	  possibly other brands of Cardbus ATA adapter
+
+	  If unsure, say N.
+
+config PATA_NS87415
+	tristate "Nat Semi NS87415 PATA support"
+	help
+	  This option enables support for the National Semiconductor
+	  NS87415 PCI-IDE controller.
+
+	  If unsure, say N.
+
+config PATA_OLDPIIX
+	tristate "Intel PATA old PIIX support"
+	help
+	  This option enables support for early PIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_OPTIDMA
+	tristate "OPTI FireStar PATA support (Very Experimental)"
+	help
+	  This option enables DMA/PIO support for the later OPTi
+	  controllers found on some old motherboards and in some
+	  laptops.
+
+	  If unsure, say N.
+
+config PATA_PDC2027X
+	tristate "Promise PATA 2027x support"
+	help
+	  This option enables support for Promise PATA pdc20268 to pdc20277 host adapters.
+
+	  If unsure, say N.
+
+config PATA_PDC_OLD
+	tristate "Older Promise PATA controller support"
+	help
+	  This option enables support for the Promise 20246, 20262, 20263,
+	  20265 and 20267 adapters.
+
+	  If unsure, say N.
+
+config PATA_RADISYS
+	tristate "RADISYS 82600 PATA support (Experimental)"
+	help
+	  This option enables support for the RADISYS 82600
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+config PATA_RDC
+	tristate "RDC PATA support"
+	help
+	  This option enables basic support for the later RDC PATA controllers
+	  controllers via the new ATA layer. For the RDC 1010, you need to
+	  enable the IT821X driver instead.
+
+	  If unsure, say N.
+
+config PATA_SC1200
+	tristate "SC1200 PATA support"
+	help
+	  This option enables support for the NatSemi/AMD SC1200 SoC
+	  companion chip used with the Geode processor family.
+
+	  If unsure, say N.
+
+config PATA_SCC
+	tristate "Toshiba's Cell Reference Set IDE support"
+	help
+	  This option enables support for the built-in IDE controller on
+	  Toshiba Cell Reference Board.
+
+	  If unsure, say N.
+
+config PATA_SCH
+	tristate "Intel SCH PATA support"
+	help
+	  This option enables support for Intel SCH PATA on the Intel
+	  SCH (US15W, US15L, UL11L) series host controllers.
+
+	  If unsure, say N.
+
+config PATA_SERVERWORKS
+	tristate "SERVERWORKS OSB4/CSB5/CSB6/HT1000 PATA support"
+	help
+	  This option enables support for the Serverworks OSB4/CSB5/CSB6 and
+	  HT1000 PATA controllers, via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_SIL680
+	tristate "CMD / Silicon Image 680 PATA support"
+	help
+	  This option enables support for CMD / Silicon Image 680 PATA.
+
+	  If unsure, say N.
+
+config PATA_SIS
+	tristate "SiS PATA support"
+	help
+	  This option enables support for SiS PATA controllers
+
+	  If unsure, say N.
+
+config PATA_TOSHIBA
+	tristate "Toshiba Piccolo support (Experimental)"
+	help
+	  Support for the Toshiba Piccolo controllers. Currently only the
+	  primary channel is supported by this driver.
+
+	  If unsure, say N.
+
+config PATA_TRIFLEX
+	tristate "Compaq Triflex PATA support"
+	help
+	  Enable support for the Compaq 'Triflex' IDE controller as found
+	  on many Compaq Pentium-Pro systems, via the new ATA layer.
+
+	  If unsure, say N.
+
+config PATA_VIA
+	tristate "VIA PATA support"
+	help
+	  This option enables support for the VIA PATA interfaces
+	  found on the many VIA chipsets.
+
+	  If unsure, say N.
+
+config PATA_WINBOND
+	tristate "Winbond SL82C105 PATA support"
+	help
+	  This option enables support for SL82C105 PATA devices found in the
+	  Netwinder and some other systems
+
+	  If unsure, say N.
+
+endif # ATA_BMDMA
+
+comment "PIO-only SFF controllers"
+
+config PATA_CMD640_PCI
+	tristate "CMD640 PCI PATA support (Experimental)"
+	help
+	  This option enables support for the CMD640 PCI IDE
+	  interface chip. Only the primary channel is currently
+	  supported.
+
+	  If unsure, say N.
+
+config PATA_MPIIX
+	tristate "Intel PATA MPIIX support"
+	help
+	  This option enables support for MPIIX PATA support.
+
+	  If unsure, say N.
+
+config PATA_NS87410
+	tristate "Nat Semi NS87410 PATA support"
+	help
+	  This option enables support for the National Semiconductor
+	  NS87410 PCI-IDE controller.
+
+	  If unsure, say N.
+
+config PATA_OPTI
+	tristate "OPTI621/6215 PATA support (Very Experimental)"
+	help
+	  This option enables full PIO support for the early Opti ATA
+	  controllers found on some old motherboards.
+
+	  If unsure, say N.
+
+config PATA_RZ1000
+	tristate "PC Tech RZ1000 PATA support"
+	help
+	  This option enables basic support for the PC Tech RZ1000/1
+	  PATA controllers via the new ATA layer
+
+	  If unsure, say N.
+
+endif # ATA_SFF
+endif # ATA
diff -durp --unidirectional-new-file linux-3.7.10/arch/tm/Kconfig.scsi linux-3.7.10.tm/arch/tm/Kconfig.scsi
--- linux-3.7.10/arch/tm/Kconfig.scsi	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.10.tm/arch/tm/Kconfig.scsi	2013-03-30 20:33:30.580322443 +0100
@@ -0,0 +1,1488 @@
+menu "SCSI device support"
+
+config SCSI
+	bool "SCSI device support"
+	---help---
+	  If you want to use a SCSI tape drive under Linux, say Y and make
+	  sure that you know the name of your SCSI host adapter (the card
+	  inside your computer that "speaks" the SCSI protocol, also called
+	  SCSI controller), because you will be asked for it.
+
+	  You also need to say Y here if you have a device which speaks
+	  the SCSI protocol.  Examples of this include the IOMEGA Ditto drive,
+	  and the HP StorageWorks DAT drive.
+
+comment "SCSI support type (tape and another tape)"
+	depends on SCSI
+
+config CHR_DEV_ST
+	tristate "SCSI tape support"
+	depends on SCSI
+	---help---
+	  If you want to use a SCSI tape drive under Linux, say Y and read the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>, and
+	  <file:Documentation/scsi/st.txt> in the kernel source.  This is NOT
+	  for SCSI CD-ROMs.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>. The module will be called st.
+
+config CHR_DEV_OSST
+	tristate "SCSI OnStream SC-x0 tape support"
+	depends on SCSI
+	---help---
+	  The OnStream SC-x0 SCSI tape drives cannot be driven by the
+	  standard st driver, but instead need this special osst driver and
+	  use the  /dev/osstX char device nodes (major 206).  Via usb-storage,
+	  you may be able to drive the USB-x0 and DI-x0 drives as well.
+	  Note that there is also a second generation of OnStream
+	  tape drives (ADR-x0) that supports the standard SCSI-2 commands for
+	  tapes (QIC-157) and can be driven by the standard driver st.
+	  For more information, you may have a look at the SCSI-HOWTO
+	  <http://www.tldp.org/docs.html#howto>  and
+	  <file:Documentation/scsi/osst.txt>  in the kernel source.
+	  More info on the OnStream driver may be found on
+	  <http://sourceforge.net/projects/osst/>
+	  Please also have a look at the standard st docu, as most of it
+	  applies to osst as well.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>. The module will be called osst.
+
+source "drivers/scsi/cxgbi/Kconfig"
+source "drivers/scsi/bnx2i/Kconfig"
+source "drivers/scsi/bnx2fc/Kconfig"
+source "drivers/scsi/be2iscsi/Kconfig"
+
+config SGIWD93_SCSI
+	tristate "SGI WD93C93 SCSI Driver"
+	depends on SCSI
+  	help
+	  If you have a Western Digital WD93 SCSI controller on
+	  an SGI MIPS system, say Y.  Otherwise, say N.
+
+config BLK_DEV_3W_XXXX_RAID
+	tristate "3ware 5/6/7/8xxx ATA-RAID support"
+	depends on SCSI
+	help
+	  3ware is the only hardware ATA-Raid product in Linux to date.
+	  This card is 2,4, or 8 channel master mode support only.
+	  SCSI support required!!!
+
+	  <http://www.3ware.com/>
+
+	  Please read the comments at the top of
+	  <file:drivers/scsi/3w-xxxx.c>.
+
+config SCSI_HPSA
+	tristate "HP Smart Array SCSI driver"
+	depends on SCSI
+	select CHECK_SIGNATURE
+	help
+	  This driver supports HP Smart Array Controllers (circa 2009).
+	  It is a SCSI alternative to the cciss driver, which is a block
+	  driver.  Anyone wishing to use HP Smart Array controllers who
+	  would prefer the devices be presented to linux as SCSI devices,
+	  rather than as generic block devices should say Y here.
+
+config SCSI_3W_9XXX
+	tristate "3ware 9xxx SATA-RAID support"
+	depends on SCSI
+	help
+	  This driver supports the 9000 series 3ware SATA-RAID cards.
+
+	  <http://www.amcc.com>
+
+	  Please read the comments at the top of
+	  <file:drivers/scsi/3w-9xxx.c>.
+
+config SCSI_3W_SAS
+	tristate "3ware 97xx SAS/SATA-RAID support"
+	depends on SCSI
+	help
+	  This driver supports the LSI 3ware 9750 6Gb/s SAS/SATA-RAID cards.
+
+	  <http://www.lsi.com>
+
+	  Please read the comments at the top of
+	  <file:drivers/scsi/3w-sas.c>.
+
+config SCSI_7000FASST
+	tristate "7000FASST SCSI support"
+	depends on SCSI
+	select CHECK_SIGNATURE
+	help
+	  This driver supports the Western Digital 7000 SCSI host adapter
+	  family.  Some information is in the source:
+	  <file:drivers/scsi/wd7000.c>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called wd7000.
+
+config SCSI_ACARD
+	tristate "ACARD SCSI support"
+	depends on SCSI
+	help
+	  This driver supports the ACARD SCSI host adapter.
+	  Support Chip <ATP870 ATP876 ATP880 ATP885>
+	  To compile this driver as a module, choose M here: the
+	  module will be called atp870u.
+
+config SCSI_AHA152X
+	tristate "Adaptec AHA152X/2825 support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
+	---help---
+	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
+	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
+	  must be manually specified in this case.
+
+	  It is explained in section 3.3 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>. You might also want to
+	  read the file <file:Documentation/scsi/aha152x.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called aha152x.
+
+config SCSI_AHA1542
+	tristate "Adaptec AHA1542 support"
+	depends on SCSI
+	---help---
+	  This is support for a SCSI host adapter.  It is explained in section
+	  3.4 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  Note that Trantor was
+	  purchased by Adaptec, and some former Trantor products are being
+	  sold under the Adaptec name.  If it doesn't work out of the box, you
+	  may have to change some settings in <file:drivers/scsi/aha1542.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called aha1542.
+
+config SCSI_AHA1740
+	tristate "Adaptec AHA1740 support"
+	depends on SCSI
+	---help---
+	  This is support for a SCSI host adapter.  It is explained in section
+	  3.5 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/aha1740.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called aha1740.
+
+config SCSI_AACRAID
+	tristate "Adaptec AACRAID support"
+	depends on SCSI
+	help
+	  This driver supports a variety of Dell, HP, Adaptec, IBM and
+	  ICP storage products. For a list of supported products, refer
+	  to <file:Documentation/scsi/aacraid.txt>.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called aacraid.
+
+
+source "drivers/scsi/aic7xxx/Kconfig.aic7xxx"
+
+config SCSI_AIC7XXX_OLD
+	tristate "Adaptec AIC7xxx support (old driver)"
+	depends on SCSI
+	help
+	  WARNING This driver is an older aic7xxx driver and is no longer
+	  under active development.  Adaptec, Inc. is writing a new driver to
+	  take the place of this one, and it is recommended that whenever
+	  possible, people should use the new Adaptec written driver instead
+	  of this one.  This driver will eventually be phased out entirely.
+
+	  This is support for the various aic7xxx based Adaptec SCSI
+	  controllers. These include the 274x EISA cards; 284x VLB cards;
+	  2902, 2910, 293x, 294x, 394x, 3985 and several other PCI and
+	  motherboard based SCSI controllers from Adaptec. It does not support
+	  the AAA-13x RAID controllers from Adaptec, nor will it likely ever
+	  support them. It does not support the 2920 cards from Adaptec that
+	  use the Future Domain SCSI controller chip. For those cards, you
+	  need the "Future Domain 16xx SCSI support" driver.
+
+	  In general, if the controller is based on an Adaptec SCSI controller
+	  chip from the aic777x series or the aic78xx series, this driver
+	  should work. The only exception is the 7810 which is specifically
+	  not supported (that's the RAID controller chip on the AAA-13x
+	  cards).
+
+	  Note that the AHA2920 SCSI host adapter is *not* supported by this
+	  driver; choose "Future Domain 16xx SCSI support" instead if you have
+	  one of those.
+
+	  Information on the configuration options for this controller can be
+	  found by checking the help file for each of the available
+	  configuration options. You should read
+	  <file:Documentation/scsi/aic7xxx_old.txt> at a minimum before
+	  contacting the maintainer with any questions.  The SCSI-HOWTO,
+	  available from <http://www.tldp.org/docs.html#howto>, can also
+	  be of great help.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called aic7xxx_old.
+
+source "drivers/scsi/aic7xxx/Kconfig.aic79xx"
+source "drivers/scsi/aic94xx/Kconfig"
+source "drivers/scsi/mvsas/Kconfig"
+
+config SCSI_MVUMI
+	tristate "Marvell UMI driver"
+	depends on SCSI
+	help
+	  Module for Marvell Universal Message Interface(UMI) driver
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mvumi.
+
+config SCSI_DPT_I2O
+	tristate "Adaptec I2O RAID support "
+	depends on SCSI
+	help
+	  This driver supports all of Adaptec's I2O based RAID controllers as 
+	  well as the DPT SmartRaid V cards.  This is an Adaptec maintained
+	  driver by Deanna Bonds.  See <file:Documentation/scsi/dpti.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dpt_i2o.
+
+config SCSI_ADVANSYS
+	tristate "AdvanSys SCSI support"
+	depends on SCSI
+	depends on SCSI
+	help
+	  This is a driver for all SCSI host adapters manufactured by
+	  AdvanSys. It is documented in the kernel source in
+	  <file:drivers/scsi/advansys.c>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called advansys.
+
+config SCSI_IN2000
+	tristate "Always IN2000 SCSI support"
+	depends on SCSI
+	help
+	  This is support for an ISA bus SCSI host adapter.  You'll find more
+	  information in <file:Documentation/scsi/in2000.txt>. If it doesn't work
+	  out of the box, you may have to change the jumpers for IRQ or
+	  address selection.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called in2000.
+
+config SCSI_ARCMSR
+	tristate "ARECA (ARC11xx/12xx/13xx/16xx) SATA/SAS RAID Host Adapter"
+	depends on SCSI
+	help
+	  This driver supports all of ARECA's SATA/SAS RAID controller cards.
+	  This is an ARECA-maintained driver by Erich Chen.
+	  If you have any problems, please mail to: <erich@areca.com.tw>.
+	  Areca supports Linux RAID config tools.
+	  Please link <http://www.areca.com.tw>
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called arcmsr (modprobe arcmsr).
+
+source "drivers/scsi/megaraid/Kconfig.megaraid"
+source "drivers/scsi/mpt2sas/Kconfig"
+source "drivers/scsi/ufs/Kconfig"
+
+config SCSI_HPTIOP
+	tristate "HighPoint RocketRAID 3xxx/4xxx Controller support"
+	depends on SCSI
+	help
+	  This option enables support for HighPoint RocketRAID 3xxx/4xxx
+	  controllers.
+
+	  To compile this driver as a module, choose M here; the module
+	  will be called hptiop. If unsure, say N.
+
+config SCSI_BUSLOGIC
+	tristate "BusLogic SCSI support"
+	depends on SCSI
+	---help---
+	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
+	  Adapters. Consult the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>, and the files
+	  <file:Documentation/scsi/BusLogic.txt> and
+	  <file:Documentation/scsi/FlashPoint.txt> for more information.
+	  Note that support for FlashPoint is only available for 32-bit
+	  x86 configurations.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called BusLogic.
+
+config SCSI_FLASHPOINT
+	bool "FlashPoint support"
+	depends on SCSI
+	help
+	  This option allows you to add FlashPoint support to the
+	  BusLogic SCSI driver. The FlashPoint SCCB Manager code is
+	  substantial, so users of MultiMaster Host Adapters may not
+	  wish to include it.
+
+config VMWARE_PVSCSI
+	tristate "VMware PVSCSI driver support"
+	depends on SCSI
+	help
+	  This driver supports VMware's para virtualized SCSI HBA.
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmw_pvscsi.
+
+config HYPERV_STORAGE
+	tristate "Microsoft Hyper-V virtual storage driver"
+	depends on SCSI
+	default HYPERV
+	help
+	  Select this option to enable the Hyper-V virtual storage driver.
+
+config FCOE
+	tristate "FCoE module"
+	depends on SCSI
+	select LIBFCOE
+	---help---
+	  Fibre Channel over Ethernet module
+
+config FCOE_FNIC
+	tristate "Cisco FNIC Driver"
+	depends on SCSI
+	select LIBFCOE
+	help
+	  This is support for the Cisco PCI-Express FCoE HBA.
+
+	  To compile this driver as a module, choose M here and read
+	  <file:Documentation/scsi/scsi.txt>.
+	  The module will be called fnic.
+
+config SCSI_DMX3191D
+	tristate "DMX3191D SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is support for Domex DMX3191D SCSI Host Adapters.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dmx3191d.
+
+config SCSI_DTC3280
+	tristate "DTC3180/3280 SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
+	help
+	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
+	  the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>, and the file
+	  <file:Documentation/scsi/dtc3x80.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dtc.
+
+config SCSI_EATA
+	tristate "EATA ISA/EISA/PCI (DPT and generic EATA/DMA-compliant boards) support"
+	depends on SCSI
+	---help---
+	  This driver supports all EATA/DMA-compliant SCSI host adapters.  DPT
+	  ISA and all EISA I/O addresses are probed looking for the "EATA"
+	  signature. The addresses of all the PCI SCSI controllers reported
+          by the PCI subsystem are probed as well.
+
+	  You want to read the start of <file:drivers/scsi/eata.c> and the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called eata.
+
+config SCSI_EATA_TAGGED_QUEUE
+	bool "enable tagged command queueing"
+	depends on SCSI
+	help
+	  This is a feature of SCSI-2 which improves performance: the host
+	  adapter can send several SCSI commands to a device's queue even if
+	  previous commands haven't finished yet.
+	  This is equivalent to the "eata=tc:y" boot option.
+
+config SCSI_EATA_LINKED_COMMANDS
+	bool "enable elevator sorting"
+	depends on SCSI
+	help
+	  This option enables elevator sorting for all probed SCSI disks and
+	  CD-ROMs. It definitely reduces the average seek distance when doing
+	  random seeks, but this does not necessarily result in a noticeable
+	  performance improvement: your mileage may vary...
+	  This is equivalent to the "eata=lc:y" boot option.
+
+config SCSI_EATA_MAX_TAGS
+	int "maximum number of queued commands"
+	depends on SCSI
+	default "16"
+	help
+	  This specifies how many SCSI commands can be maximally queued for
+	  each probed SCSI device. You should reduce the default value of 16
+	  only if you have disks with buggy or limited tagged command support.
+	  Minimum is 2 and maximum is 62. This value is also the window size
+	  used by the elevator sorting option above. The effective value used
+	  by the driver for each probed SCSI device is reported at boot time.
+	  This is equivalent to the "eata=mq:8" boot option.
+
+config SCSI_EATA_PIO
+	tristate "EATA-PIO (old DPT PM2001, PM2012A) support"
+	depends on SCSI
+	---help---
+	  This driver supports all EATA-PIO protocol compliant SCSI Host
+	  Adapters like the DPT PM2001 and the PM2012A.  EATA-DMA compliant
+	  host adapters could also use this driver but are discouraged from
+	  doing so, since this driver only supports hard disks and lacks
+	  numerous features.  You might want to have a look at the SCSI-HOWTO,
+	  available from <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called eata_pio.
+
+config SCSI_FUTURE_DOMAIN
+	tristate "Future Domain 16xx SCSI/AHA-2920A support"
+	depends on SCSI
+	select CHECK_SIGNATURE
+	---help---
+	  This is support for Future Domain's 16-bit SCSI host adapters
+	  (TMC-1660/1680, TMC-1650/1670, TMC-3260, TMC-1610M/MER/MEX) and
+	  other adapters based on the Future Domain chipsets (Quantum
+	  ISA-200S, ISA-250MG; Adaptec AHA-2920A; and at least one IBM board).
+	  It is explained in section 3.7 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  NOTE: Newer Adaptec AHA-2920C boards use the Adaptec AIC-7850 chip
+	  and should use the aic7xxx driver ("Adaptec AIC7xxx chipset SCSI
+	  controller support"). This Future Domain driver works with the older
+	  Adaptec AHA-2920A boards with a Future Domain chip on them.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called fdomain.
+
+config SCSI_GDTH
+	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
+	depends on SCSI
+	---help---
+	  Formerly called GDT SCSI Disk Array Controller Support.
+
+	  This is a driver for RAID/SCSI Disk Array Controllers (EISA/ISA/PCI) 
+	  manufactured by Intel Corporation/ICP vortex GmbH. It is documented
+	  in the kernel source in <file:drivers/scsi/gdth.c> and
+	  <file:drivers/scsi/gdth.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gdth.
+
+config SCSI_ISCI
+	tristate "Intel(R) C600 Series Chipset SAS Controller"
+	depends on SCSI
+	depends on SCSI
+	select SCSI_SAS_LIBSAS
+	---help---
+	  This driver supports the 6Gb/s SAS capabilities of the storage
+	  control unit found in the Intel(R) C600 series chipset.
+
+config SCSI_GENERIC_NCR5380
+	tristate "Generic NCR5380/53c400 SCSI PIO support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This is a driver for the old NCR 53c80 series of SCSI controllers
+	  on boards using PIO. Most boards such as the Trantor T130 fit this
+	  category, along with a large number of ISA 8bit controllers shipped
+	  for free with SCSI scanners. If you have a PAS16, T128 or DMX3191
+	  you should select the specific driver for that card rather than
+	  generic 5380 support.
+
+	  It is explained in section 3.8 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/g_NCR5380.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called g_NCR5380.
+
+config SCSI_GENERIC_NCR5380_MMIO
+	tristate "Generic NCR5380/53c400 SCSI MMIO support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This is a driver for the old NCR 53c80 series of SCSI controllers
+	  on boards using memory mapped I/O. 
+	  It is explained in section 3.8 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/g_NCR5380.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called g_NCR5380_mmio.
+
+config SCSI_GENERIC_NCR53C400
+	bool "Enable NCR53c400 extensions"
+	depends on SCSI
+	help
+	  This enables certain optimizations for the NCR53c400 SCSI cards.
+	  You might as well try it out.  Note that this driver will only probe
+	  for the Trantor T130B in its default configuration; you might have
+	  to pass a command line option to the kernel at boot time if it does
+	  not detect your card.  See the file
+	  <file:Documentation/scsi/g_NCR5380.txt> for details.
+
+config SCSI_IPS
+	tristate "IBM ServeRAID support"
+	depends on SCSI
+	---help---
+	  This is support for the IBM ServeRAID hardware RAID controllers.
+	  See <http://www.developer.ibm.com/welcome/netfinity/serveraid.html>
+	  and <http://www-947.ibm.com/support/entry/portal/docdisplay?brand=5000008&lndocid=SERV-RAID>
+	  for more information.  If this driver does not work correctly
+	  without modification please contact the author by email at
+	  <ipslinux@adaptec.com>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ips.
+
+config SCSI_IBMVSCSI
+	tristate "IBM Virtual SCSI support"
+	depends on SCSI
+	select SCSI_SRP_ATTRS
+	help
+	  This is the IBM POWER Virtual SCSI Client
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvscsic.
+
+config SCSI_IBMVSCSIS
+	tristate "IBM Virtual SCSI Server support"
+	depends on SCSI
+	help
+	  This is the SRP target driver for IBM pSeries virtual environments.
+
+	  The userspace component needed to initialize the driver and
+	  documentation can be found:
+
+	  http://stgt.berlios.de/
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvstgt.
+
+config SCSI_IBMVFC
+	tristate "IBM Virtual FC support"
+	depends on SCSI
+	select SCSI_FC_ATTRS
+	help
+	  This is the IBM POWER Virtual FC Client
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ibmvfc.
+
+config SCSI_IBMVFC_TRACE
+	bool "enable driver internal trace"
+	depends on SCSI
+	default y
+	help
+	  If you say Y here, the driver will trace all commands issued
+	  to the adapter. Performance impact is minimal. Trace can be
+	  dumped using /sys/class/scsi_host/hostXX/trace.
+
+config SCSI_INITIO
+	tristate "Initio 9100U(W) support"
+	depends on SCSI
+	help
+	  This is support for the Initio 91XXU(W) SCSI host adapter.  Please
+	  read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called initio.
+
+config SCSI_INIA100
+	tristate "Initio INI-A100U2W support"
+	depends on SCSI
+	help
+	  This is support for the Initio INI-A100U2W SCSI host adapter.
+	  Please read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called a100u2w.
+
+config SCSI_PPA
+	tristate "IOMEGA parallel port (ppa - older drives)"
+	depends on SCSI
+	---help---
+	  This driver supports older versions of IOMEGA's parallel port ZIP
+	  drive (a 100 MB removable media device).
+
+	  Note that you can say N here if you have the SCSI version of the ZIP
+	  drive: it will be supported automatically if you said Y to the
+	  generic "SCSI disk support", above.
+
+	  If you have the ZIP Plus drive or a more recent parallel port ZIP
+	  drive (if the supplied cable with the drive is labeled "AutoDetect")
+	  then you should say N here and Y to "IOMEGA parallel port (imm -
+	  newer drives)", below.
+
+	  For more information about this driver and how to use it you should
+	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
+	  the SCSI-HOWTO, which is available from
+	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
+	  you will still be able to use the parallel port for other tasks,
+	  such as a printer; it is safe to compile both drivers into the
+	  kernel.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ppa.
+
+config SCSI_IMM
+	tristate "IOMEGA parallel port (imm - newer drives)"
+	depends on SCSI
+	---help---
+	  This driver supports newer versions of IOMEGA's parallel port ZIP
+	  drive (a 100 MB removable media device).
+
+	  Note that you can say N here if you have the SCSI version of the ZIP
+	  drive: it will be supported automatically if you said Y to the
+	  generic "SCSI disk support", above.
+
+	  If you have the ZIP Plus drive or a more recent parallel port ZIP
+	  drive (if the supplied cable with the drive is labeled "AutoDetect")
+	  then you should say Y here; if you have an older ZIP drive, say N
+	  here and Y to "IOMEGA Parallel Port (ppa - older drives)", above.
+
+	  For more information about this driver and how to use it you should
+	  read the file <file:Documentation/scsi/ppa.txt>.  You should also read
+	  the SCSI-HOWTO, which is available from
+	  <http://www.tldp.org/docs.html#howto>.  If you use this driver,
+	  you will still be able to use the parallel port for other tasks,
+	  such as a printer; it is safe to compile both drivers into the
+	  kernel.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called imm.
+
+config SCSI_IZIP_EPP16
+	bool "ppa/imm option - Use slow (but safe) EPP-16"
+	depends on SCSI
+	---help---
+	  EPP (Enhanced Parallel Port) is a standard for parallel ports which
+	  allows them to act as expansion buses that can handle up to 64
+	  peripheral devices.
+
+	  Some parallel port chipsets are slower than their motherboard, and
+	  so we have to control the state of the chipset's FIFO queue every
+	  now and then to avoid data loss. This will be done if you say Y
+	  here.
+
+	  Generally, saying Y is the safe option and slows things down a bit.
+
+config SCSI_IZIP_SLOW_CTR
+	bool "ppa/imm option - Assume slow parport control register"
+	depends on SCSI
+	help
+	  Some parallel ports are known to have excessive delays between
+	  changing the parallel port control register and good data being
+	  available on the parallel port data/status register. This option
+	  forces a small delay (1.0 usec to be exact) after changing the
+	  control register to let things settle out. Enabling this option may
+	  result in a big drop in performance but some very old parallel ports
+	  (found in 386 vintage machines) will not work properly.
+
+	  Generally, saying N is fine.
+
+config SCSI_NCR53C406A
+	tristate "NCR53c406a SCSI support"
+	depends on SCSI
+	help
+	  This is support for the NCR53c406a SCSI host adapter.  For user
+	  configurable parameters, check out <file:drivers/scsi/NCR53c406a.c>
+	  in the kernel source.  Also read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called NCR53c406.
+
+config SCSI_NCR_D700
+	tristate "NCR Dual 700 MCA SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is a driver for the MicroChannel Dual 700 card produced by
+	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
+	  tries to negotiate sync and uses tag command queueing.
+
+	  Unless you have an NCR manufactured machine, the chances are that
+	  you do not have this SCSI card, so say N.
+
+config SCSI_LASI700
+	tristate "HP Lasi SCSI support for 53c700/710"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is a driver for the SCSI controller in the Lasi chip found in
+	  many PA-RISC workstations & servers.  If you do not know whether you
+	  have a Lasi chip, it is safe to say "Y" here.
+
+config SCSI_SNI_53C710
+	tristate "SNI RM SCSI support for 53c710"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	select 53C700_LE_ON_BE
+	help
+	  This is a driver for the onboard SCSI controller found in older
+	  SNI RM workstations & servers.
+
+config 53C700_LE_ON_BE
+	bool
+	depends on SCSI
+	default y
+
+config SCSI_STEX
+	tristate "Promise SuperTrak EX Series support"
+	depends on SCSI
+	---help---
+	  This driver supports Promise SuperTrak EX series storage controllers.
+
+	  Promise provides Linux RAID configuration utility for these
+	  controllers. Please visit <http://www.promise.com> to download.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called stex.
+
+config 53C700_BE_BUS
+	bool
+	depends on SCSI
+	default y
+
+config SCSI_SYM53C8XX_2
+	tristate "SYM53C8XX Version 2 SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This driver supports the whole NCR53C8XX/SYM53C8XX family of
+	  PCI-SCSI controllers.  It also supports the subset of LSI53C10XX
+	  Ultra-160 controllers that are based on the SYM53C8XX SCRIPTS
+	  language.  It does not support LSI53C10XX Ultra-320 PCI-X SCSI
+	  controllers; you need to use the Fusion MPT driver for that.
+
+	  Please read <file:Documentation/scsi/sym53c8xx_2.txt> for more
+	  information.
+
+config SCSI_SYM53C8XX_DMA_ADDRESSING_MODE
+	int "DMA addressing mode"
+	depends on SCSI
+	default "1"
+	---help---
+	  This option only applies to PCI-SCSI chips that are PCI DAC
+	  capable (875A, 895A, 896, 1010-33, 1010-66, 1000).
+
+	  When set to 0, the driver will program the chip to only perform
+	  32-bit DMA.  When set to 1, the chip will be able to perform DMA
+	  to addresses up to 1TB.  When set to 2, the driver supports the
+	  full 64-bit DMA address range, but can only address 16 segments
+	  of 4 GB each.  This limits the total addressable range to 64 GB.
+
+	  Most machines with less than 4GB of memory should use a setting
+	  of 0 for best performance.  If your machine has 4GB of memory
+	  or more, you should set this option to 1 (the default).
+
+	  The still experimental value 2 (64 bit DMA addressing with 16
+	  x 4GB segments limitation) can be used on systems that require
+	  PCI address bits past bit 39 to be set for the addressing of
+	  memory using PCI DAC cycles.
+
+config SCSI_SYM53C8XX_DEFAULT_TAGS
+	int "Default tagged command queue depth"
+	depends on SCSI
+	default "16"
+	help
+	  This is the default value of the command queue depth the
+	  driver will announce to the generic SCSI layer for devices
+	  that support tagged command queueing. This value can be changed
+	  from the boot command line.  This is a soft limit that cannot
+	  exceed CONFIG_SCSI_SYM53C8XX_MAX_TAGS.
+
+config SCSI_SYM53C8XX_MAX_TAGS
+	int "Maximum number of queued commands"
+	depends on SCSI
+	default "64"
+	help
+	  This option allows you to specify the maximum number of commands
+	  that can be queued to any device, when tagged command queuing is
+	  possible. The driver supports up to 256 queued commands per device.
+	  This value is used as a compiled-in hard limit.
+
+config SCSI_SYM53C8XX_MMIO
+	bool "Use memory mapped IO"
+	depends on SCSI
+	default y
+	help
+	  Memory mapped IO is faster than Port IO.  Most people should
+	  answer Y here, but some machines may have problems.  If you have
+	  to answer N here, please report the problem to the maintainer.
+
+config SCSI_IPR
+	tristate "IBM Power Linux RAID adapter support"
+	depends on SCSI
+	select FW_LOADER
+	---help---
+	  This driver supports the IBM Power Linux family RAID adapters.
+	  This includes IBM pSeries 5712, 5703, 5709, and 570A, as well
+	  as IBM iSeries 5702, 5703, 5709, and 570A.
+
+config SCSI_IPR_TRACE
+	bool "enable driver internal trace"
+	depends on SCSI
+	default y
+	help
+	  If you say Y here, the driver will trace all commands issued
+	  to the adapter. Performance impact is minimal. Trace can be
+	  dumped using /sys/bus/class/scsi_host/hostXX/trace.
+
+config SCSI_IPR_DUMP
+	bool "enable adapter dump support"
+	depends on SCSI
+	default y
+	help
+	  If you say Y here, the driver will support adapter crash dump.
+	  If you enable this support, the iprdump daemon can be used
+	  to capture adapter failure analysis information.
+
+config SCSI_ZALON
+	tristate "Zalon SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  The Zalon is a GSC/HSC bus interface chip that sits between the
+	  PA-RISC processor and the NCR 53c720 SCSI controller on C100,
+	  C110, J200, J210 and some D, K & R-class machines.  It's also
+	  used on the add-in Bluefish, Barracuda & Shrike SCSI cards.
+	  Say Y here if you have one of these machines or cards.
+
+config SCSI_NCR_Q720
+	tristate "NCR Quad 720 MCA SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is a driver for the MicroChannel Quad 720 card produced by
+	  NCR and commonly used in 345x/35xx/4100 class machines.  It always
+	  tries to negotiate sync and uses tag command queueing.
+
+	  Unless you have an NCR manufactured machine, the chances are that
+	  you do not have this SCSI card, so say N.
+
+config SCSI_NCR53C8XX_DEFAULT_TAGS
+	int "default tagged command queue depth"
+	depends on SCSI
+	default "8"
+	---help---
+	  "Tagged command queuing" is a feature of SCSI-2 which improves
+	  performance: the host adapter can send several SCSI commands to a
+	  device's queue even if previous commands haven't finished yet.
+	  Because the device is intelligent, it can optimize its operations
+	  (like head positioning) based on its own request queue. Some SCSI
+	  devices don't implement this properly; if you want to disable this
+	  feature, enter 0 or 1 here (it doesn't matter which).
+
+	  The default value is 8 and should be supported by most hard disks.
+	  This value can be overridden from the boot command line using the
+	  'tags' option as follows (example):
+	  'ncr53c8xx=tags:4/t2t3q16/t0u2q10' will set default queue depth to
+	  4, set queue depth to 16 for target 2 and target 3 on controller 0
+	  and set queue depth to 10 for target 0 / lun 2 on controller 1.
+
+	  The normal answer therefore is to go with the default 8 and to use
+	  a boot command line option for devices that need to use a different
+	  command queue depth.
+
+	  There is no safe option other than using good SCSI devices.
+
+config SCSI_NCR53C8XX_MAX_TAGS
+	int "maximum number of queued commands"
+	depends on SCSI
+	default "32"
+	---help---
+	  This option allows you to specify the maximum number of commands
+	  that can be queued to any device, when tagged command queuing is
+	  possible. The default value is 32. Minimum is 2, maximum is 64.
+	  Modern hard disks are able to support 64 tags and even more, but
+	  do not seem to be faster when more than 32 tags are being used.
+
+	  So, the normal answer here is to go with the default value 32 unless
+	  you are using very large hard disks with large cache (>= 1 MB) that
+	  are able to take advantage of more than 32 tagged commands.
+
+	  There is no safe option and the default answer is recommended.
+
+config SCSI_NCR53C8XX_SYNC
+	int "synchronous transfers frequency in MHz"
+	depends on SCSI
+	default "20"
+	---help---
+	  The SCSI Parallel Interface-2 Standard defines 5 classes of transfer
+	  rates: FAST-5, FAST-10, FAST-20, FAST-40 and FAST-80.  The numbers
+	  are respectively the maximum data transfer rates in mega-transfers
+	  per second for each class.  For example, a FAST-20 Wide 16 device is
+	  able to transfer data at 20 million 16 bit packets per second for a
+	  total rate of 40 MB/s.
+
+	  You may specify 0 if you want to only use asynchronous data
+	  transfers. This is the safest and slowest option. Otherwise, specify
+	  a value between 5 and 80, depending on the capability of your SCSI
+	  controller.  The higher the number, the faster the data transfer.
+	  Note that 80 should normally be ok since the driver decreases the
+	  value automatically according to the controller's capabilities.
+
+	  Your answer to this question is ignored for controllers with NVRAM,
+	  since the driver will get this information from the user set-up.  It
+	  also can be overridden using a boot setup option, as follows
+	  (example): 'ncr53c8xx=sync:12' will allow the driver to negotiate
+	  for FAST-20 synchronous data transfer (20 mega-transfers per
+	  second).
+
+	  The normal answer therefore is not to go with the default but to
+	  select the maximum value 80 allowing the driver to use the maximum
+	  value supported by each controller. If this causes problems with
+	  your SCSI devices, you should come back and decrease the value.
+
+	  There is no safe option other than using good cabling, right
+	  terminations and SCSI conformant devices.
+
+config SCSI_NCR53C8XX_NO_DISCONNECT
+	bool "not allow targets to disconnect"
+	depends on SCSI
+	help
+	  This option is only provided for safety if you suspect some SCSI
+	  device of yours to not support properly the target-disconnect
+	  feature. In that case, you would say Y here. In general however, to
+	  not allow targets to disconnect is not reasonable if there is more
+	  than 1 device on a SCSI bus. The normal answer therefore is N.
+
+config SCSI_PAS16
+	tristate "PAS16 SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This is support for a SCSI host adapter.  It is explained in section
+	  3.10 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/pas16.h>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called pas16.
+
+config SCSI_QLOGIC_FAS
+	tristate "Qlogic FAS SCSI support"
+	depends on SCSI
+	---help---
+	  This is a driver for the ISA, VLB, and PCMCIA versions of the Qlogic
+	  FastSCSI! cards as well as any other card based on the FASXX chip
+	  (including the Control Concepts SCSI/IDE/SIO/PIO/FDC cards).
+
+	  This driver does NOT support the PCI versions of these cards. The
+	  PCI versions are supported by the Qlogic ISP driver ("Qlogic ISP
+	  SCSI support"), below.
+
+	  Information about this driver is contained in
+	  <file:Documentation/scsi/qlogicfas.txt>.  You should also read the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qlogicfas.
+
+config SCSI_QLOGIC_1280
+	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
+	depends on SCSI
+	help
+	  Say Y if you have a QLogic ISP1240/1x80/1x160 SCSI host adapter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qla1280.
+
+config SCSI_QLOGICPTI
+	tristate "PTI Qlogic, ISP Driver"
+	depends on SCSI
+	help
+	  This driver supports SBUS SCSI controllers from PTI or QLogic. These
+	  controllers are known under Solaris as qpti and in the openprom as
+	  PTI,ptisp or QLGC,isp. Note that PCI QLogic SCSI controllers are
+	  driven by a different driver.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called qlogicpti.
+
+source "drivers/scsi/qla2xxx/Kconfig"
+source "drivers/scsi/qla4xxx/Kconfig"
+
+config SCSI_LPFC
+	tristate "Emulex LightPulse Fibre Channel Support"
+	depends on SCSI
+	select SCSI_FC_ATTRS
+	help
+          This lpfc driver supports the Emulex LightPulse
+          Family of Fibre Channel PCI host adapters.
+
+config SCSI_LPFC_DEBUG_FS
+	bool "Emulex LightPulse Fibre Channel debugfs Support"
+	depends on SCSI
+	help
+	  This makes debugging information from the lpfc driver
+	  available via the debugfs filesystem.
+
+config SCSI_SIM710
+	tristate "Simple 53c710 SCSI support (Compaq, NCR machines)"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	---help---
+	  This driver is for NCR53c710 based SCSI host adapters.
+
+	  It currently supports Compaq EISA cards and NCR MCA cards
+
+config SCSI_SYM53C416
+	tristate "Symbios 53c416 SCSI support"
+	depends on SCSI
+	---help---
+	  This is support for the sym53c416 SCSI host adapter, the SCSI
+	  adapter that comes with some HP scanners. This driver requires that
+	  the sym53c416 is configured first using some sort of PnP
+	  configuration program (e.g. isapnp) or by a PnP aware BIOS. If you
+	  are using isapnp then you need to compile this driver as a module
+	  and then load it using insmod after isapnp has run. The parameters
+	  of the configured card(s) should be passed to the driver. The format
+	  is:
+
+	  insmod sym53c416 sym53c416=<base>,<irq> [sym53c416_1=<base>,<irq>]
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sym53c416.
+
+config SCSI_DC395x
+	tristate "Tekram DC395(U/UW/F) and DC315(U) SCSI support (EXPERIMENTAL)"
+	depends on SCSI
+	---help---
+	  This driver supports PCI SCSI host adapters based on the ASIC
+	  TRM-S1040 chip, e.g Tekram DC395(U/UW/F) and DC315(U) variants.
+
+	  This driver works, but is still in experimental status. So better
+	  have a bootable disk and a backup in case of emergency.
+
+	  Documentation can be found in <file:Documentation/scsi/dc395x.txt>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dc395x.
+
+config SCSI_DC390T
+	tristate "Tekram DC390(T) and Am53/79C974 SCSI support"
+	depends on SCSI
+	---help---
+	  This driver supports PCI SCSI host adapters based on the Am53C974A
+	  chip, e.g. Tekram DC390(T), DawiControl 2974 and some onboard
+	  PCscsi/PCnet (Am53/79C974) solutions.
+
+	  Documentation can be found in <file:Documentation/scsi/tmscsim.txt>.
+
+	  Note that this driver does NOT support Tekram DC390W/U/F, which are
+	  based on NCR/Symbios chips. Use "NCR53C8XX SCSI support" for those.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tmscsim.
+
+config SCSI_T128
+	tristate "Trantor T128/T128F/T228 SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	select CHECK_SIGNATURE
+	---help---
+	  This is support for a SCSI host adapter. It is explained in section
+	  3.11 of the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/t128.h>.  Note that Trantor was purchased by
+	  Adaptec, and some former Trantor products are being sold under the
+	  Adaptec name.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called t128.
+
+config SCSI_U14_34F
+	tristate "UltraStor 14F/34F support"
+	depends on SCSI
+	---help---
+	  This is support for the UltraStor 14F and 34F SCSI-2 host adapters.
+	  The source at <file:drivers/scsi/u14-34f.c> contains some
+	  information about this hardware.  If the driver doesn't work out of
+	  the box, you may have to change some settings in
+	  <file: drivers/scsi/u14-34f.c>.  Read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  Note that there is also
+	  another driver for the same hardware: "UltraStor SCSI support",
+	  below.  You should say Y to both only if you want 24F support as
+	  well.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called u14-34f.
+
+config SCSI_U14_34F_TAGGED_QUEUE
+	bool "enable tagged command queueing"
+	depends on SCSI
+	help
+	  This is a feature of SCSI-2 which improves performance: the host
+	  adapter can send several SCSI commands to a device's queue even if
+	  previous commands haven't finished yet.
+	  This is equivalent to the "u14-34f=tc:y" boot option.
+
+config SCSI_U14_34F_LINKED_COMMANDS
+	bool "enable elevator sorting"
+	depends on SCSI
+	help
+	  This option enables elevator sorting for all probed SCSI disks and
+	  CD-ROMs. It definitely reduces the average seek distance when doing
+	  random seeks, but this does not necessarily result in a noticeable
+	  performance improvement: your mileage may vary...
+	  This is equivalent to the "u14-34f=lc:y" boot option.
+
+config SCSI_U14_34F_MAX_TAGS
+	int "maximum number of queued commands"
+	depends on SCSI
+	default "8"
+	help
+	  This specifies how many SCSI commands can be maximally queued for
+	  each probed SCSI device. You should reduce the default value of 8
+	  only if you have disks with buggy or limited tagged command support.
+	  Minimum is 2 and maximum is 14. This value is also the window size
+	  used by the elevator sorting option above. The effective value used
+	  by the driver for each probed SCSI device is reported at boot time.
+	  This is equivalent to the "u14-34f=mq:8" boot option.
+
+config SCSI_ULTRASTOR
+	tristate "UltraStor SCSI support"
+	depends on SCSI
+	---help---
+	  This is support for the UltraStor 14F, 24F and 34F SCSI-2 host
+	  adapter family.  This driver is explained in section 3.12 of the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.  If it doesn't work out
+	  of the box, you may have to change some settings in
+	  <file:drivers/scsi/ultrastor.h>.
+
+	  Note that there is also another driver for the same hardware:
+	  "UltraStor 14F/34F support", above.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ultrastor.
+
+config SCSI_NSP32
+	tristate "Workbit NinjaSCSI-32Bi/UDE support"
+	depends on SCSI
+	help
+	  This is support for the Workbit NinjaSCSI-32Bi/UDE PCI/Cardbus
+	  SCSI host adapter. Please read the SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nsp32.
+
+config SCSI_DEBUG
+	tristate "SCSI debugging host simulator"
+	depends on SCSI
+	select CRC_T10DIF
+	help
+	  This is a host adapter simulator that can simulate multiple hosts
+	  each with multiple dummy SCSI devices (disks). It defaults to one
+	  host adapter with one dummy SCSI disk. Each dummy disk uses kernel
+	  RAM as storage (i.e. it is a ramdisk). To save space when multiple
+	  dummy disks are simulated, they share the same kernel RAM for 
+	  their storage. See <http://sg.danny.cz/sg/sdebug26.html> for more
+	  information. This driver is primarily of use to those testing the
+	  SCSI and block subsystems. If unsure, say N.
+
+config SCSI_MESH
+	tristate "MESH (Power Mac internal SCSI) support"
+	depends on SCSI
+	help
+	  Many Power Macintoshes and clones have a MESH (Macintosh Enhanced
+	  SCSI Hardware) SCSI bus adaptor (the 7200 doesn't, but all of the
+	  other Power Macintoshes do). Say Y to include support for this SCSI
+	  adaptor.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mesh.
+
+config SCSI_MESH_SYNC_RATE
+	int "maximum synchronous transfer rate (MB/s) (0 = async)"
+	depends on SCSI
+	default "5"
+	help
+	  On Power Macintoshes (and clones) where the MESH SCSI bus adaptor
+	  drives a bus which is entirely internal to the machine (such as the
+	  7500, 7600, 8500, etc.), the MESH is capable of synchronous
+	  operation at up to 10 MB/s. On machines where the SCSI bus
+	  controlled by the MESH can have external devices connected, it is
+	  usually rated at 5 MB/s. 5 is a safe value here unless you know the
+	  MESH SCSI bus is internal only; in that case you can say 10. Say 0
+	  to disable synchronous operation.
+
+config SCSI_MESH_RESET_DELAY_MS
+	int "initial bus reset delay (ms) (0 = no reset)"
+	depends on SCSI
+	default "4000"
+
+config SCSI_MAC53C94
+	tristate "53C94 (Power Mac external SCSI) support"
+	depends on SCSI
+	help
+	  On Power Macintoshes (and clones) with two SCSI buses, the external
+	  SCSI bus is usually controlled by a 53C94 SCSI bus adaptor. Older
+	  machines which only have one SCSI bus, such as the 7200, also use
+	  the 53C94. Say Y to include support for the 53C94.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mac53c94.
+
+config JAZZ_ESP
+	bool "MIPS JAZZ FAS216 SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is the driver for the onboard SCSI host adapter of MIPS Magnum
+	  4000, Acer PICA, Olivetti M700-10 and a few other identical OEM
+	  systems.
+
+config A3000_SCSI
+	tristate "A3000 WD33C93A support"
+	depends on SCSI
+	help
+	  If you have an Amiga 3000 and have SCSI devices connected to the
+	  built-in SCSI controller, say Y. Otherwise, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called a3000.
+
+config A2091_SCSI
+	tristate "A2091/A590 WD33C93A support"
+	depends on SCSI
+	help
+	  If you have a Commodore A2091 SCSI controller, say Y. Otherwise,
+	  say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called a2091.
+
+config GVP11_SCSI
+	tristate "GVP Series II WD33C93A support"
+	depends on SCSI
+	---help---
+	  If you have a Great Valley Products Series II SCSI controller,
+	  answer Y. Also say Y if you have a later model of GVP SCSI
+	  controller (such as the GVP A4008 or a Combo board). Otherwise,
+	  answer N. This driver does NOT work for the T-Rex series of
+	  accelerators from TekMagic and GVP-M.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called gvp11.
+
+config SCSI_A4000T
+	tristate "A4000T NCR53c710 SCSI support (EXPERIMENTAL)"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  If you have an Amiga 4000T and have SCSI devices connected to the
+	  built-in SCSI controller, say Y. Otherwise, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called a4000t.
+
+config SCSI_ZORRO7XX
+	tristate "Zorro NCR53c710 SCSI support (EXPERIMENTAL)"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  Support for various NCR53c710-based SCSI controllers on Zorro
+	  expansion boards for the Amiga.
+	  This includes:
+	    - the Amiga 4091 Zorro III SCSI-2 controller,
+	    - the MacroSystem Development's WarpEngine Amiga SCSI-2 controller
+	      (info at
+	      <http://www.lysator.liu.se/amiga/ar/guide/ar310.guide?FEATURE5>),
+	    - the SCSI controller on the Phase5 Blizzard PowerUP 603e+
+	      accelerator card for the Amiga 1200,
+	    - the SCSI controller on the GVP Turbo 040/060 accelerator.
+
+config ATARI_SCSI
+	tristate "Atari native SCSI support"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	select NVRAM
+	---help---
+	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
+	  Falcon, ...) say Y to get it supported. Of course also, if you have
+	  a compatible SCSI controller (e.g. for Medusa).
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called atari_scsi.
+
+	  This driver supports both styles of NCR integration into the
+	  system: the TT style (separate DMA), and the Falcon style (via
+	  ST-DMA, replacing ACSI).  It does NOT support other schemes, like
+	  in the Hades (without DMA).
+
+config ATARI_SCSI_TOSHIBA_DELAY
+	bool "Long delays for Toshiba CD-ROMs"
+	depends on SCSI
+	help
+	  This option increases the delay after a SCSI arbitration to
+	  accommodate some flaky Toshiba CD-ROM drives. Say Y if you intend to
+	  use a Toshiba CD-ROM drive; otherwise, the option is not needed and
+	  would impact performance a bit, so say N.
+
+config ATARI_SCSI_RESET_BOOT
+	bool "Reset SCSI-devices at boottime"
+	depends on SCSI
+	help
+	  Reset the devices on your Atari whenever it boots.  This makes the
+	  boot process fractionally longer but may assist recovery from errors
+	  that leave the devices with SCSI operations partway completed.
+
+config MAC_SCSI
+	bool "Macintosh NCR5380 SCSI"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is the NCR 5380 SCSI controller included on most of the 68030
+	  based Macintoshes.  If you have one of these say Y and read the
+	  SCSI-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+config SCSI_MAC_ESP
+	tristate "Macintosh NCR53c9[46] SCSI"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is the NCR 53c9x SCSI controller found on most of the 68040
+	  based Macintoshes.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mac_esp.
+
+config MVME147_SCSI
+	bool "WD33C93 SCSI driver for MVME147"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  Support for the on-board SCSI controller on the Motorola MVME147
+	  single-board computer.
+
+config MVME16x_SCSI
+	tristate "NCR53C710 SCSI driver for MVME16x"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
+	  SCSI controller chip.  Almost everyone using one of these boards
+	  will want to say Y to this question.
+
+config BVME6000_SCSI
+	tristate "NCR53C710 SCSI driver for BVME6000"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
+	  SCSI controller chip.  Almost everyone using one of these boards
+	  will want to say Y to this question.
+
+config SUN3_SCSI
+	tristate "Sun3 NCR5380 SCSI"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This option will enable support for the OBIO (onboard io) NCR5380
+	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
+	  "Sun3" type VME scsi controllers also based on the NCR5380.
+	  General Linux information on the Sun 3 series (now discontinued)
+	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+
+config SUN3X_ESP
+	bool "Sun3x ESP SCSI"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  The ESP was an on-board SCSI controller used on Sun 3/80
+	  machines.  Say Y here to compile in support for it.
+
+config SCSI_SUNESP
+	tristate "Sparc ESP Scsi Driver"
+	depends on SCSI
+	select SCSI_SPI_ATTRS
+	help
+	  This is the driver for the Sun ESP SCSI host adapter. The ESP
+	  chipset is present in most SPARC SBUS-based computers and
+	  supports the Emulex family of ESP SCSI chips (esp100, esp100A,
+	  esp236, fas101, fas236) as well as the Qlogic fas366 SCSI chip.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sun_esp.
+
+config ZFCP
+	tristate "FCP host bus adapter driver for IBM eServer zSeries"
+	depends on SCSI
+	select SCSI_FC_ATTRS
+	help
+          If you want to access SCSI devices attached to your IBM eServer
+          zSeries by means of Fibre Channel interfaces say Y.
+          For details please refer to the documentation provided by IBM at
+          <http://oss.software.ibm.com/developerworks/opensource/linux390>
+
+          This driver is also available as a module. This module will be
+          called zfcp. If you want to compile it as a module, say M here
+          and read <file:Documentation/kbuild/modules.txt>.
+
+config SCSI_PMCRAID
+	tristate "PMC SIERRA Linux MaxRAID adapter support"
+	depends on SCSI
+	---help---
+	  This driver supports the PMC SIERRA MaxRAID adapters.
+
+config SCSI_PM8001
+	tristate "PMC-Sierra SPC 8001 SAS/SATA Based Host Adapter driver"
+	depends on SCSI
+	select SCSI_SAS_LIBSAS
+	help
+	  This driver supports PMC-Sierra PCIE SAS/SATA 8x6G SPC 8001 chip
+	  based host adapters.
+
+config SCSI_SRP
+	tristate "SCSI RDMA Protocol helper library"
+	depends on SCSI
+	select SCSI_TGT
+	help
+	  If you wish to use SRP target drivers, say Y.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called libsrp.
+
+config SCSI_BFA_FC
+	tristate "Brocade BFA Fibre Channel Support"
+	depends on SCSI
+	select SCSI_FC_ATTRS
+	help
+	  This bfa driver supports all Brocade PCIe FC/FCOE host adapters.
+
+	  To compile this driver as a module, choose M here. The module will
+	  be called bfa.
+
+config SCSI_VIRTIO
+	tristate "virtio-scsi support (EXPERIMENTAL)"
+	depends on SCSI
+	help
+          This is the virtual HBA driver for virtio.  If the kernel will
+          be used in a virtual machine, say Y or M.
+
+
+endmenu
diff -durp --unidirectional-new-file linux-3.7.10/arch/tm/Makefile linux-3.7.10.tm/arch/tm/Makefile
--- linux-3.7.10/arch/tm/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.7.10.tm/arch/tm/Makefile	2013-03-30 19:40:12.579388629 +0100
@@ -0,0 +1,42 @@
+# Makefile for tm
+
+# select defconfig based on actual architecture
+ifeq ($(ARCH),tm)
+        KBUILD_DEFCONFIG := tm_defconfig
+else
+        KBUILD_DEFCONFIG := $(ARCH)_defconfig
+endif
+
+BITS := 2
+UTS_MACHINE := tm
+CHECKFLAGS += -D__tm__ -m2
+
+KBUILD_AFLAGS += -mtm
+
+BOOT_TARGETS = tapimage
+
+PHONY += noImage $(BOOT_TARGETS)
+
+# Default kernel to build
+all: bzImage
+
+# KBUILD_IMAGE specify target image being built
+KBUILD_IMAGE := $(boot)/noImage
+
+bzImage:
+	echo "WIP"
+
+$(BOOT_TARGETS):
+	echo "WIP"
+
+PHONY += install
+install:
+	echo "Nothing to install"
+
+archclean:
+	echo "Nothing to clean"
+
+define archhelp
+  echo  '* noImage      - Compressed kernel image (arch/tm/boot/noImage)'
+  echo  '  tapimage     - Create a one MB tape image (arch/tm/boot/tapimage)'
+endef

--------------030601030506030904090502--
