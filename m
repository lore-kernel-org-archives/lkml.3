Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbaJIVLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:11:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJIVLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:11:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 067/163] don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
Date: Thu,  9 Oct 2014 14:01:32 -0700
Message-Id: <1412888588-26755-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namei.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c0cd08d..aed3458 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -630,24 +630,22 @@ static int complete_walk(struct nameidata *nd)
 
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
 
 static void path_put_conditional(struct path *path, struct nameidata *nd)
@@ -847,7 +845,8 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 			return PTR_ERR(s);
 		}
 		if (*s == '/') {
-			set_root(nd);
+			if (!nd->root.mnt)
+				set_root(nd);
 			path_put(&nd->path);
 			nd->path = nd->root;
 			path_get(&nd->root);
@@ -1120,7 +1119,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
-	set_root_rcu(nd);
+	if (!nd->root.mnt)
+		set_root_rcu(nd);
 
 	while (1) {
 		if (nd->path.dentry == nd->root.dentry &&
@@ -1232,7 +1232,8 @@ static void follow_mount(struct path *path)
 
 static void follow_dotdot(struct nameidata *nd)
 {
-	set_root(nd);
+	if (!nd->root.mnt)
+		set_root(nd);
 
 	while(1) {
 		struct dentry *old = nd->path.dentry;
@@ -1831,7 +1832,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
-			set_root_rcu(nd);
+			nd->seq = set_root_rcu(nd);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);
-- 
1.9.1

