Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab3F1Tjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:39:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54393 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066Ab3F1Tiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:38:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 2/4] ACPI / dock: Rework and simplify find_dock_devices()
Date: Fri, 28 Jun 2013 21:46:14 +0200
Message-ID: <1872152.oRKhS5XAuA@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1640211.P0jyS5muX2@vostro.rjw.lan>
References: <1640211.P0jyS5muX2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_walk_namespace() calls find_dock_devices() during tree
pre-order visit, the latter doesn't need to add devices whose
parents have _EJD pointing to the docking station to the list of
that station's dependent devices, because those parents are going to
be added to that list anyway and the removal of a parent will take
care of the removal of its children in those cases.

For this reason, rework find_dock_devices() to only call
add_dock_dependent_device() for devices whose _EJD point directy to
the docking station represented by its context argument and simplify
it slightly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -855,26 +855,13 @@ static struct notifier_block dock_acpi_n
 static acpi_status
 find_dock_devices(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	acpi_status status;
-	acpi_handle tmp, parent;
 	struct dock_station *ds = context;
+	acpi_handle ejd = NULL;
 
-	status = acpi_bus_get_ejd(handle, &tmp);
-	if (ACPI_FAILURE(status)) {
-		/* try the parent device as well */
-		status = acpi_get_parent(handle, &parent);
-		if (ACPI_FAILURE(status))
-			goto fdd_out;
-		/* see if parent is dependent on dock */
-		status = acpi_bus_get_ejd(parent, &tmp);
-		if (ACPI_FAILURE(status))
-			goto fdd_out;
-	}
-
-	if (tmp == ds->handle)
+	acpi_bus_get_ejd(handle, &ejd);
+	if (ejd == ds->handle)
 		add_dock_dependent_device(ds, handle);
 
-fdd_out:
 	return AE_OK;
 }
 

