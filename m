Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaHHU4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:56:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41511 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbaHHUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 091/259] dm: allocate a special workqueue for deferred device removal
Date: Fri,  8 Aug 2014 13:38:34 -0700
Message-Id: <1407530482-4483-92-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit acfe0ad74d2e1bfc81d1d7bf5e15b043985d3650 upstream.

The commit 2c140a246dc ("dm: allow remove to be deferred") introduced a
deferred removal feature for the device mapper.  When this feature is
used (by passing a flag DM_DEFERRED_REMOVE to DM_DEV_REMOVE_CMD ioctl)
and the user tries to remove a device that is currently in use, the
device will be removed automatically in the future when the last user
closes it.

Device mapper used the system workqueue to perform deferred removals.
However, some targets (dm-raid1, dm-mpath, dm-stripe) flush work items
scheduled for the system workqueue from their destructor.  If the
destructor itself is called from the system workqueue during deferred
removal, it introduces a possible deadlock - the workqueue tries to flush
itself.

Fix this possible deadlock by introducing a new workqueue for deferred
removals.  We allocate just one workqueue for all dm targets.  The
ability of dm targets to process IOs isn't dependent on deferred removal
of unused targets, so a deadlock due to shared workqueue isn't possible.

Also, cleanup local_init() to eliminate potential for returning success
on failure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b49c762..72859fa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -54,6 +54,8 @@ static void do_deferred_remove(struct work_struct *w);
 
 static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
+static struct workqueue_struct *deferred_remove_workqueue;
+
 /*
  * For bio-based dm.
  * One of these is allocated per bio.
@@ -283,16 +285,24 @@ static int __init local_init(void)
 	if (r)
 		goto out_free_rq_tio_cache;
 
+	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
+	if (!deferred_remove_workqueue) {
+		r = -ENOMEM;
+		goto out_uevent_exit;
+	}
+
 	_major = major;
 	r = register_blkdev(_major, _name);
 	if (r < 0)
-		goto out_uevent_exit;
+		goto out_free_workqueue;
 
 	if (!_major)
 		_major = r;
 
 	return 0;
 
+out_free_workqueue:
+	destroy_workqueue(deferred_remove_workqueue);
 out_uevent_exit:
 	dm_uevent_exit();
 out_free_rq_tio_cache:
@@ -306,6 +316,7 @@ out_free_io_cache:
 static void local_exit(void)
 {
 	flush_scheduled_work();
+	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_io_cache);
@@ -414,7 +425,7 @@ static void dm_blk_close(struct gendisk *disk, fmode_t mode)
 
 	if (atomic_dec_and_test(&md->open_count) &&
 	    (test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
-		schedule_work(&deferred_remove_work);
+		queue_work(deferred_remove_workqueue, &deferred_remove_work);
 
 	dm_put(md);
 
-- 
1.9.1

