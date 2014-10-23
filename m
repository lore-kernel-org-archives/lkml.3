Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaJWQrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:47:01 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:62901 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaJWQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:46:59 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] block: wrong return value
Date: Thu, 23 Oct 2014 22:16:48 +0530
Message-Id: <1414082808-7484-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while compiling integer err was showing as a set but unused variable.
elevator_init_fn can be either cfq_init_queue or deadline_init_queue
or noop_init_queue.
all three of these functions are returning -ENOMEM if they fail to
allocate the queue.
so we should actually be returning the error code rather than
returning 0 always.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

change in v2: added elevator_put
change in v3: remove unneeded initialization of err

 block/elevator.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/elevator.c b/block/elevator.c
index 24c28b6..afa3b03 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -229,7 +229,9 @@ int elevator_init(struct request_queue *q, char *name)
 	}
 
 	err = e->ops.elevator_init_fn(q, e);
-	return 0;
+	if (err)
+		elevator_put(e);
+	return err;
 }
 EXPORT_SYMBOL(elevator_init);
 
-- 
1.8.1.2

