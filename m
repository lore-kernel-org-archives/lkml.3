Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaKAWtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:49:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751682AbaKAWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:30 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.999453185@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 050/102] don't bugger nd->seq on set_root_rcu() from
 follow_dotdot_rcu()
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/namei.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -554,24 +554,22 @@ static int complete_walk(struct nameidat
 
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
@@ -582,7 +580,8 @@ static __always_inline int __vfs_follow_
 		goto fail;
 
 	if (*link == '/') {
-		set_root(nd);
+		if (!nd->root.mnt)
+			set_root(nd);
 		path_put(&nd->path);
 		nd->path = nd->root;
 		path_get(&nd->root);
@@ -927,7 +926,8 @@ static void follow_mount_rcu(struct name
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
-	set_root_rcu(nd);
+	if (!nd->root.mnt)
+		set_root_rcu(nd);
 
 	while (1) {
 		if (nd->path.dentry == nd->root.dentry &&
@@ -1030,7 +1030,8 @@ static void follow_mount(struct path *pa
 
 static void follow_dotdot(struct nameidata *nd)
 {
-	set_root(nd);
+	if (!nd->root.mnt)
+		set_root(nd);
 
 	while(1) {
 		struct dentry *old = nd->path.dentry;
@@ -1504,7 +1505,7 @@ static int path_init(int dfd, const char
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
-			set_root_rcu(nd);
+			nd->seq = set_root_rcu(nd);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);

