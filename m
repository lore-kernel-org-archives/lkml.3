Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760086Ab3DBXKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:10:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab3DBWM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 054/124] Btrfs: use set_nlink if our i_nlink is 0
Date: Tue,  2 Apr 2013 15:10:36 -0700
Message-Id: <20130402221110.485998030@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 9bf7a4890518186238d2579be16ecc5190a707c0 upstream.

We need to inc the nlink of deleted entries when running replay so we can do the
unlink on the fs_root and get everything cleaned up and then have the orphan
cleanup do the right thing.  The problem is inc_nlink complains about this, even
thought it still does the right thing.  So use set_nlink() if our i_nlink is 0
to keep users from seeing the warnings during log replay.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1384,7 +1384,10 @@ static noinline int link_to_fixup_dir(st
 
 	btrfs_release_path(path);
 	if (ret == 0) {
-		btrfs_inc_nlink(inode);
+		if (!inode->i_nlink)
+			set_nlink(inode, 1);
+		else
+			btrfs_inc_nlink(inode);
 		ret = btrfs_update_inode(trans, root, inode);
 	} else if (ret == -EEXIST) {
 		ret = 0;


