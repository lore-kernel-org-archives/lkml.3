Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3CQI0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:26:40 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41088 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3CQI0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:26:34 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/5] f2fs: notify when discard is not supported
Date: Sun, 17 Mar 2013 17:26:14 +0900
Message-Id: <1363508774-2818-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Change f2fs so that a warning is emitted when an attempt is made to
mount a filesystem with the unsupported discard option.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/super.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ae75536..2bb6951 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -21,6 +21,7 @@
 #include <linux/seq_file.h>
 #include <linux/random.h>
 #include <linux/exportfs.h>
+#include <linux/blkdev.h>
 #include <linux/f2fs_fs.h>
 
 #include "f2fs.h"
@@ -649,6 +650,14 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	err = f2fs_build_stats(sbi);
 	if (err)
 		goto fail;
+
+	if (test_opt(sbi, DISCARD)) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		if (!blk_queue_discard(q))
+			f2fs_msg(sb, KERN_WARNING,
+					"mounting with \"discard\" option, but "
+					"the device does not support discard");
+	}
 
 	return 0;
 fail:
-- 
1.7.9.5

