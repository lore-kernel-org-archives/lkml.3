Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaK3Lfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:35:51 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaK3Lfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:35:48 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] UBI: Fastmap: Fix memory leaks while closing the WL sub-system
Date: Sun, 30 Nov 2014 12:35:35 +0100
Message-Id: <1417347340-6872-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417347340-6872-1-git-send-email-richard@nod.at>
References: <1417347340-6872-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a ubi_fastmap_close() to free all resources used by fastmap
at WL shutdown.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index c2822f7..47b215f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -2064,6 +2064,23 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 	}
 }
 
+static void ubi_fastmap_close(struct ubi_device *ubi)
+{
+#ifdef CONFIG_MTD_UBI_FASTMAP
+	int i;
+
+	flush_work(&ubi->fm_work);
+	return_unused_pool_pebs(ubi, &ubi->fm_pool);
+	return_unused_pool_pebs(ubi, &ubi->fm_wl_pool);
+
+	if (ubi->fm) {
+		for (i = 0; i < ubi->fm->used_blocks; i++)
+			kfree(ubi->fm->e[i]);
+	}
+	kfree(ubi->fm);
+#endif
+}
+
 /**
  * ubi_wl_close - close the wear-leveling sub-system.
  * @ubi: UBI device description object
@@ -2071,9 +2088,7 @@ static void protection_queue_destroy(struct ubi_device *ubi)
 void ubi_wl_close(struct ubi_device *ubi)
 {
 	dbg_wl("close the WL sub-system");
-#ifdef CONFIG_MTD_UBI_FASTMAP
-	flush_work(&ubi->fm_work);
-#endif
+	ubi_fastmap_close(ubi);
 	shutdown_work(ubi);
 	protection_queue_destroy(ubi);
 	tree_destroy(&ubi->used);
-- 
1.8.4.5

