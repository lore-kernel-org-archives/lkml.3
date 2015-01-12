Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbbALTXw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:23:52 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45743 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbALTXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:23:49 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/10] PCI: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:11 -0800
Message-Id: <1421090600-9750-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

This one is core part, arch changes will be in following patches.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/bus.c   | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  1 +
 2 files changed, 38 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 73aef51..d29b252 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -228,6 +228,43 @@ int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 }
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 
+bool pci_bus_clip_resource(struct pci_dev *dev, struct resource *res)
+{
+	struct pci_bus *bus = dev->bus;
+	resource_size_t start, end;
+	struct resource orig_res = *res;
+	struct resource *r;
+	int i;
+
+	pci_bus_for_each_resource(bus, r, i) {
+		if (!r)
+			continue;
+
+		if (resource_type(res) != resource_type(r))
+			continue;
+
+		start = max(r->start, res->start);
+		end = min(r->end, res->end);
+
+		/* no overlap ? */
+		if (start > end)
+			continue;
+
+		if (res->start == start && res->end == end)
+			return false;
+
+		/* changed */
+		res->start = start;
+		res->end = end;
+		dev_printk(KERN_DEBUG, &dev->dev, "%pR ==> %pR\n",
+				 &orig_res, res);
+
+		return true;
+	}
+
+	return false;
+}
+
 void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
 
 /**
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 360a966..e140627 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1094,6 +1094,7 @@ void pci_free_resource_list(struct list_head *resources);
 void pci_bus_add_resource(struct pci_bus *bus, struct resource *res, unsigned int flags);
 struct resource *pci_bus_resource_n(const struct pci_bus *bus, int n);
 void pci_bus_remove_resources(struct pci_bus *bus);
+bool pci_bus_clip_resource(struct pci_dev *dev, struct resource *res);
 
 #define pci_bus_for_each_resource(bus, res, i)				\
 	for (i = 0;							\
-- 
1.8.4.5

