Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaEFEDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:03:31 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33783 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaEFED2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:28 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 2/7] staging: slicoss: fix multiple free-after-free in slic_entry_remove
Date: Mon,  5 May 2014 21:02:32 -0700
Message-Id: <1399348957-16663-3-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes two free-after-free bugs in slic_entry_remove.
Specifically, slic_unmap_mmio_space() iounmaps adapter->slic_regs,
which is the same region of memory as dev->base_addr (iounmap-ed
a few lines later).

Next, both release_mem_region() and pci_release_regions() are called
on the same pci_dev struct.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slicoss.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 6113b90..452aa02 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -2955,8 +2955,6 @@ static void slic_card_cleanup(struct sliccard *card)
 static void slic_entry_remove(struct pci_dev *pcidev)
 {
 	struct net_device *dev = pci_get_drvdata(pcidev);
-	u32 mmio_start = 0;
-	uint mmio_len = 0;
 	struct adapter *adapter = netdev_priv(dev);
 	struct sliccard *card;
 	struct mcast_address *mcaddr, *mlist;
@@ -2965,12 +2963,6 @@ static void slic_entry_remove(struct pci_dev *pcidev)
 	slic_unmap_mmio_space(adapter);
 	unregister_netdev(dev);
 
-	mmio_start = pci_resource_start(pcidev, 0);
-	mmio_len = pci_resource_len(pcidev, 0);
-
-	release_mem_region(mmio_start, mmio_len);
-
-	iounmap((void __iomem *)dev->base_addr);
 	/* free multicast addresses */
 	mlist = adapter->mcastaddrs;
 	while (mlist) {
-- 
1.9.2

