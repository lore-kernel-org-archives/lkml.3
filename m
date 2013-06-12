Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3FLXS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:18:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35466 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab3FLXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:18:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Luck, Tony" <tony.luck@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 5/5] ACPI / ia64 / sba_iommu: Use ACPI scan handler for discovery
Date: Thu, 13 Jun 2013 01:26:45 +0200
Message-ID: <2429621.vqKFZEI7Ma@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1417592.vuSG0cUIGo@vostro.rjw.lan>
References: <1417592.vuSG0cUIGo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The IA64 System Bus Adapter (SBA) I/O MMU driver uses an ACPI driver
object to look for device objects it needs in the ACPI namespace, but
the way that driver object is used by it is kind of abusive.

First of all, the ACPI driver is registered with the assumption that
its .add() routine (an equivalent of .probe()) will run immediately
during the registration, which in principle may or may not happen (it
happens in practice due to the way the kernel is built, but that's
not actually guaranteed).  Second, .add() is the only functionality
provided by that driver object (which means that it probes devices
without really doing anything with them afterward) and that .add() is
only supposed to run during system initialization, so having the
driver object registered (and present in sysfs) throughout the
system's life time isn't particularly useful.

A cleaner way to achieve the same goal that driver object is for
is to use an ACPI scan handler instead of it, which at least
prevents sysfs from being littered with useless data and causes
an improved algorithm of matching ACPI device IDs to be used.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/hp/common/sba_iommu.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

Index: linux-pm/arch/ia64/hp/common/sba_iommu.c
===================================================================
--- linux-pm.orig/arch/ia64/hp/common/sba_iommu.c
+++ linux-pm/arch/ia64/hp/common/sba_iommu.c
@@ -2042,7 +2042,8 @@ sba_map_ioc_to_node(struct ioc *ioc, acp
 #endif
 
 static int __init
-acpi_sba_ioc_add(struct acpi_device *device)
+acpi_sba_ioc_add(struct acpi_device *device,
+		 const struct acpi_device_id *not_used)
 {
 	struct ioc *ioc;
 	acpi_status status;
@@ -2090,14 +2091,18 @@ static const struct acpi_device_id hp_io
 	{"HWP0004", 0},
 	{"", 0},
 };
-static struct acpi_driver acpi_sba_ioc_driver = {
-	.name		= "IOC IOMMU Driver",
-	.ids		= hp_ioc_iommu_device_ids,
-	.ops		= {
-		.add	= acpi_sba_ioc_add,
-	},
+static struct acpi_scan_handler acpi_sba_ioc_handler = {
+	.ids	= hp_ioc_iommu_device_ids,
+	.attach	= acpi_sba_ioc_add,
 };
 
+static int __init acpi_sba_ioc_init_acpi(void)
+{
+	return acpi_scan_add_handler(&acpi_sba_ioc_handler);
+}
+/* This has to run before acpi_scan_init(). */
+arch_initcall(acpi_sba_ioc_init_acpi);
+
 extern struct dma_map_ops swiotlb_dma_ops;
 
 static int __init
@@ -2122,7 +2127,10 @@ sba_init(void)
 	}
 #endif
 
-	acpi_bus_register_driver(&acpi_sba_ioc_driver);
+	/*
+	 * ioc_list should be populated by the acpi_sba_ioc_handler's .attach()
+	 * routine, but that only happens if acpi_scan_init() has already run.
+	 */
 	if (!ioc_list) {
 #ifdef CONFIG_IA64_GENERIC
 		/*

