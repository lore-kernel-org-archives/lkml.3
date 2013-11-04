Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3KDN0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:26:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53567 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753313Ab3KDN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:26:03 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 1/6] ACPI / scan: Start matching drivers after trying scan handlers
Date: Mon, 04 Nov 2013 14:30:58 +0100
Message-ID: <2151922.M630KK6nC3@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2970389.SeMGM45Qln@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

ACPI scan handlers should always be attached to struct acpi_device
objects before any ACPI drivers, but there is a window during which
a driver may be attached to a struct acpi_device before checking if
there is a matching scan handler.  Namely, that will happen if an
ACPI driver module is loaded during acpi_bus_scan() right after
the first namespace walk is complete and before the given device
is processed by the second namespace walk.

To prevent that from happening, set the match_driver flags of
struct acpi_device objects right before running device_attach()
for them in acpi_bus_device_attach().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1676,7 +1676,6 @@ void acpi_init_device_object(struct acpi
 
 void acpi_device_add_finalize(struct acpi_device *device)
 {
-	device->flags.match_driver = true;
 	dev_set_uevent_suppress(&device->dev, false);
 	kobject_uevent(&device->dev.kobj, KOBJ_ADD);
 }
@@ -1915,8 +1914,12 @@ static acpi_status acpi_bus_device_attac
 		return AE_OK;
 
 	ret = acpi_scan_attach_handler(device);
-	if (ret)
-		return ret > 0 ? AE_OK : AE_CTRL_DEPTH;
+	if (ret < 0)
+		return AE_CTRL_DEPTH;
+
+	device->flags.match_driver = true;
+	if (ret > 0)
+		return AE_OK;
 
 	ret = device_attach(&device->dev);
 	return ret >= 0 ? AE_OK : AE_CTRL_DEPTH;

