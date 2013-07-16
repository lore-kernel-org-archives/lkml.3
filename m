Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab3GPQO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:14:59 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:50000 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932666Ab3GPQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:14:58 -0400
Date: Tue, 16 Jul 2013 18:14:58 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Brian Foster <bfoster@redhat.com>
Cc: Niels de Vos <ndevos@redhat.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [fuse-devel] [PATCH] fuse: fix occasional dentry leak when
 readdirplus is used
Message-ID: <20130716161458.GA19664@tucsk.piliscsaba.szeredi.hu>
References: <1373893160-30601-1-git-send-email-ndevos@redhat.com>
 <51E456B6.8050601@redhat.com>
 <20130716103939.GL18803@ndevos-laptop.usersys.redhat.com>
 <51E54764.4070106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E54764.4070106@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:15:16AM -0400, Brian Foster wrote:
 
> I'm not sure why it would need to have a valid inode. A dentry with a
> NULL inode is valid, no?

It is valid, yes.  It's called a "negative" dentry, which caches the information
that the file does not exist.

> I think the question is whether the above state (multiple, hashed dentries)
> can be valid for whatever reason. It certainly looks suspicious.

That state is not valid.  So we certainly need to unhash the negative dentry
first, before hashing a new one.  We could also reuse the old dentry, but that
is just an optimization.

Below patch fixes several issues with that function.  Could you please give it a
go?

Thanks,
Miklos


diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 0eda527..a8208c5 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1223,28 +1223,45 @@ static int fuse_direntplus_link(struct file *file,
 		if (name.name[1] == '.' && name.len == 2)
 			return 0;
 	}
+
+	if (invalid_nodeid(o->nodeid))
+		return -EIO;
+	if (!fuse_valid_type(o->attr.mode))
+		return -EIO;
+
 	fc = get_fuse_conn(dir);
 
 	name.hash = full_name_hash(name.name, name.len);
 	dentry = d_lookup(parent, &name);
-	if (dentry && dentry->d_inode) {
+	if (dentry) {
 		inode = dentry->d_inode;
-		if (get_node_id(inode) == o->nodeid) {
+		if (!inode) {
+			d_drop(dentry);
+		} else if (get_node_id(inode) != o->nodeid ||
+			   ((o->attr.mode ^ inode->i_mode) & S_IFMT)) {
+			err = d_invalidate(dentry);
+			if (err)
+				goto out;
+		} else if (is_bad_inode(inode)) {
+			err = -EIO;
+			goto out;
+		} else {
 			struct fuse_inode *fi;
 			fi = get_fuse_inode(inode);
 			spin_lock(&fc->lock);
 			fi->nlookup++;
 			spin_unlock(&fc->lock);
 
+			fuse_change_attributes(inode, &o->attr,
+					       entry_attr_timeout(o),
+					       attr_version);
+
 			/*
 			 * The other branch to 'found' comes via fuse_iget()
 			 * which bumps nlookup inside
 			 */
 			goto found;
 		}
-		err = d_invalidate(dentry);
-		if (err)
-			goto out;
 		dput(dentry);
 		dentry = NULL;
 	}
@@ -1259,25 +1276,30 @@ static int fuse_direntplus_link(struct file *file,
 	if (!inode)
 		goto out;
 
-	alias = d_materialise_unique(dentry, inode);
-	err = PTR_ERR(alias);
-	if (IS_ERR(alias))
-		goto out;
+	if (S_ISDIR(inode->i_mode)) {
+		mutex_lock(&fc->inst_mutex);
+		alias = fuse_d_add_directory(dentry, inode);
+		mutex_unlock(&fc->inst_mutex);
+		err = PTR_ERR(alias);
+		if (IS_ERR(alias)) {
+			iput(inode);
+			goto out;
+		}
+	} else {
+		alias = d_splice_alias(inode, dentry);
+	}
+
 	if (alias) {
 		dput(dentry);
 		dentry = alias;
 	}
 
 found:
-	fuse_change_attributes(inode, &o->attr, entry_attr_timeout(o),
-			       attr_version);
-
 	fuse_change_entry_timeout(dentry, o);
 
 	err = 0;
 out:
-	if (dentry)
-		dput(dentry);
+	dput(dentry);
 	return err;
 }
 
