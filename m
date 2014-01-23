Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaAWVAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:00:09 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47413 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaAWVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:05 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 7/8] PCI: Check for child busses which use more bus numbers than allocated.
Date: Thu, 23 Jan 2014 21:59:27 +0100
Message-Id: <1390510768-5652-8-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_scan_child_bus can (potentially) return a bus number higher than the subordinate
value of the child bus. Possible reasons are that bus numbers are reserved for
SR-IOV or for CardBus (SR-IOV is done without checks and the CardBus
checks are sketchy at best).

We clamp the returned value to the actual subordinate value and print a
warning if too many bus numbers are reserved.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 90d5c48..74bc644 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -805,10 +805,13 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 		}
 
 		cmax = pci_scan_child_bus(child);
-		if (cmax > max)
-			max = cmax;
-		if (child->busn_res.end > max)
-			max = child->busn_res.end;
+		if (cmax > subordinate)
+			dev_warn(&dev->dev,
+				"bridge has subordinate %02x but max busn %02x\n",
+				subordinate, cmax);
+		 /* subordinate should equal child->busn_res.end */
+		if (subordinate > max)
+			max = subordinate;
 	} else {
 		/*
 		 * We need to assign a number to this bus which we always
-- 
1.8.5.3

