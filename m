Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab3ERDDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:03:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758811Ab3ERDAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:31 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YJMUfa0AGmgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=natcC8j6lUsA:10 a=6rqHouBjAAAA:8 a=VwQbUJbxAAAA:8 a=kgtF5KMg6-PpXGdpY-0A:9 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021653.728813998@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 074/136 ] jbd2: fix race between jbd2_journal_remove_checkpoint and
 ->j_commit_callback
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0074-jbd2-fix-race-between-jbd2_journal_remove_checkpoint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

[ Upstream commit 794446c6946513c684d448205fbd76fa35f38b72 ]

The following race is possible:

[kjournald2]                              other_task
jbd2_journal_commit_transaction()
  j_state = T_FINISHED;
  spin_unlock(&journal->j_list_lock);
                                         ->jbd2_journal_remove_checkpoint()
					   ->jbd2_journal_free_transaction();
					     ->kmem_cache_free(transaction)
  ->j_commit_callback(journal, transaction);
    -> USE_AFTER_FREE

WARNING: at lib/list_debug.c:62 __list_del_entry+0x1c0/0x250()
Hardware name:
list_del corruption. prev->next should be ffff88019a4ec198, but was 6b6b6b6b6b6b6b6b
Modules linked in: cpufreq_ondemand acpi_cpufreq freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
Pid: 16400, comm: jbd2/dm-1-8 Tainted: G        W    3.8.0-rc3+ #107
Call Trace:
 [<ffffffff8106fb0d>] warn_slowpath_common+0xad/0xf0
 [<ffffffff8106fc06>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff813637e9>] ? ext4_journal_commit_callback+0x99/0xc0
 [<ffffffff8148cae0>] __list_del_entry+0x1c0/0x250
 [<ffffffff813637bf>] ext4_journal_commit_callback+0x6f/0xc0
 [<ffffffff813ca336>] jbd2_journal_commit_transaction+0x23a6/0x2570
 [<ffffffff8108aa42>] ? try_to_del_timer_sync+0x82/0xa0
 [<ffffffff8108b491>] ? del_timer_sync+0x91/0x1e0
 [<ffffffff813d3ecf>] kjournald2+0x19f/0x6a0
 [<ffffffff810ad630>] ? wake_up_bit+0x40/0x40
 [<ffffffff813d3d30>] ? bit_spin_lock+0x80/0x80
 [<ffffffff810ac6be>] kthread+0x10e/0x120
 [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff818ff6ac>] ret_from_fork+0x7c/0xb0
 [<ffffffff810ac5b0>] ? __init_kthread_worker+0x70/0x70

In order to demonstrace this issue one should mount ext4 with mount -o
discard option on SSD disk.  This makes callback longer and race
window becomes wider.

In order to fix this we should mark transaction as finished only after
callbacks have completed

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/jbd2/commit.c     |   50 ++++++++++++++++++++++++++++----------------------
 include/linux/jbd2.h |    1 +
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index af5280f..aa608d9 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -382,7 +382,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int space_left = 0;
 	int first_tag = 0;
 	int tag_flag;
-	int i, to_free = 0;
+	int i;
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
@@ -1108,7 +1108,7 @@ restart_loop:
 	journal->j_stats.run.rs_blocks_logged += stats.run.rs_blocks_logged;
 	spin_unlock(&journal->j_history_lock);
 
-	commit_transaction->t_state = T_FINISHED;
+	commit_transaction->t_state = T_COMMIT_CALLBACK;
 	J_ASSERT(commit_transaction == journal->j_committing_transaction);
 	journal->j_commit_sequence = commit_transaction->t_tid;
 	journal->j_committing_transaction = NULL;
@@ -1123,38 +1123,44 @@ restart_loop:
 				journal->j_average_commit_time*3) / 4;
 	else
 		journal->j_average_commit_time = commit_time;
+
 	write_unlock(&journal->j_state_lock);
 
-	if (commit_transaction->t_checkpoint_list == NULL &&
-	    commit_transaction->t_checkpoint_io_list == NULL) {
-		__jbd2_journal_drop_transaction(journal, commit_transaction);
-		to_free = 1;
+	if (journal->j_checkpoint_transactions == NULL) {
+		journal->j_checkpoint_transactions = commit_transaction;
+		commit_transaction->t_cpnext = commit_transaction;
+		commit_transaction->t_cpprev = commit_transaction;
 	} else {
-		if (journal->j_checkpoint_transactions == NULL) {
-			journal->j_checkpoint_transactions = commit_transaction;
-			commit_transaction->t_cpnext = commit_transaction;
-			commit_transaction->t_cpprev = commit_transaction;
-		} else {
-			commit_transaction->t_cpnext =
-				journal->j_checkpoint_transactions;
-			commit_transaction->t_cpprev =
-				commit_transaction->t_cpnext->t_cpprev;
-			commit_transaction->t_cpnext->t_cpprev =
-				commit_transaction;
-			commit_transaction->t_cpprev->t_cpnext =
+		commit_transaction->t_cpnext =
+			journal->j_checkpoint_transactions;
+		commit_transaction->t_cpprev =
+			commit_transaction->t_cpnext->t_cpprev;
+		commit_transaction->t_cpnext->t_cpprev =
+			commit_transaction;
+		commit_transaction->t_cpprev->t_cpnext =
 				commit_transaction;
-		}
 	}
 	spin_unlock(&journal->j_list_lock);
-
+	/* Drop all spin_locks because commit_callback may be block.
+	 * __journal_remove_checkpoint() can not destroy transaction
+	 * under us because it is not marked as T_FINISHED yet */
 	if (journal->j_commit_callback)
 		journal->j_commit_callback(journal, commit_transaction);
 
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
-	if (to_free)
-		jbd2_journal_free_transaction(commit_transaction);
 
+	write_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	commit_transaction->t_state = T_FINISHED;
+	/* Recheck checkpoint lists after j_list_lock was dropped */
+	if (commit_transaction->t_checkpoint_list == NULL &&
+	    commit_transaction->t_checkpoint_io_list == NULL) {
+		__jbd2_journal_drop_transaction(journal, commit_transaction);
+		jbd2_journal_free_transaction(commit_transaction);
+	}
+	spin_unlock(&journal->j_list_lock);
+	write_unlock(&journal->j_state_lock);
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index deee02a..ade60e7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -498,6 +498,7 @@ struct transaction_s
 		T_COMMIT,
 		T_COMMIT_DFLUSH,
 		T_COMMIT_JFLUSH,
+		T_COMMIT_CALLBACK,
 		T_FINISHED
 	}			t_state;
 
-- 
1.7.10.4


