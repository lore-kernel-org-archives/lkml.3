Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3EPQWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:22:49 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42536 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab3EPQWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:22:48 -0400
From: Cyril Roelandt <tipecaml@gmail.com>
To: kernel-janitors@vger.kernel.org, gregkh@linuxfoundation.org,
        andreas.dilger@intel.com, tao.peng@emc.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH] staging: lustre: fix return type of lo_release.
Date: Thu, 16 May 2013 18:06:20 +0200
Message-Id: <1368720380-20974-1-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return type of block_device_operations.release() changed to void in commit
db2a144b.

Found with the following Coccinelle patch:
<smpl>
@has_release_func@
identifier i;
identifier release_func;
@@
struct block_device_operations i = {
 .release = release_func
};

@depends on has_release_func@
identifier has_release_func.release_func;
@@
- int
+ void
release_func(...) {
...
- return ...;
}
</smpl>

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/lustre/lustre/llite/lloop.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index b72f257..9d4c17e 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -596,15 +596,13 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
-static int lo_release(struct gendisk *disk, fmode_t mode)
+static void lo_release(struct gendisk *disk, fmode_t mode)
 {
 	struct lloop_device *lo = disk->private_data;
 
 	mutex_lock(&lo->lo_ctl_mutex);
 	--lo->lo_refcnt;
 	mutex_unlock(&lo->lo_ctl_mutex);
-
-	return 0;
 }
 
 /* lloop device node's ioctl function. */
-- 
1.7.10.4

