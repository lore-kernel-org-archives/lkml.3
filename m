Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbaJCWAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:00:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46134 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbaJCV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:59:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.16 288/357] dont bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
Date: Fri,  3 Oct 2014 14:31:14 -0700
Message-Id: <20141003212942.135411623@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -644,24 +644,22 @@ static int complete_walk(struct nameidat
 
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
@@ -861,7 +859,8 @@ follow_link(struct path *link, struct na
 			return PTR_ERR(s);
 		}
 		if (*s == '/') {
-			set_root(nd);
+			if (!nd->root.mnt)
+				set_root(nd);
 			path_put(&nd->path);
 			nd->path = nd->root;
 			path_get(&nd->root);
@@ -1136,7 +1135,8 @@ static bool __follow_mount_rcu(struct na
 
 static int follow_dotdot_rcu(struct nameidata *nd)
 {
-	set_root_rcu(nd);
+	if (!nd->root.mnt)
+		set_root_rcu(nd);
 
 	while (1) {
 		if (nd->path.dentry == nd->root.dentry &&
@@ -1249,7 +1249,8 @@ static void follow_mount(struct path *pa
 
 static void follow_dotdot(struct nameidata *nd)
 {
-	set_root(nd);
+	if (!nd->root.mnt)
+		set_root(nd);
 
 	while(1) {
 		struct dentry *old = nd->path.dentry;
@@ -1847,7 +1848,7 @@ static int path_init(int dfd, const char
 	if (*name=='/') {
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
-			set_root_rcu(nd);
+			nd->seq = set_root_rcu(nd);
 		} else {
 			set_root(nd);
 			path_get(&nd->root);


