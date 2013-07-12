Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3GLAFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:05:45 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39011 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab3GKX6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 22/30] ACPI / hotplug / PCI: Do not queue up event handling work items in vain
Date: Fri, 12 Jul 2013 02:00:46 +0200
Message-ID: <3148946.a6Eeh6IYXM@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify handle_hotplug_event() to avoid queing up the execution of
handle_hotplug_event_work_fn() as a work item on kacpi_hotplug_wq
for non-hotplug events, such as ACPI_NOTIFY_DEVICE_WAKE.  Move
the code printing diagnostic messages for those events into
handle_hotplug_event().

In addition to that, remove the bogus comment about how the core
should distinguish between hotplug and non-hotplug events and
queue them up on different workqueues.  The core clearly cannot
know in advance what events will be interesting to the given
caller of acpi_install_notify_handler().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   64 ++++++++++++++++---------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -932,36 +932,11 @@ static void hotplug_event(acpi_handle ha
 
 		break;
 
-	case ACPI_NOTIFY_DEVICE_WAKE:
-		/* wake event */
-		dbg("%s: Device wake notify on %s\n", __func__, objname);
-		break;
-
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
 		acpiphp_disable_and_eject_slot(func->slot);
 		break;
-
-	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		printk(KERN_ERR "Device %s cannot be configured due"
-				" to a frequency mismatch\n", objname);
-		break;
-
-	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		printk(KERN_ERR "Device %s cannot be configured due"
-				" to a bus mode mismatch\n", objname);
-		break;
-
-	case ACPI_NOTIFY_POWER_FAULT:
-		printk(KERN_ERR "Device %s has suffered a power fault\n",
-				objname);
-		break;
-
-	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type,
-		     objname);
-		break;
 	}
 
 	if (bridge)
@@ -996,23 +971,42 @@ static void handle_hotplug_event(acpi_ha
 {
 	struct acpiphp_context *context;
 
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+	case ACPI_NOTIFY_DEVICE_CHECK:
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		break;
+
+	case ACPI_NOTIFY_DEVICE_WAKE:
+		return;
+
+	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a frequency mismatch\n");
+		return;
+
+	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
+		acpi_handle_err(handle, "Device cannot be configured due "
+				"to a bus mode mismatch\n");
+		return;
+
+	case ACPI_NOTIFY_POWER_FAULT:
+		acpi_handle_err(handle, "Device has suffered a power fault\n");
+		return;
+
+	default:
+		acpi_handle_warn(handle, "Unsupported event type 0x%x\n", type);
+		return;
+	}
+
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
 	if (context) {
 		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
+		alloc_acpi_hp_work(handle, type, context, hotplug_event_work);
 	}
 	mutex_unlock(&acpiphp_context_lock);
-	/*
-	 * Currently the code adds all hotplug events to the kacpid_wq
-	 * queue when it should add hotplug events to the kacpi_hotplug_wq.
-	 * The proper way to fix this is to reorganize the code so that
-	 * drivers (dock, etc.) do not call acpi_os_execute(), etc.
-	 * For now just re-add this work to the kacpi_hotplug_wq so we
-	 * don't deadlock on hotplug actions.
-	 */
-	if (context)
-		alloc_acpi_hp_work(handle, type, context, hotplug_event_work);
 }
 
 /*

