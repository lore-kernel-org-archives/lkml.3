Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaEAHMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 03:12:50 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60475 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaEAHMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 03:12:49 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] block: null_blk: fix use after free
Date: Thu,  1 May 2014 15:12:36 +0800
Message-Id: <1398928356-24390-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

entry(cmd->ll_list) may belong to new request once end_cmd()
returns, so fix the bug with the patch.

Without the change, it is easy to observe oops when
doing null_blk(timer) test.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/block/null_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 8e7e3a0..e932398 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -203,8 +203,8 @@ static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
 		entry = llist_reverse_order(entry);
 		do {
 			cmd = container_of(entry, struct nullb_cmd, ll_list);
-			end_cmd(cmd);
 			entry = entry->next;
+			end_cmd(cmd);
 		} while (entry);
 	}
 
-- 
1.7.9.5

