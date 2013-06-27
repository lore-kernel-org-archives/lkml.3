Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab3F0Q0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:26:54 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:56754 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3F0Q0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:26:51 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andy Whitcroft <apw@canonical.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] overlayfs -- ovl_path_open should not take path reference
Date: Thu, 27 Jun 2013 17:26:42 +0100
Message-Id: <1372350404-10359-2-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372350404-10359-1-git-send-email-apw@canonical.com>
References: <1372350404-10359-1-git-send-email-apw@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit below dentry_open now takes its own references
as required.  We therefore should no longer take path references in
ovl_path_open.  Doing so leaves stray mount references to the underlying
devices preventing them being released:

    commit 765927b2d508712d320c8934db963bbe14c3fcec
    Author: Al Viro <viro@zeniv.linux.org.uk>
    Date:   Tue Jun 26 21:58:53 2012 +0400

        switch dentry_open() to struct path, make it grab references itself

BugLink: http://bugs.launchpad.net/bugs/1098378
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 fs/overlayfs/super.c | 1 -
 1 file changed, 1 deletion(-)


    Found this in testing on Ubuntu raring, testing against loopback
    mounted files.  Without this change we were unable to release the
    loopback device for reuse.  Looking at it actually we were also leaking
    references on the root filesystem, but these are not as obvious.
    Applies against overlayfs.v17 as rebased to 3.8 and later.

    -apw


diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 482c26f..9473e79 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -385,7 +385,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 struct file *ovl_path_open(struct path *path, int flags)
 {
-	path_get(path);
 	return dentry_open(path, flags, current_cred());
 }
 
-- 
1.8.3.1

