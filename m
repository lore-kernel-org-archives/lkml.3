Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbaIOVUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:20:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaIOT0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3.16 002/158] reiserfs: Fix use after free in journal teardown
Date: Mon, 15 Sep 2014 12:24:01 -0700
Message-Id: <20140915192542.947905753@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/journal.c |   22 ++++++++++++++++------
 fs/reiserfs/super.c   |    6 +++++-
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -1947,8 +1947,6 @@ static int do_journal_release(struct rei
 		}
 	}
 
-	/* wait for all commits to finish */
-	cancel_delayed_work(&SB_JOURNAL(sb)->j_work);
 
 	/*
 	 * We must release the write lock here because
@@ -1956,8 +1954,14 @@ static int do_journal_release(struct rei
 	 */
 	reiserfs_write_unlock(sb);
 
+	/*
+	 * Cancel flushing of old commits. Note that neither of these works
+	 * will be requeued because superblock is being shutdown and doesn't
+	 * have MS_ACTIVE set.
+	 */
 	cancel_delayed_work_sync(&REISERFS_SB(sb)->old_work);
-	flush_workqueue(REISERFS_SB(sb)->commit_wq);
+	/* wait for all commits to finish */
+	cancel_delayed_work_sync(&SB_JOURNAL(sb)->j_work);
 
 	free_journal_ram(sb);
 
@@ -4292,9 +4296,15 @@ static int do_journal_end(struct reiserf
 	if (flush) {
 		flush_commit_list(sb, jl, 1);
 		flush_journal_list(sb, jl, 1);
-	} else if (!(jl->j_state & LIST_COMMIT_PENDING))
-		queue_delayed_work(REISERFS_SB(sb)->commit_wq,
-				   &journal->j_work, HZ / 10);
+	} else if (!(jl->j_state & LIST_COMMIT_PENDING)) {
+		/*
+		 * Avoid queueing work when sb is being shut down. Transaction
+		 * will be flushed on journal shutdown.
+		 */
+		if (sb->s_flags & MS_ACTIVE)
+			queue_delayed_work(REISERFS_SB(sb)->commit_wq,
+					   &journal->j_work, HZ / 10);
+	}
 
 	/*
 	 * if the next transaction has any chance of wrapping, flush
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -100,7 +100,11 @@ void reiserfs_schedule_old_flush(struct
 	struct reiserfs_sb_info *sbi = REISERFS_SB(s);
 	unsigned long delay;
 
-	if (s->s_flags & MS_RDONLY)
+	/*
+	 * Avoid scheduling flush when sb is being shut down. It can race
+	 * with journal shutdown and free still queued delayed work.
+	 */
+	if (s->s_flags & MS_RDONLY || !(s->s_flags & MS_ACTIVE))
 		return;
 
 	spin_lock(&sbi->old_work_lock);


