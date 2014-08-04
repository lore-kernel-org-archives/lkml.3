Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaHDQzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:55:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56633 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Eric Sandeen" <sandeen@redhat.com>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.603528683@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 27/94] ext4: disable synchronous transaction batching
 if max_batch_time==0
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: option parsing looks different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c       | 2 --
 fs/jbd2/transaction.c | 5 ++++-
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1663,8 +1663,6 @@ static int parse_options(char *options,
 				return 0;
 			if (option < 0)
 				return 0;
-			if (option == 0)
-				option = EXT4_DEF_MAX_BATCH_TIME;
 			sbi->s_max_batch_time = option;
 			break;
 		case Opt_min_batch_time:
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1388,9 +1388,12 @@ int jbd2_journal_stop(handle_t *handle)
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

