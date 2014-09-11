Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbaIKWYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:24:21 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58935 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaIKWYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:24:13 -0400
Subject: [PATCH 2/2] ACPIPHP / radeon / nouveau: Remove acpi_bus_no_hotplug()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: SpacemanSpiff <a818958@trbvm.com>, Rajat Jain <rajatxjain@gmail.com>,
        Dave Airlie <airlied@linux.ie>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Pali =?utf-8?b?Um9ow6Fy?= <pali.rohar@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>,
        "Jose P." <lbdkmjdf@sharklasers.com>
Date: Thu, 11 Sep 2014 16:24:10 -0600
Message-ID: <20140911222410.16809.69017.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140911222022.16809.57079.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert parts of f244d8b623da ("ACPIPHP / radeon / nouveau: Fix VGA
switcheroo problem related to hotplug").

A previous commit 5493b31f0b55 ("PCI: Add pci_ignore_hotplug() to ignore
hotplug events for a device") added equivalent functionality implemented in
a different way for both acpiphp and pciehp.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/acpi/bus.c                           |   10 ----------
 drivers/gpu/drm/nouveau/nouveau_acpi.c       |   16 ++--------------
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   16 ++--------------
 include/acpi/acpi_bus.h                      |    4 +---
 4 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 8581f5b84f48..8b67bd0f6bb5 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -177,16 +177,6 @@ void acpi_bus_detach_private_data(acpi_handle handle)
 }
 EXPORT_SYMBOL_GPL(acpi_bus_detach_private_data);
 
-void acpi_bus_no_hotplug(acpi_handle handle)
-{
-	struct acpi_device *adev = NULL;
-
-	acpi_bus_get_device(handle, &adev);
-	if (adev)
-		adev->flags.no_hotplug = true;
-}
-EXPORT_SYMBOL_GPL(acpi_bus_no_hotplug);
-
 static void acpi_print_osc_error(acpi_handle handle,
 	struct acpi_osc_context *context, char *error)
 {
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 279206997e5c..622424692b3b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -46,7 +46,6 @@ static struct nouveau_dsm_priv {
 	bool dsm_detected;
 	bool optimus_detected;
 	acpi_handle dhandle;
-	acpi_handle other_handle;
 	acpi_handle rom_handle;
 } nouveau_dsm_priv;
 
@@ -222,10 +221,9 @@ static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
 	if (!dhandle)
 		return false;
 
-	if (!acpi_has_method(dhandle, "_DSM")) {
-		nouveau_dsm_priv.other_handle = dhandle;
+	if (!acpi_has_method(dhandle, "_DSM"))
 		return false;
-	}
+
 	if (acpi_check_dsm(dhandle, nouveau_dsm_muid, 0x00000102,
 			   1 << NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;
@@ -301,16 +299,6 @@ static bool nouveau_dsm_detect(void)
 		printk(KERN_INFO "VGA switcheroo: detected DSM switching method %s handle\n",
 			acpi_method_name);
 		nouveau_dsm_priv.dsm_detected = true;
-		/*
-		 * On some systems hotplug events are generated for the device
-		 * being switched off when _DSM is executed.  They cause ACPI
-		 * hotplug to trigger and attempt to remove the device from
-		 * the system, which causes it to break down.  Prevent that from
-		 * happening by setting the no_hotplug flag for the involved
-		 * ACPI device objects.
-		 */
-		acpi_bus_no_hotplug(nouveau_dsm_priv.dhandle);
-		acpi_bus_no_hotplug(nouveau_dsm_priv.other_handle);
 		ret = true;
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index a9fb0d016d38..8bc7d0bbd3c8 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -33,7 +33,6 @@ static struct radeon_atpx_priv {
 	bool atpx_detected;
 	/* handle for device - and atpx */
 	acpi_handle dhandle;
-	acpi_handle other_handle;
 	struct radeon_atpx atpx;
 } radeon_atpx_priv;
 
@@ -453,10 +452,9 @@ static bool radeon_atpx_pci_probe_handle(struct pci_dev *pdev)
 		return false;
 
 	status = acpi_get_handle(dhandle, "ATPX", &atpx_handle);
-	if (ACPI_FAILURE(status)) {
-		radeon_atpx_priv.other_handle = dhandle;
+	if (ACPI_FAILURE(status))
 		return false;
-	}
+
 	radeon_atpx_priv.dhandle = dhandle;
 	radeon_atpx_priv.atpx.handle = atpx_handle;
 	return true;
@@ -540,16 +538,6 @@ static bool radeon_atpx_detect(void)
 		printk(KERN_INFO "VGA switcheroo: detected switching method %s handle\n",
 		       acpi_method_name);
 		radeon_atpx_priv.atpx_detected = true;
-		/*
-		 * On some systems hotplug events are generated for the device
-		 * being switched off when ATPX is executed.  They cause ACPI
-		 * hotplug to trigger and attempt to remove the device from
-		 * the system, which causes it to break down.  Prevent that from
-		 * happening by setting the no_hotplug flag for the involved
-		 * ACPI device objects.
-		 */
-		acpi_bus_no_hotplug(radeon_atpx_priv.dhandle);
-		acpi_bus_no_hotplug(radeon_atpx_priv.other_handle);
 		return true;
 	}
 	return false;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bcfd808b1098..95c506961a13 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -204,10 +204,9 @@ struct acpi_device_flags {
 	u32 match_driver:1;
 	u32 initialized:1;
 	u32 visited:1;
-	u32 no_hotplug:1;
 	u32 hotplug_notify:1;
 	u32 is_dock_station:1;
-	u32 reserved:22;
+	u32 reserved:23;
 };
 
 /* File System */
@@ -412,7 +411,6 @@ void acpi_bus_private_data_handler(acpi_handle, void *);
 int acpi_bus_get_private_data(acpi_handle, void **);
 int acpi_bus_attach_private_data(acpi_handle, void *);
 void acpi_bus_detach_private_data(acpi_handle);
-void acpi_bus_no_hotplug(acpi_handle handle);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);

