Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbaJ2MxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:53:05 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14395 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835AbaJ2MqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:14 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/35] UBI: Fastmap: Fix memory leaks while closing the WL sub-system
Date: Wed, 29 Oct 2014 13:45:33 +0100
Message-Id: <1414586758-9972-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
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
index 0639353..73ff40a 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -2055,6 +2055,23 @@ static void protection_queue_destroy(struct ubi_device *ubi)
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
@@ -2062,9 +2079,7 @@ static void protection_queue_destroy(struct ubi_device *ubi)
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

