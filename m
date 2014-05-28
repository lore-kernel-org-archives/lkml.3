Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbaE1W3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:29:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:54605 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804AbaE1W3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:29:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,930,1392192000"; 
   d="scan'208";a="519301463"
Subject: [PATCH 1/2] pci: Add pci_walk_vbus for walking virtual busses
 associated with SR-IOV
From: Alexander Duyck <alexander.h.duyck@intel.com>
To: bhelgaas@google.com, ddutile@redhat.com
Cc: linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 15:29:09 -0700
Message-ID: <20140528222901.18898.48031.stgit@ahduyck-cp2.jf.intel.com>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function provides a simple means for applying a given function to all
devices on bus and all of it's children, including virtual busses.  To do
this the function begins by processing all devices on the bus, then it will
proceed through bus->children and process each of the child busses.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
---
 drivers/pci/bus.c   |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index fb8aed3..769bbcb 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -336,6 +336,50 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 }
 EXPORT_SYMBOL_GPL(pci_walk_bus);
 
+/** pci_walk_vbus - walk devices on/under bus, calling callback.
+ *  @top      bus whose devices should be walked
+ *  @cb       callback to be called for each device found
+ *  @userdata arbitrary pointer to be passed to callback.
+ *
+ *  Walk the given bus, including any child buses under this bus.
+ *  Call the provided callback on each device found.
+ *
+ *  We check the return of @cb each time. If it returns anything
+ *  other than 0, we break out.
+ *
+ */
+void pci_walk_vbus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
+		   void *userdata)
+{
+	struct list_head *bus_next;
+	struct pci_bus *bus;
+	struct pci_dev *dev;
+
+	down_read(&pci_bus_sem);
+	bus_next = &top->node;
+	for (;;) {
+		/* prep bus for next iteration */
+		bus = list_entry(bus_next, struct pci_bus, node);
+
+		/* process each device on this bus */
+		list_for_each_entry(dev, &bus->devices, bus_list) {
+			if (cb(dev, userdata))
+				goto release_semaphore;
+		}
+
+		/* end of this bus, go to child, next bus, or finish */
+		for (bus_next = bus->children.next;
+		     bus_next == &bus->children;
+		     bus_next = bus->node.next, bus = bus->parent) {
+			if (bus == top)
+				goto release_semaphore;
+		}
+	}
+release_semaphore:
+	up_read(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_walk_vbus);
+
 struct pci_bus *pci_bus_get(struct pci_bus *bus)
 {
 	if (bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index aab57b4..1fb18a8 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1118,6 +1118,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+void pci_walk_vbus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
+		   void *userdata);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 void pci_setup_bridge(struct pci_bus *bus);

