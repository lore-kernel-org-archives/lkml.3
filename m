Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaAWVBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:01:15 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:64914 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbaAWVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:04 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 5/8] PCI: Make sure bus number resources stay within their parents bounds.
Date: Thu, 23 Jan 2014 21:59:25 +0100
Message-Id: <1390510768-5652-6-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now we use 0xff for busn_res.end when probing and later reduce it
to the value that is actually used. This does not work if a parent
bridge has already a lower subordinate value. For example during hotplug of a
new bridge below an already configured bridge the following message is
printed from pci_bus_insert_busn_res:

pci_bus 0000:06: busn_res: can not insert [bus 06-ff] under [bus 05-9b]
(conflicts with (null) [bus 05-9b])

This patch clamps the bus range to that of the parent and also ensures
that we do not exceed the parents range when assigning the final
subordinate value.

We also check that busses configured by the firmware fit into their
parents bounds.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index fe6e10e..42ee0c0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -782,7 +782,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 	/* Check if setup is sensible at all */
 	if (!pass &&
 	    (primary != bus->number || secondary <= bus->number ||
-	     secondary > subordinate)) {
+	     secondary > subordinate || subordinate > bus->busn_res.end)) {
 		dev_info(&dev->dev, "bridge configuration invalid ([bus %02x-%02x]), reconfiguring\n",
 			 secondary, subordinate);
 		broken = 1;
@@ -854,7 +854,8 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			child = pci_add_new_bus(bus, dev, max+1);
 			if (!child)
 				goto out;
-			pci_bus_insert_busn_res(child, max+1, 0xff);
+			pci_bus_insert_busn_res(child, max+1,
+						bus->busn_res.end);
 		}
 		max++;
 		buses = (buses & 0xff000000)
@@ -927,6 +928,12 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		/*
 		 * Set the subordinate bus number to its real value.
 		 */
+		if (max > bus->busn_res.end) {
+			dev_warn(&dev->dev,
+				"bridge has max busn %02x, but can only accomodate up to %02x\n",
+				max, bus->busn_res.end);
+			max = bus->busn_res.end;
+		}
 		pci_bus_update_busn_res_end(child, max);
 		pci_write_config_byte(dev, PCI_SUBORDINATE_BUS, max);
 	}
-- 
1.8.5.3

