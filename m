Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3IGPJA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 11:09:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42706 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3IGPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 11:08:59 -0400
Date: Sat, 7 Sep 2013 16:08:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/19] pramfs: inode operations for dirs
Message-ID: <20130907150857.GC13318@ZenIV.linux.org.uk>
References: <522AE28E.3010709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522AE28E.3010709@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 10:23:42AM +0200, Marco Stornelli wrote:

> +static int pram_rmdir(struct inode *dir, struct dentry *dentry)
> +{
> +	struct inode *inode = dentry->d_inode;
> +	struct pram_inode *pi;
> +	int err = -ENOTEMPTY;
> +
> +	if (!inode)
> +		return -ENOENT;
> +
> +	pi = pram_get_inode(dir->i_sb, inode->i_ino);
> +
> +	/* directory to delete is empty? */
> +	if (pi->i_type.dir.tail == 0) {
> +		inode->i_ctime = dir->i_ctime;
> +		inode->i_size = 0;
> +		clear_nlink(inode);
> +		pram_write_inode(inode, NULL);
> +		pram_dec_count(dir);
> +		err = 0;
> +	} else {
> +		pram_dbg("dir not empty\n");
> +	}
> +
> +	return err;
> +}

... and here you are paying for delayed removal of entries:
	mkdir foo
	touch foo/bar
	rm -rf foo <foo/bar
will fail, since opened-and-unlinked file in effect keeps the directory
where it used to be "not empty" from your rmdir (and rename) POV.
