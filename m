Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab3AUVYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:24:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19719 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3AUVVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:24 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 01/11] PCI, acpiphp: Add is_hotplug_bridge detection
Date: Mon, 21 Jan 2013 13:20:42 -0800
Message-Id: <1358803252-20639-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When system support hotplug bridge with children hotplug slots, we need
to make sure that parent bridge get preallocated resource so later when
device is plugged into children slot, those children devices will get
resource allocated.

We do not meet this problem, because for pcie hotplug card, when acpiphp
is used, pci_scan_bridge will set that for us when detect hotplug bit in
slot cap.

Reported-and-tested-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jason Baron <jbaron@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 9e2b1f6..b94879d 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -797,6 +797,29 @@ static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
 	}
 }
 
+static void check_hotplug_bridge(struct acpiphp_slot *slot, struct pci_dev *dev)
+{
+	struct acpiphp_func *func;
+
+	if (!dev->subordinate)
+		return;
+
+	/* quirk, or pcie could set it already */
+	if (dev->is_hotplug_bridge)
+		return;
+
+	if (PCI_SLOT(dev->devfn) != slot->device)
+		return;
+
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		if (PCI_FUNC(dev->devfn) == func->function) {
+			/* check if this bridge has ejectable slots */
+			if ((detect_ejectable_slots(func->handle) > 0))
+				dev->is_hotplug_bridge = 1;
+			break;
+		}
+	}
+}
 /**
  * enable_device - enable, configure a slot
  * @slot: slot to be enabled
@@ -831,8 +854,10 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 			if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 			    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 				max = pci_scan_bridge(bus, dev, max, pass);
-				if (pass && dev->subordinate)
+				if (pass && dev->subordinate) {
+					check_hotplug_bridge(slot, dev);
 					pci_bus_size_bridges(dev->subordinate);
+				}
 			}
 		}
 	}
-- 
1.7.10.4

