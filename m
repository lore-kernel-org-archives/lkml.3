Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3L0Eci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 23:32:38 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52361 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754230Ab3L0EcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 23:32:24 -0500
X-Sasl-enc: +oq40Ak/rVXg2wOV2Fd7jf2Tq64frZVAiXOuGVLXTzp2 1388118739
Subject: [PATCH] autofs - fix symlinks aren't checked for expiry
To: Andrew Morton <akpm@linux-foundation.org>
From: Ian Kent <raven@themaw.net>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 27 Dec 2013 12:32:16 +0800
Message-ID: <20131227043216.3519.3477.stgit@perseus.fritz.box>
In-Reply-To: <20131227042828.3519.11223.stgit@perseus.fritz.box>
References: <20131227042828.3519.11223.stgit@perseus.fritz.box>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Kent <ikent@redhat.com>

The autofs4 module doesn't consider symlinks for expire as it did
in the older autofs v3 module (so it's actually a long stnding
regression).

The user space daemon has focused on the use of bind mounts instead
of symlinks for a long time now and that's why this has not been
noticed. But with the future addition of amd map parsing to
automount(8), not to mention amd itself (of am-utils), symlink
expiry will be needed.

The direct and offset mount types can't be symlinks and the tree
mounts of version 4 were always real mounts so only indirect
mounts need expire symlinks.

Since the current users of the autofs4 module haven't reproted
this as a problem to date this patch probably isn't a candidate
for backport to stable.

Signed-off-by: Ian Kent <ikent@redhat.com>
---
 fs/autofs4/expire.c  |   14 ++++++++++++++
 fs/autofs4/symlink.c |    4 ++++
 2 files changed, 18 insertions(+)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 3d9d3f5..394e90b 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -402,6 +402,20 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 			goto next;
 		}
 
+		if (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)) {
+			DPRINTK("checking symlink %p %.*s",
+				dentry, (int)dentry->d_name.len, dentry->d_name.name);
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
index f27c094..1e8ea19 100644
--- a/fs/autofs4/symlink.c
+++ b/fs/autofs4/symlink.c
@@ -14,6 +14,10 @@
 
 static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
+	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
+	struct autofs_info *ino = autofs4_dentry_ino(dentry);
+	if (ino && !autofs4_oz_mode(sbi))
+		ino->last_used = jiffies;
 	nd_set_link(nd, dentry->d_inode->i_private);
 	return NULL;
 }

