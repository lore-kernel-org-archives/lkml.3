Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaILSDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:39 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:51326 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaILSDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:36 -0400
Subject: [PATCH v1 07/13] ACPI / hotplug / PCI: Remove pci_configure_slot()
 usage
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:34 -0600
Message-ID: <20140912180334.1630.56528.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now configure each PCI device as it is enumerated, in pci_device_add(),
so remove the configuration done in acpiphp.

That configuration, in pci_configure_device(), does not include the
MPS/MRRS configuration done by pcie_bus_configure_settings(), so keep
that here.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 70741c8c46a0..a6f8e0ba0bfe 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,7 +61,6 @@ static DEFINE_MUTEX(bridge_mutex);
 static int acpiphp_hotplug_notify(struct acpi_device *adev, u32 type);
 static void acpiphp_post_dock_fixup(struct acpi_device *adev);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
-static void acpiphp_set_hpp_values(struct pci_bus *bus);
 static void hotplug_event(u32 type, struct acpiphp_context *context);
 static void free_bridge(struct kref *kref);
 
@@ -510,7 +509,7 @@ static void enable_slot(struct acpiphp_slot *slot)
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 
 	acpiphp_sanitize_bus(bus);
-	acpiphp_set_hpp_values(bus);
+	pcie_bus_configure_settings(bus);
 	acpiphp_set_acpi_region(slot);
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
@@ -702,14 +701,6 @@ static void acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 	}
 }
 
-static void acpiphp_set_hpp_values(struct pci_bus *bus)
-{
-	struct pci_dev *dev;
-
-	list_for_each_entry(dev, &bus->devices, bus_list)
-		pci_configure_slot(dev);
-}
-
 /*
  * Remove devices for which we could not assign resources, call
  * arch specific code to fix-up the bus

