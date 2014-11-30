Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaK3MQG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:16:06 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14389 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaK3MPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:15:39 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 4/6] UBI: Fastmap: Add self check to detect absent PEBs
Date: Sun, 30 Nov 2014 13:15:26 +0100
Message-Id: <1417349728-9070-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349728-9070-1-git-send-email-richard@nod.at>
References: <1417349728-9070-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This self check allows Fastmap to detect absent PEBs while
writing a new fastmap to the MTD device.
It will help to find implementation issues in Fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 86 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index db2625d..0c1e2c3 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012 Linutronix GmbH
+ * Copyright (c) 2014 sigma star gmbh
  * Author: Richard Weinberger <richard@nod.at>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -17,6 +18,69 @@
 #include "ubi.h"
 
 /**
+ * init_seen - allocate memory for used for debugging.
+ * @ubi: UBI device description object
+ */
+static inline int *init_seen(struct ubi_device *ubi)
+{
+	int *ret;
+
+	if (!ubi_dbg_chk_fastmap(ubi))
+		return NULL;
+
+	ret = kcalloc(ubi->peb_count, sizeof(int), GFP_KERNEL);
+	if (!ret)
+		return ERR_PTR(-ENOMEM);
+
+	return ret;
+}
+
+/**
+ * free_seen - free the seen logic integer array.
+ * @seen: integer array of @ubi->peb_count size
+ */
+static inline void free_seen(int *seen)
+{
+	kfree(seen);
+}
+
+/**
+ * set_seen - mark a PEB as seen.
+ * @ubi: UBI device description object
+ * @pnum: The PEB to be makred as seen
+ * @seen: integer array of @ubi->peb_count size
+ */
+static inline void set_seen(struct ubi_device *ubi, int pnum, int *seen)
+{
+	if (!ubi_dbg_chk_fastmap(ubi) || !seen)
+		return;
+
+	seen[pnum] = 1;
+}
+
+/**
+ * self_check_seen - check whether all PEB have been seen by fastmap.
+ * @ubi: UBI device description object
+ * @seen: integer array of @ubi->peb_count size
+ */
+static int self_check_seen(struct ubi_device *ubi, int *seen)
+{
+	int pnum, ret = 0;
+
+	if (!ubi_dbg_chk_fastmap(ubi) || !seen)
+		return 0;
+
+	for (pnum = 0; pnum < ubi->peb_count; pnum++) {
+		if (!seen[pnum] && ubi->lookuptbl[pnum]) {
+			ubi_err(ubi, "self-check failed for PEB %d, fastmap didn't see it", pnum);
+			ret = -EINVAL;
+		}
+	}
+
+	return ret;
+}
+
+/**
  * ubi_calc_fm_size - calculates the fastmap size in bytes for an UBI device.
  * @ubi: UBI device description object
  */
@@ -1030,6 +1094,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	struct ubi_work *ubi_wrk;
 	int ret, i, j, free_peb_count, used_peb_count, vol_count;
 	int scrub_peb_count, erase_peb_count;
+	int *seen_pebs = NULL;
 
 	fm_raw = ubi->fm_buf;
 	memset(ubi->fm_buf, 0, ubi->fm_size);
@@ -1046,6 +1111,12 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		goto out_kfree;
 	}
 
+	seen_pebs = init_seen(ubi);
+	if (IS_ERR(seen_pebs)) {
+		ret = PTR_ERR(seen_pebs);
+		goto out_kfree;
+	}
+
 	spin_lock(&ubi->volumes_lock);
 	spin_lock(&ubi->wl_lock);
 
@@ -1076,8 +1147,10 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	fmpl1->size = cpu_to_be16(ubi->fm_pool.size);
 	fmpl1->max_size = cpu_to_be16(ubi->fm_pool.max_size);
 
-	for (i = 0; i < ubi->fm_pool.size; i++)
+	for (i = 0; i < ubi->fm_pool.size; i++) {
 		fmpl1->pebs[i] = cpu_to_be32(ubi->fm_pool.pebs[i]);
+		set_seen(ubi, ubi->fm_pool.pebs[i], seen_pebs);
+	}
 
 	fmpl2 = (struct ubi_fm_scan_pool *)(fm_raw + fm_pos);
 	fm_pos += sizeof(*fmpl2);
@@ -1085,14 +1158,17 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	fmpl2->size = cpu_to_be16(ubi->fm_wl_pool.size);
 	fmpl2->max_size = cpu_to_be16(ubi->fm_wl_pool.max_size);
 
-	for (i = 0; i < ubi->fm_wl_pool.size; i++)
+	for (i = 0; i < ubi->fm_wl_pool.size; i++) {
 		fmpl2->pebs[i] = cpu_to_be32(ubi->fm_wl_pool.pebs[i]);
+		set_seen(ubi, ubi->fm_wl_pool.pebs[i], seen_pebs);
+	}
 
 	for (node = rb_first(&ubi->free); node; node = rb_next(node)) {
 		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
+		set_seen(ubi, wl_e->pnum, seen_pebs);
 		fec->ec = cpu_to_be32(wl_e->ec);
 
 		free_peb_count++;
@@ -1106,6 +1182,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
+		set_seen(ubi, wl_e->pnum, seen_pebs);
 		fec->ec = cpu_to_be32(wl_e->ec);
 
 		used_peb_count++;
@@ -1132,6 +1209,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
+		set_seen(ubi, wl_e->pnum, seen_pebs);
 		fec->ec = cpu_to_be32(wl_e->ec);
 
 		scrub_peb_count++;
@@ -1149,6 +1227,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 			fec->pnum = cpu_to_be32(wl_e->pnum);
+			set_seen(ubi, wl_e->pnum, seen_pebs);
 			fec->ec = cpu_to_be32(wl_e->ec);
 
 			erase_peb_count++;
@@ -1208,6 +1287,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 	for (i = 0; i < new_fm->used_blocks; i++) {
 		fmsb->block_loc[i] = cpu_to_be32(new_fm->e[i]->pnum);
+		set_seen(ubi, new_fm->e[i]->pnum, seen_pebs);
 		fmsb->block_ec[i] = cpu_to_be32(new_fm->e[i]->ec);
 	}
 
@@ -1241,11 +1321,13 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	ubi_assert(new_fm);
 	ubi->fm = new_fm;
 
+	ret = self_check_seen(ubi, seen_pebs);
 	dbg_bld("fastmap written!");
 
 out_kfree:
 	ubi_free_vid_hdr(ubi, avhdr);
 	ubi_free_vid_hdr(ubi, dvhdr);
+	free_seen(seen_pebs);
 out:
 	return ret;
 }
-- 
1.8.4.5

