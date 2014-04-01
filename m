Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaDAIB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:01:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56069 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAIB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:01:58 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH] mtd: ubi: Free peb's synchronously for fastmap
Date: Tue,  1 Apr 2014 11:01:45 +0300
Message-Id: <1396339305-16005-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first mount it's possible that there are not enough free PEBs since
there are PEB's pending to be erased. In such scenario, fm_pool (which is
the pool from which user required PEBs are allocated) will be empty.
Try fixing the above described situation by synchronously performing
pending erase work, thus produce another free PEB.

Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 457ead3..9a36f78 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -595,10 +595,29 @@ static void refill_wl_pool(struct ubi_device *ubi)
 static void refill_wl_user_pool(struct ubi_device *ubi)
 {
 	struct ubi_fm_pool *pool = &ubi->fm_pool;
+	int err;
 
 	return_unused_pool_pebs(ubi, pool);
 
 	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
+retry:
+		if (!ubi->free.rb_node ||
+		   (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
+			/*
+			 * There are no available PEBs. Try to free
+			 * PEB by means of synchronous execution of
+			 * pending works.
+			 */
+			if (ubi->works_count == 0)
+				break;
+			spin_unlock(&ubi->wl_lock);
+			err = do_work(ubi);
+			spin_lock(&ubi->wl_lock);
+			if (err < 0)
+				break;
+			goto retry;
+		}
+
 		pool->pebs[pool->size] = __wl_get_peb(ubi);
 		if (pool->pebs[pool->size] < 0)
 			break;
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation


