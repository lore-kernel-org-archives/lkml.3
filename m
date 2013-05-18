Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab3ERDEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:04:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32671 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758733Ab3ERDAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:30 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=AlBoplBjjYYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=b9Nr5StIqZwA:10 a=6rqHouBjAAAA:8 a=u05PGdd5AAAA:8 a=M7LX_DECYEPQXPigYpAA:9 a=TAmEwCHjoHMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021653.891772469@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, "Theodore Tso" <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, <stable@vger.kernel.com>
Subject: [ 075/136 ] ext4: fix journal callback list traversal
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0075-ext4-fix-journal-callback-list-traversal.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Dmitry Monakhov <dmonakhov@openvz.org>

[ Upstream commit 5d3ee20855e28169d711b394857ee608a5023094 ]

It is incorrect to use list_for_each_entry_safe() for journal callback
traversial because ->next may be removed by other task:
->ext4_mb_free_metadata()
  ->ext4_mb_free_metadata()
    ->ext4_journal_callback_del()

This results in the following issue:

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

This patch fix the issue as follows:
- ext4_journal_commit_callback() make list truly traversial safe
  simply by always starting from list_head
- fix race between two ext4_journal_callback_del() and
  ext4_journal_callback_try_del()

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/ext4_jbd2.h |    6 +++++-
 fs/ext4/mballoc.c   |    8 ++++----
 fs/ext4/super.c     |    7 +++++--
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 56d258c..1a27af3 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -170,16 +170,20 @@ static inline void ext4_journal_callback_add(handle_t *handle,
  * ext4_journal_callback_del: delete a registered callback
  * @handle: active journal transaction handle on which callback was registered
  * @jce: registered journal callback entry to unregister
+ * Return true if object was sucessfully removed
  */
-static inline void ext4_journal_callback_del(handle_t *handle,
+static inline bool ext4_journal_callback_try_del(handle_t *handle,
 					     struct ext4_journal_cb_entry *jce)
 {
+	bool deleted;
 	struct ext4_sb_info *sbi =
 			EXT4_SB(handle->h_transaction->t_journal->j_private);
 
 	spin_lock(&sbi->s_md_lock);
+	deleted = !list_empty(&jce->jce_list);
 	list_del_init(&jce->jce_list);
 	spin_unlock(&sbi->s_md_lock);
+	return deleted;
 }
 
 int
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 87b5519..773d341 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4438,11 +4438,11 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_prev(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(entry, new_entry)) {
+		if (can_merge(entry, new_entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_start_cluster = entry->efd_start_cluster;
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
@@ -4450,10 +4450,10 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	node = rb_next(new_node);
 	if (node) {
 		entry = rb_entry(node, struct ext4_free_data, efd_node);
-		if (can_merge(new_entry, entry)) {
+		if (can_merge(new_entry, entry) &&
+		    ext4_journal_callback_try_del(handle, &entry->efd_jce)) {
 			new_entry->efd_count += entry->efd_count;
 			rb_erase(node, &(db->bb_free_root));
-			ext4_journal_callback_del(handle, &entry->efd_jce);
 			kmem_cache_free(ext4_free_data_cachep, entry);
 		}
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f581886..f9b129c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -452,10 +452,13 @@ static void ext4_journal_commit_callback(journal_t *journal, transaction_t *txn)
 	struct super_block		*sb = journal->j_private;
 	struct ext4_sb_info		*sbi = EXT4_SB(sb);
 	int				error = is_journal_aborted(journal);
-	struct ext4_journal_cb_entry	*jce, *tmp;
+	struct ext4_journal_cb_entry	*jce;
 
+	BUG_ON(txn->t_state == T_FINISHED);
 	spin_lock(&sbi->s_md_lock);
-	list_for_each_entry_safe(jce, tmp, &txn->t_private_list, jce_list) {
+	while (!list_empty(&txn->t_private_list)) {
+		jce = list_entry(txn->t_private_list.next,
+				 struct ext4_journal_cb_entry, jce_list);
 		list_del_init(&jce->jce_list);
 		spin_unlock(&sbi->s_md_lock);
 		jce->jce_func(sb, jce, error);
-- 
1.7.10.4


