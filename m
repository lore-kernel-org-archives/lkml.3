Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbaIKMw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:52:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kara" <jack@suse.cz>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.441380773@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 062/131] reiserfs: Fix use after free in journal teardown
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 01777836c87081e4f68c4a43c9abe6114805f91e upstream.

If do_journal_release() races with do_journal_end() which requeues
delayed works for transaction flushing, we can leave work items for
flushing outstanding transactions queued while freeing them. That
results in use after free and possible crash in run_timers_softirq().

Fix the problem by not requeueing works if superblock is being shut down
(MS_ACTIVE not set) and using cancel_delayed_work_sync() in
do_journal_release().

Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.2:
 - Adjust context
 - commit_wq is global, not per-superblock
 - Change comment about 'these works'; we only have one work item
 - Drop inapplicable changes to reiserfs_schedule_old_flush()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1916,15 +1916,19 @@ static int do_journal_release(struct rei
 	}
 
 	reiserfs_mounted_fs_count--;
-	/* wait for all commits to finish */
-	cancel_delayed_work(&SB_JOURNAL(sb)->j_work);
 
 	/*
 	 * We must release the write lock here because
 	 * the workqueue job (flush_async_commit) needs this lock
 	 */
 	reiserfs_write_unlock(sb);
-	flush_workqueue(commit_wq);
+	/*
+	 * Cancel flushing of old commits. Note that this work will not
+	 * be requeued because superblock is being shutdown and doesn't
+	 * have MS_ACTIVE set.
+	 */
+	/* wait for all commits to finish */
+	cancel_delayed_work_sync(&SB_JOURNAL(sb)->j_work);
 
 	if (!reiserfs_mounted_fs_count) {
 		destroy_workqueue(commit_wq);
@@ -4211,8 +4215,15 @@ static int do_journal_end(struct reiserf
 	if (flush) {
 		flush_commit_list(sb, jl, 1);
 		flush_journal_list(sb, jl, 1);
-	} else if (!(jl->j_state & LIST_COMMIT_PENDING))
-		queue_delayed_work(commit_wq, &journal->j_work, HZ / 10);
+	} else if (!(jl->j_state & LIST_COMMIT_PENDING)) {
+		/*
+		 * Avoid queueing work when sb is being shut down. Transaction
+		 * will be flushed on journal shutdown.
+		 */
+		if (sb->s_flags & MS_ACTIVE)
+			queue_delayed_work(commit_wq,
+					   &journal->j_work, HZ / 10);
+	}
 
 	/* if the next transaction has any chance of wrapping, flush
 	 ** transactions that might get overwritten.  If any journal lists are very

