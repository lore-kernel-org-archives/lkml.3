Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaAWVAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:00:11 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48265 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbaAWVAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:06 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 8/8] PCI: Don't scan random busses in pci_scan_bridge.
Date: Thu, 23 Jan 2014 21:59:28 +0100
Message-Id: <1390510768-5652-9-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When assigning a new bus number in pci_scan_bridge we check whether
max+1 is free by calling pci_find_bus. If it does already exists then we
assume that we are rescanning and that this is the right bus to scan.

This is fragile. If max+1 lies outside of bus->busn_res.end then we will
rescan some random bus from somewhere else in the hierachy. This patch
checks for this case and prints a warning.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 74bc644..0a94de2 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -830,12 +830,16 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 			goto out;
 		}
 
+		if (max >= bus->busn_res.end) {
+			dev_warn(&dev->dev,
+				"parent bus ran out of bus numbers, cannot allocate child bus\n");
+			goto out;
+		}
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
-		/* Prevent assigning a bus number that already exists.
-		 * This can happen when a bridge is hot-plugged, so in
-		 * this case we only re-scan this bus. */
+		/* The bus will already exist if we are rescanning */
 		child = pci_find_bus(pci_domain_nr(bus), max+1);
 		if (!child) {
 			child = pci_add_new_bus(bus, dev, max+1);
-- 
1.8.5.3

