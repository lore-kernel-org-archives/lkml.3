Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaF3MHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:07:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52034 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 003/181] GFS2: revert "GFS2: d_splice_alias() can't return error"
Date: Mon, 30 Jun 2014 13:50:24 +0200
Message-Id: <22d3112ae7f819d3965ede21a79a5b5ad6ff33ed.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d57b9c9a999a8f4475fe73fba629c964245800ca upstream.

0d0d110720d7960b77c03c9f2597faaff4b484ae asserts that "d_splice_alias()
can't return error unless it was given an IS_ERR(inode)".

That was true of the implementation of d_splice_alias, but this is
really a problem with d_splice_alias: at a minimum it should be able to
return -ELOOP in the case where inserting the given dentry would cause a
directory loop.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/gfs2/inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 630db362a2d1..e803e3cafc53 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -583,6 +583,9 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
+		error = PTR_ERR(d);
+		if (IS_ERR(d))
+			goto fail_gunlock;
 		error = 0;
 		if (file) {
 			if (S_ISREG(inode->i_mode)) {
@@ -777,6 +780,11 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	d = d_splice_alias(inode, dentry);
+	if (IS_ERR(d)) {
+		iput(inode);
+		gfs2_glock_dq_uninit(&gh);
+		return d;
+	}
 	if (file && S_ISREG(inode->i_mode))
 		error = finish_open(file, dentry, gfs2_open_common, opened);
 
-- 
2.0.0

