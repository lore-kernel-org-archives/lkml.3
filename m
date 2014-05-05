Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaEEMue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41034 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932320AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Derek Basehore <dbasehore@chromium.org>,
        Alexander Viro <viro@zento.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, Benson Leung <bleung@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        Luigi Semenzato <semenzato@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Dave Chinner <david@fromorbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 17/50] backing_dev: fix hung task on sync
Date: Mon,  5 May 2014 14:42:59 +0200
Message-Id: <24239843f9734736d15bc22003a3c2467b7f0fb1.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Derek Basehore <dbasehore@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6ca738d60c563d5c6cf6253ee4b8e76fa77b2b9e upstream.

bdi_wakeup_thread_delayed() used the mod_delayed_work() function to
schedule work to writeback dirty inodes.  The problem with this is that
it can delay work that is scheduled for immediate execution, such as the
work from sync_inodes_sb().  This can happen since mod_delayed_work()
can now steal work from a work_queue.  This fixes the problem by using
queue_delayed_work() instead.  This is a regression caused by commit
839a8e8660b6 ("writeback: replace custom worker pool implementation with
unbound workqueue").

The reason that this causes a problem is that laptop-mode will change
the delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.
In the case that bdi_wakeup_thread_delayed() races with
sync_inodes_sb(), sync will be stopped for 10 minutes and trigger a hung
task.  Even if dirty_writeback_centisecs is not long enough to cause a
hung task, we still don't want to delay sync for that long.

We fix the problem by using queue_delayed_work() when we want to
schedule writeback sometime in future.  This function doesn't change the
timer if it is already armed.

For the same reason, we also change bdi_writeback_workfn() to
immediately queue the work again in the case that the work_list is not
empty.  The same problem can happen if the sync work is run on the
rescue worker.

[jack@suse.cz: update changelog, add comment, use bdi_wakeup_thread_delayed()]
Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zento.linux.org.uk>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Derek Basehore <dbasehore@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Luigi Semenzato <semenzato@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/fs-writeback.c | 8 ++++----
 mm/backing-dev.c  | 5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3595180b62ac..6abd284754e2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1038,10 +1038,10 @@ void bdi_writeback_workfn(struct work_struct *work)
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
1.9.2

