Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaIKWYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:24:10 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:32825 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaIKWYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:24:05 -0400
Subject: [PATCH 1/2] PCI: Add pci_ignore_hotplug() to ignore hotplug events
 for a device
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: SpacemanSpiff <a818958@trbvm.com>, Rajat Jain <rajatxjain@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Pali =?utf-8?b?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        "Jose P." <lbdkmjdf@sharklasers.com>
Date: Thu, 11 Sep 2014 16:24:02 -0600
Message-ID: <20140911222402.16809.94145.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powering off a hot-pluggable device, e.g., with pci_set_power_state(D3cold),
normally generates a hot-remove event that unbinds the driver.

Some drivers expect to remain bound to a device even while they power it
off and back on again.  This can be dangerous, because if the device is
removed or replaced while it is powered off, the driver doesn't know that
anything changed.  But some drivers accept that risk.

Add pci_ignore_hotplug() for use by drivers that know their device cannot
be removed.  Using pci_ignore_hotplug() tells the PCI core that hot-plug
events for the device should be ignored.

The radeon and nouveau drivers use this to switch between a low-power,
integrated GPU and a higher-power, higher-performance discrete GPU.  They
power off the unused GPU, but they want to remain bound to it.

This is a reimplementation of f244d8b623da ("ACPIPHP / radeon / nouveau:
Fix VGA switcheroo problem related to hotplug") but extends it to work with
both acpiphp and pciehp.

This fixes a problem where systems with dual GPUs using the radeon drivers
become unusable, freezing every few seconds (see bugzillas below).  The
resume of the radeon device may also fail, e.g.,

This fixes problems on dual GPU systems where the radeon driver becomes
unusable because of problems while suspending the device, as in bug 79701:

    [drm] radeon: finishing device.
    radeon 0000:01:00.0: Userspace still has active objects !
    radeon 0000:01:00.0: ffff8800cb4ec288 ffff8800cb4ec000 16384 4294967297 force free
    ...
    WARNING: CPU: 0 PID: 67 at /home/apw/COD/linux/drivers/gpu/drm/radeon/radeon_gart.c:234 radeon_gart_unbind+0xd2/0xe0 [radeon]()
    trying to unbind memory from uninitialized GART !

or while resuming it, as in bug 77261:

    radeon 0000:01:00.0: ring 0 stalled for more than 10158msec
    radeon 0000:01:00.0: GPU lockup ...
    radeon 0000:01:00.0: GPU pci config reset
    pciehp 0000:00:01.0:pcie04: Card not present on Slot(1-1)
    radeon 0000:01:00.0: GPU reset succeeded, trying to resume
    *ERROR* radeon: dpm resume failed
    radeon 0000:01:00.0: Wait for MC idle timedout !

Link: https://bugzilla.kernel.org/show_bug.cgi?id=77261
Link: https://bugzilla.kernel.org/show_bug.cgi?id=79701
Reported-by: Shawn Starr <shawn.starr@rogers.com>
Reported-by: Jose P. <lbdkmjdf@sharklasers.com>
Tested-by: SpacemanSpiff <a818958@trbvm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: stable@vger.kernel.org	# v3.15+
---
 drivers/gpu/drm/nouveau/nouveau_drm.c |    1 +
 drivers/gpu/drm/radeon/radeon_drv.c   |    1 +
 drivers/pci/hotplug/acpiphp_glue.c    |   16 ++++++----------
 drivers/pci/hotplug/pciehp_hpc.c      |   12 ++++++++++++
 include/linux/pci.h                   |    6 ++++++
 5 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index 250a5e88c751..9c3af96a7153 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -627,6 +627,7 @@ int nouveau_pmops_suspend(struct device *dev)
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3hot);
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c b/drivers/gpu/drm/radeon/radeon_drv.c
index 8df888908833..abbd87adfd75 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -440,6 +440,7 @@ static int radeon_pmops_runtime_suspend(struct device *dev)
 	ret = radeon_suspend_kms(drm_dev, false, false);
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+	pci_ignore_hotplug(pdev);
 	pci_set_power_state(pdev, PCI_D3cold);
 	drm_dev->switch_power_state = DRM_SWITCH_POWER_DYNAMIC_OFF;
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 70741c8c46a0..6cd5160fc057 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -560,19 +560,15 @@ static void disable_slot(struct acpiphp_slot *slot)
 	slot->flags &= (~SLOT_ENABLED);
 }
 
-static bool acpiphp_no_hotplug(struct acpi_device *adev)
-{
-	return adev && adev->flags.no_hotplug;
-}
-
 static bool slot_no_hotplug(struct acpiphp_slot *slot)
 {
-	struct acpiphp_func *func;
+	struct pci_bus *bus = slot->bus;
+	struct pci_dev *dev;
 
-	list_for_each_entry(func, &slot->funcs, sibling)
-		if (acpiphp_no_hotplug(func_to_acpi_device(func)))
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (PCI_SLOT(dev->devfn) == slot->device && dev->ignore_hotplug)
 			return true;
-
+	}
 	return false;
 }
 
@@ -645,7 +641,7 @@ static void trim_stale_devices(struct pci_dev *dev)
 
 		status = acpi_evaluate_integer(adev->handle, "_STA", NULL, &sta);
 		alive = (ACPI_SUCCESS(status) && device_status_valid(sta))
-			|| acpiphp_no_hotplug(adev);
+			|| dev->ignore_hotplug;
 	}
 	if (!alive)
 		alive = pci_device_is_present(dev);
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 9da84b8b27d8..5e01ae39ec46 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -506,6 +506,8 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 {
 	struct controller *ctrl = (struct controller *)dev_id;
 	struct pci_dev *pdev = ctrl_dev(ctrl);
+	struct pci_bus *subordinate = pdev->subordinate;
+	struct pci_dev *dev;
 	struct slot *slot = ctrl->slot;
 	u16 detected, intr_loc;
 
@@ -539,6 +541,16 @@ static irqreturn_t pcie_isr(int irq, void *dev_id)
 		wake_up(&ctrl->queue);
 	}
 
+	if (subordinate) {
+		list_for_each_entry(dev, &subordinate->devices, bus_list) {
+			if (dev->ignore_hotplug) {
+				ctrl_dbg(ctrl, "ignoring hotplug event %#06x (%s requested no hotplug)\n",
+					 intr_loc, pci_name(dev));
+				return IRQ_HANDLED;
+			}
+		}
+	}
+
 	if (!(intr_loc & ~PCI_EXP_SLTSTA_CC))
 		return IRQ_HANDLED;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 61978a460841..96453f9bc8ba 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -303,6 +303,7 @@ struct pci_dev {
 						   D3cold, not set for devices
 						   powered on/off by the
 						   corresponding bridge */
+	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 
@@ -1021,6 +1022,11 @@ bool pci_dev_run_wake(struct pci_dev *dev);
 bool pci_check_pme_status(struct pci_dev *dev);
 void pci_pme_wakeup_bus(struct pci_bus *bus);
 
+static inline void pci_ignore_hotplug(struct pci_dev *dev)
+{
+	dev->ignore_hotplug = 1;
+}
+
 static inline int pci_enable_wake(struct pci_dev *dev, pci_power_t state,
 				  bool enable)
 {

