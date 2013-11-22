Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3KVKfu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 05:35:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab3KVKfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 05:35:46 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/2] GFS2: Fix ref count bug relating to atomic_open
Date: Fri, 22 Nov 2013 10:35:35 +0000
Message-Id: <1385116535-4564-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1385116535-4564-1-git-send-email-swhiteho@redhat.com>
References: <1385116535-4564-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that atomic_open calls finish_no_open() with
the dentry that was supplied to gfs2_atomic_open() an
extra reference count is required. This patch fixes that
issue preventing a bug trap triggering at umount time.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 1615df1..7119504 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1171,8 +1171,11 @@ static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (d != NULL)
 		dentry = d;
 	if (dentry->d_inode) {
-		if (!(*opened & FILE_OPENED))
+		if (!(*opened & FILE_OPENED)) {
+			if (d == NULL)
+				dget(dentry);
 			return finish_no_open(file, dentry);
+		}
 		dput(d);
 		return 0;
 	}
-- 
1.8.3.1

