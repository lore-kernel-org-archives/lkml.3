Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3IPMwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:15 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:64505 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab3IPMvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:47 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 06/11] gfs2: d_splice_alias() cant return error
Date: Mon, 16 Sep 2013 14:52:00 +0200
Message-Id: <1379335925-30858-7-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

unless it was given an IS_ERR(inode), which isn't the case here.  So clean
up the unnecessary error handling in gfs2_create_inode().

This paves the way for real fixes (hence the stable Cc).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: stable@vger.kernel.org
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
1.8.1.4

