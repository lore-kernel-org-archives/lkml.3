Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaEWE0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:26:18 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38348 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaEWE0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:17 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: fix use-after-free in slic_entry_probe
Date: Thu, 22 May 2014 21:25:40 -0700
Message-Id: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a use-after-free bug that can cause a kernel oops. If
slic_card_init fails then slic_entry_probe() (the pci probe()
function for this device) will return error without cleaning
up memory (including the registered netdev struct).

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
This patch was originally sent here https://lkml.org/lkml/2014/5/6/10 with
my google.com email address. But due to Google's recent change in DMARC
policies, that patchset was silently dropped for at least some users
(including my personal gmail account). So I'm sending it out now with
my gmail.com account. Let me know if this is an issue. Thanks.

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

