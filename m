Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152AbaGRNli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:41:38 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17640 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934950AbaGRNM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:12:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 159/170] ext4: disable synchronous transaction batching if max_batch_time==0
Date: Fri, 18 Jul 2014 14:12:44 +0200
Message-Id: <14e64d74cf337c8edcce44a09490af720f31c3e1.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5dd214248f94d430d70e9230bda72f2654ac88a8 upstream.

The mount manpage says of the max_batch_time option,

	This optimization can be turned off entirely
	by setting max_batch_time to 0.

But the code doesn't do that.  So fix the code to do
that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/super.c       | 2 --
 fs/jbd2/transaction.c | 5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a8b886851ff6..9afc4ba21611 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1500,8 +1500,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_max_batch_time) {
-		if (arg == 0)
-			arg = EXT4_DEF_MAX_BATCH_TIME;
 		sbi->s_max_batch_time = arg;
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 7272cc6977ec..ab3815c856dc 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1590,9 +1590,12 @@ int jbd2_journal_stop(handle_t *handle)
 	 * to perform a synchronous write.  We do this to detect the
 	 * case where a single process is doing a stream of sync
 	 * writes.  No point in waiting for joiners in that case.
+	 *
+	 * Setting max_batch_time to 0 disables this completely.
 	 */
 	pid = current->pid;
-	if (handle->h_sync && journal->j_last_sync_writer != pid) {
+	if (handle->h_sync && journal->j_last_sync_writer != pid &&
+	    journal->j_max_batch_time) {
 		u64 commit_time, trans_time;
 
 		journal->j_last_sync_writer = pid;
-- 
2.0.0

