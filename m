Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbaF3MBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:01:52 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52132 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752917AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Joel Becker <jlbec@evilplan.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/181] ocfs2: move dquot_initialize() in ocfs2_delete_inode() somewhat later
Date: Mon, 30 Jun 2014 13:50:52 +0200
Message-Id: <2eb0658fb6525f85a6386e1b7cc8bd7066ed1281.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bd62ad7aebd8e8895bb7649ace948040332f27d3 upstream.

Move dquot_initalize() call in ocfs2_delete_inode() after the moment we
verify inode is actually a sane one to delete.  We certainly don't want
to initialize quota for system inodes etc.  This also avoids calling
into quota code from downconvert thread.

Add more details into the comment why bailing out from
ocfs2_delete_inode() when we are in downconvert thread is OK.

Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>
Reviewed-by: Srinivas Eeda <srinivas.eeda@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ocfs2/inode.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f87f9bd1edff..059fa362f4c0 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -814,11 +814,13 @@ static int ocfs2_inode_is_valid_to_delete(struct inode *inode)
 		goto bail;
 	}
 
-	/* If we're coming from downconvert_thread we can't go into our own
-	 * voting [hello, deadlock city!], so unforuntately we just
-	 * have to skip deleting this guy. That's OK though because
-	 * the node who's doing the actual deleting should handle it
-	 * anyway. */
+	/*
+	 * If we're coming from downconvert_thread we can't go into our own
+	 * voting [hello, deadlock city!] so we cannot delete the inode. But
+	 * since we dropped last inode ref when downconverting dentry lock,
+	 * we cannot have the file open and thus the node doing unlink will
+	 * take care of deleting the inode.
+	 */
 	if (current == osb->dc_task)
 		goto bail;
 
@@ -970,8 +972,6 @@ static void ocfs2_delete_inode(struct inode *inode)
 	if (is_bad_inode(inode) || !OCFS2_I(inode)->ip_blkno)
 		goto bail;
 
-	dquot_initialize(inode);
-
 	if (!ocfs2_inode_is_valid_to_delete(inode)) {
 		/* It's probably not necessary to truncate_inode_pages
 		 * here but we do it for safety anyway (it will most
@@ -980,6 +980,8 @@ static void ocfs2_delete_inode(struct inode *inode)
 		goto bail;
 	}
 
+	dquot_initialize(inode);
+
 	/* We want to block signals in delete_inode as the lock and
 	 * messaging paths may return us -ERESTARTSYS. Which would
 	 * cause us to exit early, resulting in inodes being orphaned
-- 
2.0.0

