Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965025Ab3CMX3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:29:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51334 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964868Ab3CMX3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:29:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 11/27] PCI: Use for_each_pci_resource() in pci_enable_dev
Date: Wed, 13 Mar 2013 16:28:06 -0700
Message-Id: <1363217302-14383-12-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/pci.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b099e00..c0473dc 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -440,8 +440,9 @@ static void
 pci_restore_bars(struct pci_dev *dev)
 {
 	int i;
+	struct resource *res;
 
-	for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
+	for_each_pci_resource(dev, res, i, PCI_NOBRIDGE_RES)
 		pci_update_resource(dev, i);
 }
 
@@ -1153,6 +1154,7 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 {
 	int err;
 	int i, bars = 0;
+	struct resource *res;
 
 	/*
 	 * Power state could be unknown at this point, either due to a fresh
@@ -1170,12 +1172,11 @@ static int pci_enable_device_flags(struct pci_dev *dev, unsigned long flags)
 		return 0;		/* already enabled */
 
 	/* only skip sriov related */
-	for (i = 0; i <= PCI_ROM_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
-			bars |= (1 << i);
-	for (i = PCI_BRIDGE_RESOURCES; i < DEVICE_COUNT_RESOURCE; i++)
-		if (dev->resource[i].flags & flags)
+	for_each_pci_resource(dev, res, i, PCI_NOIOV_RES) {
+		/* TODO: check i with bits of bars */
+		if (res->flags & flags)
 			bars |= (1 << i);
+	}
 
 	err = do_pci_enable_device(dev, bars);
 	if (err < 0)
@@ -2557,7 +2558,7 @@ static int __pci_request_region(struct pci_dev *pdev, int bar, const char *res_n
 
 err_out:
 	dev_warn(&pdev->dev, "BAR %d: can't reserve %pR\n", bar,
-		 &pdev->resource[bar]);
+		 pci_dev_resource_n(pdev, bar));
 	return -EBUSY;
 }
 
-- 
1.7.10.4

