Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3K1LD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:03:27 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54208 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab3K1LDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:03:24 -0500
X-Sasl-enc: jXpZYjqOEjI7Y6qFzcmLWjEJPk6xks63n1d8ojNh0BWz 1385636599
Subject: [PATCH] autofs - fix symlinks aren't checked for expiry
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>
Date: Thu, 28 Nov 2013 16:38:13 +0800
Message-ID: <20131128083812.15855.54556.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <ikent@redhat.com>

The autofs4 module doesn't consider symlinks for expire.

The user space daemon has focused on the use of bind mounts
instead of symlinks for a long time now. But, with the
future addition of amd map parsing in automount(8), not
to mention amd iteslf, symlink expiry is needed.

The direct and offset mount types can't be symlinks and
the tree mounts of version 4 were always real mounts so
only indirect mounts need expire symlinks.

Signed-off-by: Ian Kent <ikent@redhat.com>
---
 fs/autofs4/expire.c  |   12 ++++++++++++
 fs/autofs4/symlink.c |    3 +++
 2 files changed, 15 insertions(+)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 3d9d3f5..ce7df7c 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -402,6 +402,18 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			goto next;
 		}
 
+		if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+			/*
+			 * A symlink can't be "busy" in the usual sense so
+			 * just check last used for expire timeout.
+			 */
+			if (autofs4_can_expire(dentry, timeout, do_now)) {
+				expired = dentry;
+				goto found;
+			}
+			goto next;
+		}
+
 		if (simple_empty(dentry))
 			goto next;
 
diff --git a/fs/autofs4/symlink.c b/fs/autofs4/symlink.c
index f27c094..061a692 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -14,6 +14,9 @@
 
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino)
+		ino->last_used = jiffies;
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }

