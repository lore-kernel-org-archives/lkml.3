Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505Ab3IGOl1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 10:41:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42587 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3IGOl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 10:41:26 -0400
Date: Sat, 7 Sep 2013 15:41:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 12/19] pramfs: symlink operations
Message-ID: <20130907144118.GA13318@ZenIV.linux.org.uk>
References: <522AE3DB.7000209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522AE3DB.7000209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 10:29:15AM +0200, Marco Stornelli wrote:
> +static int pram_readlink(struct dentry *dentry, char __user *buffer, int buflen)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	u64 block;
> +	char *blockp;
> +
> +	block = pram_find_data_block(inode, 0);
> +	blockp = pram_get_block(sb, block);
> +	return vfs_readlink(dentry, buffer, buflen, blockp);
> +}

> +static void *pram_follow_link(struct dentry *dentry, struct nameidata *nd)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	off_t block;
> +	int status;
> +	char *blockp;
> +
> +	block = pram_find_data_block(inode, 0);
> +	blockp = pram_get_block(sb, block);
> +	status = vfs_follow_link(nd, blockp);
> +	return ERR_PTR(status);
> +}

Just nd_set_link(nd, blockp) instead of that vfs_follow_link() and be
done with that; that way you can use generic_readlink() instead of
pram_readlink() *and* get lower stack footprint on traversing them.

BTW, where's the error checking?  pram_get_block()/pram_find_data_block()
seem to assume that fs image isn't corrupted and if it is... that code
will happily dereference any address.  At least range checks of some sort
in pram_get_block() (and checking if it has failed) would be a good idea...
