Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab3I1Nze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:55:34 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62409 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3I1Nz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:29 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/7] UBI: fix refill_wl_user_pool()
Date: Sat, 28 Sep 2013 15:55:10 +0200
Message-Id: <1380376516-30144-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no free PEBs are available refill_wl_user_pool() must not
return with -ENOSPC immediately.
It has to block till produce_free_peb() produced a free PEB.

Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index c95bfb1..02317c1 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -599,10 +599,6 @@ static void refill_wl_user_pool(struct ubi_device *ubi)
 	return_unused_pool_pebs(ubi, pool);
 
 	for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
-		if (!ubi->free.rb_node ||
-		   (ubi->free_count - ubi->beb_rsvd_pebs < 1))
-			break;
-
 		pool->pebs[pool->size] = __wl_get_peb(ubi);
 		if (pool->pebs[pool->size] < 0)
 			break;
-- 
1.8.3.1

