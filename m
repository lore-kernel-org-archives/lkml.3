Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3DMNif (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:38:35 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52194 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab3DMNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:38:24 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, nbd-general@lists.sourceforge.net,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH 1/8] block: fix max discard sectors limit
Date: Sat, 13 Apr 2013 22:38:13 +0900
Message-Id: <1365860293-21227-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

https://lkml.org/lkml/2013/4/1/292

As per above discussion, it has been oberved that few drivers are
setting q->limits.max_discard_sectors to more than (UINT_MAX >> 9)

If multiple discard requests get merged, merged discard request's
size exceeds 4GB, there is possibility that merged discard request's
__data_len field may overflow.

This patch fixes this issue.

Also, adding BLK_DEF_MAX_DISCARD_SECTORS macro to use it instead
of UINT_MAX >> 9

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 block/blk-settings.c   |    3 ++-
 include/linux/blkdev.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..994d91c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -283,7 +283,8 @@ EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 void blk_queue_max_discard_sectors(struct request_queue *q,
 		unsigned int max_discard_sectors)
 {
-	q->limits.max_discard_sectors = max_discard_sectors;
+	q->limits.max_discard_sectors = min_t(unsigned int, max_discard_sectors,
+					BLK_DEF_MAX_DISCARD_SECTORS);
 }
 EXPORT_SYMBOL(blk_queue_max_discard_sectors);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 07aa5f6..efff505 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1105,6 +1105,7 @@ enum blk_default_limits {
 	BLK_DEF_MAX_SECTORS	= 1024,
 	BLK_MAX_SEGMENT_SIZE	= 65536,
 	BLK_SEG_BOUNDARY_MASK	= 0xFFFFFFFFUL,
+	BLK_DEF_MAX_DISCARD_SECTORS	= UINT_MAX >> 9,
 };
 
 #define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)
-- 
1.7.9.5

