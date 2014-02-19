Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaBSKOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbaBSKOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:14:05 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH] tsi721: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:27 +0100
Message-Id: <1392804931-30671-7-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/rapidio/devices/tsi721.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index ff7cbf2..3071492 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -768,15 +768,11 @@ static int tsi721_enable_msix(struct tsi721_device *priv)
 	}
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
-	err = pci_enable_msix(priv->pdev, entries, ARRAY_SIZE(entries));
-	if (err) {
-		if (err > 0)
-			dev_info(&priv->pdev->dev,
-				 "Only %d MSI-X vectors available, "
-				 "not using MSI-X\n", err);
-		else
-			dev_err(&priv->pdev->dev,
-				"Failed to enable MSI-X (err=%d)\n", err);
+	err = pci_enable_msix_range(priv->pdev, entries,
+				    ARRAY_SIZE(entries), ARRAY_SIZE(entries));
+	if (err < 0) {
+		dev_err(&priv->pdev->dev,
+			"Failed to enable MSI-X (err=%d)\n", err);
 		return err;
 	}
 
-- 
1.7.7.6

