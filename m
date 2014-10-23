Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaJWPVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:21:13 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44941 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaJWPVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:21:11 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fat: Fix d_splice_alias() return code checking
References: <1413715184-30196-1-git-send-email-richard@nod.at>
	<20141020123415.GN7996@ZenIV.linux.org.uk>
Date: Fri, 24 Oct 2014 00:21:04 +0900
In-Reply-To: <20141020123415.GN7996@ZenIV.linux.org.uk> (Al Viro's message of
	"Mon, 20 Oct 2014 13:34:15 +0100")
Message-ID: <87siie95i7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sun, Oct 19, 2014 at 12:39:43PM +0200, Richard Weinberger wrote:
>> d_splice_alias() can return a valid dentry, NULL or an ERR_PTR.
>> Currently the code checks not for ERR_PTR.
>> Fix this by using IS_ERR_OR_NULL().
>
> Why do we need to set ->d_time for non-NULL inode anyway?  AFAICS,
> it's never checked for positive dentries, and the moment when positive
> dentry become negative is when we want to set it anyway.
>
> What am I missing here?  Why not simply do this:

Hm, at least, this changes behavior though (old one drops if parent
changed after target dentry created, then when become negative. New one
drops if changed parent after target became negative.).

However, looks like new behavior is workable. And I think it is worth to try.

Can you add Signed-off-by:?

> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index 6df8d3d..e2dc6bf 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -725,15 +725,14 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
>  			inode = NULL;
>  			goto out;
>  		}
> -		goto error;
> +		inode = ERR_PTR(inode);
> +		goto out;
>  	}
>  
>  	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
>  	brelse(sinfo.bh);
> -	if (IS_ERR(inode)) {
> -		err = PTR_ERR(inode);
> -		goto error;
> -	}
> +	if (IS_ERR(inode))
> +		goto out;
>  
>  	alias = d_find_alias(inode);
>  	if (alias && !vfat_d_anon_disconn(alias)) {
> @@ -754,16 +753,10 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
>  		dput(alias);
>  
>  out:
> +	if (!inode)
> +		dentry->d_time = dir->i_version;
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
> -	dentry->d_time = dentry->d_parent->d_inode->i_version;
> -	dentry = d_splice_alias(inode, dentry);
> -	if (dentry)
> -		dentry->d_time = dentry->d_parent->d_inode->i_version;
> -	return dentry;
> -
> -error:
> -	mutex_unlock(&MSDOS_SB(sb)->s_lock);
> -	return ERR_PTR(err);
> +	return d_splice_alias(inode, dentry);
>  }
>  
>  static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
> @@ -793,7 +786,6 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
>  	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
>  
> -	dentry->d_time = dentry->d_parent->d_inode->i_version;
>  	d_instantiate(dentry, inode);
>  out:
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
> @@ -824,6 +816,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
>  	clear_nlink(inode);
>  	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>  	fat_detach(inode);
> +	dentry->d_time = dir->i_version;
>  out:
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
>  
> @@ -849,6 +842,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
>  	clear_nlink(inode);
>  	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
>  	fat_detach(inode);
> +	dentry->d_time = dir->i_version;
>  out:
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
>  
> @@ -889,7 +883,6 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
>  	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
>  
> -	dentry->d_time = dentry->d_parent->d_inode->i_version;
>  	d_instantiate(dentry, inode);
>  
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
