Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbaDUPST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 11:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaDUPSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 11:18:12 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH RESEND 1/2] skd: Use pci_enable_msix_exact() instead of pci_enable_msix_range()
Date: Mon, 21 Apr 2014 17:19:31 +0200
Message-Id: <b673482f9449adc4e659e4f68fa52626c5775124.1398093399.git.agordeev@redhat.com>
In-Reply-To: <cover.1398093399.git.agordeev@redhat.com>
References: <cover.1398093399.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function pci_enable_msix_exact() is a variation of
pci_enable_msix_range() that allows a device driver
to request a particular number of MSI-X interrupts,
rather than any number within a specified range.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/block/skd_main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index a69dd93..c244c5bc 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -3945,15 +3945,14 @@ static int skd_acquire_msix(struct skd_device *skdev)
 	for (i = 0; i < SKD_MAX_MSIX_COUNT; i++)
 		entries[i].entry = i;
 
-	rc = pci_enable_msix_range(pdev, entries,
-				   SKD_MIN_MSIX_COUNT, SKD_MAX_MSIX_COUNT);
-	if (rc < 0) {
+	rc = pci_enable_msix_exact(pdev, entries, SKD_MAX_MSIX_COUNT);
+	if (rc) {
 		pr_err("(%s): failed to enable MSI-X %d\n",
 		       skd_name(skdev), rc);
 		goto msix_out;
 	}
 
-	skdev->msix_count = rc;
+	skdev->msix_count = SKD_MAX_MSIX_COUNT;
 	skdev->msix_entries = kzalloc(sizeof(struct skd_msix_entry) *
 				      skdev->msix_count, GFP_KERNEL);
 	if (!skdev->msix_entries) {
-- 
1.7.7.6

