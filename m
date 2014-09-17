Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaIQLlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 07:41:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbaIQLk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 07:40:58 -0400
From: Aaron Tomlin <atomlin@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, atomlin@redhat.com,
        oleg@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        mguzik@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fs: Use a seperate wq for do_sync_work() to avoid a potential deadlock
Date: Wed, 17 Sep 2014 12:39:02 +0100
Message-Id: <1410953942-32144-1-git-send-email-atomlin@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since do_sync_work() is a deferred function it can block indefinitely by
design. At present do_sync_work() is added to the global system_wq.
As such a deadlock is theoretically possible between sys_unmount() and
sync_filesystems():

  * The current work fn on the system_wq (do_sync_work()) is blocked
    waiting to aquire a sb's s_umount for reading.

  * The "umount" task is the current owner of the s_umount in
    question but is waiting for do_sync_work() to continue.
    Thus we hit a deadlock situation.

This patch introduces a separate workqueue for do_sync_work() to avoid a
the described deadlock.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Reviewed-by: Alexander Viro <viro@zeniv.linux.org.uk>
---
 fs/sync.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index bdc729d..df455d0 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/quotaops.h>
 #include <linux/backing-dev.h>
+#include <linux/kthread.h>
 #include "internal.h"
 
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
@@ -114,7 +115,7 @@ SYSCALL_DEFINE0(sync)
 	return 0;
 }
 
-static void do_sync_work(struct work_struct *work)
+static int do_sync_work(void *dummy)
 {
 	int nowait = 0;
 
@@ -129,18 +130,12 @@ static void do_sync_work(struct work_struct *work)
 	iterate_supers(sync_fs_one_sb, &nowait);
 	iterate_bdevs(fdatawrite_one_bdev, NULL);
 	printk("Emergency Sync complete\n");
-	kfree(work);
+	return 0;
 }
 
 void emergency_sync(void)
 {
-	struct work_struct *work;
-
-	work = kmalloc(sizeof(*work), GFP_ATOMIC);
-	if (work) {
-		INIT_WORK(work, do_sync_work);
-		schedule_work(work);
-	}
+	kthread_run(do_sync_work, NULL, "sync_work_thread");
 }
 
 /*
-- 
1.9.3

