Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaINNRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 09:17:00 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:57143 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaINNQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 09:16:59 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: Dirk Gouders <dirk@gouders.net>
Cc: Andreas Noever <andreas.noever@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [BUG] Bisected Problem with LSI PCI FC Adapter
Date: Sun, 14 Sep 2014 15:16:37 +0200
Message-Id: <1410700597-27265-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <ghfvfu1lc1.fsf@quad.gouders.net>
References: <ghfvfu1lc1.fsf@quad.gouders.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated version with dmi strings. Dirk can you test this (without pci=nocrs) and look for
PCI: Ignoring host bridge windows from ACPI
If it does not show up then I have messed up the DMI_MATCH macros. In that case
please try to boot with pci=nocrs.

Bjorn, this would expand the meaning of nocrs to also ignore the bus window from crs. I can also add a separate flag (like pci_ignore_seg) and match the old behavior.

Thanks,
Andreas

---
 arch/x86/pci/acpi.c     | 17 +++++++++++++----
 arch/x86/pci/bus_numa.c | 12 +-----------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index cfd1b13..c9ebc36 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -107,6 +107,16 @@ static const struct dmi_system_id pci_crs_quirks[] __initconst = {
 			DMI_MATCH(DMI_BIOS_VERSION, "6JET85WW (1.43 )"),
 		},
 	},
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=84281 */
+	{
+		.callback = set_nouse_crs,
+		.ident = "TYAN Transport VX50 B4985",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TYAN Computer Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Tyan Transport VX50-B4985"),
+			DMI_MATCH(DMI_BIOS_VERSION, "TYAN Transport VX50 B4985 BIOS V3.01.B30"),
+		},
+	},
 
 	/* https://bugzilla.kernel.org/show_bug.cgi?id=15362 */
 	{
@@ -522,15 +532,14 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
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

