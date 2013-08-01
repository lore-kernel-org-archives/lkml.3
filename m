Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab3HAWXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:23:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51181 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab3HAWXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:23:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] ACPI: Do not fail acpi_bind_one() if device is already bound correctly
Date: Fri, 02 Aug 2013 00:33:42 +0200
Message-ID: <1888947.F5IBMfDKlY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify acpi_bind_one() so that it doesn't fail if the device
represented by its first argument has already been bound to the
given ACPI handle (second argument), because that is not a good
enough reason for returning an error code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -143,7 +143,10 @@ int acpi_bind_one(struct device *dev, ac
 	list_for_each_entry(pn, &acpi_dev->physical_node_list, node)
 		if (pn->dev == dev) {
 			dev_warn(dev, "Already associated with ACPI node\n");
-			goto err_free;
+			if (ACPI_HANDLE(dev) == handle)
+				retval = 0;
+
+			goto out_free;
 		}
 
 	/* allocate physical node id according to physical_node_id_bitmap */
@@ -152,7 +155,7 @@ int acpi_bind_one(struct device *dev, ac
 		ACPI_MAX_PHYSICAL_NODE);
 	if (physical_node->node_id >= ACPI_MAX_PHYSICAL_NODE) {
 		retval = -ENOSPC;
-		goto err_free;
+		goto out_free;
 	}
 
 	set_bit(physical_node->node_id, acpi_dev->physical_node_id_bitmap);
@@ -185,10 +188,14 @@ int acpi_bind_one(struct device *dev, ac
 	put_device(dev);
 	return retval;
 
- err_free:
+ out_free:
 	mutex_unlock(&acpi_dev->physical_node_lock);
 	kfree(physical_node);
-	goto err;
+	if (retval)
+		goto err;
+
+	put_device(dev);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_bind_one);
 

