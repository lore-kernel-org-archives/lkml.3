Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3GKOZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42886 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617Ab3GKOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/98] jbd2: move superblock checksum calculation to jbd2_write_superblock()
Date: Thu, 11 Jul 2013 15:23:46 +0100
Message-Id: <1373552708-15235-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit fe52d17cdd343ac43c85cf72940a58865b9d3bfb upstream.

Some of the functions which modify the jbd2 superblock were not
updating the checksum before calling jbd2_write_superblock().  Move
the call to jbd2_superblock_csum_set() to jbd2_write_superblock(), so
that the checksum is calculated consistently.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index dfb0e5b..34cdd6d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1304,6 +1304,7 @@ static int journal_reset(journal_t *journal)
 static void jbd2_write_superblock(journal_t *journal, int write_op)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
+	journal_superblock_t *sb = journal->j_superblock;
 	int ret;
 
 	trace_jbd2_write_superblock(journal, write_op);
@@ -1325,6 +1326,7 @@ static void jbd2_write_superblock(journal_t *journal, int write_op)
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
 	}
+	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
 	ret = submit_bh(write_op, bh);
@@ -1421,7 +1423,6 @@ void jbd2_journal_update_sb_errno(journal_t *journal)
 	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
 		  journal->j_errno);
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
-	jbd2_superblock_csum_set(journal, sb);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_SYNC);
-- 
1.8.1.2

