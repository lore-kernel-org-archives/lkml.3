Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbbAFTUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:20:44 -0500
Received: from mail.kernel.org ([198.145.29.136]:43549 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbbAFTUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:20:42 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] f2fs: avoid potential unnecessary codes
Date: Tue,  6 Jan 2015 11:20:32 -0800
Message-Id: <1420572034-53758-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1420572034-53758-1-git-send-email-jaegeuk@kernel.org>
References: <1420572034-53758-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch relocates some operations to avoid unnecessary execution.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 5 +++--
 fs/f2fs/node.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2c0cb66..155885b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -299,8 +299,6 @@ void update_extent_cache(struct dnode_of_data *dn)
 	int need_update = true;
 
 	f2fs_bug_on(F2FS_I_SB(dn->inode), dn->data_blkaddr == NEW_ADDR);
-	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
-							dn->ofs_in_node;
 
 	/* Update the page address in the parent node */
 	__set_data_blkaddr(dn);
@@ -308,6 +306,9 @@ void update_extent_cache(struct dnode_of_data *dn)
 	if (is_inode_flag_set(fi, FI_NO_EXTENT))
 		return;
 
+	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
+							dn->ofs_in_node;
+
 	write_lock(&fi->ext.ext_lock);
 
 	start_fofs = fi->ext.fofs;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a7cb0db..9bed016 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -348,7 +348,6 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t nid, struct node_info *ni)
 	struct nat_entry *e;
 	int i;
 
-	memset(&ne, 0, sizeof(struct f2fs_nat_entry));
 	ni->nid = nid;
 
 	/* Check nat cache */
@@ -363,6 +362,8 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t nid, struct node_info *ni)
 	if (e)
 		return;
 
+	memset(&ne, 0, sizeof(struct f2fs_nat_entry));
+
 	/* Check current segment summary */
 	mutex_lock(&curseg->curseg_mutex);
 	i = lookup_journal_in_cursum(sum, NAT_JOURNAL, nid, 0);
-- 
2.1.1

