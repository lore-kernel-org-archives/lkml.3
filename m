Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3GLABc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:01:32 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39077 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3GKX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 6/30] ACPI / hotplug / PCI: Rework acpiphp_handle_to_bridge()
Date: Fri, 12 Jul 2013 01:44:48 +0200
Message-ID: <2333838.TBMBK0FoVN@vostro.rjw.lan>
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
Subject: 

Using the hotplug context objects introduced previously rework the
ACPI-based PCI hotplug (ACPIPHP) core code to get to acpiphp_bridge
objects associated with hotplug bridges from those context objects
rather than from the global list of hotplug bridges.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -464,18 +464,20 @@ static int detect_ejectable_slots(acpi_h
 
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
 {
-	struct acpiphp_bridge *bridge;
+	struct acpiphp_context *context;
+	struct acpiphp_bridge *bridge = NULL;
 
-	mutex_lock(&bridge_mutex);
-	list_for_each_entry(bridge, &bridge_list, list)
-		if (bridge->handle == handle) {
+	mutex_lock(&acpiphp_context_lock);
+	context = acpiphp_get_context(handle);
+	if (context) {
+		bridge = context->bridge;
+		if (bridge)
 			get_bridge(bridge);
-			mutex_unlock(&bridge_mutex);
-			return bridge;
-		}
-	mutex_unlock(&bridge_mutex);
 
-	return NULL;
+		acpiphp_put_context(context);
+	}
+	mutex_unlock(&acpiphp_context_lock);
+	return bridge;
 }
 
 static void cleanup_bridge(struct acpiphp_bridge *bridge)

