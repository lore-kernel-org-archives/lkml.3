Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3HZQyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:54:54 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62158 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab3HZQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:54:52 -0400
From: Gabriel de Perthuis <g2p.code@gmail.com>
To: Kent Overstreet <kmo@daterainc.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] bcache: Downgrade "device already registered" to pr_debug
Date: Mon, 26 Aug 2013 18:54:10 +0200
Message-Id: <1377536050-22925-1-git-send-email-g2p.code@gmail.com>
X-Mailer: git-send-email 1.8.4.rc0.5.g48765cc
In-Reply-To: <kvfvst$j12$2@ger.gmane.org>
References: <kvfvst$j12$2@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People tended to see:

    (info) bcache: register_bcache() error opening /dev/blah: device already registered

as more problematic than it really is.  Change it to:

    (debug) bcache: register_bcache() device /dev/blah is already registered

and don't return -EINVAL in this case.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 drivers/md/bcache/super.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a41c681..b09e973 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1894,21 +1894,24 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
 	if (!(path = kstrndup(buffer, size, GFP_KERNEL)) ||
 	    !(sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL)))
 		goto err;
 
-	err = "failed to open device";
 	bdev = blkdev_get_by_path(strim(path),
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				  sb);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
 			bdev = lookup_bdev(strim(path));
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
-				err = "device already registered";
-			else
-				err = "device busy";
+			if (!IS_ERR(bdev) && bch_is_open(bdev)) {
+				pr_debug("device %s is already registered",
+					 path);
+				goto out;
+			}
+			err = "device busy";
+		} else {
+			err = "failed to open device";
 		}
 		goto err;
 	}
 
 	err = "failed to set blocksize";
-- 
1.8.4.rc0.5.g48765cc

