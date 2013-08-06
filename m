Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3HFAV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:21:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57238 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab3HFAVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/5] ACPI: Reduce acpi_bind_one()/acpi_unbind_one() code duplication
Date: Tue, 06 Aug 2013 02:26:03 +0200
Message-ID: <3953188.BVVap3qZDB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3015032.qfOqgEVZKP@vostro.rjw.lan>
References: <3015032.qfOqgEVZKP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Move some duplicated code from acpi_bind_one() and acpi_unbind_one()
into a separate function and make that function use snprintf()
instead of sprintf() for extra safety.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -108,6 +108,15 @@ acpi_handle acpi_get_child(acpi_handle p
 }
 EXPORT_SYMBOL(acpi_get_child);
 
+static void acpi_bind_physnode_name(char *buf, unsigned int node_id)
+{
+	if (node_id > 0)
+		snprintf(buf, PHYSICAL_NODE_NAME_SIZE,
+			 PHYSICAL_NODE_STRING "%u", node_id);
+	else
+		strcpy(buf, PHYSICAL_NODE_STRING);
+}
+
 int acpi_bind_one(struct device *dev, acpi_handle handle)
 {
 	struct acpi_device *acpi_dev;
@@ -173,11 +182,7 @@ int acpi_bind_one(struct device *dev, ac
 	if (!ACPI_HANDLE(dev))
 		ACPI_HANDLE_SET(dev, acpi_dev->handle);
 
-	if (!physical_node->node_id)
-		strcpy(physical_node_name, PHYSICAL_NODE_STRING);
-	else
-		sprintf(physical_node_name,
-			"physical_node%d", physical_node->node_id);
+	acpi_bind_physnode_name(physical_node_name, node_id);
 	retval = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
 			physical_node_name);
 	retval = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
@@ -231,12 +236,7 @@ int acpi_unbind_one(struct device *dev)
 
 		acpi_dev->physical_node_count--;
 
-		if (!entry->node_id)
-			strcpy(physical_node_name, PHYSICAL_NODE_STRING);
-		else
-			sprintf(physical_node_name,
-				"physical_node%d", entry->node_id);
-
+		acpi_bind_physnode_name(physical_node_name, entry->node_id);
 		sysfs_remove_link(&acpi_dev->dev.kobj, physical_node_name);
 		sysfs_remove_link(&dev->kobj, "firmware_node");
 		ACPI_HANDLE_SET(dev, NULL);

