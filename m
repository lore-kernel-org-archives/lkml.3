Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbaDBPTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:19:18 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60662 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337AbaDBPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:19:16 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: axboe@kernel.dk
Cc: hch@lst.de, jack@suse.cz, viro@zeniv.linux.org.uk, kmo@daterainc.com,
        namjae.jeon@samsung.com, nasa4836@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] blkdev: use an efficient way to check merge flags
Date: Wed,  2 Apr 2014 23:19:06 +0800
Message-Id: <1396451946-13924-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bitwise flag comparison could be done using a more efficient bit-ops way.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 include/linux/blkdev.h | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1e1fa3f..adfa40a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -655,16 +655,9 @@ static inline bool rq_mergeable(struct request *rq)
 static inline bool blk_check_merge_flags(unsigned int flags1,
 					 unsigned int flags2)
 {
-	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
-		return false;
-
-	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
-		return false;
-
-	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
-		return false;
-
-	return true;
+	return (flags1 & (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME)) ^
+	       (flags2 & (REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME))
+		== 0;
 }
 
 static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
-- 
1.9.0.GIT

