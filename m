Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbaIPN1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:27:17 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbaIPN0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:26:48 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] UBI: Call worker functions without work_sem held
Date: Tue, 16 Sep 2014 15:26:37 +0200
Message-Id: <1410873998-2955-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1410873998-2955-1-git-send-email-richard@nod.at>
References: <1410873998-2955-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to call the worker function with work_sem held.
We only need the semaphore to synchronize workers and protect
the work list.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 20f4917..b1e2ed1 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -245,6 +245,7 @@ static int do_work(struct ubi_device *ubi)
 	ubi->works_count -= 1;
 	ubi_assert(ubi->works_count >= 0);
 	spin_unlock(&ubi->wl_lock);
+	up_read(&ubi->work_sem);
 
 	/*
 	 * Call the worker function. Do not touch the work structure
@@ -254,7 +255,6 @@ static int do_work(struct ubi_device *ubi)
 	err = wrk->func(ubi, wrk, 0);
 	if (err)
 		ubi_err("work failed with error code %d", err);
-	up_read(&ubi->work_sem);
 
 	return err;
 }
@@ -1452,7 +1452,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		serve_prot_queue(ubi);
 
 		/* And take care about wear-leveling */
-		err = ensure_wear_leveling(ubi, 1);
+		err = ensure_wear_leveling(ubi, 0);
 		return err;
 	}
 
@@ -1730,13 +1730,14 @@ int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum)
 				ubi->works_count -= 1;
 				ubi_assert(ubi->works_count >= 0);
 				spin_unlock(&ubi->wl_lock);
+				up_read(&ubi->work_sem);
 
 				err = wrk->func(ubi, wrk, 0);
 				if (err) {
-					up_read(&ubi->work_sem);
 					return err;
 				}
 
+				down_read(&ubi->work_sem);
 				spin_lock(&ubi->wl_lock);
 				found = 1;
 				break;
-- 
1.8.4.5

