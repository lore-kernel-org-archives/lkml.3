Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbaEFEGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:06:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:60458 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaEFED1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:27 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 1/7] staging: slicoss: fix use-after-free in slic_entry_probe
Date: Mon,  5 May 2014 21:02:31 -0700
Message-Id: <1399348957-16663-2-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a use-after-free bug that can cause a kernel
oops. If slic_card_init fails then slic_entry_probe (the pci
probe() function for this device) will return error without
cleaning up memory.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/slicoss.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index e27b88f..6113b90 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3595,7 +3595,6 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	struct net_device *netdev;
 	struct adapter *adapter;
 	void __iomem *memmapped_ioaddr = NULL;
-	u32 status = 0;
 	ulong mmio_start = 0;
 	ulong mmio_len = 0;
 	struct sliccard *card = NULL;
@@ -3686,16 +3685,11 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 		adapter->allocated = 1;
 	}
 
-	status = slic_card_init(card, adapter);
+	err = slic_card_init(card, adapter);
+	if (err)
+		goto err_out_unmap;
 
-	if (status != 0) {
-		card->state = CARD_FAIL;
-		adapter->state = ADAPT_FAIL;
-		adapter->linkstate = LINK_DOWN;
-		dev_err(&pcidev->dev, "FAILED status[%x]\n", status);
-	} else {
-		slic_adapter_set_hwaddr(adapter);
-	}
+	slic_adapter_set_hwaddr(adapter);
 
 	netdev->base_addr = (unsigned long)adapter->memorybase;
 	netdev->irq = adapter->irq;
@@ -3712,7 +3706,7 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 
 	cards_found++;
 
-	return status;
+	return 0;
 
 err_out_unmap:
 	iounmap(memmapped_ioaddr);
-- 
1.9.2

