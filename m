Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaBEUTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:19:55 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48562 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932372AbaBEUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Anatol Pomozov <anatol.pomozov@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 181/213] ext4: make orphan functions be no-op in no-journal mode
Date: Wed, 5 Feb 2014 15:02:16 -0500
Message-ID: <1391630568-49251-182-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anatol Pomozov <anatol.pomozov@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c9b92530a723ac5ef8e352885a1862b18f31b2f5 upstream.

Instead of checking whether the handle is valid, we check if journal
is enabled. This avoids taking the s_orphan_lock mutex in all cases
when there is no journal in use, including the error paths where
ext4_orphan_del() is called with a handle set to NULL.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/namei.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 683c0f9d8a83..d64e5f4f12ed 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2000,7 +2000,7 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle))
+	if (!EXT4_SB(sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2081,8 +2081,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
+	if (!EXT4_SB(inode->i_sb)->s_journal)
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
@@ -2101,7 +2100,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
-- 
1.8.5.2

