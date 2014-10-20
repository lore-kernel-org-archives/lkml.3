Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaJTMeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:34:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJTMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:34:18 -0400
Date: Mon, 20 Oct 2014 13:34:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH 1/2] fat: Fix d_splice_alias() return code checking
Message-ID: <20141020123415.GN7996@ZenIV.linux.org.uk>
References: <1413715184-30196-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413715184-30196-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 12:39:43PM +0200, Richard Weinberger wrote:
> d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
> Currently the code checks not for ERR_PTR.
> Fix this by using IS_ERR_OR_NULL().

Why do we need to set ->d_time for non-NULL inode anyway?  AFAICS,
it's never checked for positive dentries, and the moment when positive
dentry become negative is when we want to set it anyway.

What am I missing here?  Why not simply do this:

diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6df8d3d..e2dc6bf 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -725,15 +725,14 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 			inode = NULL;
 			goto out;
 		}
-		goto error;
+		inode = ERR_PTR(inode);
+		goto out;
 	}
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
-	if (IS_ERR(inode)) {
-		err = PTR_ERR(inode);
-		goto error;
-	}
+	if (IS_ERR(inode))
+		goto out;
 
 	alias = d_find_alias(inode);
 	if (alias && !vfat_d_anon_disconn(alias)) {
@@ -754,16 +753,10 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 		dput(alias);
 
 out:
+	if (!inode)
+		dentry->d_time = dir->i_version;
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
-	dentry = d_splice_alias(inode, dentry);
-	if (dentry)
-		dentry->d_time = dentry->d_parent->d_inode->i_version;
-	return dentry;
-
-error:
-	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-	return ERR_PTR(err);
+	return d_splice_alias(inode, dentry);
 }
 
 static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
@@ -793,7 +786,6 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -824,6 +816,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -849,6 +842,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
 	fat_detach(inode);
+	dentry->d_time = dir->i_version;
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -889,7 +883,6 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
-	dentry->d_time = dentry->d_parent->d_inode->i_version;
 	d_instantiate(dentry, inode);
 
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
