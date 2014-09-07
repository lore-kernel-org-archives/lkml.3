Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaIGXFB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:05:01 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58763 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720AbaIGXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:13 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/6] bdi: remove bdi->wb_lock locking around bdi->dev clearing in bdi_unregister()
Date: Mon,  8 Sep 2014 08:03:58 +0900
Message-Id: <1410131041-1881-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only places where NULL test on bdi->dev is used are
bdi_[un]register().  The functions can't be called in parallel anyway
and there's no point in protecting bdi->dev clearing with a lock.
Remove bdi->wb_lock grabbing around bdi->dev clearing and move it
after device_unregister() call so that bdi->dev doesn't have to be
cached in a local variable.

This patch shouldn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/backing-dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 1706cbb..4afeefe 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -402,21 +402,15 @@ static void bdi_prune_sb(struct backing_dev_info *bdi)
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
-	struct device *dev = bdi->dev;
-
-	if (dev) {
+	if (bdi->dev) {
 		bdi_set_min_ratio(bdi, 0);
 		trace_writeback_bdi_unregister(bdi);
 		bdi_prune_sb(bdi);
 
 		bdi_wb_shutdown(bdi);
 		bdi_debug_unregister(bdi);
-
-		spin_lock_bh(&bdi->wb_lock);
+		device_unregister(bdi->dev);
 		bdi->dev = NULL;
-		spin_unlock_bh(&bdi->wb_lock);
-
-		device_unregister(dev);
 	}
 }
 EXPORT_SYMBOL(bdi_unregister);
-- 
1.9.3

