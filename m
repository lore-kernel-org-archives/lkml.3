Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaFYStN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:49:13 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:18954 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbaFYStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:49:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah8HAEkYq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZR6hECBDhd1hDEvI4EaN4hGAasRmBcXhWOJGR2ELQWPdIpdizaINYNEO4ExIg
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/1] FS/JBD:replace count*size kmalloc by kmalloc_array
Date: Wed, 25 Jun 2014 20:49:06 +0200
Message-Id: <1403722146-19657-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc_array manages count*sizeof overflow.

This patch also fixes checkpatch warnings:
ERROR: "(foo*)" should be "(foo *)"

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jbd/journal.c | 6 ++++--
 fs/jbd/revoke.c  | 2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 06fe11e..26ebba7 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -810,7 +810,8 @@ journal_t * journal_init_dev(struct block_device *bdev,
 	journal->j_blocksize = blocksize;
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
 			__func__);
@@ -871,7 +872,8 @@ journal_t * journal_init_inode (struct inode *inode)
 	/* journal descriptor can store up to n blocks -bzzz */
 	n = journal->j_blocksize / sizeof(journal_block_tag_t);
 	journal->j_wbufsize = n;
-	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
+	journal->j_wbuf = kmalloc_array(n, sizeof(struct buffer_head *),
+					GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Can't allocate bhs for commit thread\n",
 			__func__);
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 8898bbd..7374a57 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -241,7 +241,7 @@ static struct jbd_revoke_table_s *journal_init_revoke_table(int hash_size)
 	table->hash_size = hash_size;
 	table->hash_shift = ilog2(hash_size);
 	table->hash_table =
-		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
+		kmalloc_array(hash_size, sizeof(struct list_head), GFP_KERNEL);
 	if (!table->hash_table) {
 		kmem_cache_free(revoke_table_cache, table);
 		table = NULL;
-- 
1.9.1

