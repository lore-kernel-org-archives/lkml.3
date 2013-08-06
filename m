Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3HFAVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:21:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57229 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755639Ab3HFAVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:21:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 5/5] ACPI: Clean up error code path in acpi_unbind_one()
Date: Tue, 06 Aug 2013 02:28:36 +0200
Message-ID: <7329028.7Z1dZAAkTZ@vostro.rjw.lan>
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

The error code path in acpi_unbind_one() is unnecessarily complicated
(in particular, the err label is not really necessary) and the error
message printed by it is inaccurate (there's nothing called
'acpi_handle' in that function), so clean up those things.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -219,8 +219,10 @@ int acpi_unbind_one(struct device *dev)
 		return 0;
 
 	status = acpi_bus_get_device(ACPI_HANDLE(dev), &acpi_dev);
-	if (ACPI_FAILURE(status))
-		goto err;
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "Oops, ACPI handle corrupt in %s()\n", __func__);
+		return -EINVAL;
+	}
 
 	mutex_lock(&acpi_dev->physical_node_lock);
 
@@ -242,12 +244,7 @@ int acpi_unbind_one(struct device *dev)
 		}
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
-
 	return 0;
-
-err:
-	dev_err(dev, "Oops, 'acpi_handle' corrupt\n");
-	return -EINVAL;
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 

