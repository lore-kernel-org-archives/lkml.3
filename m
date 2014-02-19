Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaBSI4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:56:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbaBSI4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:56:44 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH 7/9] skd: Fix incomplete cleanup of MSI-X interrupt
Date: Wed, 19 Feb 2014 09:58:19 +0100
Message-Id: <554eac1b5dc4852f4a8c92f07d6c06d12f1c3f13.1392799752.git.agordeev@redhat.com>
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enabling MSI-X interrupts fails due to lack of memory
the call to pci_disable_msix() is missed and the device is
left with MSI-X interrupts enabled while the driver assumes
otherwise. This update fixes the described misbehaviour and
cleans up the code of skd_release_msix() function.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/skd_main.c |   50 +++++++++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 3fa0918..d0550ba 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3910,43 +3910,44 @@ static void skd_release_msix(struct skd_device *skdev)
 	struct skd_msix_entry *qentry;
 	int i;
 
-	if (skdev->msix_entries == NULL)
-		return;
-	for (i = 0; i < skdev->msix_count; i++) {
-		qentry = &skdev->msix_entries[i];
-		skdev = qentry->rsp;
+	if (skdev->msix_entries) {
+		for (i = 0; i < skdev->msix_count; i++) {
+			qentry = &skdev->msix_entries[i];
+			skdev = qentry->rsp;
+
+			if (qentry->have_irq)
+				devm_free_irq(&skdev->pdev->dev,
+					      qentry->vector, qentry->rsp);
+		}
 
-		if (qentry->have_irq)
-			devm_free_irq(&skdev->pdev->dev,
-				      qentry->vector, qentry->rsp);
+		kfree(skdev->msix_entries);
 	}
-	pci_disable_msix(skdev->pdev);
-	kfree(skdev->msix_entries);
+
+	if (skdev->msix_count)
+		pci_disable_msix(skdev->pdev);
+
 	skdev->msix_count = 0;
 	skdev->msix_entries = NULL;
 }
 
 static int skd_acquire_msix(struct skd_device *skdev)
 {
-	int i, rc;
-	struct pci_dev *pdev;
-	struct msix_entry *entries = NULL;
+	int i, rc, msix_count = SKD_MAX_MSIX_COUNT;
+	struct pci_dev *pdev = skdev->pdev;
+	struct msix_entry *entries;
 	struct skd_msix_entry *qentry;
 
-	pdev = skdev->pdev;
-	skdev->msix_count = SKD_MAX_MSIX_COUNT;
-	entries = kzalloc(sizeof(struct msix_entry) * SKD_MAX_MSIX_COUNT,
-			  GFP_KERNEL);
+	entries = kzalloc(sizeof(struct msix_entry) * msix_count, GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
 
-	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++)
+	for (i = 0; i < msix_count; i++)
 		entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, entries, SKD_MAX_MSIX_COUNT);
+	rc = pci_enable_msix(pdev, entries, msix_count);
 	if (rc < 0)
 		goto msix_out;
-	if (rc) {
+	else if (rc) {
 		if (rc < SKD_MIN_MSIX_COUNT) {
 			pr_err("(%s): failed to enable MSI-X %d\n",
 			       skd_name(skdev), rc);
@@ -3956,20 +3957,21 @@ static int skd_acquire_msix(struct skd_device *skdev)
 			 skdev->name, __func__, __LINE__,
 			 pci_name(pdev), skdev->name, rc);
 
-		skdev->msix_count = rc;
-		rc = pci_enable_msix(pdev, entries, skdev->msix_count);
+		msix_count = rc;
+		rc = pci_enable_msix(pdev, entries, msix_count);
 		if (rc) {
 			pr_err("(%s): failed to enable MSI-X "
 			       "support (%d) %d\n",
-			       skd_name(skdev), skdev->msix_count, rc);
+			       skd_name(skdev), msix_count, rc);
 			goto msix_out;
 		}
 	}
+
+	skdev->msix_count = msix_count;
 	skdev->msix_entries = kzalloc(sizeof(struct skd_msix_entry) *
 				      skdev->msix_count, GFP_KERNEL);
 	if (!skdev->msix_entries) {
 		rc = -ENOMEM;
-		skdev->msix_count = 0;
 		pr_err("(%s): msix table allocation error\n",
 		       skd_name(skdev));
 		goto msix_out;
-- 
1.7.7.6

