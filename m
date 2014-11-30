Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaK3MUA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:20:00 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaK3MT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:19:58 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/6] UBI: Fastmap: Wire up WL accessor functions
Date: Sun, 30 Nov 2014 13:19:45 +0100
Message-Id: <1417349988-9238-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349988-9238-1-git-send-email-richard@nod.at>
References: <1417349988-9238-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new WL accessor functions in fastmap.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 0c1e2c3..a6cc951 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1087,11 +1087,11 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	struct ubi_fm_ec *fec;
 	struct ubi_fm_volhdr *fvh;
 	struct ubi_fm_eba *feba;
-	struct rb_node *node;
 	struct ubi_wl_entry *wl_e;
 	struct ubi_volume *vol;
 	struct ubi_vid_hdr *avhdr, *dvhdr;
 	struct ubi_work *ubi_wrk;
+	struct rb_node *tmp_rb;
 	int ret, i, j, free_peb_count, used_peb_count, vol_count;
 	int scrub_peb_count, erase_peb_count;
 	int *seen_pebs = NULL;
@@ -1163,8 +1163,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		set_seen(ubi, ubi->fm_wl_pool.pebs[i], seen_pebs);
 	}
 
-	for (node = rb_first(&ubi->free); node; node = rb_next(node)) {
-		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+	ubi_for_each_free_peb(ubi, wl_e, tmp_rb) {
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
@@ -1177,8 +1176,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	}
 	fmh->free_peb_count = cpu_to_be32(free_peb_count);
 
-	for (node = rb_first(&ubi->used); node; node = rb_next(node)) {
-		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+	ubi_for_each_used_peb(ubi, wl_e, tmp_rb) {
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
@@ -1190,22 +1188,20 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		ubi_assert(fm_pos <= ubi->fm_size);
 	}
 
-	for (i = 0; i < UBI_PROT_QUEUE_LEN; i++) {
-		list_for_each_entry(wl_e, &ubi->pq[i], u.list) {
-			fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
+	ubi_for_each_protected_peb(ubi, i, wl_e) {
+		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
-			fec->pnum = cpu_to_be32(wl_e->pnum);
-			fec->ec = cpu_to_be32(wl_e->ec);
+		fec->pnum = cpu_to_be32(wl_e->pnum);
+		set_seen(ubi, wl_e->pnum, seen_pebs);
+		fec->ec = cpu_to_be32(wl_e->ec);
 
-			used_peb_count++;
-			fm_pos += sizeof(*fec);
-			ubi_assert(fm_pos <= ubi->fm_size);
-		}
+		used_peb_count++;
+		fm_pos += sizeof(*fec);
+		ubi_assert(fm_pos <= ubi->fm_size);
 	}
 	fmh->used_peb_count = cpu_to_be32(used_peb_count);
 
-	for (node = rb_first(&ubi->scrub); node; node = rb_next(node)) {
-		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+	ubi_for_each_scrub_peb(ubi, wl_e, tmp_rb) {
 		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
-- 
1.8.4.5

