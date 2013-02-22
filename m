Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab3BVWUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:20:15 -0500
Received: from havoc.gtf.org ([69.61.125.42]:34163 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756939Ab3BVWUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:20:07 -0500
Date: Fri, 22 Feb 2013 17:20:01 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 3.9
Message-ID: <20130222222001.GA31651@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 53637e0760d56274177be7e6d630490bc49766c1 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus

1) apply, and then revert, the sysfs export of ATA host controller number.
   Discussion was continuing after patch application, trying to figure out how
   to best mesh exported data with the installers, boot-time agents and other
   parties that want this info.

2) Merge Zero-Power Optical Device Driver (ZPODD) support, bringing
   the wonderfulness of sane power management to your CD/DVD device.

   Includes one SCSI-subsystem patch (with appropriate ACKs),
   adding runtime PM support to 'sr' driver.  That is the ZPODD interaction
   bits.

   Patchset went through some 13 revisions before it got here; kudos to
   Intel for persistence.

3) pata_samsung_cf: use devm_clk_get()

4) more ata_piix, ahci PCI IDs

5) Add SATA driver for R-Car SoC

6) Convert libata to use devm_ioremap_resource (Note: I think
   Greg sent this to you, also)

7) Set proper Sense Key (SK) in the SCSI simulator when
   ATA passthrough indicates check condition.  Google and specification
   hawks everywhere shall rejoice.


to receive the following updates:

 drivers/ata/Kconfig           |  21 +
 drivers/ata/Makefile          |   2 +
 drivers/ata/ahci.c            |  32 +-
 drivers/ata/ata_piix.c        |  17 +
 drivers/ata/libahci.c         |   6 +-
 drivers/ata/libata-acpi.c     | 177 ++++----
 drivers/ata/libata-core.c     |  88 ++--
 drivers/ata/libata-eh.c       |  29 +-
 drivers/ata/libata-scsi.c     |  20 +-
 drivers/ata/libata-zpodd.c    | 299 ++++++++++++++
 drivers/ata/libata.h          |  27 ++
 drivers/ata/pata_ep93xx.c     |   7 +-
 drivers/ata/pata_samsung_cf.c |   4 +-
 drivers/ata/sata_rcar.c       | 910 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c       |  14 +
 drivers/scsi/sr.c             |  46 ++-
 include/linux/ata.h           |   8 +-
 include/linux/libata.h        |   7 +-
 include/scsi/scsi_device.h    |   5 +-
 include/uapi/linux/cdrom.h    |  34 ++
 20 files changed, 1593 insertions(+), 160 deletions(-)
 create mode 100644 drivers/ata/libata-zpodd.c
 create mode 100644 drivers/ata/sata_rcar.c

Aaron Lu (12):
      libata: identify and init ZPODD devices
      libata: move acpi notification code to zpodd
      libata: check zero power ready status for ZPODD
      libata: handle power transition of ODD
      libata: expose pm qos flags for ata device
      libata: do not suspend port if normal ODD is attached
      [libata] pm: differentiate system and runtime pm for ata port
      [libata] PM code cleanup for ata port
      [SCSI] sr: support runtime pm
      [libata] scsi: no poll when ODD is powered off
      [SCSI] remove can_power_off flag from scsi_device
      [libata] fix smatch warning for zpodd_wake_dev

Bian Yu (1):
      [libata] ahci: Fix lack of command retry after a success error handler.

David Milburn (1):
      libata: export host controller number thru /sys

Gwendal Grignou (1):
      [libata] Set proper SK when CK_COND is set.

Hugh Daschbach (1):
      [libata] ahci: Add support for Enmotus Bobcat device.

James Ralston (2):
      ata_piix: Add Device IDs for Intel Wellsburg PCH
      ahci: Add Device IDs for Intel Wellsburg PCH

Jeff Garzik (1):
      Revert "libata: export host controller number thru /sys"

Jingoo Han (1):
      pata_samsung_cf: Use devm_clk_get()

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

Shane Huang (1):
      [libata] replace sata_settings with devslp_timing

Thierry Reding (1):
      [libata] Convert to devm_ioremap_resource()

Vladimir Barinov (1):
      libata: add R-Car SATA driver

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index e08d322..9b58d32 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -58,6 +58,19 @@ config ATA_ACPI
 	  You can disable this at kernel boot time by using the
 	  option libata.noacpi=1
 
+config SATA_ZPODD
+	bool "SATA Zero Power ODD Support"
+	depends on ATA_ACPI
+	default n
+	help
+	  This option adds support for SATA ZPODD. It requires both
+	  ODD and the platform support, and if enabled, will automatically
+	  power on/off the ODD when certain condition is satisfied. This
+	  does not impact user's experience of the ODD, only power is saved
+	  when ODD is not in use(i.e. no disc inside).
+
+	  If unsure, say N.
+
 config SATA_PMP
 	bool "SATA Port Multiplier support"
 	default y
@@ -247,6 +260,14 @@ config SATA_PROMISE
 
 	  If unsure, say N.
 
+config SATA_RCAR
+	tristate "Renesas R-Car SATA support"
+	depends on ARCH_SHMOBILE && ARCH_R8A7779
+	help
+	  This option enables support for Renesas R-Car Serial ATA.
+
+	  If unsure, say N.
+
 config SATA_SIL
 	tristate "Silicon Image SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 9329daf..c04d0fd 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_MV)		+= sata_mv.o
 obj-$(CONFIG_SATA_NV)		+= sata_nv.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
+obj-$(CONFIG_SATA_RCAR)		+= sata_rcar.o
 obj-$(CONFIG_SATA_SIL)		+= sata_sil.o
 obj-$(CONFIG_SATA_SIS)		+= sata_sis.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
@@ -107,3 +108,4 @@ libata-y	:= libata-core.o libata-scsi.o libata-eh.o libata-transport.o
 libata-$(CONFIG_ATA_SFF)	+= libata-sff.o
 libata-$(CONFIG_SATA_PMP)	+= libata-pmp.o
 libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
+libata-$(CONFIG_SATA_ZPODD)	+= libata-zpodd.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7862d17..72e3e12 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -53,6 +53,7 @@
 
 enum {
 	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_ENMOTUS	= 2,
 	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
@@ -264,6 +265,30 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f22), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f23), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f24), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f25), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f26), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f27), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f32), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f33), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f34), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f35), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f36), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f37), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d0e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d62), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -410,6 +435,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -1098,9 +1126,11 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
-	/* The Connext uses non-standard BAR */
+	/* Both Connext and Enmotus devices use non-standard BARs */
 	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
 		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor == 0x1c44 && pdev->device == 0x8000)
+		ahci_pci_bar = AHCI_PCI_BAR_ENMOTUS;
 
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 174eca6..d2ba439 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -317,6 +317,23 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f30, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f31, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Wellsburg) */
+	{ 0x8086, 0x8d68, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 320712a..6cd7805 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1951,13 +1951,13 @@ static void ahci_set_aggressive_devslp(struct ata_port *ap, bool sleep)
 	/* Use the nominal value 10 ms if the read MDAT is zero,
 	 * the nominal value of DETO is 20 ms.
 	 */
-	if (dev->sata_settings[ATA_LOG_DEVSLP_VALID] &
+	if (dev->devslp_timing[ATA_LOG_DEVSLP_VALID] &
 	    ATA_LOG_DEVSLP_VALID_MASK) {
-		mdat = dev->sata_settings[ATA_LOG_DEVSLP_MDAT] &
+		mdat = dev->devslp_timing[ATA_LOG_DEVSLP_MDAT] &
 		       ATA_LOG_DEVSLP_MDAT_MASK;
 		if (!mdat)
 			mdat = 10;
-		deto = dev->sata_settings[ATA_LOG_DEVSLP_DETO];
+		deto = dev->devslp_timing[ATA_LOG_DEVSLP_DETO];
 		if (!deto)
 			deto = 20;
 	} else {
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index ef01ac0..dfd529a 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -17,6 +17,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_qos.h>
 #include <scsi/scsi_device.h>
 #include "libata.h"
 
@@ -835,50 +836,95 @@ void ata_acpi_on_resume(struct ata_port *ap)
 	}
 }
 
-/**
- * ata_acpi_set_state - set the port power state
- * @ap: target ATA port
- * @state: state, on/off
- *
- * This function executes the _PS0/_PS3 ACPI method to set the power state.
- * ACPI spec requires _PS0 when IDE power on and _PS3 when power off
- */
-void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
+static int ata_acpi_choose_suspend_state(struct ata_device *dev, bool runtime)
+{
+	int d_max_in = ACPI_STATE_D3_COLD;
+	if (!runtime)
+		goto out;
+
+	/*
+	 * For ATAPI, runtime D3 cold is only allowed
+	 * for ZPODD in zero power ready state
+	 */
+	if (dev->class == ATA_DEV_ATAPI &&
+	    !(zpodd_dev_enabled(dev) && zpodd_zpready(dev)))
+		d_max_in = ACPI_STATE_D3_HOT;
+
+out:
+	return acpi_pm_device_sleep_state(&dev->sdev->sdev_gendev,
+					  NULL, d_max_in);
+}
+
+static void sata_acpi_set_state(struct ata_port *ap, pm_message_t state)
 {
+	bool runtime = PMSG_IS_AUTO(state);
 	struct ata_device *dev;
 	acpi_handle handle;
 	int acpi_state;
 
-	/* channel first and then drives for power on and vica versa
-	   for power off */
-	handle = ata_ap_acpi_handle(ap);
-	if (handle && state.event == PM_EVENT_ON)
-		acpi_bus_set_power(handle, ACPI_STATE_D0);
-
 	ata_for_each_dev(dev, &ap->link, ENABLED) {
 		handle = ata_dev_acpi_handle(dev);
 		if (!handle)
 			continue;
 
-		if (state.event != PM_EVENT_ON) {
-			acpi_state = acpi_pm_device_sleep_state(
-				&dev->sdev->sdev_gendev, NULL, ACPI_STATE_D3);
-			if (acpi_state > 0)
-				acpi_bus_set_power(handle, acpi_state);
-			/* TBD: need to check if it's runtime pm request */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, true);
+		if (!(state.event & PM_EVENT_RESUME)) {
+			acpi_state = ata_acpi_choose_suspend_state(dev, runtime);
+			if (acpi_state == ACPI_STATE_D0)
+				continue;
+			if (runtime && zpodd_dev_enabled(dev) &&
+			    acpi_state == ACPI_STATE_D3_COLD)
+				zpodd_enable_run_wake(dev);
+			acpi_bus_set_power(handle, acpi_state);
 		} else {
-			/* Ditto */
-			acpi_pm_device_run_wake(
-				&dev->sdev->sdev_gendev, false);
+			if (runtime && zpodd_dev_enabled(dev))
+				zpodd_disable_run_wake(dev);
 			acpi_bus_set_power(handle, ACPI_STATE_D0);
 		}
 	}
+}
+
+/* ACPI spec requires _PS0 when IDE power on and _PS3 when power off */
+static void pata_acpi_set_state(struct ata_port *ap, pm_message_t state)
+{
+	struct ata_device *dev;
+	acpi_handle port_handle;
+
+	port_handle = ata_ap_acpi_handle(ap);
+	if (!port_handle)
+		return;
+
+	/* channel first and then drives for power on and vica versa
+	   for power off */
+	if (state.event & PM_EVENT_RESUME)
+		acpi_bus_set_power(port_handle, ACPI_STATE_D0);
+
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
+		acpi_handle dev_handle = ata_dev_acpi_handle(dev);
+		if (!dev_handle)
+			continue;
+
+		acpi_bus_set_power(dev_handle, state.event & PM_EVENT_RESUME ?
+						ACPI_STATE_D0 : ACPI_STATE_D3);
+	}
 
-	handle = ata_ap_acpi_handle(ap);
-	if (handle && state.event != PM_EVENT_ON)
-		acpi_bus_set_power(handle, ACPI_STATE_D3);
+	if (!(state.event & PM_EVENT_RESUME))
+		acpi_bus_set_power(port_handle, ACPI_STATE_D3);
+}
+
+/**
+ * ata_acpi_set_state - set the port power state
+ * @ap: target ATA port
+ * @state: state, on/off
+ *
+ * This function sets a proper ACPI D state for the device on
+ * system and runtime PM operations.
+ */
+void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
+{
+	if (ap->flags & ATA_FLAG_ACPI_SATA)
+		sata_acpi_set_state(ap, state);
+	else
+		pata_acpi_set_state(ap, state);
 }
 
 /**
@@ -974,57 +1020,6 @@ void ata_acpi_on_disable(struct ata_device *dev)
 	ata_acpi_clear_gtf(dev);
 }
 
-static void ata_acpi_wake_dev(acpi_handle handle, u32 event, void *context)
-{
-	struct ata_device *ata_dev = context;
-
-	if (event == ACPI_NOTIFY_DEVICE_WAKE && ata_dev &&
-			pm_runtime_suspended(&ata_dev->sdev->sdev_gendev))
-		scsi_autopm_get_device(ata_dev->sdev);
-}
-
-static void ata_acpi_add_pm_notifier(struct ata_device *dev)
-{
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
-	acpi_status status;
-
-	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (dev->sdev->can_power_off) {
-		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-			ata_acpi_wake_dev, dev);
-		device_set_run_wake(&dev->sdev->sdev_gendev, true);
-	}
-}
-
-static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
-{
-	struct acpi_device *acpi_dev;
-	acpi_handle handle;
-	acpi_status status;
-
-	handle = ata_dev_acpi_handle(dev);
-	if (!handle)
-		return;
-
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (dev->sdev->can_power_off) {
-		device_set_run_wake(&dev->sdev->sdev_gendev, false);
-		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-			ata_acpi_wake_dev);
-	}
-}
-
 static void ata_acpi_register_power_resource(struct ata_device *dev)
 {
 	struct scsi_device *sdev = dev->sdev;
@@ -1057,13 +1052,13 @@ static void ata_acpi_unregister_power_resource(struct ata_device *dev)
 
 void ata_acpi_bind(struct ata_device *dev)
 {
-	ata_acpi_add_pm_notifier(dev);
 	ata_acpi_register_power_resource(dev);
+	if (zpodd_dev_enabled(dev))
+		dev_pm_qos_expose_flags(&dev->sdev->sdev_gendev, 0);
 }
 
 void ata_acpi_unbind(struct ata_device *dev)
 {
-	ata_acpi_remove_pm_notifier(dev);
 	ata_acpi_unregister_power_resource(dev);
 }
 
@@ -1105,9 +1100,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 				acpi_handle *handle)
 {
 	struct ata_device *ata_dev;
-	acpi_status status;
-	struct acpi_device *acpi_dev;
-	struct acpi_device_power_state *states;
 
 	if (ap->flags & ATA_FLAG_ACPI_SATA) {
 		if (!sata_pmp_attached(ap))
@@ -1124,21 +1116,6 @@ static int ata_acpi_bind_device(struct ata_port *ap, struct scsi_device *sdev,
 	if (!*handle)
 		return -ENODEV;
 
-	status = acpi_bus_get_device(*handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		return 0;
-
-	/*
-	 * If firmware has _PS3 or _PR3 for this device,
-	 * and this ata ODD device support device attention,
-	 * it means this device can be powered off
-	 */
-	states = acpi_dev->power.states;
-	if ((states[ACPI_STATE_D3_HOT].flags.valid ||
-			states[ACPI_STATE_D3_COLD].flags.explicit_set) &&
-			ata_dev->flags & ATA_DFLAG_DA)
-		sdev->can_power_off = 1;
-
 	return 0;
 }
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9e8b99a..497adea 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2325,24 +2325,28 @@ int ata_dev_configure(struct ata_device *dev)
 			}
 		}
 
-		/* check and mark DevSlp capability */
-		if (ata_id_has_devslp(dev->id))
-			dev->flags |= ATA_DFLAG_DEVSLP;
-
-		/* Obtain SATA Settings page from Identify Device Data Log,
-		 * which contains DevSlp timing variables etc.
-		 * Exclude old devices with ata_id_has_ncq()
+		/* Check and mark DevSlp capability. Get DevSlp timing variables
+		 * from SATA Settings page of Identify Device Data Log.
 		 */
-		if (ata_id_has_ncq(dev->id)) {
+		if (ata_id_has_devslp(dev->id)) {
+			u8 sata_setting[ATA_SECT_SIZE];
+			int i, j;
+
+			dev->flags |= ATA_DFLAG_DEVSLP;
 			err_mask = ata_read_log_page(dev,
 						     ATA_LOG_SATA_ID_DEV_DATA,
 						     ATA_LOG_SATA_SETTINGS,
-						     dev->sata_settings,
+						     sata_setting,
 						     1);
 			if (err_mask)
 				ata_dev_dbg(dev,
 					    "failed to get Identify Device Data, Emask 0x%x\n",
 					    err_mask);
+			else
+				for (i = 0; i < ATA_LOG_DEVSLP_SIZE; i++) {
+					j = ATA_LOG_DEVSLP_OFFSET + i;
+					dev->devslp_timing[i] = sata_setting[j];
+				}
 		}
 
 		dev->cdb_len = 16;
@@ -2396,8 +2400,10 @@ int ata_dev_configure(struct ata_device *dev)
 			dma_dir_string = ", DMADIR";
 		}
 
-		if (ata_id_has_da(dev->id))
+		if (ata_id_has_da(dev->id)) {
 			dev->flags |= ATA_DFLAG_DA;
+			zpodd_init(dev);
+		}
 
 		/* print device info to dmesg */
 		if (ata_msg_drv(ap) && print_info)
@@ -5327,9 +5333,6 @@ static int ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
 
 static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int *async)
 {
-	unsigned int ehi_flags = ATA_EHI_QUIET;
-	int rc;
-
 	/*
 	 * On some hardware, device fails to respond after spun down
 	 * for suspend.  As the device won't be used before being
@@ -5338,11 +5341,9 @@ static int __ata_port_suspend_common(struct ata_port *ap, pm_message_t mesg, int
 	 *
 	 * http://thread.gmane.org/gmane.linux.ide/46764
 	 */
-	if (mesg.event == PM_EVENT_SUSPEND)
-		ehi_flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_NO_RECOVERY;
-
-	rc = ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
-	return rc;
+	unsigned int ehi_flags = ATA_EHI_QUIET | ATA_EHI_NO_AUTOPSY |
+				 ATA_EHI_NO_RECOVERY;
+	return ata_port_request_pm(ap, mesg, 0, ehi_flags, async);
 }
 
 static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
@@ -5363,40 +5364,38 @@ static int ata_port_suspend(struct device *dev)
 static int ata_port_do_freeze(struct device *dev)
 {
 	if (pm_runtime_suspended(dev))
-		pm_runtime_resume(dev);
+		return 0;
 
 	return ata_port_suspend_common(dev, PMSG_FREEZE);
 }
 
 static int ata_port_poweroff(struct device *dev)
 {
-	if (pm_runtime_suspended(dev))
-		return 0;
-
 	return ata_port_suspend_common(dev, PMSG_HIBERNATE);
 }
 
-static int __ata_port_resume_common(struct ata_port *ap, int *async)
+static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
+				    int *async)
 {
 	int rc;
 
-	rc = ata_port_request_pm(ap, PMSG_ON, ATA_EH_RESET,
+	rc = ata_port_request_pm(ap, mesg, ATA_EH_RESET,
 		ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET, async);
 	return rc;
 }
 
-static int ata_port_resume_common(struct device *dev)
+static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
 {
 	struct ata_port *ap = to_ata_port(dev);
 
-	return __ata_port_resume_common(ap, NULL);
+	return __ata_port_resume_common(ap, mesg, NULL);
 }
 
 static int ata_port_resume(struct device *dev)
 {
 	int rc;
 
-	rc = ata_port_resume_common(dev);
+	rc = ata_port_resume_common(dev, PMSG_RESUME);
 	if (!rc) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
@@ -5406,11 +5405,40 @@ static int ata_port_resume(struct device *dev)
 	return rc;
 }
 
+/*
+ * For ODDs, the upper layer will poll for media change every few seconds,
+ * which will make it enter and leave suspend state every few seconds. And
+ * as each suspend will cause a hard/soft reset, the gain of runtime suspend
+ * is very little and the ODD may malfunction after constantly being reset.
+ * So the idle callback here will not proceed to suspend if a non-ZPODD capable
+ * ODD is attached to the port.
+ */
 static int ata_port_runtime_idle(struct device *dev)
 {
+	struct ata_port *ap = to_ata_port(dev);
+	struct ata_link *link;
+	struct ata_device *adev;
+
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		ata_for_each_dev(adev, link, ENABLED)
+			if (adev->class == ATA_DEV_ATAPI &&
+			    !zpodd_dev_enabled(adev))
+				return -EBUSY;
+	}
+
 	return pm_runtime_suspend(dev);
 }
 
+static int ata_port_runtime_suspend(struct device *dev)
+{
+	return ata_port_suspend_common(dev, PMSG_AUTO_SUSPEND);
+}
+
+static int ata_port_runtime_resume(struct device *dev)
+{
+	return ata_port_resume_common(dev, PMSG_AUTO_RESUME);
+}
+
 static const struct dev_pm_ops ata_port_pm_ops = {
 	.suspend = ata_port_suspend,
 	.resume = ata_port_resume,
@@ -5419,8 +5447,8 @@ static const struct dev_pm_ops ata_port_pm_ops = {
 	.poweroff = ata_port_poweroff,
 	.restore = ata_port_resume,
 
-	.runtime_suspend = ata_port_suspend,
-	.runtime_resume = ata_port_resume_common,
+	.runtime_suspend = ata_port_runtime_suspend,
+	.runtime_resume = ata_port_runtime_resume,
 	.runtime_idle = ata_port_runtime_idle,
 };
 
@@ -5437,7 +5465,7 @@ EXPORT_SYMBOL_GPL(ata_sas_port_async_suspend);
 
 int ata_sas_port_async_resume(struct ata_port *ap, int *async)
 {
-	return __ata_port_resume_common(ap, async);
+	return __ata_port_resume_common(ap, PMSG_RESUME, async);
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_async_resume);
 
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index bf039b0..f9476fb 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1591,7 +1591,7 @@ static int ata_eh_read_log_10h(struct ata_device *dev,
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure.
  */
-static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
+unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
 {
 	u8 cdb[ATAPI_CDB_LEN] = { TEST_UNIT_READY, 0, 0, 0, 0, 0 };
 	struct ata_taskfile tf;
@@ -1624,7 +1624,7 @@ static unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key)
  *	RETURNS:
  *	0 on success, AC_ERR_* mask on failure
  */
-static unsigned int atapi_eh_request_sense(struct ata_device *dev,
+unsigned int atapi_eh_request_sense(struct ata_device *dev,
 					   u8 *sense_buf, u8 dfl_sense_key)
 {
 	u8 cdb[ATAPI_CDB_LEN] =
@@ -2094,7 +2094,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
  */
 static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & AC_ERR_MEDIA)
+	if (qc->err_mask & AC_ERR_MEDIA)
 		return 0;	/* don't retry media errors */
 	if (qc->flags & ATA_QCFLAG_IO)
 		return 1;	/* otherwise retry anything from fs stack */
@@ -3857,6 +3857,8 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 				rc = atapi_eh_clear_ua(dev);
 				if (rc)
 					goto rest_fail;
+				if (zpodd_dev_enabled(dev))
+					zpodd_post_poweron(dev);
 			}
 		}
 
@@ -4022,11 +4024,12 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 {
 	unsigned long flags;
 	int rc = 0;
+	struct ata_device *dev;
 
 	/* are we suspending? */
 	spin_lock_irqsave(ap->lock, flags);
 	if (!(ap->pflags & ATA_PFLAG_PM_PENDING) ||
-	    ap->pm_mesg.event == PM_EVENT_ON) {
+	    ap->pm_mesg.event & PM_EVENT_RESUME) {
 		spin_unlock_irqrestore(ap->lock, flags);
 		return;
 	}
@@ -4034,6 +4037,18 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 
 	WARN_ON(ap->pflags & ATA_PFLAG_SUSPENDED);
 
+	/*
+	 * If we have a ZPODD attached, check its zero
+	 * power ready status before the port is frozen.
+	 * Only needed for runtime suspend.
+	 */
+	if (PMSG_IS_AUTO(ap->pm_mesg)) {
+		ata_for_each_dev(dev, &ap->link, ENABLED) {
+			if (zpodd_dev_enabled(dev))
+				zpodd_on_suspend(dev);
+		}
+	}
+
 	/* tell ACPI we're suspending */
 	rc = ata_acpi_on_suspend(ap);
 	if (rc)
@@ -4045,7 +4060,7 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 	if (ap->ops->port_suspend)
 		rc = ap->ops->port_suspend(ap, ap->pm_mesg);
 
-	ata_acpi_set_state(ap, PMSG_SUSPEND);
+	ata_acpi_set_state(ap, ap->pm_mesg);
  out:
 	/* report result */
 	spin_lock_irqsave(ap->lock, flags);
@@ -4085,7 +4100,7 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 	/* are we resuming? */
 	spin_lock_irqsave(ap->lock, flags);
 	if (!(ap->pflags & ATA_PFLAG_PM_PENDING) ||
-	    ap->pm_mesg.event != PM_EVENT_ON) {
+	    !(ap->pm_mesg.event & PM_EVENT_RESUME)) {
 		spin_unlock_irqrestore(ap->lock, flags);
 		return;
 	}
@@ -4104,7 +4119,7 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 		ata_for_each_dev(dev, link, ALL)
 			ata_ering_clear(&dev->ering);
 
-	ata_acpi_set_state(ap, PMSG_ON);
+	ata_acpi_set_state(ap, ap->pm_mesg);
 
 	if (ap->ops->port_resume)
 		rc = ap->ops->port_resume(ap);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 7c337e7..318b413 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -933,7 +933,11 @@ static void ata_to_sense_error(unsigned id, u8 drv_stat, u8 drv_err, u8 *sk,
  *	block specified for the ATA pass through commands.  Regardless
  *	of whether the command errored or not, return a sense
  *	block. Copy all controller registers into the sense
- *	block. Clear sense key, ASC & ASCQ if there is no error.
+ *	block. If there was no error, we get the request from an ATA
+ *	passthrough command, so we use the following sense data:
+ *	sk = RECOVERED ERROR
+ *	asc,ascq = ATA PASS-THROUGH INFORMATION AVAILABLE
+ *      
  *
  *	LOCKING:
  *	None.
@@ -959,6 +963,10 @@ static void ata_gen_passthru_sense(struct ata_queued_cmd *qc)
 		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
 				   &sb[1], &sb[2], &sb[3], verbose);
 		sb[1] &= 0x0f;
+	} else {
+		sb[1] = RECOVERED_ERROR;
+		sb[2] = 0;
+		sb[3] = 0x1D;
 	}
 
 	/*
@@ -1733,10 +1741,12 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
 
 	/* For ATA pass thru (SAT) commands, generate a sense block if
 	 * user mandated it or if there's an error.  Note that if we
-	 * generate because the user forced us to, a check condition
-	 * is generated and the ATA register values are returned
+	 * generate because the user forced us to [CK_COND =1], a check
+	 * condition is generated and the ATA register values are returned
 	 * whether the command completed successfully or not. If there
-	 * was no error, SK, ASC and ASCQ will all be zero.
+	 * was no error, we use the following sense data:
+	 * sk = RECOVERED ERROR
+	 * asc,ascq = ATA PASS-THROUGH INFORMATION AVAILABLE
 	 */
 	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
 	    ((cdb[2] & 0x20) || need_sense)) {
@@ -3755,6 +3765,8 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
 	mutex_lock(&ap->scsi_host->scan_mutex);
 	spin_lock_irqsave(ap->lock, flags);
 
+	if (zpodd_dev_enabled(dev))
+		zpodd_exit(dev);
 	ata_acpi_unbind(dev);
 
 	/* clearing dev->sdev is protected by host lock */
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
new file mode 100644
index 0000000..90b159b
--- /dev/null
+++ b/drivers/ata/libata-zpodd.c
@@ -0,0 +1,299 @@
+#include <linux/libata.h>
+#include <linux/cdrom.h>
+#include <linux/pm_runtime.h>
+#include <linux/module.h>
+#include <scsi/scsi_device.h>
+
+#include "libata.h"
+
+static int zpodd_poweroff_delay = 30; /* 30 seconds for power off delay */
+module_param(zpodd_poweroff_delay, int, 0644);
+MODULE_PARM_DESC(zpodd_poweroff_delay, "Poweroff delay for ZPODD in seconds");
+
+enum odd_mech_type {
+	ODD_MECH_TYPE_SLOT,
+	ODD_MECH_TYPE_DRAWER,
+	ODD_MECH_TYPE_UNSUPPORTED,
+};
+
+struct zpodd {
+	enum odd_mech_type	mech_type; /* init during probe, RO afterwards */
+	struct ata_device	*dev;
+
+	/* The following fields are synchronized by PM core. */
+	bool			from_notify; /* resumed as a result of
+					      * acpi wake notification */
+	bool			zp_ready; /* ZP ready state */
+	unsigned long		last_ready; /* last ZP ready timestamp */
+	bool			zp_sampled; /* ZP ready state sampled */
+	bool			powered_off; /* ODD is powered off
+					      *	during suspend */
+};
+
+static int eject_tray(struct ata_device *dev)
+{
+	struct ata_taskfile tf = {};
+	const char cdb[] = {  GPCMD_START_STOP_UNIT,
+		0, 0, 0,
+		0x02,     /* LoEj */
+		0, 0, 0, 0, 0, 0, 0,
+	};
+
+	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_NODATA;
+
+	return ata_exec_internal(dev, &tf, cdb, DMA_NONE, NULL, 0, 0);
+}
+
+/* Per the spec, only slot type and drawer type ODD can be supported */
+static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
+{
+	char buf[16];
+	unsigned int ret;
+	struct rm_feature_desc *desc = (void *)(buf + 8);
+	struct ata_taskfile tf = {};
+
+	char cdb[] = {  GPCMD_GET_CONFIGURATION,
+			2,      /* only 1 feature descriptor requested */
+			0, 3,   /* 3, removable medium feature */
+			0, 0, 0,/* reserved */
+			0, sizeof(buf),
+			0, 0, 0,
+	};
+
+	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
+	tf.command = ATA_CMD_PACKET;
+	tf.protocol = ATAPI_PROT_PIO;
+	tf.lbam = sizeof(buf);
+
+	ret = ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
+				buf, sizeof(buf), 0);
+	if (ret)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+
+	if (be16_to_cpu(desc->feature_code) != 3)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+		return ODD_MECH_TYPE_SLOT;
+	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+		return ODD_MECH_TYPE_DRAWER;
+	else
+		return ODD_MECH_TYPE_UNSUPPORTED;
+}
+
+static bool odd_can_poweroff(struct ata_device *ata_dev)
+{
+	acpi_handle handle;
+	acpi_status status;
+	struct acpi_device *acpi_dev;
+
+	handle = ata_dev_acpi_handle(ata_dev);
+	if (!handle)
+		return false;
+
+	status = acpi_bus_get_device(handle, &acpi_dev);
+	if (ACPI_FAILURE(status))
+		return false;
+
+	return acpi_device_can_poweroff(acpi_dev);
+}
+
+/* Test if ODD is zero power ready by sense code */
+static bool zpready(struct ata_device *dev)
+{
+	u8 sense_key, *sense_buf;
+	unsigned int ret, asc, ascq, add_len;
+	struct zpodd *zpodd = dev->zpodd;
+
+	ret = atapi_eh_tur(dev, &sense_key);
+
+	if (!ret || sense_key != NOT_READY)
+		return false;
+
+	sense_buf = dev->link->ap->sector_buf;
+	ret = atapi_eh_request_sense(dev, sense_buf, sense_key);
+	if (ret)
+		return false;
+
+	/* sense valid */
+	if ((sense_buf[0] & 0x7f) != 0x70)
+		return false;
+
+	add_len = sense_buf[7];
+	/* has asc and ascq */
+	if (add_len < 6)
+		return false;
+
+	asc = sense_buf[12];
+	ascq = sense_buf[13];
+
+	if (zpodd->mech_type == ODD_MECH_TYPE_SLOT)
+		/* no media inside */
+		return asc == 0x3a;
+	else
+		/* no media inside and door closed */
+		return asc == 0x3a && ascq == 0x01;
+}
+
+/*
+ * Update the zpodd->zp_ready field. This field will only be set
+ * if the ODD has stayed in ZP ready state for zpodd_poweroff_delay
+ * time, and will be used to decide if power off is allowed. If it
+ * is set, it will be cleared during resume from powered off state.
+ */
+void zpodd_on_suspend(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+	unsigned long expires;
+
+	if (!zpready(dev)) {
+		zpodd->zp_sampled = false;
+		zpodd->zp_ready = false;
+		return;
+	}
+
+	if (!zpodd->zp_sampled) {
+		zpodd->zp_sampled = true;
+		zpodd->last_ready = jiffies;
+		return;
+	}
+
+	expires = zpodd->last_ready +
+		  msecs_to_jiffies(zpodd_poweroff_delay * 1000);
+	if (time_before(jiffies, expires))
+		return;
+
+	zpodd->zp_ready = true;
+}
+
+bool zpodd_zpready(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+	return zpodd->zp_ready;
+}
+
+/*
+ * Enable runtime wake capability through ACPI and set the powered_off flag,
+ * this flag will be used during resume to decide what operations are needed
+ * to take.
+ *
+ * Also, media poll needs to be silenced, so that it doesn't bring the ODD
+ * back to full power state every few seconds.
+ */
+void zpodd_enable_run_wake(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	sdev_disable_disk_events(dev->sdev);
+
+	zpodd->powered_off = true;
+	device_set_run_wake(&dev->sdev->sdev_gendev, true);
+	acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, true);
+}
+
+/* Disable runtime wake capability if it is enabled */
+void zpodd_disable_run_wake(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	if (zpodd->powered_off) {
+		acpi_pm_device_run_wake(&dev->sdev->sdev_gendev, false);
+		device_set_run_wake(&dev->sdev->sdev_gendev, false);
+	}
+}
+
+/*
+ * Post power on processing after the ODD has been recovered. If the
+ * ODD wasn't powered off during suspend, it doesn't do anything.
+ *
+ * For drawer type ODD, if it is powered on due to user pressed the
+ * eject button, the tray needs to be ejected. This can only be done
+ * after the ODD has been recovered, i.e. link is initialized and
+ * device is able to process NON_DATA PIO command, as eject needs to
+ * send command for the ODD to process.
+ *
+ * The from_notify flag set in wake notification handler function
+ * zpodd_wake_dev represents if power on is due to user's action.
+ *
+ * For both types of ODD, several fields need to be reset.
+ */
+void zpodd_post_poweron(struct ata_device *dev)
+{
+	struct zpodd *zpodd = dev->zpodd;
+
+	if (!zpodd->powered_off)
+		return;
+
+	zpodd->powered_off = false;
+
+	if (zpodd->from_notify) {
+		zpodd->from_notify = false;
+		if (zpodd->mech_type == ODD_MECH_TYPE_DRAWER)
+			eject_tray(dev);
+	}
+
+	zpodd->zp_sampled = false;
+	zpodd->zp_ready = false;
+
+	sdev_enable_disk_events(dev->sdev);
+}
+
+static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
+{
+	struct ata_device *ata_dev = context;
+	struct zpodd *zpodd = ata_dev->zpodd;
+	struct device *dev = &ata_dev->sdev->sdev_gendev;
+
+	if (event == ACPI_NOTIFY_DEVICE_WAKE && pm_runtime_suspended(dev)) {
+		zpodd->from_notify = true;
+		pm_runtime_resume(dev);
+	}
+}
+
+static void ata_acpi_add_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = ata_dev_acpi_handle(dev);
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				    zpodd_wake_dev, dev);
+}
+
+static void ata_acpi_remove_pm_notifier(struct ata_device *dev)
+{
+	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->sdev->sdev_gendev);
+	acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY, zpodd_wake_dev);
+}
+
+void zpodd_init(struct ata_device *dev)
+{
+	enum odd_mech_type mech_type;
+	struct zpodd *zpodd;
+
+	if (dev->zpodd)
+		return;
+
+	if (!odd_can_poweroff(dev))
+		return;
+
+	mech_type = zpodd_get_mech_type(dev);
+	if (mech_type == ODD_MECH_TYPE_UNSUPPORTED)
+		return;
+
+	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
+	if (!zpodd)
+		return;
+
+	zpodd->mech_type = mech_type;
+
+	ata_acpi_add_pm_notifier(dev);
+	zpodd->dev = dev;
+	dev->zpodd = zpodd;
+}
+
+void zpodd_exit(struct ata_device *dev)
+{
+	ata_acpi_remove_pm_notifier(dev);
+	kfree(dev->zpodd);
+	dev->zpodd = NULL;
+}
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 7148a58..c949dd3 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -182,6 +182,9 @@ extern void ata_eh_finish(struct ata_port *ap);
 extern int ata_ering_map(struct ata_ering *ering,
 			 int (*map_fn)(struct ata_ering_entry *, void *),
 		  	 void *arg);
+extern unsigned int atapi_eh_tur(struct ata_device *dev, u8 *r_sense_key);
+extern unsigned int atapi_eh_request_sense(struct ata_device *dev,
+					   u8 *sense_buf, u8 dfl_sense_key);
 
 /* libata-pmp.c */
 #ifdef CONFIG_SATA_PMP
@@ -230,4 +233,28 @@ static inline void ata_sff_exit(void)
 { }
 #endif /* CONFIG_ATA_SFF */
 
+/* libata-zpodd.c */
+#ifdef CONFIG_SATA_ZPODD
+void zpodd_init(struct ata_device *dev);
+void zpodd_exit(struct ata_device *dev);
+static inline bool zpodd_dev_enabled(struct ata_device *dev)
+{
+	return dev->zpodd != NULL;
+}
+void zpodd_on_suspend(struct ata_device *dev);
+bool zpodd_zpready(struct ata_device *dev);
+void zpodd_enable_run_wake(struct ata_device *dev);
+void zpodd_disable_run_wake(struct ata_device *dev);
+void zpodd_post_poweron(struct ata_device *dev);
+#else /* CONFIG_SATA_ZPODD */
+static inline void zpodd_init(struct ata_device *dev) {}
+static inline void zpodd_exit(struct ata_device *dev) {}
+static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+static inline void zpodd_on_suspend(struct ata_device *dev) {}
+static inline bool zpodd_zpready(struct ata_device *dev) { return false; }
+static inline void zpodd_enable_run_wake(struct ata_device *dev) {}
+static inline void zpodd_disable_run_wake(struct ata_device *dev) {}
+static inline void zpodd_post_poweron(struct ata_device *dev) {}
+#endif /* CONFIG_SATA_ZPODD */
+
 #endif /* __LIBATA_H__ */
diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index 556222f..c1bfaf4 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -31,6 +31,7 @@
  *   Copyright (C) 2006 Tower Technologies
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -937,9 +938,9 @@ static int ep93xx_pata_probe(struct platform_device *pdev)
 		goto err_rel_gpio;
 	}
 
-	ide_base = devm_request_and_ioremap(&pdev->dev, mem_res);
-	if (!ide_base) {
-		err = -ENXIO;
+	ide_base = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(ide_base)) {
+		err = PTR_ERR(ide_base);
 		goto err_rel_gpio;
 	}
 
diff --git a/drivers/ata/pata_samsung_cf.c b/drivers/ata/pata_samsung_cf.c
index 63ffb00..70b0e01 100644
--- a/drivers/ata/pata_samsung_cf.c
+++ b/drivers/ata/pata_samsung_cf.c
@@ -512,7 +512,7 @@ static int __init pata_s3c_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	info->clk = clk_get(&pdev->dev, "cfcon");
+	info->clk = devm_clk_get(&pdev->dev, "cfcon");
 	if (IS_ERR(info->clk)) {
 		dev_err(dev, "failed to get access to cf controller clock\n");
 		ret = PTR_ERR(info->clk);
@@ -589,7 +589,6 @@ static int __init pata_s3c_probe(struct platform_device *pdev)
 
 stop_clk:
 	clk_disable(info->clk);
-	clk_put(info->clk);
 	return ret;
 }
 
@@ -601,7 +600,6 @@ static int __exit pata_s3c_remove(struct platform_device *pdev)
 	ata_host_detach(host);
 
 	clk_disable(info->clk);
-	clk_put(info->clk);
 
 	return 0;
 }
diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
new file mode 100644
index 0000000..caf33f6
--- /dev/null
+++ b/drivers/ata/sata_rcar.c
@@ -0,0 +1,910 @@
+/*
+ * Renesas R-Car SATA driver
+ *
+ * Author: Vladimir Barinov <source@cogentembedded.com>
+ * Copyright (C) 2013 Cogent Embedded, Inc.
+ * Copyright (C) 2013 Renesas Solutions Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ata.h>
+#include <linux/libata.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+
+#define DRV_NAME "sata_rcar"
+
+/* SH-Navi2G/ATAPI-ATA compatible task registers */
+#define DATA_REG			0x100
+#define SDEVCON_REG			0x138
+
+/* SH-Navi2G/ATAPI module compatible control registers */
+#define ATAPI_CONTROL1_REG		0x180
+#define ATAPI_STATUS_REG		0x184
+#define ATAPI_INT_ENABLE_REG		0x188
+#define ATAPI_DTB_ADR_REG		0x198
+#define ATAPI_DMA_START_ADR_REG		0x19C
+#define ATAPI_DMA_TRANS_CNT_REG		0x1A0
+#define ATAPI_CONTROL2_REG		0x1A4
+#define ATAPI_SIG_ST_REG		0x1B0
+#define ATAPI_BYTE_SWAP_REG		0x1BC
+
+/* ATAPI control 1 register (ATAPI_CONTROL1) bits */
+#define ATAPI_CONTROL1_ISM		BIT(16)
+#define ATAPI_CONTROL1_DTA32M		BIT(11)
+#define ATAPI_CONTROL1_RESET		BIT(7)
+#define ATAPI_CONTROL1_DESE		BIT(3)
+#define ATAPI_CONTROL1_RW		BIT(2)
+#define ATAPI_CONTROL1_STOP		BIT(1)
+#define ATAPI_CONTROL1_START		BIT(0)
+
+/* ATAPI status register (ATAPI_STATUS) bits */
+#define ATAPI_STATUS_SATAINT		BIT(11)
+#define ATAPI_STATUS_DNEND		BIT(6)
+#define ATAPI_STATUS_DEVTRM		BIT(5)
+#define ATAPI_STATUS_DEVINT		BIT(4)
+#define ATAPI_STATUS_ERR		BIT(2)
+#define ATAPI_STATUS_NEND		BIT(1)
+#define ATAPI_STATUS_ACT		BIT(0)
+
+/* Interrupt enable register (ATAPI_INT_ENABLE) bits */
+#define ATAPI_INT_ENABLE_SATAINT	BIT(11)
+#define ATAPI_INT_ENABLE_DNEND		BIT(6)
+#define ATAPI_INT_ENABLE_DEVTRM		BIT(5)
+#define ATAPI_INT_ENABLE_DEVINT		BIT(4)
+#define ATAPI_INT_ENABLE_ERR		BIT(2)
+#define ATAPI_INT_ENABLE_NEND		BIT(1)
+#define ATAPI_INT_ENABLE_ACT		BIT(0)
+
+/* Access control registers for physical layer control register */
+#define SATAPHYADDR_REG			0x200
+#define SATAPHYWDATA_REG		0x204
+#define SATAPHYACCEN_REG		0x208
+#define SATAPHYRESET_REG		0x20C
+#define SATAPHYRDATA_REG		0x210
+#define SATAPHYACK_REG			0x214
+
+/* Physical layer control address command register (SATAPHYADDR) bits */
+#define SATAPHYADDR_PHYRATEMODE		BIT(10)
+#define SATAPHYADDR_PHYCMD_READ		BIT(9)
+#define SATAPHYADDR_PHYCMD_WRITE	BIT(8)
+
+/* Physical layer control enable register (SATAPHYACCEN) bits */
+#define SATAPHYACCEN_PHYLANE		BIT(0)
+
+/* Physical layer control reset register (SATAPHYRESET) bits */
+#define SATAPHYRESET_PHYRST		BIT(1)
+#define SATAPHYRESET_PHYSRES		BIT(0)
+
+/* Physical layer control acknowledge register (SATAPHYACK) bits */
+#define SATAPHYACK_PHYACK		BIT(0)
+
+/* Serial-ATA HOST control registers */
+#define BISTCONF_REG			0x102C
+#define SDATA_REG			0x1100
+#define SSDEVCON_REG			0x1204
+
+#define SCRSSTS_REG			0x1400
+#define SCRSERR_REG			0x1404
+#define SCRSCON_REG			0x1408
+#define SCRSACT_REG			0x140C
+
+#define SATAINTSTAT_REG			0x1508
+#define SATAINTMASK_REG			0x150C
+
+/* SATA INT status register (SATAINTSTAT) bits */
+#define SATAINTSTAT_SERR		BIT(3)
+#define SATAINTSTAT_ATA			BIT(0)
+
+/* SATA INT mask register (SATAINTSTAT) bits */
+#define SATAINTMASK_SERRMSK		BIT(3)
+#define SATAINTMASK_ERRMSK		BIT(2)
+#define SATAINTMASK_ERRCRTMSK		BIT(1)
+#define SATAINTMASK_ATAMSK		BIT(0)
+
+#define SATA_RCAR_INT_MASK		(SATAINTMASK_SERRMSK | \
+					 SATAINTMASK_ATAMSK)
+
+/* Physical Layer Control Registers */
+#define SATAPCTLR1_REG			0x43
+#define SATAPCTLR2_REG			0x52
+#define SATAPCTLR3_REG			0x5A
+#define SATAPCTLR4_REG			0x60
+
+/* Descriptor table word 0 bit (when DTA32M = 1) */
+#define SATA_RCAR_DTEND			BIT(0)
+
+struct sata_rcar_priv {
+	void __iomem *base;
+	struct clk *clk;
+};
+
+static void sata_rcar_phy_initialize(struct sata_rcar_priv *priv)
+{
+	/* idle state */
+	iowrite32(0, priv->base + SATAPHYADDR_REG);
+	/* reset */
+	iowrite32(SATAPHYRESET_PHYRST, priv->base + SATAPHYRESET_REG);
+	udelay(10);
+	/* deassert reset */
+	iowrite32(0, priv->base + SATAPHYRESET_REG);
+}
+
+static void sata_rcar_phy_write(struct sata_rcar_priv *priv, u16 reg, u32 val,
+				int group)
+{
+	int timeout;
+
+	/* deassert reset */
+	iowrite32(0, priv->base + SATAPHYRESET_REG);
+	/* lane 1 */
+	iowrite32(SATAPHYACCEN_PHYLANE, priv->base + SATAPHYACCEN_REG);
+	/* write phy register value */
+	iowrite32(val, priv->base + SATAPHYWDATA_REG);
+	/* set register group */
+	if (group)
+		reg |= SATAPHYADDR_PHYRATEMODE;
+	/* write command */
+	iowrite32(SATAPHYADDR_PHYCMD_WRITE | reg, priv->base + SATAPHYADDR_REG);
+	/* wait for ack */
+	for (timeout = 0; timeout < 100; timeout++) {
+		val = ioread32(priv->base + SATAPHYACK_REG);
+		if (val & SATAPHYACK_PHYACK)
+			break;
+	}
+	if (timeout >= 100)
+		pr_err("%s timeout\n", __func__);
+	/* idle state */
+	iowrite32(0, priv->base + SATAPHYADDR_REG);
+}
+
+static void sata_rcar_freeze(struct ata_port *ap)
+{
+	struct sata_rcar_priv *priv = ap->host->private_data;
+
+	/* mask */
+	iowrite32(0x7ff, priv->base + SATAINTMASK_REG);
+
+	ata_sff_freeze(ap);
+}
+
+static void sata_rcar_thaw(struct ata_port *ap)
+{
+	struct sata_rcar_priv *priv = ap->host->private_data;
+
+	/* ack */
+	iowrite32(~SATA_RCAR_INT_MASK, priv->base + SATAINTSTAT_REG);
+
+	ata_sff_thaw(ap);
+
+	/* unmask */
+	iowrite32(0x7ff & ~SATA_RCAR_INT_MASK, priv->base + SATAINTMASK_REG);
+}
+
+static void sata_rcar_ioread16_rep(void __iomem *reg, void *buffer, int count)
+{
+	u16 *ptr = buffer;
+
+	while (count--) {
+		u16 data = ioread32(reg);
+
+		*ptr++ = data;
+	}
+}
+
+static void sata_rcar_iowrite16_rep(void __iomem *reg, void *buffer, int count)
+{
+	const u16 *ptr = buffer;
+
+	while (count--)
+		iowrite32(*ptr++, reg);
+}
+
+static u8 sata_rcar_check_status(struct ata_port *ap)
+{
+	return ioread32(ap->ioaddr.status_addr);
+}
+
+static u8 sata_rcar_check_altstatus(struct ata_port *ap)
+{
+	return ioread32(ap->ioaddr.altstatus_addr);
+}
+
+static void sata_rcar_set_devctl(struct ata_port *ap, u8 ctl)
+{
+	iowrite32(ctl, ap->ioaddr.ctl_addr);
+}
+
+static void sata_rcar_dev_select(struct ata_port *ap, unsigned int device)
+{
+	iowrite32(ATA_DEVICE_OBS, ap->ioaddr.device_addr);
+	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
+}
+
+static unsigned int sata_rcar_ata_devchk(struct ata_port *ap,
+					 unsigned int device)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	u8 nsect, lbal;
+
+	sata_rcar_dev_select(ap, device);
+
+	iowrite32(0x55, ioaddr->nsect_addr);
+	iowrite32(0xaa, ioaddr->lbal_addr);
+
+	iowrite32(0xaa, ioaddr->nsect_addr);
+	iowrite32(0x55, ioaddr->lbal_addr);
+
+	iowrite32(0x55, ioaddr->nsect_addr);
+	iowrite32(0xaa, ioaddr->lbal_addr);
+
+	nsect = ioread32(ioaddr->nsect_addr);
+	lbal  = ioread32(ioaddr->lbal_addr);
+
+	if (nsect == 0x55 && lbal == 0xaa)
+		return 1;	/* found a device */
+
+	return 0;		/* nothing found */
+}
+
+static int sata_rcar_wait_after_reset(struct ata_link *link,
+				      unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+
+	ata_msleep(ap, ATA_WAIT_AFTER_RESET);
+
+	return ata_sff_wait_ready(link, deadline);
+}
+
+static int sata_rcar_bus_softreset(struct ata_port *ap, unsigned long deadline)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
+
+	/* software reset.  causes dev0 to be selected */
+	iowrite32(ap->ctl, ioaddr->ctl_addr);
+	udelay(20);
+	iowrite32(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
+	udelay(20);
+	iowrite32(ap->ctl, ioaddr->ctl_addr);
+	ap->last_ctl = ap->ctl;
+
+	/* wait the port to become ready */
+	return sata_rcar_wait_after_reset(&ap->link, deadline);
+}
+
+static int sata_rcar_softreset(struct ata_link *link, unsigned int *classes,
+			       unsigned long deadline)
+{
+	struct ata_port *ap = link->ap;
+	unsigned int devmask = 0;
+	int rc;
+	u8 err;
+
+	/* determine if device 0 is present */
+	if (sata_rcar_ata_devchk(ap, 0))
+		devmask |= 1 << 0;
+
+	/* issue bus reset */
+	DPRINTK("about to softreset, devmask=%x\n", devmask);
+	rc = sata_rcar_bus_softreset(ap, deadline);
+	/* if link is occupied, -ENODEV too is an error */
+	if (rc && (rc != -ENODEV || sata_scr_valid(link))) {
+		ata_link_err(link, "SRST failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* determine by signature whether we have ATA or ATAPI devices */
+	classes[0] = ata_sff_dev_classify(&link->device[0], devmask, &err);
+
+	DPRINTK("classes[0]=%u\n", classes[0]);
+	return 0;
+}
+
+static void sata_rcar_tf_load(struct ata_port *ap,
+			      const struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	unsigned int is_addr = tf->flags & ATA_TFLAG_ISADDR;
+
+	if (tf->ctl != ap->last_ctl) {
+		iowrite32(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+		ata_wait_idle(ap);
+	}
+
+	if (is_addr && (tf->flags & ATA_TFLAG_LBA48)) {
+		iowrite32(tf->hob_feature, ioaddr->feature_addr);
+		iowrite32(tf->hob_nsect, ioaddr->nsect_addr);
+		iowrite32(tf->hob_lbal, ioaddr->lbal_addr);
+		iowrite32(tf->hob_lbam, ioaddr->lbam_addr);
+		iowrite32(tf->hob_lbah, ioaddr->lbah_addr);
+		VPRINTK("hob: feat 0x%X nsect 0x%X, lba 0x%X 0x%X 0x%X\n",
+			tf->hob_feature,
+			tf->hob_nsect,
+			tf->hob_lbal,
+			tf->hob_lbam,
+			tf->hob_lbah);
+	}
+
+	if (is_addr) {
+		iowrite32(tf->feature, ioaddr->feature_addr);
+		iowrite32(tf->nsect, ioaddr->nsect_addr);
+		iowrite32(tf->lbal, ioaddr->lbal_addr);
+		iowrite32(tf->lbam, ioaddr->lbam_addr);
+		iowrite32(tf->lbah, ioaddr->lbah_addr);
+		VPRINTK("feat 0x%X nsect 0x%X lba 0x%X 0x%X 0x%X\n",
+			tf->feature,
+			tf->nsect,
+			tf->lbal,
+			tf->lbam,
+			tf->lbah);
+	}
+
+	if (tf->flags & ATA_TFLAG_DEVICE) {
+		iowrite32(tf->device, ioaddr->device_addr);
+		VPRINTK("device 0x%X\n", tf->device);
+	}
+
+	ata_wait_idle(ap);
+}
+
+static void sata_rcar_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
+{
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+
+	tf->command = sata_rcar_check_status(ap);
+	tf->feature = ioread32(ioaddr->error_addr);
+	tf->nsect = ioread32(ioaddr->nsect_addr);
+	tf->lbal = ioread32(ioaddr->lbal_addr);
+	tf->lbam = ioread32(ioaddr->lbam_addr);
+	tf->lbah = ioread32(ioaddr->lbah_addr);
+	tf->device = ioread32(ioaddr->device_addr);
+
+	if (tf->flags & ATA_TFLAG_LBA48) {
+		iowrite32(tf->ctl | ATA_HOB, ioaddr->ctl_addr);
+		tf->hob_feature = ioread32(ioaddr->error_addr);
+		tf->hob_nsect = ioread32(ioaddr->nsect_addr);
+		tf->hob_lbal = ioread32(ioaddr->lbal_addr);
+		tf->hob_lbam = ioread32(ioaddr->lbam_addr);
+		tf->hob_lbah = ioread32(ioaddr->lbah_addr);
+		iowrite32(tf->ctl, ioaddr->ctl_addr);
+		ap->last_ctl = tf->ctl;
+	}
+}
+
+static void sata_rcar_exec_command(struct ata_port *ap,
+				   const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+
+	iowrite32(tf->command, ap->ioaddr.command_addr);
+	ata_sff_pause(ap);
+}
+
+static unsigned int sata_rcar_data_xfer(struct ata_device *dev,
+					      unsigned char *buf,
+					      unsigned int buflen, int rw)
+{
+	struct ata_port *ap = dev->link->ap;
+	void __iomem *data_addr = ap->ioaddr.data_addr;
+	unsigned int words = buflen >> 1;
+
+	/* Transfer multiple of 2 bytes */
+	if (rw == READ)
+		sata_rcar_ioread16_rep(data_addr, buf, words);
+	else
+		sata_rcar_iowrite16_rep(data_addr, buf, words);
+
+	/* Transfer trailing byte, if any. */
+	if (unlikely(buflen & 0x01)) {
+		unsigned char pad[2] = { };
+
+		/* Point buf to the tail of buffer */
+		buf += buflen - 1;
+
+		/*
+		 * Use io*16_rep() accessors here as well to avoid pointlessly
+		 * swapping bytes to and from on the big endian machines...
+		 */
+		if (rw == READ) {
+			sata_rcar_ioread16_rep(data_addr, pad, 1);
+			*buf = pad[0];
+		} else {
+			pad[0] = *buf;
+			sata_rcar_iowrite16_rep(data_addr, pad, 1);
+		}
+		words++;
+	}
+
+	return words << 1;
+}
+
+static void sata_rcar_drain_fifo(struct ata_queued_cmd *qc)
+{
+	int count;
+	struct ata_port *ap;
+
+	/* We only need to flush incoming data when a command was running */
+	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
+		return;
+
+	ap = qc->ap;
+	/* Drain up to 64K of data before we give up this recovery method */
+	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ) &&
+			count < 65536; count += 2)
+		ioread32(ap->ioaddr.data_addr);
+
+	/* Can become DEBUG later */
+	if (count)
+		ata_port_dbg(ap, "drained %d bytes to clear DRQ\n", count);
+}
+
+static int sata_rcar_scr_read(struct ata_link *link, unsigned int sc_reg,
+			      u32 *val)
+{
+	if (sc_reg > SCR_ACTIVE)
+		return -EINVAL;
+
+	*val = ioread32(link->ap->ioaddr.scr_addr + (sc_reg << 2));
+	return 0;
+}
+
+static int sata_rcar_scr_write(struct ata_link *link, unsigned int sc_reg,
+			       u32 val)
+{
+	if (sc_reg > SCR_ACTIVE)
+		return -EINVAL;
+
+	iowrite32(val, link->ap->ioaddr.scr_addr + (sc_reg << 2));
+	return 0;
+}
+
+static void sata_rcar_bmdma_fill_sg(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_bmdma_prd *prd = ap->bmdma_prd;
+	struct scatterlist *sg;
+	unsigned int si, pi;
+
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		u32 addr, sg_len, len;
+
+		/*
+		 * Note: h/w doesn't support 64-bit, so we unconditionally
+		 * truncate dma_addr_t to u32.
+		 */
+		addr = (u32)sg_dma_address(sg);
+		sg_len = sg_dma_len(sg);
+
+		/* H/w transfer count is only 29 bits long, let's be careful */
+		while (sg_len) {
+			len = sg_len;
+			if (len > 0x1ffffffe)
+				len = 0x1ffffffe;
+
+			prd[pi].addr = cpu_to_le32(addr);
+			prd[pi].flags_len = cpu_to_le32(len);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
+
+			pi++;
+			sg_len -= len;
+			addr += len;
+		}
+	}
+
+	/* end-of-table flag */
+	prd[pi - 1].addr |= cpu_to_le32(SATA_RCAR_DTEND);
+}
+
+static void sata_rcar_qc_prep(struct ata_queued_cmd *qc)
+{
+	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
+		return;
+
+	sata_rcar_bmdma_fill_sg(qc);
+}
+
+static void sata_rcar_bmdma_setup(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	unsigned int rw = qc->tf.flags & ATA_TFLAG_WRITE;
+	u32 dmactl;
+	struct sata_rcar_priv *priv = ap->host->private_data;
+
+	/* load PRD table addr. */
+	mb();   /* make sure PRD table writes are visible to controller */
+	iowrite32(ap->bmdma_prd_dma, priv->base + ATAPI_DTB_ADR_REG);
+
+	/* specify data direction, triple-check start bit is clear */
+	dmactl = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	dmactl &= ~(ATAPI_CONTROL1_RW | ATAPI_CONTROL1_STOP);
+	if (dmactl & ATAPI_CONTROL1_START) {
+		dmactl &= ~ATAPI_CONTROL1_START;
+		dmactl |= ATAPI_CONTROL1_STOP;
+	}
+	if (!rw)
+		dmactl |= ATAPI_CONTROL1_RW;
+	iowrite32(dmactl, priv->base + ATAPI_CONTROL1_REG);
+
+	/* issue r/w command */
+	ap->ops->sff_exec_command(ap, &qc->tf);
+}
+
+static void sata_rcar_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	u32 dmactl;
+	struct sata_rcar_priv *priv = ap->host->private_data;
+
+	/* start host DMA transaction */
+	dmactl = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	dmactl |= ATAPI_CONTROL1_START;
+	iowrite32(dmactl, priv->base + ATAPI_CONTROL1_REG);
+}
+
+static void sata_rcar_bmdma_stop(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct sata_rcar_priv *priv = ap->host->private_data;
+	u32 dmactl;
+
+	/* force termination of DMA transfer if active */
+	dmactl = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	if (dmactl & ATAPI_CONTROL1_START) {
+		dmactl &= ~ATAPI_CONTROL1_START;
+		dmactl |= ATAPI_CONTROL1_STOP;
+		iowrite32(dmactl, priv->base + ATAPI_CONTROL1_REG);
+	}
+
+	/* one-PIO-cycle guaranteed wait, per spec, for HDMA1:0 transition */
+	ata_sff_dma_pause(ap);
+}
+
+static u8 sata_rcar_bmdma_status(struct ata_port *ap)
+{
+	struct sata_rcar_priv *priv = ap->host->private_data;
+	u32 status;
+	u8 host_stat = 0;
+
+	status = ioread32(priv->base + ATAPI_STATUS_REG);
+	if (status & ATAPI_STATUS_DEVINT)
+		host_stat |= ATA_DMA_INTR;
+	if (status & ATAPI_STATUS_ACT)
+		host_stat |= ATA_DMA_ACTIVE;
+
+	return host_stat;
+}
+
+static struct scsi_host_template sata_rcar_sht = {
+	ATA_BMDMA_SHT(DRV_NAME),
+};
+
+static struct ata_port_operations sata_rcar_port_ops = {
+	.inherits		= &ata_bmdma_port_ops,
+
+	.freeze			= sata_rcar_freeze,
+	.thaw			= sata_rcar_thaw,
+	.softreset		= sata_rcar_softreset,
+
+	.scr_read		= sata_rcar_scr_read,
+	.scr_write		= sata_rcar_scr_write,
+
+	.sff_dev_select		= sata_rcar_dev_select,
+	.sff_set_devctl		= sata_rcar_set_devctl,
+	.sff_check_status	= sata_rcar_check_status,
+	.sff_check_altstatus	= sata_rcar_check_altstatus,
+	.sff_tf_load		= sata_rcar_tf_load,
+	.sff_tf_read		= sata_rcar_tf_read,
+	.sff_exec_command	= sata_rcar_exec_command,
+	.sff_data_xfer		= sata_rcar_data_xfer,
+	.sff_drain_fifo		= sata_rcar_drain_fifo,
+
+	.qc_prep		= sata_rcar_qc_prep,
+
+	.bmdma_setup		= sata_rcar_bmdma_setup,
+	.bmdma_start		= sata_rcar_bmdma_start,
+	.bmdma_stop		= sata_rcar_bmdma_stop,
+	.bmdma_status		= sata_rcar_bmdma_status,
+};
+
+static int sata_rcar_serr_interrupt(struct ata_port *ap)
+{
+	struct sata_rcar_priv *priv = ap->host->private_data;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
+	int freeze = 0;
+	int handled = 0;
+	u32 serror;
+
+	serror = ioread32(priv->base + SCRSERR_REG);
+	if (!serror)
+		return 0;
+
+	DPRINTK("SError @host_intr: 0x%x\n", serror);
+
+	/* first, analyze and record host port events */
+	ata_ehi_clear_desc(ehi);
+
+	if (serror & (SERR_DEV_XCHG | SERR_PHYRDY_CHG)) {
+		/* Setup a soft-reset EH action */
+		ata_ehi_hotplugged(ehi);
+		ata_ehi_push_desc(ehi, "%s", "hotplug");
+
+		freeze = serror & SERR_COMM_WAKE ? 0 : 1;
+		handled = 1;
+	}
+
+	/* freeze or abort */
+	if (freeze)
+		ata_port_freeze(ap);
+	else
+		ata_port_abort(ap);
+
+	return handled;
+}
+
+static int sata_rcar_ata_interrupt(struct ata_port *ap)
+{
+	struct ata_queued_cmd *qc;
+	int handled = 0;
+
+	qc = ata_qc_from_tag(ap, ap->link.active_tag);
+	if (qc)
+		handled |= ata_bmdma_port_intr(ap, qc);
+
+	return handled;
+}
+
+static irqreturn_t sata_rcar_interrupt(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct sata_rcar_priv *priv = host->private_data;
+	struct ata_port *ap;
+	unsigned int handled = 0;
+	u32 sataintstat;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+
+	sataintstat = ioread32(priv->base + SATAINTSTAT_REG);
+	if (!sataintstat)
+		goto done;
+	/* ack */
+	iowrite32(sataintstat & ~SATA_RCAR_INT_MASK,
+		 priv->base + SATAINTSTAT_REG);
+
+	ap = host->ports[0];
+
+	if (sataintstat & SATAINTSTAT_ATA)
+		handled |= sata_rcar_ata_interrupt(ap);
+
+	if (sataintstat & SATAINTSTAT_SERR)
+		handled |= sata_rcar_serr_interrupt(ap);
+
+done:
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	return IRQ_RETVAL(handled);
+}
+
+static void sata_rcar_setup_port(struct ata_host *host)
+{
+	struct ata_port *ap = host->ports[0];
+	struct ata_ioports *ioaddr = &ap->ioaddr;
+	struct sata_rcar_priv *priv = host->private_data;
+
+	ap->ops		= &sata_rcar_port_ops;
+	ap->pio_mask	= ATA_PIO4;
+	ap->udma_mask	= ATA_UDMA6;
+	ap->flags	|= ATA_FLAG_SATA;
+
+	ioaddr->cmd_addr = priv->base + SDATA_REG;
+	ioaddr->ctl_addr = priv->base + SSDEVCON_REG;
+	ioaddr->scr_addr = priv->base + SCRSSTS_REG;
+	ioaddr->altstatus_addr = ioaddr->ctl_addr;
+
+	ioaddr->data_addr	= ioaddr->cmd_addr + (ATA_REG_DATA << 2);
+	ioaddr->error_addr	= ioaddr->cmd_addr + (ATA_REG_ERR << 2);
+	ioaddr->feature_addr	= ioaddr->cmd_addr + (ATA_REG_FEATURE << 2);
+	ioaddr->nsect_addr	= ioaddr->cmd_addr + (ATA_REG_NSECT << 2);
+	ioaddr->lbal_addr	= ioaddr->cmd_addr + (ATA_REG_LBAL << 2);
+	ioaddr->lbam_addr	= ioaddr->cmd_addr + (ATA_REG_LBAM << 2);
+	ioaddr->lbah_addr	= ioaddr->cmd_addr + (ATA_REG_LBAH << 2);
+	ioaddr->device_addr	= ioaddr->cmd_addr + (ATA_REG_DEVICE << 2);
+	ioaddr->status_addr	= ioaddr->cmd_addr + (ATA_REG_STATUS << 2);
+	ioaddr->command_addr	= ioaddr->cmd_addr + (ATA_REG_CMD << 2);
+}
+
+static void sata_rcar_init_controller(struct ata_host *host)
+{
+	struct sata_rcar_priv *priv = host->private_data;
+	u32 val;
+
+	/* reset and setup phy */
+	sata_rcar_phy_initialize(priv);
+	sata_rcar_phy_write(priv, SATAPCTLR1_REG, 0x00200188, 0);
+	sata_rcar_phy_write(priv, SATAPCTLR1_REG, 0x00200188, 1);
+	sata_rcar_phy_write(priv, SATAPCTLR3_REG, 0x0000A061, 0);
+	sata_rcar_phy_write(priv, SATAPCTLR2_REG, 0x20000000, 0);
+	sata_rcar_phy_write(priv, SATAPCTLR2_REG, 0x20000000, 1);
+	sata_rcar_phy_write(priv, SATAPCTLR4_REG, 0x28E80000, 0);
+
+	/* SATA-IP reset state */
+	val = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	val |= ATAPI_CONTROL1_RESET;
+	iowrite32(val, priv->base + ATAPI_CONTROL1_REG);
+
+	/* ISM mode, PRD mode, DTEND flag at bit 0 */
+	val = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	val |= ATAPI_CONTROL1_ISM;
+	val |= ATAPI_CONTROL1_DESE;
+	val |= ATAPI_CONTROL1_DTA32M;
+	iowrite32(val, priv->base + ATAPI_CONTROL1_REG);
+
+	/* Release the SATA-IP from the reset state */
+	val = ioread32(priv->base + ATAPI_CONTROL1_REG);
+	val &= ~ATAPI_CONTROL1_RESET;
+	iowrite32(val, priv->base + ATAPI_CONTROL1_REG);
+
+	/* ack and mask */
+	iowrite32(0, priv->base + SATAINTSTAT_REG);
+	iowrite32(0x7ff, priv->base + SATAINTMASK_REG);
+	/* enable interrupts */
+	iowrite32(ATAPI_INT_ENABLE_SATAINT, priv->base + ATAPI_INT_ENABLE_REG);
+}
+
+static int sata_rcar_probe(struct platform_device *pdev)
+{
+	struct ata_host *host;
+	struct sata_rcar_priv *priv;
+	struct resource *mem;
+	int irq;
+	int ret = 0;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (mem == NULL)
+		return -EINVAL;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0)
+		return -EINVAL;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct sata_rcar_priv),
+			   GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(priv->clk)) {
+		dev_err(&pdev->dev, "failed to get access to sata clock\n");
+		return PTR_ERR(priv->clk);
+	}
+	clk_enable(priv->clk);
+
+	host = ata_host_alloc(&pdev->dev, 1);
+	if (!host) {
+		dev_err(&pdev->dev, "ata_host_alloc failed\n");
+		ret = -ENOMEM;
+		goto cleanup;
+	}
+
+	host->private_data = priv;
+
+	priv->base = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!priv->base) {
+		ret = -EADDRNOTAVAIL;
+		goto cleanup;
+	}
+
+	/* setup port */
+	sata_rcar_setup_port(host);
+
+	/* initialize host controller */
+	sata_rcar_init_controller(host);
+
+	ret = ata_host_activate(host, irq, sata_rcar_interrupt, 0,
+				&sata_rcar_sht);
+	if (!ret)
+		return 0;
+
+cleanup:
+	clk_disable(priv->clk);
+
+	return ret;
+}
+
+static int sata_rcar_remove(struct platform_device *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	struct sata_rcar_priv *priv = host->private_data;
+
+	ata_host_detach(host);
+
+	/* disable interrupts */
+	iowrite32(0, priv->base + ATAPI_INT_ENABLE_REG);
+	/* ack and mask */
+	iowrite32(0, priv->base + SATAINTSTAT_REG);
+	iowrite32(0x7ff, priv->base + SATAINTMASK_REG);
+
+	clk_disable(priv->clk);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int sata_rcar_suspend(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct sata_rcar_priv *priv = host->private_data;
+	int ret;
+
+	ret = ata_host_suspend(host, PMSG_SUSPEND);
+	if (!ret) {
+		/* disable interrupts */
+		iowrite32(0, priv->base + ATAPI_INT_ENABLE_REG);
+		/* mask */
+		iowrite32(0x7ff, priv->base + SATAINTMASK_REG);
+
+		clk_disable(priv->clk);
+	}
+
+	return ret;
+}
+
+static int sata_rcar_resume(struct device *dev)
+{
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct sata_rcar_priv *priv = host->private_data;
+
+	clk_enable(priv->clk);
+
+	/* ack and mask */
+	iowrite32(0, priv->base + SATAINTSTAT_REG);
+	iowrite32(0x7ff, priv->base + SATAINTMASK_REG);
+	/* enable interrupts */
+	iowrite32(ATAPI_INT_ENABLE_SATAINT, priv->base + ATAPI_INT_ENABLE_REG);
+
+	ata_host_resume(host);
+
+	return 0;
+}
+
+static const struct dev_pm_ops sata_rcar_pm_ops = {
+	.suspend	= sata_rcar_suspend,
+	.resume		= sata_rcar_resume,
+};
+#endif
+
+static struct of_device_id sata_rcar_match[] = {
+	{ .compatible = "renesas,rcar-sata", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, sata_rcar_match);
+
+static struct platform_driver sata_rcar_driver = {
+	.probe		= sata_rcar_probe,
+	.remove		= sata_rcar_remove,
+	.driver = {
+		.name		= DRV_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= sata_rcar_match,
+#ifdef CONFIG_PM
+		.pm		= &sata_rcar_pm_ops,
+#endif
+	},
+};
+
+module_platform_driver(sata_rcar_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vladimir Barinov");
+MODULE_DESCRIPTION("Renesas R-Car SATA controller low level driver");
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f1bf5af..765398c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2617,3 +2617,17 @@ void scsi_kunmap_atomic_sg(void *virt)
 	kunmap_atomic(virt);
 }
 EXPORT_SYMBOL(scsi_kunmap_atomic_sg);
+
+void sdev_disable_disk_events(struct scsi_device *sdev)
+{
+	atomic_inc(&sdev->disk_events_disable_depth);
+}
+EXPORT_SYMBOL(sdev_disable_disk_events);
+
+void sdev_enable_disk_events(struct scsi_device *sdev)
+{
+	if (WARN_ON_ONCE(atomic_read(&sdev->disk_events_disable_depth) <= 0))
+		return;
+	atomic_dec(&sdev->disk_events_disable_depth);
+}
+EXPORT_SYMBOL(sdev_enable_disk_events);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5fc97d2..f2884ee 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -45,6 +45,7 @@
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -79,6 +80,11 @@ static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
+static int sr_runtime_suspend(struct device *dev);
+
+static struct dev_pm_ops sr_pm_ops = {
+	.runtime_suspend	= sr_runtime_suspend,
+};
 
 static struct scsi_driver sr_template = {
 	.owner			= THIS_MODULE,
@@ -86,6 +92,7 @@ static struct scsi_driver sr_template = {
 		.name   	= "sr",
 		.probe		= sr_probe,
 		.remove		= sr_remove,
+		.pm		= &sr_pm_ops,
 	},
 	.done			= sr_done,
 };
@@ -131,6 +138,16 @@ static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
 	return container_of(disk->private_data, struct scsi_cd, driver);
 }
 
+static int sr_runtime_suspend(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+
+	if (cd->media_present)
+		return -EBUSY;
+	else
+		return 0;
+}
+
 /*
  * The get and put routines for the struct scsi_cd.  Note this entity
  * has a scsi_device pointer and owns a reference to this.
@@ -146,7 +163,8 @@ static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 	kref_get(&cd->kref);
 	if (scsi_device_get(cd->device))
 		goto out_put;
-	goto out;
+	if (!scsi_autopm_get_device(cd->device))
+		goto out;
 
  out_put:
 	kref_put(&cd->kref, sr_kref_release);
@@ -162,6 +180,7 @@ static void scsi_cd_put(struct scsi_cd *cd)
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
+	scsi_autopm_put_device(sdev);
 	scsi_device_put(sdev);
 	mutex_unlock(&sr_ref_mutex);
 }
@@ -540,6 +559,8 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
+	scsi_autopm_get_device(cd->device);
+
 	mutex_lock(&sr_mutex);
 
 	/*
@@ -571,6 +592,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 out:
 	mutex_unlock(&sr_mutex);
+	scsi_autopm_put_device(cd->device);
 	return ret;
 }
 
@@ -578,7 +600,17 @@ static unsigned int sr_block_check_events(struct gendisk *disk,
 					  unsigned int clearing)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	return cdrom_check_events(&cd->cdi, clearing);
+	unsigned int ret;
+
+	if (atomic_read(&cd->device->disk_events_disable_depth) == 0) {
+		scsi_autopm_get_device(cd->device);
+		ret = cdrom_check_events(&cd->cdi, clearing);
+		scsi_autopm_put_device(cd->device);
+	} else {
+		ret = 0;
+	}
+
+	return ret;
 }
 
 static int sr_block_revalidate_disk(struct gendisk *disk)
@@ -586,12 +618,16 @@ static int sr_block_revalidate_disk(struct gendisk *disk)
 	struct scsi_cd *cd = scsi_cd(disk);
 	struct scsi_sense_hdr sshdr;
 
+	scsi_autopm_get_device(cd->device);
+
 	/* if the unit is not ready, nothing more to do */
 	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
-		return 0;
+		goto out;
 
 	sr_cd_check(&cd->cdi);
 	get_sectorsize(cd);
+out:
+	scsi_autopm_put_device(cd->device);
 	return 0;
 }
 
@@ -718,6 +754,8 @@ static int sr_probe(struct device *dev)
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
+	scsi_autopm_put_device(cd->device);
+
 	return 0;
 
 fail_put:
@@ -965,6 +1003,8 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	scsi_autopm_get_device(cd->device);
+
 	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 408da95..8f7a3d6 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -297,10 +297,12 @@ enum {
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_SATA_ID_DEV_DATA  = 0x30,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
-	ATA_LOG_DEVSLP_MDAT	  = 0x30,
+	ATA_LOG_DEVSLP_OFFSET	  = 0x30,
+	ATA_LOG_DEVSLP_SIZE	  = 0x08,
+	ATA_LOG_DEVSLP_MDAT	  = 0x00,
 	ATA_LOG_DEVSLP_MDAT_MASK  = 0x1F,
-	ATA_LOG_DEVSLP_DETO	  = 0x31,
-	ATA_LOG_DEVSLP_VALID	  = 0x37,
+	ATA_LOG_DEVSLP_DETO	  = 0x01,
+	ATA_LOG_DEVSLP_VALID	  = 0x07,
 	ATA_LOG_DEVSLP_VALID_MASK = 0x80,
 
 	/* READ/WRITE LONG (obsolete) */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 83ba0ab..91c9d10 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -620,6 +620,9 @@ struct ata_device {
 	union acpi_object	*gtf_cache;
 	unsigned int		gtf_filter;
 #endif
+#ifdef CONFIG_SATA_ZPODD
+	void			*zpodd;
+#endif
 	struct device		tdev;
 	/* n_sector is CLEAR_BEGIN, read comment above CLEAR_BEGIN */
 	u64			n_sectors;	/* size of device, if ATA */
@@ -652,8 +655,8 @@ struct ata_device {
 		u32		gscr[SATA_PMP_GSCR_DWORDS]; /* PMP GSCR block */
 	};
 
-	/* Identify Device Data Log (30h), SATA Settings (page 08h) */
-	u8			sata_settings[ATA_SECT_SIZE];
+	/* DEVSLP Timing Variables from Identify Device Data Log */
+	u8			devslp_timing[ATA_LOG_DEVSLP_SIZE];
 
 	/* error history */
 	int			spdn_cnt;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..a7f9cba 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,10 +157,11 @@ struct scsi_device {
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
-	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
+	atomic_t disk_events_disable_depth; /* disable depth for disk events */
+
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
@@ -397,6 +398,8 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
+extern void sdev_disable_disk_events(struct scsi_device *sdev);
+extern void sdev_enable_disk_events(struct scsi_device *sdev);
 
 #ifdef CONFIG_PM_RUNTIME
 extern int scsi_autopm_get_device(struct scsi_device *);
diff --git a/include/uapi/linux/cdrom.h b/include/uapi/linux/cdrom.h
index 898b866..bd17ad5 100644
--- a/include/uapi/linux/cdrom.h
+++ b/include/uapi/linux/cdrom.h
@@ -908,5 +908,39 @@ struct mode_page_header {
 	__be16 desc_length;
 };
 
+/* removable medium feature descriptor */
+struct rm_feature_desc {
+	__be16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1:2;
+	__u8 feature_version:4;
+	__u8 persistent:1;
+	__u8 curr:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr:1;
+	__u8 persistent:1;
+	__u8 feature_version:4;
+	__u8 reserved1:2;
+#endif
+	__u8 add_len;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 mech_type:3;
+	__u8 load:1;
+	__u8 eject:1;
+	__u8 pvnt_jmpr:1;
+	__u8 dbml:1;
+	__u8 lock:1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 lock:1;
+	__u8 dbml:1;
+	__u8 pvnt_jmpr:1;
+	__u8 eject:1;
+	__u8 load:1;
+	__u8 mech_type:3;
+#endif
+	__u8 reserved2;
+	__u8 reserved3;
+	__u8 reserved4;
+};
 
 #endif /* _UAPI_LINUX_CDROM_H */
