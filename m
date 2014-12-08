Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaLHJTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:19:42 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbaLHJTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:19:40 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: tlinder@codeaurora.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: Fastmap: Fix possible fastmap inconsistency
Date: Mon,  8 Dec 2014 10:19:26 +0100
Message-Id: <1418030366-9192-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we call ubi_refill_pools() before all UBI meta data
is collected for the fastmap on-flash data structure.
It can happen that a second thread requests a new PEB and returns
it immediately to the free list between ubi_refill_pools()
and collecting meta data.
In this case the same PEB will be in the free list and a fastmap
pool.
Upon attach time fastmap is able to detect that inconsistency
and will fall back to scanning mode.
But we can do better.

To bypass the issue just call ubi_refill_pools() under the same
wl_lock as the meta data collecting happens.
If fastmap is disabled we can still call ubi_refill_pools() early.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c |  4 ----
 drivers/mtd/ubi/fastmap.c    | 17 +++++++++--------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 8f109cc..6883146 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -226,8 +226,6 @@ void ubi_refill_pools(struct ubi_device *ubi)
 	struct ubi_wl_entry *e;
 	int enough;
 
-	spin_lock(&ubi->wl_lock);
-
 	return_unused_pool_pebs(ubi, wl_pool);
 	return_unused_pool_pebs(ubi, pool);
 
@@ -270,8 +268,6 @@ void ubi_refill_pools(struct ubi_device *ubi)
 
 	wl_pool->used = 0;
 	pool->used = 0;
-
-	spin_unlock(&ubi->wl_lock);
 }
 
 /**
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 976e498..05b3c00 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1121,6 +1121,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	spin_lock(&ubi->volumes_lock);
 	spin_lock(&ubi->wl_lock);
 
+	ubi_refill_pools(ubi);
+
 	fmsb = (struct ubi_fm_sb *)fm_raw;
 	fm_pos += sizeof(*fmsb);
 	ubi_assert(fm_pos <= ubi->fm_size);
@@ -1477,19 +1479,14 @@ int ubi_update_fastmap(struct ubi_device *ubi, struct ubi_wl_entry **forced_anch
 
 	down_write(&ubi->fm_protect);
 
-	ubi_refill_pools(ubi);
-
 	if (ubi->ro_mode || ubi->fm_disabled) {
+		spin_lock(&ubi->wl_lock);
+		ubi_refill_pools(ubi);
+		spin_unlock(&ubi->wl_lock);
 		up_write(&ubi->fm_protect);
 		return 0;
 	}
 
-	ret = ubi_ensure_anchor_pebs(ubi);
-	if (ret) {
-		up_write(&ubi->fm_protect);
-		return ret;
-	}
-
 	new_fm = kzalloc(sizeof(*new_fm), GFP_KERNEL);
 	if (!new_fm) {
 		up_write(&ubi->fm_protect);
@@ -1614,6 +1611,10 @@ int ubi_update_fastmap(struct ubi_device *ubi, struct ubi_wl_entry **forced_anch
 	if (ret)
 		goto err;
 
+	ret = ubi_ensure_anchor_pebs(ubi);
+	if (ret)
+		goto err;
+
 out_unlock:
 	up_write(&ubi->fm_protect);
 	kfree(old_fm);
-- 
1.8.4.5

