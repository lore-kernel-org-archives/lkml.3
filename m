Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaINKm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:42:58 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55339 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaINKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:42:57 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andreas Noever <andreas.noever@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
Date: Sun, 14 Sep 2014 12:42:01 +0200
Message-Id: <1410691321-17860-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <gh8uln71g1.fsf@lena.gouders.net>
References: <gh8uln71g1.fsf@lena.gouders.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an implementation of fix 1 (Add a quirk to fix the _CRS information
based on what amd_bus.c read from the hardware) which makes pci=nocrs ignore bus numbers from crs.

If this works then we can add the board to the crs blacklist (Dirk can you attach the output of dmidecode to the bugzilla report?).



---
 arch/x86/pci/acpi.c     |  7 +++----
 arch/x86/pci/bus_numa.c | 12 +-----------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index cfd1b13..b073948 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -522,15 +522,14 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	} else {
 		probe_pci_root_info(info, device, busnum, domain);
 
-		/* insert busn res at first */
-		pci_add_resource(&resources,  &root->secondary);
 		/*
 		 * _CRS with no apertures is normal, so only fall back to
 		 * defaults or native bridge info if we're ignoring _CRS.
 		 */
-		if (pci_use_crs)
+		if (pci_use_crs) {
+			pci_add_resource(&resources,  &root->secondary);
 			add_resources(info, &resources);
-		else {
+		} else {
 			free_pci_root_info_res(info);
 			x86_pci_root_bus_resources(busnum, &resources);
 		}
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index f3a2cfc..b735d0e 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -31,8 +31,6 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 {
 	struct pci_root_info *info = x86_find_pci_root_info(bus);
 	struct pci_root_res *root_res;
-	struct pci_host_bridge_window *window;
-	bool found = false;
 
 	if (!info)
 		goto default_resources;
@@ -40,15 +38,7 @@ void x86_pci_root_bus_resources(int bus, struct list_head *resources)
 	printk(KERN_DEBUG "PCI: root bus %02x: hardware-probed resources\n",
 	       bus);
 
-	/* already added by acpi ? */
-	list_for_each_entry(window, resources, list)
-		if (window->res->flags & IORESOURCE_BUS) {
-			found = true;
-			break;
-		}
-
-	if (!found)
-		pci_add_resource(resources, &info->busn);
+	pci_add_resource(resources, &info->busn);
 
 	list_for_each_entry(root_res, &info->resources, list) {
 		struct resource *res;
-- 
2.1.0

