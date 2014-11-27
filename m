Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaK0JH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:07:27 -0500
Received: from mail.kernel.org ([198.145.19.201]:41797 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbaK0Irs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:48 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 40/91] don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
Date: Thu, 27 Nov 2014 16:42:23 +0800
Message-Id: <1417077794-9299-40-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 7bd88377d482e1eae3c5329b12e33cfd664fa6a9 upstream.

return the value instead, and have path_init() do the assignment.  Broken by
"vfs: Fix absolute RCU path walk failures due to uninitialized seq number",
which was Cc-stable with 2.6.38+ as destination.  This one should go where
it went.

To avoid dummy value returned in case when root is already set (it would do
no harm, actually, since the only caller that doesn't ignore the return value
is guaranteed to have nd->root *not* set, but it's more obvious that way),
lift the check into callers.  And do the same to set_root(), to keep them
in sync.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
[lizf: Backported to 3.4:
 - remove the changes to follow_link() as it doesn't call set_root()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/namei.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c427919..5974fb5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -553,24 +553,22 @@ static int complete_walk(struct nameidata *nd)
 
 static __always_inline void set_root(struct nameidata *nd)
 {
-	if (!nd->root.mnt)
-		get_fs_root(current->fs, &nd->root);
+	get_fs_root(current->fs, &nd->root);
 }
 
 static int link_path_walk(const char *, struct nameidata *);
 
-static __always_inline void set_root_rcu(struct nameidata *nd)
+static __always_inline unsigned set_root_rcu(struct nameidata *nd)
 {
-	if (!nd->root.mnt) {
-		struct fs_struct *fs = current->fs;
-		unsigned seq;
+	struct fs_struct *fs = current->fs;
+	unsigned seq, res;
 
-		do {
-			seq = read_seqcount_begin(&fs->seq);
-			nd->root = fs->root;
-			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
-		} while (read_seqcount_retry(&fs->seq, seq));
-	}
+	do {
+		seq = read_seqcount_begin(&fs->seq);
+		nd->root = fs->root;
+		res = __read_seqcount_begin(&nd->root.dentry->d_seq);
+	} while (read_seqcount_retry(&fs->seq, seq));
+	return res;
 }
 
 static __always_inline int __vfs_follow_link(struct nameidata *nd, const char *link)
@@ -928,7 +926,8 @@ static void follow_mount_rcu(struct nameidata *nd)
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
-	set_root_rcu(nd);
+	if (!nd->root.mnt)
+		set_root_rcu(nd);
 
 	while (1) {
 		if (nd->path.dentry == nd->root.dentry &&
@@ -1031,7 +1030,8 @@ static void follow_mount(struct path *path)
 
 static void follow_dotdot(struct nameidata *nd)
 {
-	set_root(nd);
+	if (!nd->root.mnt)
+		set_root(nd);
 
 	while(1) {
 		struct dentry *old = nd->path.dentry;
@@ -1633,7 +1633,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
-			set_root_rcu(nd);
+			nd->seq = set_root_rcu(nd);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);
-- 
1.9.1

