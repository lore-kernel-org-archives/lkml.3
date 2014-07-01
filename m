Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbaGAQWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:22:42 -0400
Received: from zimbra13.linbit.com ([212.69.166.240]:53060 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbaGAQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:16:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 03/20] drbd: Remove unnecessary/unused code
Date: Tue,  1 Jul 2014 18:16:33 +0200
Message-Id: <1404231410-29852-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
References: <1404231410-29852-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Get rid of dump_stack() debug statements.

There is no point whatsoever in registering and unregistering a reboot
notifier that doesn't do anything.

The intention was to switch to an "emergency read-only" mode,
so we won't have to resync the full activity log just because
we had been Primary before the reboot.

Once we have that implemented, we may re-introduce the reboot notifier.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |  1 -
 drivers/block/drbd/drbd_main.c | 18 ------------------
 drivers/block/drbd/drbd_proc.c |  2 +-
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 72b5001..e306a22 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1468,7 +1468,6 @@ static inline void drbd_generic_make_request(struct drbd_device *device,
 		printk(KERN_ERR "drbd%d: drbd_generic_make_request: "
 				"bio->bi_bdev == NULL\n",
 		       device_to_minor(device));
-		dump_stack();
 		bio_endio(bio, -ENODEV);
 		return;
 	}
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 68ec774..7c06024 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2125,20 +2125,6 @@ Enomem:
 	return -ENOMEM;
 }
 
-static int drbd_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
-{
-	/* just so we have it.  you never know what interesting things we
-	 * might want to do here some day...
-	 */
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block drbd_notifier = {
-	.notifier_call = drbd_notify_sys,
-};
-
 static void drbd_release_all_peer_reqs(struct drbd_device *device)
 {
 	int rr;
@@ -2314,8 +2300,6 @@ static void drbd_cleanup(void)
 	struct drbd_device *device;
 	struct drbd_resource *resource, *tmp;
 
-	unregister_reboot_notifier(&drbd_notifier);
-
 	/* first remove proc,
 	 * drbdsetup uses it's presence to detect
 	 * whether DRBD is loaded.
@@ -2899,8 +2883,6 @@ static int __init drbd_init(void)
 		return err;
 	}
 
-	register_reboot_notifier(&drbd_notifier);
-
 	/*
 	 * allocate all necessary structs
 	 */
diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
index 46bb8dd..886f6be 100644
--- a/drivers/block/drbd/drbd_proc.c
+++ b/drivers/block/drbd/drbd_proc.c
@@ -299,7 +299,7 @@ static int drbd_proc_open(struct inode *inode, struct file *file)
 	int err;
 
 	if (try_module_get(THIS_MODULE)) {
-		err = single_open(file, drbd_seq_show, PDE_DATA(inode));
+		err = single_open(file, drbd_seq_show, NULL);
 		if (err)
 			module_put(THIS_MODULE);
 		return err;
-- 
1.9.1

