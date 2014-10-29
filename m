Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080AbaJ2MwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:52:22 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14398 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811AbaJ2MqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:17 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 16/35] UBI: Fastmap: Fix memory leak while attaching
Date: Wed, 29 Oct 2014 13:45:39 +0100
Message-Id: <1414586758-9972-17-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we leak a few ubi_ainf_pebs while attaching.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c  | 61 +++++++++++++++++++++++++----------------------
 drivers/mtd/ubi/fastmap.c | 13 ----------
 2 files changed, 33 insertions(+), 41 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 6f27d9a..d1072bc 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1297,6 +1297,30 @@ out_ech:
 	return err;
 }
 
+static struct ubi_attach_info *alloc_ai(const char *slab_name)
+{
+	struct ubi_attach_info *ai;
+
+	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
+	if (!ai)
+		return ai;
+
+	INIT_LIST_HEAD(&ai->corr);
+	INIT_LIST_HEAD(&ai->free);
+	INIT_LIST_HEAD(&ai->erase);
+	INIT_LIST_HEAD(&ai->alien);
+	ai->volumes = RB_ROOT;
+	ai->aeb_slab_cache = kmem_cache_create(slab_name,
+					       sizeof(struct ubi_ainf_peb),
+					       0, 0, NULL);
+	if (!ai->aeb_slab_cache) {
+		kfree(ai);
+		ai = NULL;
+	}
+
+	return ai;
+}
+
 #ifdef CONFIG_MTD_UBI_FASTMAP
 
 /**
@@ -1309,7 +1333,7 @@ out_ech:
  * UBI_NO_FASTMAP denotes that no fastmap was found.
  * UBI_BAD_FASTMAP denotes that the found fastmap was invalid.
  */
-static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
+static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info **ai)
 {
 	int err, pnum, fm_anchor = -1;
 	unsigned long long max_sqnum = 0;
@@ -1330,7 +1354,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		cond_resched();
 
 		dbg_gen("process PEB %d", pnum);
-		err = scan_peb(ubi, ai, pnum, &vol_id, &sqnum);
+		err = scan_peb(ubi, *ai, pnum, &vol_id, &sqnum);
 		if (err < 0)
 			goto out_vidh;
 
@@ -1346,7 +1370,12 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	if (fm_anchor < 0)
 		return UBI_NO_FASTMAP;
 
-	return ubi_scan_fastmap(ubi, ai, fm_anchor);
+	destroy_ai(*ai);
+	*ai = alloc_ai("ubi_aeb_slab_cache");
+	if (!*ai)
+		return -ENOMEM;
+
+	return ubi_scan_fastmap(ubi, *ai, fm_anchor);
 
 out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
@@ -1358,30 +1387,6 @@ out:
 
 #endif
 
-static struct ubi_attach_info *alloc_ai(const char *slab_name)
-{
-	struct ubi_attach_info *ai;
-
-	ai = kzalloc(sizeof(struct ubi_attach_info), GFP_KERNEL);
-	if (!ai)
-		return ai;
-
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
-	ai->aeb_slab_cache = kmem_cache_create(slab_name,
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache) {
-		kfree(ai);
-		ai = NULL;
-	}
-
-	return ai;
-}
-
 /**
  * ubi_attach - attach an MTD device.
  * @ubi: UBI device descriptor
@@ -1409,7 +1414,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (force_scan)
 		err = scan_all(ubi, ai, 0);
 	else {
-		err = scan_fast(ubi, ai);
+		err = scan_fast(ubi, &ai);
 		if (err > 0) {
 			if (err != UBI_NO_FASTMAP) {
 				destroy_ai(ai);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 09a97ad..1654f95 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -625,21 +625,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	INIT_LIST_HEAD(&used);
 	INIT_LIST_HEAD(&free);
 	INIT_LIST_HEAD(&eba_orphans);
-	INIT_LIST_HEAD(&ai->corr);
-	INIT_LIST_HEAD(&ai->free);
-	INIT_LIST_HEAD(&ai->erase);
-	INIT_LIST_HEAD(&ai->alien);
-	ai->volumes = RB_ROOT;
 	ai->min_ec = UBI_MAX_ERASECOUNTER;
 
-	ai->aeb_slab_cache = kmem_cache_create("ubi_ainf_peb_slab",
-					       sizeof(struct ubi_ainf_peb),
-					       0, 0, NULL);
-	if (!ai->aeb_slab_cache) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-
 	fmsb = (struct ubi_fm_sb *)(fm_raw);
 	ai->max_sqnum = fmsb->sqnum;
 	fm_pos += sizeof(struct ubi_fm_sb);
-- 
1.8.4.5

