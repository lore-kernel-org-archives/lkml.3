Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195Ab3GQX3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:29:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47883 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab3GQX1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:27:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH 7/30] ACPI / hotplug / PCI: Pass hotplug context objects to event handlers
Date: Thu, 18 Jul 2013 01:19:59 +0200
Message-ID: <12177707.iMaENA9NZf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2366394.4EoP1MXmG2@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan> <2366394.4EoP1MXmG2@vostro.rjw.lan>
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
@@ -989,6 +989,7 @@ void acpiphp_check_host_bridge(acpi_hand
 
 static void _handle_hotplug_event_bridge(struct work_struct *work)
 {
+	struct acpiphp_context *context;
 	struct acpiphp_bridge *bridge;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
@@ -1000,7 +1001,8 @@ static void _handle_hotplug_event_bridge
 	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
-	bridge = (struct acpiphp_bridge *)hp_work->context;
+	context = hp_work->context;
+	bridge = context->bridge;
 
 	acpi_scan_lock_acquire();
 
@@ -1105,18 +1107,18 @@ static void hotplug_event_func(acpi_hand
 
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
@@ -1137,11 +1139,9 @@ static void handle_hotplug_event(acpi_ha
 	if (context) {
 		if (context->bridge) {
 			get_bridge(context->bridge);
-			data = context->bridge;
 			work_func = _handle_hotplug_event_bridge;
 		} else if (context->func) {
 			get_bridge(context->func->slot->bridge);
-			data = context->func;
 			work_func = _handle_hotplug_event_func;
 		}
 		acpiphp_put_context(context);
@@ -1157,7 +1157,7 @@ static void handle_hotplug_event(acpi_ha
 	 * don't deadlock on hotplug actions.
 	 */
 	if (work_func)
-		alloc_acpi_hp_work(handle, type, data, work_func);
+		alloc_acpi_hp_work(handle, type, context, work_func);
 }
 
 /*

