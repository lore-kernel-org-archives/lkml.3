Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648AbaGORPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:15:32 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:36558 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623AbaGORCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:11 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        stable@vger.kernel.org, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 34/94] ext4: disable synchronous transaction batching if max_batch_time==0
Date: Tue, 15 Jul 2014 20:00:49 +0300
Message-Id: <1405443709-15288-34-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

The mount manpage says of the max_batch_time option,

	This optimization can be turned off entirely
	by setting max_batch_time to 0.

But the code doesn't do that.  So fix the code to do
that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 fs/ext4/super.c       |    2 --
 fs/jbd2/transaction.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3423947..6297c07 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1525,8 +1525,6 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_max_batch_time) {
-		if (arg == 0)
-			arg = EXT4_DEF_MAX_BATCH_TIME;
 		sbi->s_max_batch_time = arg;
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 38cfcf5..6f0f590 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1588,9 +1588,12 @@ int jbd2_journal_stop(handle_t *handle)
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
1.7.10.4

