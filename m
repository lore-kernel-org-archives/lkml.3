Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3FDWrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:47:09 -0400
Received: from 1wt.eu ([62.212.114.60]:35926 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab3FDWoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:44 -0400
Message-Id: <20130604172135.737485013@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 131/184] ext4: make orphan functions be no-op in no-journal
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 mode

From: Anatol Pomozov <anatol.pomozov@gmail.com>

Instead of checking whether the handle is valid, we check if journal
is enabled. This avoids taking the s_orphan_lock mutex in all cases
when there is no journal in use, including the error paths where
ext4_orphan_del() is called with a handle set to NULL.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 828c9c9..230bef5 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2001,7 +2001,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle))
+	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2082,8 +2082,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
+	if (!EXT4_SB(inode->i_sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
@@ -2102,7 +2101,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-- 
1.7.12.2.21.g234cd45.dirty



