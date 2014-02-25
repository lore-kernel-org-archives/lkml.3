Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaBYV3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 16:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaBYV3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 16:29:18 -0500
Date: Tue, 25 Feb 2014 22:31:10 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-pci@vger.kernel.org
Subject: [PATCH 10/9] skd: Use pci_enable_msix_exact() instead of
 pci_enable_msix_range()
Message-ID: <20140225213109.GA20652@dhcp-26-207.brq.redhat.com>
References: <cover.1392799751.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
