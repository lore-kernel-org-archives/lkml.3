Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbaJ2Mrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:47:36 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14402 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaJ2MqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:25 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 32/35] UBI: Fastmap: Introduce ubi_fastmap_init()
Date: Wed, 29 Oct 2014 13:45:55 +0100
Message-Id: <1414586758-9972-33-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...and kill another #ifdef in wl.c. :-)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 8 +-------
 drivers/mtd/ubi/wl.h | 7 +++++++
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 40d89a3..ecb7402 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1503,9 +1503,6 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	init_rwsem(&ubi->work_sem);
 	ubi->max_ec = ai->max_ec;
 	INIT_LIST_HEAD(&ubi->works);
-#ifdef CONFIG_MTD_UBI_FASTMAP
-	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
-#endif
 
 	sprintf(ubi->bgt_name, UBI_BGT_NAME_PATTERN, ubi->ubi_num);
 
@@ -1600,10 +1597,7 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		ubi_assert(ubi->good_peb_count == found_pebs);
 
 	reserved_pebs = WL_RESERVED_PEBS;
-#ifdef CONFIG_MTD_UBI_FASTMAP
-	/* Reserve enough LEBs to store two fastmaps. */
-	reserved_pebs += (ubi->fm_size / ubi->leb_size) * 2;
-#endif
+	ubi_fastmap_init(ubi, &reserved_pebs);
 
 	if (ubi->avail_pebs < reserved_pebs) {
 		ubi_err("no enough physical eraseblocks (%d, need %d)",
diff --git a/drivers/mtd/ubi/wl.h b/drivers/mtd/ubi/wl.h
index db86814..4046ccf 100644
--- a/drivers/mtd/ubi/wl.h
+++ b/drivers/mtd/ubi/wl.h
@@ -7,6 +7,12 @@ static void update_fastmap_work_fn(struct work_struct *wrk);
 static struct ubi_wl_entry *find_anchor_wl_entry(struct rb_root *root);
 static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
 static void ubi_fastmap_close(struct ubi_device *ubi);
+static inline void ubi_fastmap_init(struct ubi_device *ubi, int *count)
+{
+	/* Reserve enough LEBs to store two fastmaps. */
+	*count += (ubi->fm_size / ubi->leb_size) * 2;
+	INIT_WORK(&ubi->fm_work, update_fastmap_work_fn);
+}
 #else /* !CONFIG_MTD_UBI_FASTMAP */
 static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi);
 static inline int is_fm_block(struct ubi_device *ubi, int pnum)
@@ -14,5 +20,6 @@ static inline int is_fm_block(struct ubi_device *ubi, int pnum)
 	return 0;
 }
 static inline void ubi_fastmap_close(struct ubi_device *ubi) { }
+static inline void ubi_fastmap_init(struct ubi_device *ubi, int *count) { }
 #endif /* CONFIG_MTD_UBI_FASTMAP */
 #endif /* UBI_WL_H */
-- 
1.8.4.5

