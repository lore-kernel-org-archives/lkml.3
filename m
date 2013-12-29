Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3L2VX0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 16:23:26 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55286 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752106Ab3L2VXW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 16:23:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Lothian <mike@fireburn.co.uk>, madcatx@atlas.cz,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?Joaqu=EDn_Aramend=EDa?= <samsagax@gmail.com>
Subject: [PATCH][update] ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug events
Date: Sun, 29 Dec 2013 22:36:56 +0100
Message-ID: <3135179.iXEx1Rk87m@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <10163453.2AxBLHI1XI@vostro.rjw.lan>
References: <10163453.2AxBLHI1XI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The changes in the ACPI-based PCI hotplug (ACPIPHP) subsystem made
during the 3.12 development cycle uncovered a problem with VGA
switcheroo that on some systems, when the device-specific method
(ATPX in the radeon case, _DSM in the nouveau case) is used to turn
off the discrete graphics, the BIOS generates ACPI hotplug events for
that device and those events cause ACPIPHP to attempt to remove the
device from the system (they are events for a device that was present
previously and is not present any more, so that's what should be done
according to the spec).  Then, the system stops functioning correctly.

Since the hotplug events in question were simply silently ignored
previously, the least intrusive way to address that problem is to
make ACPIPHP ignore them again.  For this purpose, introduce a new
ACPI device flag, no_hotplug, and modify ACPIPHP to ignore hotplug
events for PCI devices whose ACPI companions have that flag set.
Next, make the radeon and nouveau switcheroo detection code set the
no_hotplug flag for the discrete graphics' ACPI companion.

Fixes: bbd34fcdd1b2 (ACPI / hotplug / PCI: Register all devices under the given bridge)
References: https://bugzilla.kernel.org/show_bug.cgi?id=61891
References: https://bugzilla.kernel.org/show_bug.cgi?id=64891
Reported-and-tested-by: Mike Lothian <mike@fireburn.co.uk>
Reported-and-tested-by: <madcatx@atlas.cz>
Reported-by: Joaquín Aramendía <samsagax@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.12+ <stable@vger.kernel.org> # 3.12+
---

Hi All,

According to recent testing results, the nouveau part is needed to address
that issue on systems with analogous layouts.

Thanks,
Rafael

---
 drivers/gpu/drm/nouveau/nouveau_acpi.c       |   20 ++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   20 ++++++++++++++++++--
 drivers/pci/hotplug/acpiphp_glue.c           |   26 +++++++++++++++++++++++---
 include/acpi/acpi_bus.h                      |    3 ++-
 4 files changed, 61 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -33,6 +33,7 @@ static struct radeon_atpx_priv {
 	bool atpx_detected;
 	/* handle for device - and atpx */
 	acpi_handle dhandle;
+	acpi_handle other_handle;
 	struct radeon_atpx atpx;
 } radeon_atpx_priv;
 
@@ -451,9 +452,10 @@ static bool radeon_atpx_pci_probe_handle
 		return false;
 
 	status = acpi_get_handle(dhandle, "ATPX", &atpx_handle);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		radeon_atpx_priv.other_handle = dhandle;
 		return false;
-
+	}
 	radeon_atpx_priv.dhandle = dhandle;
 	radeon_atpx_priv.atpx.handle = atpx_handle;
 	return true;
@@ -526,10 +528,24 @@ static bool radeon_atpx_detect(void)
 	}
 
 	if (has_atpx && vga_count == 2) {
+		struct acpi_device *adev = NULL;
+
 		acpi_get_name(radeon_atpx_priv.atpx.handle, ACPI_FULL_PATHNAME, &buffer);
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",
 		       acpi_method_name);
 		radeon_atpx_priv.atpx_detected = true;
+		/*
+		 * On some systems hotplug events are generated for the device
+		 * being switched off when ATPX is executed.  They cause ACPI
+		 * hotplug to trigger and attempt to remove the device from
+		 * the system, which causes it to break down.  Prevent that from
+		 * happening by setting the no_hotplug flag for the ACPI device
+		 * object in question.
+		 */
+		acpi_bus_get_device(radeon_atpx_priv.other_handle, &adev);
+		if (adev)
+			adev->flags.no_hotplug = true;
+
 		return true;
 	}
 	return false;
Index: linux-pm/drivers/gpu/drm/nouveau/nouveau_acpi.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ linux-pm/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -51,6 +51,7 @@ static struct nouveau_dsm_priv {
 	bool dsm_detected;
 	bool optimus_detected;
 	acpi_handle dhandle;
+	acpi_handle other_handle;
 	acpi_handle rom_handle;
 } nouveau_dsm_priv;
 
@@ -260,9 +261,10 @@ static int nouveau_dsm_pci_probe(struct
 	if (!dhandle)
 		return false;
 
-	if (!acpi_has_method(dhandle, "_DSM"))
+	if (!acpi_has_method(dhandle, "_DSM")) {
+		nouveau_dsm_priv.other_handle = dhandle;
 		return false;
-
+	}
 	if (nouveau_test_dsm(dhandle, nouveau_dsm, NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;
 
@@ -333,11 +335,25 @@ static bool nouveau_dsm_detect(void)
 		nouveau_dsm_priv.optimus_detected = true;
 		ret = true;
 	} else if (vga_count == 2 && has_dsm && guid_valid) {
+		struct acpi_device *adev = NULL;
+
 		acpi_get_name(nouveau_dsm_priv.dhandle, ACPI_FULL_PATHNAME,
 			&buffer);
 		printk(KERN_INFO "VGA switcheroo: detected DSM switching method %s handle\n",
 			acpi_method_name);
 		nouveau_dsm_priv.dsm_detected = true;
+		/*
+		 * On some systems hotplug events are generated for the device
+		 * being switched off when _DSM is executed.  They cause ACPI
+		 * hotplug to trigger and attempt to remove the device from
+		 * the system, which causes it to break down.  Prevent that from
+		 * happening by setting the no_hotplug flag for the ACPI device
+		 * object in question.
+		 */
+		acpi_bus_get_device(nouveau_dsm_priv.other_handle, &adev);
+		if (adev)
+			adev->flags.no_hotplug = true;
+
 		ret = true;
 	}
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -169,7 +169,8 @@ struct acpi_device_flags {
 	u32 ejectable:1;
 	u32 power_manageable:1;
 	u32 match_driver:1;
-	u32 reserved:27;
+	u32 no_hotplug:1;
+	u32 reserved:26;
 };
 
 /* File System */
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -643,6 +643,24 @@ static void disable_slot(struct acpiphp_
 	slot->flags &= (~SLOT_ENABLED);
 }
 
+static bool acpiphp_no_hotplug(acpi_handle handle)
+{
+	struct acpi_device *adev = NULL;
+
+	acpi_bus_get_device(handle, &adev);
+	return adev && adev->flags.no_hotplug;
+}
+
+static bool slot_no_hotplug(struct acpiphp_slot *slot)
+{
+	struct acpiphp_func *func;
+
+	list_for_each_entry(func, &slot->funcs, sibling)
+		if (acpiphp_no_hotplug(func_to_handle(func)))
+			return true;
+
+	return false;
+}
 
 /**
  * get_slot_status - get ACPI slot status
@@ -701,7 +719,8 @@ static void trim_stale_devices(struct pc
 		unsigned long long sta;
 
 		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-		alive = ACPI_SUCCESS(status) && sta == ACPI_STA_ALL;
+		alive = (ACPI_SUCCESS(status) && sta == ACPI_STA_ALL)
+			|| acpiphp_no_hotplug(handle);
 	}
 	if (!alive) {
 		u32 v;
@@ -741,8 +760,9 @@ static void acpiphp_check_bridge(struct
 		struct pci_dev *dev, *tmp;
 
 		mutex_lock(&slot->crit_sect);
-		/* wake up all functions */
-		if (get_slot_status(slot) == ACPI_STA_ALL) {
+		if (slot_no_hotplug(slot)) {
+			; /* do nothing */
+		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
 			/* remove stale devices if any */
 			list_for_each_entry_safe(dev, tmp, &bus->devices,
 						 bus_list)

