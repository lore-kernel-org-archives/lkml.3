Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383Ab3HGXqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:46:03 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59871 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab3HGXpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:45:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 1/2] ACPI: Drop unnecessary label from acpi_bind_one()
Date: Thu, 08 Aug 2013 01:55:21 +0200
Message-ID: <21521585.9Si4heEI7J@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5685060.iNWFUGc9at@vostro.rjw.lan>
References: <5685060.iNWFUGc9at@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The out_free label in acpi_bind_one() is only jumped to from one
place, so in fact it is not necessary, because the code below it
can be moved to that place directly.  Move that code and drop the
label.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -225,11 +225,15 @@ int acpi_bind_one(struct device *dev, ac
 	list_for_each_entry(pn, &acpi_dev->physical_node_list, node) {
 		/* Sanity check. */
 		if (pn->dev == dev) {
+			mutex_unlock(&acpi_dev->physical_node_lock);
+
 			dev_warn(dev, "Already associated with ACPI node\n");
-			if (ACPI_HANDLE(dev) == handle)
-				retval = 0;
+			kfree(physical_node);
+			if (ACPI_HANDLE(dev) != handle)
+				goto err;
 
-			goto out_free;
+			put_device(dev);
+			return 0;
 		}
 		if (pn->node_id == node_id) {
 			physnode_list = &pn->node;
@@ -262,15 +266,6 @@ int acpi_bind_one(struct device *dev, ac
 	ACPI_HANDLE_SET(dev, NULL);
 	put_device(dev);
 	return retval;
-
- out_free:
-	mutex_unlock(&acpi_dev->physical_node_lock);
-	kfree(physical_node);
-	if (retval)
-		goto err;
-
-	put_device(dev);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_bind_one);
 

