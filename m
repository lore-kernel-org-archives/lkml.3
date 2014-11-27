Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaK0Itp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:42637 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbaK0Itm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:42 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 74/91] genhd: fix leftover might_sleep() in blk_free_devt()
Date: Thu, 27 Nov 2014 16:42:57 +0800
Message-Id: <1417077794-9299-74-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <axboe@fb.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 46f341ffcfb5d8530f7d1e60f3be06cce6661b62 upstream.

Commit 2da78092 changed the locking from a mutex to a spinlock,
so we now longer sleep in this context. But there was a leftover
might_sleep() in there, which now triggers since we do the final
free from an RCU callback. Get rid of it.

Reported-by: Pontus Fuchs <pontus.fuchs@gmail.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 block/genhd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 54867f4..60f7e6c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -447,8 +447,6 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
  */
 void blk_free_devt(dev_t devt)
 {
-	might_sleep();
-
 	if (devt == MKDEV(0, 0))
 		return;
 
-- 
1.9.1

