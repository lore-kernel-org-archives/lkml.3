Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaEWE0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:26:21 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49850 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaEWE0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:18 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: fix free-after-free in slic_entry_remove
Date: Thu, 22 May 2014 21:25:41 -0700
Message-Id: <1400819147-14236-2-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix two trivial free-after-free bugs in slic_entry_remove.

1. Don't iounmap() the same address twice. adapter->slic_regs
(iounmap()'ed in slic_unmap_mmio_space()) and dev->base_addr
(iounmap()'ed in slic_entry_remove()) are the same region.

2. Don't call release_mem_region() and pci_release_regions()
on the same pci_dev struct. They both free pci memory regions.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
This patch was originally sent here https://lkml.org/lkml/2014/5/6/3 with
my google.com email address. But due to Google's recent change in DMARC
policies, that patchset was silently dropped for at least some users
(including my personal gmail account). So I'm sending it out now with
my gmail.com account. Let me know if this is an issue. Thanks.

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

