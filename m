Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaBSI5D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:57:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaBSI4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:48 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH 9/9] skd: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 09:58:21 +0100
Message-Id: <916f0aad90121bc7d2d43deb4088c63f600c1d20.1392799752.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/skd_main.c |   38 ++++++++++++--------------------------
 1 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1cd1095..a69dd93 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3932,42 +3932,28 @@ static void skd_release_msix(struct skd_device *skdev)
 
 static int skd_acquire_msix(struct skd_device *skdev)
 {
-	int i, rc, msix_count = SKD_MAX_MSIX_COUNT;
+	int i, rc;
 	struct pci_dev *pdev = skdev->pdev;
 	struct msix_entry *entries;
 	struct skd_msix_entry *qentry;
 
-	entries = kzalloc(sizeof(struct msix_entry) * msix_count, GFP_KERNEL);
+	entries = kzalloc(sizeof(struct msix_entry) * SKD_MAX_MSIX_COUNT,
+			  GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
 
-	for (i = 0; i < msix_count; i++)
+	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++)
 		entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, entries, msix_count);
-	if (rc < 0)
+	rc = pci_enable_msix_range(pdev, entries,
+				   SKD_MIN_MSIX_COUNT, SKD_MAX_MSIX_COUNT);
+	if (rc < 0) {
+		pr_err("(%s): failed to enable MSI-X %d\n",
+		       skd_name(skdev), rc);
 		goto msix_out;
-	else if (rc) {
-		if (rc < SKD_MIN_MSIX_COUNT) {
-			pr_err("(%s): failed to enable MSI-X %d\n",
-			       skd_name(skdev), rc);
-			goto msix_out;
-		}
-		pr_debug("%s:%s:%d %s: <%s> allocated %d MSI-X vectors\n",
-			 skdev->name, __func__, __LINE__,
-			 pci_name(pdev), skdev->name, rc);
-
-		msix_count = rc;
-		rc = pci_enable_msix(pdev, entries, msix_count);
-		if (rc) {
-			pr_err("(%s): failed to enable MSI-X "
-			       "support (%d) %d\n",
-			       skd_name(skdev), msix_count, rc);
-			goto msix_out;
-		}
 	}
 
-	skdev->msix_count = msix_count;
+	skdev->msix_count = rc;
 	skdev->msix_entries = kzalloc(sizeof(struct skd_msix_entry) *
 				      skdev->msix_count, GFP_KERNEL);
 	if (!skdev->msix_entries) {
@@ -4046,8 +4032,8 @@ RETRY_IRQ_TYPE:
 	case SKD_IRQ_MSI:
 		snprintf(skdev->isr_name, sizeof(skdev->isr_name), "%s%d-msi",
 			 DRV_NAME, skdev->devno);
-		rc = pci_enable_msi(pdev);
-		if (!rc) {
+		rc = pci_enable_msi_range(pdev, 1, 1);
+		if (rc > 0) {
 			rc = devm_request_irq(&pdev->dev, pdev->irq, skd_isr, 0,
 					      skdev->isr_name, skdev);
 			if (rc) {
-- 
1.7.7.6

