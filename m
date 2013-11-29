Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3K2QBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 11:01:15 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:61059 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab3K2QBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 11:01:09 -0500
Date: Fri, 29 Nov 2013 11:01:06 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: [GIT PULL] libata fixes for v3.13-rc1
Message-ID: <20131129160106.GH3717@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

libata device removal path was removing parent device node before its
child, which is mostly harmless but triggers warning after recent
sysfs changes.  Rafael's patch fixes the order.

Other than that, minor controller-specific fixes and device ID
additions.

The patches are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.13-fixes

for you to fetch changes up to c5700766975c69d27150256444db63fbfd103791:

  ATA: Fix port removal ordering (2013-11-27 13:55:16 -0500)

Thanks.

----------------------------------------------------------------
Alistair Popple (1):
      ahci: add support for IBM Akebono platform device

Rafael J. Wysocki (1):
      ATA: Fix port removal ordering

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Wei Yongjun (1):
      pata_arasan_cf: add missing clk_disable_unprepare() on error path

Yijing Wang (1):
      ata: fix acpi_bus_get_device() return value check

 drivers/ata/ahci.c           | 2 ++
 drivers/ata/ahci_platform.c  | 1 +
 drivers/ata/libata-core.c    | 3 +--
 drivers/ata/libata-zpodd.c   | 4 +---
 drivers/ata/pata_arasan_cf.c | 1 +
 5 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e2903d0..14f1e95 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -435,6 +435,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index f955431..4b231ba 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -329,6 +329,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "snps,spear-ahci", },
 	{ .compatible = "snps,exynos5440-ahci", },
+	{ .compatible = "ibm,476gtr-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 81a94a3..75b9367 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6304,10 +6304,9 @@ static void ata_port_detach(struct ata_port *ap)
 		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
 			ata_tlink_delete(&ap->pmp_link[i]);
 	}
-	ata_tport_delete(ap);
-
 	/* remove the associated SCSI host */
 	scsi_remove_host(ap->scsi_host);
+	ata_tport_delete(ap);
 }
 
 /**
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 68f9e32..88949c6 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -88,15 +88,13 @@ static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
 static bool odd_can_poweroff(struct ata_device *ata_dev)
 {
 	acpi_handle handle;
-	acpi_status status;
 	struct acpi_device *acpi_dev;
 
 	handle = ata_dev_acpi_handle(ata_dev);
 	if (!handle)
 		return false;
 
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
+	if (acpi_bus_get_device(handle, &acpi_dev))
 		return false;
 
 	return acpi_device_can_poweroff(acpi_dev);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index e88690e..73492dd 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -319,6 +319,7 @@ static int cf_init(struct arasan_cf_dev *acdev)
 	ret = clk_set_rate(acdev->clk, 166000000);
 	if (ret) {
 		dev_warn(acdev->host->dev, "clock set rate failed");
+		clk_disable_unprepare(acdev->clk);
 		return ret;
 	}
 
