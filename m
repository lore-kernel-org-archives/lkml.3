Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968416Ab3DSQko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:40:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36906 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968355Ab3DSQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:40:42 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: dwmw2@infradead.org, axboe@kernel.dk, shli@kernel.org,
        Paul.Clements@steeleye.com, npiggin@kernel.dk, neilb@suse.de,
        cjb@laptop.org, adrian.hunter@intel.com,
        James.Bottomley@HansenPartnership.com, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        nbd-general@lists.sourceforge.net, linux-raid@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcmvbkbc@gmail.com, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>
Subject: [PATCH v2 1/9] block: fix max discard sectors limit
Date: Sat, 20 Apr 2013 01:40:33 +0900
Message-Id: <1366389634-19348-1-git-send-email-linkinjeon@gmail.com>
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
of UINT_MAX >> 9.

Reported-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
---
 block/blk-settings.c   |    3 ++-
 include/linux/blkdev.h |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index c50ecf0..34e6b61 100644
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

