Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3GIANX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:13:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35118 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab3GIANQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 7/8] ACPI / hotplug / PCI: Pass hotplug context object to event handlers
Date: Tue, 09 Jul 2013 02:21:14 +0200
Message-ID: <2105086.uA3FT4uR04@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify handle_hotplug_event() to pass the entire context object
(instead of its fields individually) to work functions started by it.

This change makes the subsequent consolidation of the event handling
work functions a bit more straightforward.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -984,6 +984,7 @@ void acpiphp_check_host_bridge(acpi_hand
 
 static void _handle_hotplug_event_bridge(struct work_struct *work)
 {
+	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
@@ -995,7 +996,8 @@ static void _handle_hotplug_event_bridge
 	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
-	bridge = (struct acpiphp_bridge *)hp_work->context;
+	context = hp_work->context;
+	bridge = context->bridge;
 
 	acpi_scan_lock_acquire();
 
@@ -1100,18 +1102,18 @@ static void hotplug_event_func(acpi_hand
 
 static void _handle_hotplug_event_func(struct work_struct *work)
 {
+	struct acpiphp_context *context;
 	struct acpi_hp_work *hp_work;
-	struct acpiphp_func *func;
 
 	hp_work = container_of(work, struct acpi_hp_work, work);
-	func = hp_work->context;
+	context = hp_work->context;
 	acpi_scan_lock_acquire();
 
-	hotplug_event_func(hp_work->handle, hp_work->type, func);
+	hotplug_event_func(hp_work->handle, hp_work->type, context->func);
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */
-	put_bridge(func->slot->bridge);
+	put_bridge(context->func->slot->bridge);
 }
 
 /**
@@ -1129,11 +1131,9 @@ static void handle_hotplug_event(acpi_ha
 
 	if (context->bridge) {
 		get_bridge(context->bridge);
-		data = context->bridge;
 		work_func = _handle_hotplug_event_bridge;
 	} else if (context->func) {
 		get_bridge(context->func->slot->bridge);
-		data = context->func;
 		work_func = _handle_hotplug_event_func;
 	} else {
 		return;
@@ -1146,7 +1146,7 @@ static void handle_hotplug_event(acpi_ha
 	 * For now just re-add this work to the kacpi_hotplug_wq so we
 	 * don't deadlock on hotplug actions.
 	 */
-	alloc_acpi_hp_work(handle, type, data, work_func);
+	alloc_acpi_hp_work(handle, type, context, work_func);
 }
 
 /*

