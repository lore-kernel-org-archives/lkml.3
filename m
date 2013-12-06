Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162518Ab3LFNWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:22:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44565 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161891Ab3LFNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:16 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 212/272] GFS2: d_splice_alias() can't return error
Date: Fri,  6 Dec 2013 12:58:21 +0000
Message-Id: <1386334761-25517-213-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit 0d0d110720d7960b77c03c9f2597faaff4b484ae upstream.

unless it was given an IS_ERR(inode), which isn't the case here.  So clean
up the unnecessary error handling in gfs2_create_inode().

This paves the way for real fixes (hence the stable Cc).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 64915ee..6d7f976 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -584,7 +584,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	if (!IS_ERR(inode)) {
 		d = d_splice_alias(inode, dentry);
 		error = 0;
-		if (file && !IS_ERR(d)) {
+		if (file) {
 			if (d == NULL)
 				d = dentry;
 			if (S_ISREG(inode->i_mode))
@@ -593,8 +593,6 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 				error = finish_no_open(file, d);
 		}
 		gfs2_glock_dq_uninit(ghs);
-		if (IS_ERR(d))
-			return PTR_ERR(d);
 		return error;
 	} else if (error != -ENOENT) {
 		goto fail_gunlock;
-- 
1.8.3.2

