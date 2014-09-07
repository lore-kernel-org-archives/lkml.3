Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaIGXER (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:04:17 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38809 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaIGXEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:14 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] bdi: make backing_dev_info->wb.dwork canceling stricter
Date: Mon,  8 Sep 2014 08:03:59 +0900
Message-Id: <1410131041-1881-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Canceling of bdi->wb.dwork is currently a bit mushy.
bdi_wb_shutdown() performs cancel_delayed_work_sync() at the end after
shutting down and flushing the delayed_work and bdi_destroy() tries
yet again after bdi_unregister().

bdi->wb.dwork is queued only after checking BDI_registered while
holding bdi->wb_lock and bdi_wb_shutdown() clears the flag while
holding the same lock and then flushes the delayed_work.  There's no
way the delayed_work can be queued again after that.

Replace the two unnecessary cancel_delayed_work_sync() invocations
with WARNs on pending.  This simplifies and clarifies the code a bit
and will help future changes in further isolating bdi_writeback
handling.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/backing-dev.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 4afeefe..cb7c5e3 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -376,13 +376,7 @@ static void bdi_wb_shutdown(struct backing_dev_info *bdi)
 	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
 	flush_delayed_work(&bdi->wb.dwork);
 	WARN_ON(!list_empty(&bdi->work_list));
-
-	/*
-	 * This shouldn't be necessary unless @bdi for some reason has
-	 * unflushed dirty IO after work_list is drained.  Do it anyway
-	 * just in case.
-	 */
-	cancel_delayed_work_sync(&bdi->wb.dwork);
+	WARN_ON(delayed_work_pending(&bdi->wb.dwork));
 }
 
 /*
@@ -497,12 +491,7 @@ void bdi_destroy(struct backing_dev_info *bdi)
 
 	bdi_unregister(bdi);
 
-	/*
-	 * If bdi_unregister() had already been called earlier, the dwork
-	 * could still be pending because bdi_prune_sb() can race with the
-	 * bdi_wakeup_thread_delayed() calls from __mark_inode_dirty().
-	 */
-	cancel_delayed_work_sync(&bdi->wb.dwork);
+	WARN_ON(delayed_work_pending(&bdi->wb.dwork));
 
 	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
 		percpu_counter_destroy(&bdi->bdi_stat[i]);
-- 
1.9.3

