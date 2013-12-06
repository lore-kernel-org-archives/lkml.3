Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161840Ab3LFXNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:13:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48467 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161442Ab3LFXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Shiva Krishna Merla <shivakrishna.merla@netapp.com>,
        Mike Snitzer <snitzer@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 040/152] dm mpath: fix race condition between multipath_dtr and pg_init_done
Date: Fri,  6 Dec 2013 15:09:24 -0800
Message-Id: <1386371476-2477-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiva Krishna Merla <shivakrishna.merla@netapp.com>

commit 954a73d5d3073df2231820c718fdd2f18b0fe4c9 upstream.

Whenever multipath_dtr() is happening we must prevent queueing any
further path activation work.  Implement this by adding a new
'pg_init_disabled' flag to the multipath structure that denotes future
path activation work should be skipped if it is set.  By disabling
pg_init and then re-enabling in flush_multipath_work() we also avoid the
potential for pg_init to be initiated while suspending an mpath device.

Without this patch a race condition exists that may result in a kernel
panic:

1) If after pg_init_done() decrements pg_init_in_progress to 0, a call
   to wait_for_pg_init_completion() assumes there are no more pending path
   management commands.
2) If pg_init_required is set by pg_init_done(), due to retryable
   mode_select errors, then process_queued_ios() will again queue the
   path activation work.
3) If free_multipath() completes before activate_path() work is called a
   NULL pointer dereference like the following can be seen when
   accessing members of the recently destructed multipath:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
RIP: 0010:[<ffffffffa003db1b>]  [<ffffffffa003db1b>] activate_path+0x1b/0x30 [dm_multipath]
[<ffffffff81090ac0>] worker_thread+0x170/0x2a0
[<ffffffff81096c80>] ? autoremove_wake_function+0x0/0x40

[switch to disabling pg_init in flush_multipath_work & header edits by Mike Snitzer]
Signed-off-by: Shiva Krishna Merla <shivakrishna.merla@netapp.com>
Reviewed-by: Krishnasamy Somasundaram <somasundaram.krishnasamy@netapp.com>
Tested-by: Speagle Andy <Andy.Speagle@netapp.com>
Acked-by: Junichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-mpath.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 9f330c1..9d11b4e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -86,6 +86,7 @@ struct multipath {
 	unsigned queue_if_no_path:1;	/* Queue I/O if last path fails? */
 	unsigned saved_queue_if_no_path:1; /* Saved state during suspension */
 	unsigned retain_attached_hw_handler:1; /* If there's already a hw_handler present, don't change it. */
+	unsigned pg_init_disabled:1;	/* pg_init is not currently allowed */
 
 	unsigned pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned pg_init_count;		/* Number of times pg_init called */
@@ -497,7 +498,8 @@ static void process_queued_ios(struct work_struct *work)
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath)
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
+	    !m->pg_init_disabled)
 		__pg_init_all_paths(m);
 
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -941,10 +943,20 @@ static void multipath_wait_for_pg_init_completion(struct multipath *m)
 
 static void flush_multipath_work(struct multipath *m)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 1;
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	flush_workqueue(kmpath_handlerd);
 	multipath_wait_for_pg_init_completion(m);
 	flush_workqueue(kmultipathd);
 	flush_work(&m->trigger_event);
+
+	spin_lock_irqsave(&m->lock, flags);
+	m->pg_init_disabled = 0;
+	spin_unlock_irqrestore(&m->lock, flags);
 }
 
 static void multipath_dtr(struct dm_target *ti)
@@ -1163,7 +1175,7 @@ static int pg_init_limit_reached(struct multipath *m, struct pgpath *pgpath)
 
 	spin_lock_irqsave(&m->lock, flags);
 
-	if (m->pg_init_count <= m->pg_init_retries)
+	if (m->pg_init_count <= m->pg_init_retries && !m->pg_init_disabled)
 		m->pg_init_required = 1;
 	else
 		limit_reached = 1;
@@ -1689,7 +1701,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 5, 1},
+	.version = {1, 6, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
-- 
1.8.3.2

