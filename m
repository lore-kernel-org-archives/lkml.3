Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3LQN6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:58:02 -0500
Received: from mga09.intel.com ([134.134.136.24]:37779 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3LQN57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:57:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,501,1384329600"; 
   d="scan'208";a="453616844"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: me: set dma mask using DMA mapping API
Date: Tue, 17 Dec 2013 15:56:57 +0200
Message-Id: <1387288617-18043-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387288617-18043-1-git-send-email-tomas.winkler@intel.com>
References: <1387288617-18043-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ME device is 64bit DMA capable
We assume both coherent and consistent memory to match

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/pci-me.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 7dfaa32..8b1deea 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -144,6 +144,21 @@ static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev, "failed to get pci regions.\n");
 		goto disable_device;
 	}
+
+	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)) ||
+	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64))) {
+
+		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (err)
+			err = dma_set_coherent_mask(&pdev->dev,
+						    DMA_BIT_MASK(32));
+	}
+	if (err) {
+		dev_err(&pdev->dev, "No usable DMA configuration, aborting\n");
+		goto release_regions;
+	}
+
+
 	/* allocates and initializes the mei dev structure */
 	dev = mei_me_dev_init(pdev);
 	if (!dev) {
-- 
1.8.3.1

