Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3IFNgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:36:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36746 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab3IFNgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:36:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 2/2] ACPI / hotplug / PCI: Use _OST to notify firmware about notify status
Date: Fri, 06 Sep 2013 15:46:07 +0200
Message-ID: <2116332.8hDG0uhn9a@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2228690.GcUDD3xFfP@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <1599165.8kjc3DtEzc@vostro.rjw.lan> <2228690.GcUDD3xFfP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The spec suggests that we should use _OST to inform the platform
of the status of notifications it sends us, for example so that
it doesn't repeate a notification that has been handled already.

For this reason, add _OST evaluation to the ACPIPHP subsystem.

This turns out to help reduce the amount of diagnostic output from
the ACPIPHP subsystem and speed up boot on at least one system that
generates multiple device check notifies for PCIe ports during
boot.

Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -870,6 +870,8 @@ static void hotplug_event_work(struct wo
 	hotplug_event(hp_work->handle, hp_work->type, context);
 
 	acpi_scan_lock_release();
+	acpi_evaluate_hotplug_ost(hp_work->handle, hp_work->type,
+				  ACPI_OST_SC_SUCCESS, NULL);
 	kfree(hp_work); /* allocated in handle_hotplug_event() */
 	put_bridge(context->func.parent);
 }
@@ -885,11 +887,15 @@ static void hotplug_event_work(struct wo
 static void handle_hotplug_event(acpi_handle handle, u32 type, void *data)
 {
 	struct acpiphp_context *context;
+	u32 ost_code = ACPI_OST_SC_SUCCESS;
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 	case ACPI_NOTIFY_DEVICE_CHECK:
+		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
+		ost_code = ACPI_OST_SC_EJECT_IN_PROGRESS;
+		acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
@@ -898,20 +904,21 @@ static void handle_hotplug_event(acpi_ha
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
 		acpi_handle_err(handle, "Device cannot be configured due "
 				"to a frequency mismatch\n");
-		return;
+		goto out;
 
 	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
 		acpi_handle_err(handle, "Device cannot be configured due "
 				"to a bus mode mismatch\n");
-		return;
+		goto out;
 
 	case ACPI_NOTIFY_POWER_FAULT:
 		acpi_handle_err(handle, "Device has suffered a power fault\n");
-		return;
+		goto out;
 
 	default:
 		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
-		return;
+		ost_code = ACPI_OST_SC_UNRECOGNIZED_NOTIFY;
+		goto out;
 	}
 
 	mutex_lock(&acpiphp_context_lock);
@@ -920,8 +927,14 @@ static void handle_hotplug_event(acpi_ha
 		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
 		alloc_acpi_hp_work(handle, type, context, hotplug_event_work);
+		mutex_unlock(&acpiphp_context_lock);
+		return;
 	}
 	mutex_unlock(&acpiphp_context_lock);
+	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+
+ out:
+	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
 /*

