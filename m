Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab3HSUEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:04:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3HSUEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:04:12 -0400
Subject: [PATCH] pci: Add pci_walk_slot() interface
To: bhelgaas@google.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Aug 2013 14:04:10 -0600
Message-ID: <20130819195917.9062.43580.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a pci_walk_bus() interface, but it's exceptionally cumbersome
for the callback function to figure out if the device is relevant if
the caller is trying to walk all the devices in or below a slot.  Add
a variant to walk only slot devices.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

This allows me to use pci_walk_bus() and pci_walk_slot() instead of
rolling my own for iterating devices for bus/slot reset.  Please
consider for 3.12 to go with the rest of the bus/slot infrastructure.

 drivers/pci/bus.c   |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |    2 ++
 2 files changed, 58 insertions(+)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index b1ff02a..316579a 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -283,6 +283,62 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 }
 EXPORT_SYMBOL_GPL(pci_walk_bus);
 
+/** pci_walk_slot - walk devices in/under slot, calling callback.
+ *  @slot     slot whose devices should be walked
+ *  @cb       callback to be called for each device found
+ *  @userdata arbitrary pointer to be passed to callback.
+ *
+ *  Walk the given slot, including any bridged devices
+ *  on buses under this slot.  Call the provided callback
+ *  on each device found.
+ *
+ *  We check the return of @cb each time. If it returns anything
+ *  other than 0, we break out.
+ *
+ */
+void pci_walk_slot(struct pci_slot *slot, int (*cb)(struct pci_dev *, void *),
+		   void *userdata)
+{
+	struct pci_dev *dev;
+	struct pci_bus *bus;
+	struct list_head *next;
+	int retval;
+
+	bus = slot->bus;
+	down_read(&pci_bus_sem);
+	next = slot->bus->devices.next;
+	for (;;) {
+		if (next == &bus->devices) {
+			/* end of this bus, go up or finish */
+			if (bus == slot->bus)
+				break;
+			next = bus->self->bus_list.next;
+			bus = bus->self->bus;
+			continue;
+		}
+		dev = list_entry(next, struct pci_dev, bus_list);
+
+		/* skip anything on the top level bus not in our slot */
+		if (dev->bus == slot->bus && dev->slot != slot) {
+			next = dev->bus_list.next;
+			continue;
+		}
+
+		if (dev->subordinate) {
+			/* this is a pci-pci bridge, do its devices next */
+			next = dev->subordinate->devices.next;
+			bus = dev->subordinate;
+		} else
+			next = dev->bus_list.next;
+
+		retval = cb(dev, userdata);
+		if (retval)
+			break;
+	}
+	up_read(&pci_bus_sem);
+}
+EXPORT_SYMBOL_GPL(pci_walk_slot);
+
 struct pci_bus *pci_bus_get(struct pci_bus *bus)
 {
 	if (bus)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index daf40cd..cbb291b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1087,6 +1087,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 		  void *userdata);
+void pci_walk_slot(struct pci_slot *slot, int (*cb)(struct pci_dev *, void *),
+		  void *userdata);
 int pci_cfg_space_size_ext(struct pci_dev *dev);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);

