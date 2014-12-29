Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaL2BSE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:18:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33120 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751761AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Anatol Pomozov" <anatol.pomozov@gmail.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.843196711@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 15/27] ext4: make orphan functions be no-op in
 no-journal mode
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit c9b92530a723ac5ef8e352885a1862b18f31b2f5 upstream.

Instead of checking whether the handle is valid, we check if journal
is enabled. This avoids taking the s_orphan_lock mutex in all cases
when there is no journal in use, including the error paths where
ext4_orphan_del() is called with a handle set to NULL.

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Adjust context to apply after commit 0e9a9a1ad619
 ('ext4: avoid hang when mounting non-journal filesystems with orphan list')
 and commit e2bfb088fac0
 ('ext4: don't orphan or truncate the boot loader inode')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/namei.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1986,7 +1986,7 @@ int ext4_orphan_add(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0, rc;
 
-	if (!ext4_handle_valid(handle) || is_bad_inode(inode))
+	if (!EXT4_SB(sb)->s_journal || is_bad_inode(inode))
 		return 0;
 
 	mutex_lock(&EXT4_SB(sb)->s_orphan_lock);
@@ -2060,8 +2060,7 @@ int ext4_orphan_del(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle) &&
+	if (!EXT4_SB(inode->i_sb)->s_journal &&
 	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
@@ -2081,7 +2080,7 @@ int ext4_orphan_del(handle_t *handle, st
 	 * transaction handle with which to update the orphan list on
 	 * disk, but we still need to remove the inode from the linked
 	 * list in memory. */
-	if (sbi->s_journal && !handle)
+	if (!handle)
 		goto out;
 
 	err = ext4_reserve_inode_write(handle, inode, &iloc);

