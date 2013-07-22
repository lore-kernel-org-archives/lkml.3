Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3GVQZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:25:15 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:50899 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3GVQKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:04 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/48] staging/lustre/llite: use READ, WRITE around ll_rw_stats_tally()
Date: Tue, 23 Jul 2013 00:06:24 +0800
Message-Id: <1374509230-3324-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In vvp_io_write_start() the stats function ll_rw_stats_tally() was
incorrectly called with a rw argument of 0. Correct this and use the
macros READ and WRITE in and around ll_rw_stats_tally() for clarity.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3384
Lustre-change: http://review.whamcloud.com/6447
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/lproc_llite.c |   10 ++++++----
 drivers/staging/lustre/lustre/llite/vvp_io.c      |    4 ++--
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 5c7368c..a7b12fd 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -1303,8 +1303,9 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 	/* We stored the discontiguous offsets here; print them first */
 	for(i = 0; i < LL_OFFSET_HIST_MAX; i++) {
 		if (offset[i].rw_pid != 0)
-			seq_printf(seq,"%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
-				   offset[i].rw_op ? 'W' : 'R',
+			seq_printf(seq,
+				   "%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
+				   offset[i].rw_op == READ ? 'R' : 'W',
 				   offset[i].rw_pid,
 				   offset[i].rw_range_start,
 				   offset[i].rw_range_end,
@@ -1315,8 +1316,9 @@ static int ll_rw_offset_stats_seq_show(struct seq_file *seq, void *v)
 	/* Then print the current offsets for each process */
 	for(i = 0; i < LL_PROCESS_HIST_MAX; i++) {
 		if (process[i].rw_pid != 0)
-			seq_printf(seq,"%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
-				   process[i].rw_op ? 'W' : 'R',
+			seq_printf(seq,
+				   "%3c %10d %14Lu %14Lu %17lu %17lu %14Lu",
+				   process[i].rw_op == READ ? 'R' : 'W',
 				   process[i].rw_pid,
 				   process[i].rw_range_start,
 				   process[i].rw_last_file_pos,
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index eb964ac..c24dc268 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -525,7 +525,7 @@ out:
 			io->ci_continue = 0;
 		io->ci_nob += result;
 		ll_rw_stats_tally(ll_i2sbi(inode), current->pid,
-				  cio->cui_fd, pos, result, 0);
+				  cio->cui_fd, pos, result, READ);
 		result = 0;
 	}
 	return result;
@@ -580,7 +580,7 @@ static int vvp_io_write_start(const struct lu_env *env,
 			io->ci_continue = 0;
 		io->ci_nob += result;
 		ll_rw_stats_tally(ll_i2sbi(inode), current->pid,
-				  cio->cui_fd, pos, result, 0);
+				  cio->cui_fd, pos, result, WRITE);
 		result = 0;
 	}
 	RETURN(result);
-- 
1.7.9.5

