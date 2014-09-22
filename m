Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaIVIpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:45:46 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaIVIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:45:44 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/3] UBI: Fix possible deadlock in erase_worker()
Date: Mon, 22 Sep 2014 10:45:36 +0200
Message-Id: <1411375536-20067-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411375536-20067-1-git-send-email-richard@nod.at>
References: <1411375536-20067-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sync_erase() fails with EINTR, ENOMEM, EAGAIN or
EBUSY erase_worker() re-schedules the failed work.
This will lead to a deadlock because erase_worker() is called
with work_sem held in read mode. And schedule_erase() will take
this lock again.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 253ec9b..637ffff 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1421,8 +1421,6 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 {
 	struct ubi_wl_entry *e = wl_wrk->e;
 	int pnum = e->pnum;
-	int vol_id = wl_wrk->vol_id;
-	int lnum = wl_wrk->lnum;
 	int err, available_consumed = 0;
 
 	if (shutdown) {
@@ -1459,21 +1457,15 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	}
 
 	ubi_err("failed to erase PEB %d, error %d", pnum, err);
-	kfree(wl_wrk);
 
 	if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
 	    err == -EBUSY) {
-		int err1;
-
 		/* Re-schedule the LEB for erasure */
-		err1 = schedule_erase(ubi, e, vol_id, lnum, 0);
-		if (err1) {
-			err = err1;
-			goto out_ro;
-		}
+		__schedule_ubi_work(ubi, wl_wrk);
 		return err;
 	}
 
+	kfree(wl_wrk);
 	kmem_cache_free(ubi_wl_entry_slab, e);
 	if (err != -EIO)
 		/*
-- 
1.8.4.5

