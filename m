Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246AbaGOXYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:24:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934163AbaGOXO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.15 52/84] ext4: disable synchronous transaction batching if max_batch_time==0
Date: Tue, 15 Jul 2014 16:17:49 -0700
Message-Id: <20140715231714.764668295@linuxfoundation.org>
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

From: Eric Sandeen <sandeen@redhat.com>

commit 5dd214248f94d430d70e9230bda72f2654ac88a8 upstream.

The mount manpage says of the max_batch_time option,

	This optimization can be turned off entirely
	by setting max_batch_time to 0.

But the code doesn't do that.  So fix the code to do
that.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c       |    2 --
 fs/jbd2/transaction.c |    5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,8 +1524,6 @@ static int handle_mount_opt(struct super
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_max_batch_time) {
-		if (arg == 0)
-			arg = EXT4_DEF_MAX_BATCH_TIME;
 		sbi->s_max_batch_time = arg;
 	} else if (token == Opt_min_batch_time) {
 		sbi->s_min_batch_time = arg;
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


