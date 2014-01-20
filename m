Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaATM1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:27:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaATMY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:56 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 19/24] GFS2: Clean up quota slot allocation
Date: Mon, 20 Jan 2014 12:23:42 +0000
Message-Id: <1390220627-1571-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quota slot allocation has historically used a vector of pages
and a set of homegrown find/test/set/clear bit functions. Since
the size of the bitmap is likely to be based on the default
qc file size, thats a couple of pages at most. So we ought
to be able to allocate that as a single chunk, with a vmalloc
fallback, just in case of memory fragmentation.

We are then able to use the kernel's own find/test/set/clear
bit functions, rather than rolling our own.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 59d99ec..4b9aa5b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -733,8 +733,7 @@ struct gfs2_sbd {
 	spinlock_t sd_trunc_lock;
 
 	unsigned int sd_quota_slots;
-	unsigned int sd_quota_chunks;
-	unsigned char **sd_quota_bitmap;
+	unsigned long *sd_quota_bitmap;
 
 	u64 sd_quota_sync_gen;
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3287d98..79be67a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -315,50 +315,30 @@ static void qd_put(struct gfs2_quota_data *qd)
 
 static int slot_get(struct gfs2_quota_data *qd)
 {
-	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
-	unsigned int c, o = 0, b;
-	unsigned char byte = 0;
+	struct gfs2_sbd *sdp = qd->qd_sbd;
+	unsigned int bit;
+	int error = 0;
 
 	spin_lock(&qd_lock);
+	if (qd->qd_slot_count != 0)
+		goto out;
 
-	if (qd->qd_slot_count++) {
-		spin_unlock(&qd_lock);
-		return 0;
+	error = -ENOSPC;
+	bit = find_first_zero_bit(sdp->sd_quota_bitmap, sdp->sd_quota_slots);
+	if (bit < sdp->sd_quota_slots) {
+		set_bit(bit, sdp->sd_quota_bitmap);
+		qd->qd_slot = bit;
+out:
+		qd->qd_slot_count++;
 	}
-
-	for (c = 0; c < sdp->sd_quota_chunks; c++)
-		for (o = 0; o < PAGE_SIZE; o++) {
-			byte = sdp->sd_quota_bitmap[c][o];
-			if (byte != 0xFF)
-				goto found;
-		}
-
-	goto fail;
-
-found:
-	for (b = 0; b < 8; b++)
-		if (!(byte & (1 << b)))
-			break;
-	qd->qd_slot = c * (8 * PAGE_SIZE) + o * 8 + b;
-
-	if (qd->qd_slot >= sdp->sd_quota_slots)
-		goto fail;
-
-	sdp->sd_quota_bitmap[c][o] |= 1 << b;
-
 	spin_unlock(&qd_lock);
 
-	return 0;
-
-fail:
-	qd->qd_slot_count--;
-	spin_unlock(&qd_lock);
-	return -ENOSPC;
+	return error;
 }
 
 static void slot_hold(struct gfs2_quota_data *qd)
 {
-	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
+	struct gfs2_sbd *sdp = qd->qd_sbd;
 
 	spin_lock(&qd_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
@@ -366,34 +346,14 @@ static void slot_hold(struct gfs2_quota_data *qd)
 	spin_unlock(&qd_lock);
 }
 
-static void gfs2_icbit_munge(struct gfs2_sbd *sdp, unsigned char **bitmap,
-			     unsigned int bit, int new_value)
-{
-	unsigned int c, o, b = bit;
-	int old_value;
-
-	c = b / (8 * PAGE_SIZE);
-	b %= 8 * PAGE_SIZE;
-	o = b / 8;
-	b %= 8;
-
-	old_value = (bitmap[c][o] & (1 << b));
-	gfs2_assert_withdraw(sdp, !old_value != !new_value);
-
-	if (new_value)
-		bitmap[c][o] |= 1 << b;
-	else
-		bitmap[c][o] &= ~(1 << b);
-}
-
 static void slot_put(struct gfs2_quota_data *qd)
 {
-	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
+	struct gfs2_sbd *sdp = qd->qd_sbd;
 
 	spin_lock(&qd_lock);
 	gfs2_assert(sdp, qd->qd_slot_count);
 	if (!--qd->qd_slot_count) {
-		gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, qd->qd_slot, 0);
+		BUG_ON(!test_and_clear_bit(qd->qd_slot, sdp->sd_quota_bitmap));
 		qd->qd_slot = -1;
 	}
 	spin_unlock(&qd_lock);
@@ -1269,6 +1229,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 	unsigned int x, slot = 0;
 	unsigned int found = 0;
 	unsigned int hash;
+	unsigned int bm_size;
 	u64 dblock;
 	u32 extlen = 0;
 	int error;
@@ -1277,20 +1238,16 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 		return -EIO;
 
 	sdp->sd_quota_slots = blocks * sdp->sd_qc_per_block;
-	sdp->sd_quota_chunks = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * PAGE_SIZE);
-
+	bm_size = DIV_ROUND_UP(sdp->sd_quota_slots, 8 * sizeof(unsigned long));
+	bm_size *= sizeof(unsigned long);
 	error = -ENOMEM;
-
-	sdp->sd_quota_bitmap = kcalloc(sdp->sd_quota_chunks,
-				       sizeof(unsigned char *), GFP_NOFS);
+	sdp->sd_quota_bitmap = kmalloc(bm_size, GFP_NOFS|__GFP_NOWARN);
+	if (sdp->sd_quota_bitmap == NULL)
+		sdp->sd_quota_bitmap = __vmalloc(bm_size, GFP_NOFS, PAGE_KERNEL);
 	if (!sdp->sd_quota_bitmap)
 		return error;
 
-	for (x = 0; x < sdp->sd_quota_chunks; x++) {
-		sdp->sd_quota_bitmap[x] = kzalloc(PAGE_SIZE, GFP_NOFS);
-		if (!sdp->sd_quota_bitmap[x])
-			goto fail;
-	}
+	memset(sdp->sd_quota_bitmap, 0, bm_size);
 
 	for (x = 0; x < blocks; x++) {
 		struct buffer_head *bh;
@@ -1339,7 +1296,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 			qd->qd_slot_count = 1;
 
 			spin_lock(&qd_lock);
-			gfs2_icbit_munge(sdp, sdp->sd_quota_bitmap, slot, 1);
+			BUG_ON(test_and_set_bit(slot, sdp->sd_quota_bitmap));
 			list_add(&qd->qd_list, &sdp->sd_quota_list);
 			atomic_inc(&sdp->sd_quota_count);
 			spin_unlock(&qd_lock);
@@ -1370,7 +1327,6 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 {
 	struct list_head *head = &sdp->sd_quota_list;
 	struct gfs2_quota_data *qd;
-	unsigned int x;
 
 	spin_lock(&qd_lock);
 	while (!list_empty(head)) {
@@ -1401,9 +1357,11 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	gfs2_assert_warn(sdp, !atomic_read(&sdp->sd_quota_count));
 
 	if (sdp->sd_quota_bitmap) {
-		for (x = 0; x < sdp->sd_quota_chunks; x++)
-			kfree(sdp->sd_quota_bitmap[x]);
-		kfree(sdp->sd_quota_bitmap);
+		if (is_vmalloc_addr(sdp->sd_quota_bitmap))
+			vfree(sdp->sd_quota_bitmap);
+		else
+			kfree(sdp->sd_quota_bitmap);
+		sdp->sd_quota_bitmap = NULL;
 	}
 }
 
-- 
1.8.3.1

