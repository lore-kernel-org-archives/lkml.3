Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030285AbaGOXjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:39:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933333AbaGOXOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.15 43/84] dm: allocate a special workqueue for deferred device removal
Date: Tue, 15 Jul 2014 16:17:40 -0700
Message-Id: <20140715231714.494756078@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -54,6 +54,8 @@ static void do_deferred_remove(struct wo
 
 static DECLARE_WORK(deferred_remove_work, do_deferred_remove);
 
+static struct workqueue_struct *deferred_remove_workqueue;
+
 /*
  * For bio-based dm.
  * One of these is allocated per bio.
@@ -276,16 +278,24 @@ static int __init local_init(void)
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
@@ -299,6 +309,7 @@ out_free_io_cache:
 static void local_exit(void)
 {
 	flush_scheduled_work();
+	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_io_cache);
@@ -407,7 +418,7 @@ static void dm_blk_close(struct gendisk
 
 	if (atomic_dec_and_test(&md->open_count) &&
 	    (test_bit(DMF_DEFERRED_REMOVE, &md->flags)))
-		schedule_work(&deferred_remove_work);
+		queue_work(deferred_remove_workqueue, &deferred_remove_work);
 
 	dm_put(md);
 


