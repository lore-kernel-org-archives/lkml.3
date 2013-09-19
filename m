Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3ISUqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 16:46:35 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:43241 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab3ISUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 16:46:34 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Sep 2013 16:46:34 EDT
From: Josh Durgin <josh.durgin@inktank.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Josh Durgin <josh.durgin@inktank.com>
Subject: [PATCH] block: check CAP_SYS_ADMIN before calling driver BLKROSET
Date: Thu, 19 Sep 2013 13:29:17 -0700
Message-Id: <1379622557-11042-1-git-send-email-josh.durgin@inktank.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling the driver-specific ioctl first, then bailing because
CAP_SYS_ADMIN is not set, can lead to an inconsistency between the
driver and the block layer, where one thinks the device is read only,
and the other considers it readwrite.

Fix this by checking the capability first, like the rest of the block
ioctls that require it. This bug was introduced pre-git in commit
23deaf89e3075b9271c7f48a2764ae3ed8f9573a.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
---
 block/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..6e5933e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -293,11 +293,11 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return 0;
 
 	case BLKROSET:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 		if (!is_unrecognized_ioctl(ret))
 			return ret;
-		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
 		set_device_ro(bdev, n);
-- 
1.7.2.5

