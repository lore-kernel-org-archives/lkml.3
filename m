Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaJ2MzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:55:11 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaJ2MqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:12 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/35] UBI: Fastmap: Ensure that only one fastmap work is scheduled
Date: Wed, 29 Oct 2014 13:45:28 +0100
Message-Id: <1414586758-9972-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the WL pool runs out of PEBs we schedule a fastmap write
to refill it as soon as possible.
Ensure that only one at a time is scheduled otherwise we might end in
a fastmap write storm because writing the fastmap can schedule another
write if bitflips are detected.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h | 2 ++
 drivers/mtd/ubi/wl.c  | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f80a726..5d2e737 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -430,6 +430,7 @@ struct ubi_debug_info {
  * @fm_size: fastmap size in bytes
  * @fm_sem: allows ubi_update_fastmap() to block EBA table changes
  * @fm_work: fastmap work queue
+ * @fm_work_scheduled: non-zero if fastmap work was scheduled
  *
  * @used: RB-tree of used physical eraseblocks
  * @erroneous: RB-tree of erroneous used physical eraseblocks
@@ -536,6 +537,7 @@ struct ubi_device {
 	void *fm_buf;
 	size_t fm_size;
 	struct work_struct fm_work;
+	int fm_work_scheduled;
 
 	/* Wear-leveling sub-system's stuff */
 	struct rb_root used;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index a12c54b..bd2e8d5 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -149,6 +149,9 @@ static void update_fastmap_work_fn(struct work_struct *wrk)
 {
 	struct ubi_device *ubi = container_of(wrk, struct ubi_device, fm_work);
 	ubi_update_fastmap(ubi);
+	spin_lock(&ubi->wl_lock);
+	ubi->fm_work_scheduled = 0;
+	spin_unlock(&ubi->wl_lock);
 }
 
 /**
@@ -657,7 +660,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 		/* We cannot update the fastmap here because this
 		 * function is called in atomic context.
 		 * Let's fail here and refill/update it as soon as possible. */
-		schedule_work(&ubi->fm_work);
+		if (!ubi->fm_work_scheduled) {
+			ubi->fm_work_scheduled = 1;
+			schedule_work(&ubi->fm_work);
+		}
 		return NULL;
 	} else {
 		pnum = pool->pebs[pool->used++];
-- 
1.8.4.5

