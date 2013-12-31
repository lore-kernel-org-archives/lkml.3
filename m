Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3LaVA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:00:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64392 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756286Ab3LaVAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:00:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Lothian <mike@fireburn.co.uk>, madcatx@atlas.cz,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Takashi Iwai <tiwai@suse.de>,
        =?ISO-8859-1?Q?Joaqu=EDn_Aramend=EDa?= <samsagax@gmail.com>
Subject: [PATCH][update 2] ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug
Date: Tue, 31 Dec 2013 22:14:32 +0100
Message-ID: <15972921.jFQXWrkyOJ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3135179.iXEx1Rk87m@vostro.rjw.lan>
References: <10163453.2AxBLHI1XI@vostro.rjw.lan> <3135179.iXEx1Rk87m@vostro.rjw.lan>
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
Reported-and-tested-by: Joaquín Aramendía <samsagax@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 3.12+ <stable@vger.kernel.org> # 3.12+
---

Hi All,

One more update here.  Because the device the hotplug events are generated for
may be either the one with the "switching" ACPI method (ATPX or _DSM) or the
second one, no_hotplug needs to be set for the both of them.

This version has been retested and appears to work for both the radeon and
nouveau cases.

Thanks and Happy New Year,
Rafael

---
 drivers/acpi/bus.c                           |   10 ++++++++++
 drivers/gpu/drm/nouveau/nouveau_acpi.c       |   16 ++++++++++++++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   16 ++++++++++++++--
 drivers/pci/hotplug/acpiphp_glue.c           |   26 +++++++++++++++++++++++---
 include/acpi/acpi_bus.h                      |    4 +++-
 5 files changed, 64 insertions(+), 8 deletions(-)

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
@@ -530,6 +532,16 @@ static bool radeon_atpx_detect(void)
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",
 		       acpi_method_name);
 		radeon_atpx_priv.atpx_detected = true;
+		/*
+		 * On some systems hotplug events are generated for the device
+		 * being switched off when ATPX is executed.  They cause ACPI
+		 * hotplug to trigger and attempt to remove the device from
+		 * the system, which causes it to break down.  Prevent that from
+		 * happening by setting the no_hotplug flag for the involved
+		 * ACPI device objects.
+		 */
+		acpi_bus_no_hotplug(radeon_atpx_priv.dhandle);
+		acpi_bus_no_hotplug(radeon_atpx_priv.other_handle);
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
 
@@ -338,6 +340,16 @@ static bool nouveau_dsm_detect(void)
 		printk(KERN_INFO "VGA switcheroo: detected DSM switching method %s handle\n",
 			acpi_method_name);
 		nouveau_dsm_priv.dsm_detected = true;
+		/*
+		 * On some systems hotplug events are generated for the device
+		 * being switched off when _DSM is executed.  They cause ACPI
+		 * hotplug to trigger and attempt to remove the device from
+		 * the system, which causes it to break down.  Prevent that from
+		 * happening by setting the no_hotplug flag for the involved
+		 * ACPI device objects.
+		 */
+		acpi_bus_no_hotplug(nouveau_dsm_priv.dhandle);
+		acpi_bus_no_hotplug(nouveau_dsm_priv.other_handle);
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
@@ -344,6 +345,7 @@ extern struct kobject *acpi_kobj;
 extern int acpi_bus_generate_netlink_event(const char*, const char*, u8, int);
 void acpi_bus_private_data_handler(acpi_handle, void *);
 int acpi_bus_get_private_data(acpi_handle, void **);
+void acpi_bus_no_hotplug(acpi_handle handle);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);
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
Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -156,6 +156,16 @@ int acpi_bus_get_private_data(acpi_handl
 }
 EXPORT_SYMBOL(acpi_bus_get_private_data);
 
+void acpi_bus_no_hotplug(acpi_handle handle)
+{
+	struct acpi_device *adev = NULL;
+
+	acpi_bus_get_device(handle, &adev);
+	if (adev)
+		adev->flags.no_hotplug = true;
+}
+EXPORT_SYMBOL_GPL(acpi_bus_no_hotplug);
+
 static void acpi_print_osc_error(acpi_handle handle,
 	struct acpi_osc_context *context, char *error)
 {

