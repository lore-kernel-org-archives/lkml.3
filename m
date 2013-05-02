Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054Ab3EBAky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:40:54 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51051 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734Ab3EBAkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:40:39 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        vgoyal@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/31] blk-throttle: remove spurious throtl_enqueue_tg() call from throtl_select_dispatch()
Date: Wed,  1 May 2013 17:39:24 -0700
Message-Id: <1367455189-6957-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

throtl_select_dispatch() calls throtl_enqueue_tg() right after
tg_update_disptime(), which always calls the function anyway.  The
call is, while harmless, unnecessary.  Remove it.

This patch doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-throttle.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 3114622..3960787 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -816,10 +816,8 @@ static int throtl_select_dispatch(struct throtl_data *td, struct bio_list *bl)
 
 		nr_disp += throtl_dispatch_tg(td, tg, bl);
 
-		if (tg->nr_queued[0] || tg->nr_queued[1]) {
+		if (tg->nr_queued[0] || tg->nr_queued[1])
 			tg_update_disptime(td, tg);
-			throtl_enqueue_tg(td, tg);
-		}
 
 		if (nr_disp >= throtl_quantum)
 			break;
-- 
1.8.1.4

