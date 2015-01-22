Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbbAVEM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:12:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47258 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbbAVEMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:12:47 -0500
Date: Thu, 22 Jan 2015 04:12:41 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Moore <pmoore@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Sabrina Dubroca <sd@queasysnail.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>
Subject: Re: linux-next: Tree for Jan 20 -- Kernel panic - Unable to mount
 root fs
Message-ID: <20150122041241.GT29656@ZenIV.linux.org.uk>
References: <54BF1292.2080902@roeck-us.net>
 <54C01418.5060204@roeck-us.net>
 <20150121212833.GS29656@ZenIV.linux.org.uk>
 <1829267.G68Yz0UZrY@sifl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1829267.G68Yz0UZrY@sifl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:28:51PM -0500, Paul Moore wrote:

> Al, do you mind if I fold your patch below into the existing patches?

No problem, but I'd probably prefer to put this series through vfs.git.
With the following as the first step:

Cut down on do_path_lookup() callers

Use filename_lookup() instead.  And don't bother with creating new
struct filename when caller already has one.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/namei.c b/fs/namei.c
index bc35b02..73fcf42 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2046,7 +2046,8 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 {
 	struct nameidata nd;
 	struct dentry *d;
-	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
+	struct filename filename = {.name = name};
+	int err = filename_lookup(AT_FDCWD, &filename, LOOKUP_PARENT, &nd);
 	if (err)
 		return ERR_PTR(err);
 	if (nd.last_type != LAST_NORM) {
@@ -3290,7 +3291,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname,
+static struct dentry *filename_create(int dfd, struct filename *name,
 				struct path *path, unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
@@ -3305,7 +3306,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = filename_lookup(dfd, name, LOOKUP_PARENT|lookup_flags, &nd);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3359,6 +3360,13 @@ out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct filename filename = {.name = pathname};
+	return filename_create(dfd, &filename, path, lookup_flags);
+}
 EXPORT_SYMBOL(kern_path_create);
 
 void done_path_create(struct path *path, struct dentry *dentry)
@@ -3377,7 +3385,7 @@ struct dentry *user_path_create(int dfd, const char __user *pathname,
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
+	res = filename_create(dfd, tmp, path, lookup_flags);
 	putname(tmp);
 	return res;
 }
