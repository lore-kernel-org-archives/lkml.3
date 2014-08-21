Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaHUDpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:45:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52873 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750809AbaHUDpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:45:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Dirk Griesbach <spamthis@freenet.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH] ACPI / scan: Allow ACPI drivers to bind to PNP device objects
Date: Thu, 21 Aug 2014 06:04:51 +0200
Message-ID: <5487060.QsgluucUH4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

We generally don't allow ACPI drivers to bind to ACPI device objects
that companion "physical" device objects are created for to avoid
situations in which two different drivers may attempt to handle one
device at the same time.  Recent ACPI device enumeration rework
extended that approach to ACPI PNP devices by starting to use a scan
handler for enumerating them.  However, we previously allowed ACPI
drivers to bind to ACPI device objects with existing PNP device
companions and changing that led to functional regressions on some
systems.

For this reason, add a special check for PNP devices in
acpi_device_probe() so that ACPI drivers can bind to ACPI device
objects having existing PNP device companions as before.

Fixes: eec15edbb0e1 (ACPI / PNP: use device ID list for PNPACPI device enumeration)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81511
Link: https://bugzilla.kernel.org/show_bug.cgi?id=81971
Reported-and-tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Reported-and-tested-by: Dirk Griesbach <spamthis@freenet.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_pnp.c |    5 +++++
 drivers/acpi/internal.h |    1 +
 drivers/acpi/scan.c     |    2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/acpi_pnp.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_pnp.c
+++ linux-pm/drivers/acpi/acpi_pnp.c
@@ -396,3 +396,8 @@ void __init acpi_pnp_init(void)
 {
 	acpi_scan_add_handler(&acpi_pnp_handler);
 }
+
+bool is_acpi_pnp_device(struct acpi_device *adev)
+{
+	return adev->handler == &acpi_pnp_handler;
+}
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -86,6 +86,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 bool acpi_device_is_present(struct acpi_device *adev);
 bool acpi_device_is_battery(struct acpi_device *adev);
+bool is_acpi_pnp_device(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -975,7 +975,7 @@ static int acpi_device_probe(struct devi
 	struct acpi_driver *acpi_drv = to_acpi_driver(dev->driver);
 	int ret;
 
-	if (acpi_dev->handler)
+	if (acpi_dev->handler && !is_acpi_pnp_device(acpi_dev))
 		return -EINVAL;
 
 	if (!acpi_drv->ops.add)
