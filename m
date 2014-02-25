Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaBYW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:29:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaBYW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:29:27 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Derek Basehore <dbasehore@chromium.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/2] bdi: Fix hung task on sync
Date: Tue, 25 Feb 2014 23:29:13 +0100
Message-Id: <1393367354-5172-2-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393367354-5172-1-git-send-email-jack@suse.cz>
References: <1393367354-5172-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derek Basehore <dbasehore@chromium.org>

bdi_wakeup_thread_delayed() used the mod_delayed_work() function to
schedule work to writeback dirty inodes. The problem with this is that
it can delay work that is scheduled for immediate execution, such as the
work from sync_inodes_sb().  This can happen since mod_delayed_work()
can now steal work from a work_queue.  This fixes the problem by using
queue_delayed_work() instead. This is a regression caused by
839a8e8660b6 "writeback: replace custom worker pool implementation with
unbound workqueue".

The reason that this causes a problem is that laptop-mode will change
the delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.
In the case that bdi_wakeup_thread_delayed() races with
sync_inodes_sb(), sync will be stopped for 10 minutes and trigger a hung
task. Even if dirty_writeback_centisecs is not long enough to cause a
hung task, we still don't want to delay sync for that long.

We fix the problem by using queue_delayed_work() when we want to
schedule writeback sometime in future. This function doesn't change the
timer if it is already armed.

For the same reason, we also change bdi_writeback_workfn() to
immediately queue the work again in the case that the work_list is not
empty. The same problem can happen if the sync work is run on the rescue
worker.

Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977
CC: stable@vger.kernel.org
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 8 ++++----
 mm/backing-dev.c  | 5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e0259a163f98..8277b76be983 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1047,10 +1047,10 @@ void bdi_writeback_workfn(struct work_struct *work)
 		trace_writeback_pages_written(pages_written);
 	}
 
-	if (!list_empty(&bdi->work_list) ||
-	    (wb_has_dirty_io(wb) && dirty_writeback_interval))
-		queue_delayed_work(bdi_wq, &wb->dwork,
-			msecs_to_jiffies(dirty_writeback_interval * 10));
+	if (!list_empty(&bdi->work_list))
+		mod_delayed_work(bdi_wq, &wb->dwork, 0);
+	else if (wb_has_dirty_io(wb) && dirty_writeback_interval)
+		bdi_wakeup_thread_delayed(bdi);
 
 	current->flags &= ~PF_SWAPWRITE;
 }
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index ce682f7a4f29..fab8401fc54e 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -288,13 +288,16 @@ int bdi_has_dirty_io(struct backing_dev_info *bdi)
  * Note, we wouldn't bother setting up the timer, but this function is on the
  * fast-path (used by '__mark_inode_dirty()'), so we save few context switches
  * by delaying the wake-up.
+ *
+ * We have to be careful not to postpone flush work if it is scheduled for
+ * earlier. Thus we use queue_delayed_work().
  */
 void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
 {
 	unsigned long timeout;
 
 	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
-	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
+	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
 }
 
 /*
-- 
1.8.1.4

