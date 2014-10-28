Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbaJ1Gb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:31:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaJ1Dvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:51:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 01/43] Btrfs: try not to ENOSPC on log replay
Date: Tue, 28 Oct 2014 11:35:59 +0800
Message-Id: <20141028033523.463317932@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 1d52c78afbbf80b58299e076a159617d6b42fe3c upstream.

When doing log replay we may have to update inodes, which traditionally goes
through our delayed inode stuff.  This will try to move space over from the
trans handle, but we don't reserve space in our trans handle on replay since we
don't know how much we will need, so instead we try to flush.  But because we
have a trans handle open we won't flush anything, so if we are out of reserve
space we will simply return ENOSPC.  Since we know that if an operation made it
into the log then we definitely had space before the box bought the farm then we
don't need to worry about doing this space reservation.  Use the
fs_info->log_root_recovering flag to skip the delayed inode stuff and update the
item directly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3545,7 +3545,8 @@ noinline int btrfs_update_inode(struct b
 	 * without delay
 	 */
 	if (!btrfs_is_free_space_inode(inode)
-	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID) {
+	    && root->root_key.objectid != BTRFS_DATA_RELOC_TREE_OBJECTID
+	    && !root->fs_info->log_root_recovering) {
 		btrfs_update_root_times(trans, root);
 
 		ret = btrfs_delayed_update_inode(trans, root, inode);


