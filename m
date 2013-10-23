Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3JWJJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:09:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48158 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3JWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH 1/5] drbd: fix NULL pointer deref in module init error path
Date: Wed, 23 Oct 2013 10:59:15 +0200
Message-Id: <1382518759-5467-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
References: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

If we want to iterate over the (as of yet still empty) list in the
cleanup path, we need to initialize the list before the first goto fail.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55635ed..9e3818b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2750,13 +2750,6 @@ int __init drbd_init(void)
 		return err;
 	}
 
-	err = drbd_genl_register();
-	if (err) {
-		printk(KERN_ERR "drbd: unable to register generic netlink family\n");
-		goto fail;
-	}
-
-
 	register_reboot_notifier(&drbd_notifier);
 
 	/*
@@ -2767,6 +2760,15 @@ int __init drbd_init(void)
 	drbd_proc = NULL; /* play safe for drbd_cleanup */
 	idr_init(&minors);
 
+	rwlock_init(&global_state_lock);
+	INIT_LIST_HEAD(&drbd_tconns);
+
+	err = drbd_genl_register();
+	if (err) {
+		printk(KERN_ERR "drbd: unable to register generic netlink family\n");
+		goto fail;
+	}
+
 	err = drbd_create_mempools();
 	if (err)
 		goto fail;
@@ -2778,9 +2780,6 @@ int __init drbd_init(void)
 		goto fail;
 	}
 
-	rwlock_init(&global_state_lock);
-	INIT_LIST_HEAD(&drbd_tconns);
-
 	retry.wq = create_singlethread_workqueue("drbd-reissue");
 	if (!retry.wq) {
 		printk(KERN_ERR "drbd: unable to create retry workqueue\n");
-- 
1.7.9.5

