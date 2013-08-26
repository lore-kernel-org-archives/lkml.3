Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3HZWcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 18:32:17 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55747 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3HZWcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 18:32:16 -0400
From: Gabriel de Perthuis <g2p.code@gmail.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Cc: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: [PATCH] bcache: register_quiet should still report errors
Date: Tue, 27 Aug 2013 00:31:46 +0200
Message-Id: <1377556306-29938-1-git-send-email-g2p.code@gmail.com>
X-Mailer: git-send-email 1.8.4.rc0.5.g48765cc
In-Reply-To: <521BD3C0.9070209@gmail.com>
References: <521BD3C0.9070209@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

register_quiet should still report all errors except
"device already registered".

Before this some potential errors would be silenced.

Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 drivers/md/bcache/super.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a41c681..c3a3dc8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1901,14 +1901,17 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 				  FMODE_READ|FMODE_WRITE|FMODE_EXCL,
 				  sb);
 	if (IS_ERR(bdev)) {
 		if (bdev == ERR_PTR(-EBUSY)) {
 			bdev = lookup_bdev(strim(path));
-			if (!IS_ERR(bdev) && bch_is_open(bdev))
+			if (!IS_ERR(bdev) && bch_is_open(bdev)) {
+				if (attr == &ksysfs_register_quiet)
+					goto out;
 				err = "device already registered";
-			else
+			} else {
 				err = "device busy";
+			}
 		}
 		goto err;
 	}
 
 	err = "failed to set blocksize";
@@ -1942,12 +1945,11 @@ out:
 	return ret;
 
 err_close:
 	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 err:
-	if (attr != &ksysfs_register_quiet)
-		pr_info("error opening %s: %s", path, err);
+	pr_info("error opening %s: %s", path, err);
 	ret = -EINVAL;
 	goto out;
 }
 
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
-- 
1.8.4.rc0.5.g48765cc

