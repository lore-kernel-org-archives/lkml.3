Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875Ab3CWECX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:02:23 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53869 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab3CWECV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:02:21 -0400
Date: Sat, 23 Mar 2013 00:02:20 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata minor updates
Message-ID: <20130323040220.GA7454@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull b186affe0c9d39e4d3152cd34bffea8fe1fa17f4 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

 drivers/ata/Kconfig           | 13 +++++++------
 drivers/ata/ahci.c            |  2 ++
 drivers/ata/ata_piix.c        |  4 ++++
 drivers/ata/libata-acpi.c     |  2 +-
 drivers/ata/pata_samsung_cf.c | 13 +------------
 drivers/ata/sata_fsl.c        |  3 +--
 6 files changed, 16 insertions(+), 21 deletions(-)

Aaron Lu (1):
      [libata] Avoid specialized TLA's in ZPODD's Kconfig

Andrew Brownfield (1):
      ata_piix: Add MODULE_PARM_DESC to prefer_ms_hyperv

James Ralston (1):
      ahci: Add Device IDs for Intel Wellsburg PCH

Jingoo Han (1):
      pata_samsung_cf: use module_platform_driver_probe()

Sander Eikelenboom (1):
      libata-acpi.c: fix copy and paste mistake in ata_acpi_register_power_resource

Syam Sidhardhan (1):
      sata_fsl: Remove redundant NULL check before kfree

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 3e751b7..a5a3ebc 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -59,15 +59,16 @@ config ATA_ACPI
 	  option libata.noacpi=1
 
 config SATA_ZPODD
-	bool "SATA Zero Power ODD Support"
+	bool "SATA Zero Power Optical Disc Drive (ZPODD) support"
 	depends on ATA_ACPI
 	default n
 	help
-	  This option adds support for SATA ZPODD. It requires both
-	  ODD and the platform support, and if enabled, will automatically
-	  power on/off the ODD when certain condition is satisfied. This
-	  does not impact user's experience of the ODD, only power is saved
-	  when ODD is not in use(i.e. no disc inside).
+	  This option adds support for SATA Zero Power Optical Disc
+	  Drive (ZPODD). It requires both the ODD and the platform
+	  support, and if enabled, will automatically power on/off the
+	  ODD when certain condition is satisfied. This does not impact
+	  end user's experience of the ODD, only power is saved when
+	  the ODD is not in use (i.e. no disc inside).
 
 	  If unsure, say N.
 
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a99112c..6a67b07 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -281,6 +281,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x1f37), board_ahci }, /* Avoton RAID */
 	{ PCI_VDEVICE(INTEL, 0x1f3e), board_ahci }, /* Avoton RAID */
 	{ PCI_VDEVICE(INTEL, 0x1f3f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x2823), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x2827), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
 	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index d2ba439..ffdd32d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1547,6 +1547,10 @@ static bool piix_broken_system_poweroff(struct pci_dev *pdev)
 
 static int prefer_ms_hyperv = 1;
 module_param(prefer_ms_hyperv, int, 0);
+MODULE_PARM_DESC(prefer_ms_hyperv,
+	"Prefer Hyper-V paravirtualization drivers instead of ATA, "
+	"0 - Use ATA drivers, "
+	"1 (Default) - Use the paravirtualization drivers.");
 
 static void piix_ignore_devices_quirk(struct ata_host *host)
 {
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 0ea1018..cb3eab6d 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -1027,7 +1027,7 @@ static void ata_acpi_register_power_resource(struct ata_device *dev)
 
 	handle = ata_dev_acpi_handle(dev);
 	if (handle)
-		acpi_dev_pm_remove_dependent(handle, &sdev->sdev_gendev);
+		acpi_dev_pm_add_dependent(handle, &sdev->sdev_gendev);
 }
 
 static void ata_acpi_unregister_power_resource(struct ata_device *dev)
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 70b0e01..6ef27e9 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -661,18 +661,7 @@ static struct platform_driver pata_s3c_driver = {
 	},
 };
 
-static int __init pata_s3c_init(void)
-{
-	return platform_driver_probe(&pata_s3c_driver, pata_s3c_probe);
-}
-
-static void __exit pata_s3c_exit(void)
-{
-	platform_driver_unregister(&pata_s3c_driver);
-}
-
-module_init(pata_s3c_init);
-module_exit(pata_s3c_exit);
+module_platform_driver_probe(pata_s3c_driver, pata_s3c_probe);
 
 MODULE_AUTHOR("Abhilash Kesavan, <a.kesavan@samsung.com>");
 MODULE_DESCRIPTION("low-level driver for Samsung PATA controller");
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 124b2c1..608f82f 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1511,8 +1511,7 @@ error_exit_with_cleanup:
 
 	if (hcr_base)
 		iounmap(hcr_base);
-	if (host_priv)
-		kfree(host_priv);
+	kfree(host_priv);
 
 	return retval;
 }
