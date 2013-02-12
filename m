Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3BLWl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:41:27 -0500
Received: from mail.df.lth.se ([194.47.250.12]:18863 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758850Ab3BLWlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:41:25 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/9] block: xd: fix up request handler loop
Date: Tue, 12 Feb 2013 23:40:53 +0100
Message-Id: <1360708860-23466-4-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
References: <1360708860-23466-1-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-2-git-send-email-linus.walleij@linaro.org>
 <1360708860-23466-3-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The result (res) variable was set to -EIO in this loop, however
since the iteratively retried request execution loop would
exit on !res this means that loop is never taken.

Instead, assign zero to the res variable, and explicitly set
it to -EIO on error.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/block/xd.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 303e9f2..ce088f8 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -322,13 +322,19 @@ static void do_xd_request (struct request_queue * q)
 		unsigned block = blk_rq_pos(req);
 		unsigned count = blk_rq_cur_sectors(req);
 		XD_INFO *disk = req->rq_disk->private_data;
-		int res = -EIO;
+		int res = 0;
 		int retry;
 
-		if (req->cmd_type != REQ_TYPE_FS)
+		if (req->cmd_type != REQ_TYPE_FS) {
+			pr_err("unsupported request: %d\n", req->cmd_type);
+			res = -EIO;
 			goto done;
-		if (block + count > get_capacity(req->rq_disk))
+		}
+		if (block + count > get_capacity(req->rq_disk)) {
+			pr_err("request beyond device capacity\n");
+			res = -EIO;
 			goto done;
+		}
 		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
 			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
 					   block, count);
-- 
1.8.1.2

