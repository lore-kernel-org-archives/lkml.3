Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbbAYV5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 16:57:54 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbbAYV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 16:57:52 -0500
From: Richard Weinberger <richard@nod.at>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] fs: Detect API misuse of i_op->lookup
Date: Sun, 25 Jan 2015 22:57:40 +0100
Message-Id: <1422223060-8561-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hunting down a refcount issue in an out-of-tree filesystem uncovered
that its lookup function directly returned the dentry which was passed to it.
Add a BUG_ON() to detect such misuse in future.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namei.c b/fs/namei.c
index bc35b02..f8ccae6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1370,6 +1370,7 @@ static struct dentry *lookup_real(struct inode *dir, struct dentry *dentry,
 
 	old = dir->i_op->lookup(dir, dentry, flags);
 	if (unlikely(old)) {
+		BUG_ON(old == dentry);
 		dput(dentry);
 		dentry = old;
 	}
-- 
2.2.2

