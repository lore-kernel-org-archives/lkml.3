Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260AbaEFEFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:05:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46425 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaEFEDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:30 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 3/7] staging: slicoss: remove unused members of struct adapter
Date: Mon,  5 May 2014 21:02:33 -0700
Message-Id: <1399348957-16663-4-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two fields from the private "struct adapter".
Specifically,

memorybase      duplicate of slic_regs

memorylength    written once and never read. This field is trivially
                computed with pci_resource_len if it's ever needed in
                the future.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slic.h    | 2 --
 drivers/staging/slicoss/slicoss.c | 4 +---
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index 702902c..379c4f7 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -420,8 +420,6 @@ struct adapter {
 	ushort              devid;
 	ushort              subsysid;
 	u32             irq;
-	void __iomem *memorybase;
-	u32             memorylength;
 	u32             drambase;
 	u32             dramlength;
 	uint                queues_initialized;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 452aa02..b0b8544 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3422,7 +3422,6 @@ static void slic_init_adapter(struct net_device *netdev,
 	adapter->busnumber = pcidev->bus->number;
 	adapter->slotnumber = ((pcidev->devfn >> 3) & 0x1F);
 	adapter->functionnumber = (pcidev->devfn & 0x7);
-	adapter->memorylength = pci_resource_len(pcidev, 0);
 	adapter->slic_regs = (__iomem struct slic_regs *)memaddr;
 	adapter->irq = pcidev->irq;
 /*	adapter->netdev = netdev;*/
@@ -3431,7 +3430,6 @@ static void slic_init_adapter(struct net_device *netdev,
 	adapter->chipid = chip_idx;
 	adapter->port = 0;	/*adapter->functionnumber;*/
 	adapter->cardindex = adapter->port;
-	adapter->memorybase = memaddr;
 	spin_lock_init(&adapter->upr_lock.lock);
 	spin_lock_init(&adapter->bit64reglock.lock);
 	spin_lock_init(&adapter->adapter_lock.lock);
@@ -3683,7 +3681,7 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 
 	slic_adapter_set_hwaddr(adapter);
 
-	netdev->base_addr = (unsigned long)adapter->memorybase;
+	netdev->base_addr = (unsigned long) memmapped_ioaddr;
 	netdev->irq = adapter->irq;
 	netdev->netdev_ops = &slic_netdev_ops;
 
-- 
1.9.2

