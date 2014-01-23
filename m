Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbaAWVAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:00:04 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:49799 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAWVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:00 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 1/8] PCI: Increment max correctly in pci_scan_bridge.
Date: Thu, 23 Jan 2014 21:59:21 +0100
Message-Id: <1390510768-5652-2-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two small issues:
 - If pci_add_new_bus fails then max must not be incremented. Otherwise
   an incorrect value is returned from pci_scan_bridge().
 - If the bus is already present, then max must be incremented. I think
   that this case should only be hit if we trigger a manual rescan of a
   CardBus bridge.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 04796c0..78caade 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -852,11 +852,12 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		 * this case we only re-scan this bus. */
 		child = pci_find_bus(pci_domain_nr(bus), max+1);
 		if (!child) {
-			child = pci_add_new_bus(bus, dev, ++max);
+			child = pci_add_new_bus(bus, dev, max+1);
 			if (!child)
 				goto out;
-			pci_bus_insert_busn_res(child, max, 0xff);
+			pci_bus_insert_busn_res(child, max+1, 0xff);
 		}
+		max++;
 		buses = (buses & 0xff000000)
 		      | ((unsigned int)(child->primary)     <<  0)
 		      | ((unsigned int)(child->busn_res.start)   <<  8)
-- 
1.8.5.3

