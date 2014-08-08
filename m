Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaHHVYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:24:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40881 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaHHUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 069/259] ext4: disable synchronous transaction batching if max_batch_time==0
Date: Fri,  8 Aug 2014 13:38:12 -0700
Message-Id: <1407530482-4483-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

commit 5dd214248f94d430d70e9230bda72f2654ac88a8 upstream.

The mount manpage says of the max_batch_time option,

	This optimization can be turned off entirely
	by setting max_batch_time to 0.

But the code doesn't do that.  So fix the code to do
that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c       | 2 --
 fs/jbd2/transaction.c | 5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a81a3da..25b327e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1519,8 +1519,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_max_batch_time) {
-		if (arg == 0)
-			arg = EXT4_DEF_MAX_BATCH_TIME;
 		sbi->s_max_batch_time = arg;
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 60bb365..f8a5d6a 100644
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
1.9.1

