Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaIKMdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:33:36 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:47844 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbaIKM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:29:18 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 5/9] drbd: Get rid of the __no_warn and __cond_lock macros
Date: Thu, 11 Sep 2014 14:29:09 +0200
Message-Id: <1410438553-30440-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
References: <1410438553-30440-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>

These macros can easily be replaced with its definition.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    | 11 ++++++-----
 drivers/block/drbd/drbd_worker.c |  9 ++++++---
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index f424dc0..9b22f8f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -61,8 +61,6 @@
 # define __must_hold(x)
 #endif
 
-#define __no_warn(lock, stmt) do { __acquire(lock); stmt; __release(lock); } while (0)
-
 /* module parameter, defined in drbd_main.c */
 extern unsigned int minor_count;
 extern bool disable_sendpage;
@@ -2100,12 +2098,15 @@ static inline bool is_sync_state(enum drbd_conns connection_state)
 
 /**
  * get_ldev() - Increase the ref count on device->ldev. Returns 0 if there is no ldev
- * @M:		DRBD device.
+ * @_device:		DRBD device.
+ * @_min_state:		Minimum device state required for success.
  *
  * You have to call put_ldev() when finished working with device->ldev.
  */
-#define get_ldev(M) __cond_lock(local, _get_ldev_if_state(M,D_INCONSISTENT))
-#define get_ldev_if_state(M,MINS) __cond_lock(local, _get_ldev_if_state(M,MINS))
+#define get_ldev_if_state(_device, _min_state)				\
+	(_get_ldev_if_state((_device), (_min_state)) ?			\
+	 ({ __acquire(x); true; }) : false)
+#define get_ldev(_device) get_ldev_if_state(_device, D_INCONSISTENT)
 
 static inline void put_ldev(struct drbd_device *device)
 {
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 6e01e62..b20cd21 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1853,9 +1853,12 @@ static void drbd_ldev_destroy(struct drbd_device *device)
 	device->resync = NULL;
 	lc_destroy(device->act_log);
 	device->act_log = NULL;
-	__no_warn(local,
-		drbd_free_ldev(device->ldev);
-		device->ldev = NULL;);
+
+	__acquire(local);
+	drbd_free_ldev(device->ldev);
+	device->ldev = NULL;
+	__release(local);
+
 	clear_bit(GOING_DISKLESS, &device->flags);
 	wake_up(&device->misc_wait);
 }
-- 
1.9.1

