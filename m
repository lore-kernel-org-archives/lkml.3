Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3HFAV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:21:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57236 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab3HFAVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 2/5] ACPI: Create symlinks in acpi_bind_one() under physical_node_lock
Date: Tue, 06 Aug 2013 02:26:46 +0200
Message-ID: <5865465.O2TCJ2dK9V@vostro.rjw.lan>
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

Put the creation of symlinks in acpi_bind_one() under the
physical_node_lock mutex of the given ACPI device objects, because
that is part of the binding operation logically (those links are
already removed under that mutex too).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -177,8 +177,6 @@ int acpi_bind_one(struct device *dev, ac
 	list_add(&physical_node->node, physnode_list);
 	acpi_dev->physical_node_count++;
 
-	mutex_unlock(&acpi_dev->physical_node_lock);
-
 	if (!ACPI_HANDLE(dev))
 		ACPI_HANDLE_SET(dev, acpi_dev->handle);
 
@@ -188,6 +186,8 @@ int acpi_bind_one(struct device *dev, ac
 	retval = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
 		"firmware_node");
 
+	mutex_unlock(&acpi_dev->physical_node_lock);
+
 	if (acpi_dev->wakeup.flags.valid)
 		device_set_wakeup_capable(dev, true);
 

