Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407Ab3CMWoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:44:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934364Ab3CMWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:44:34 -0400
Date: Wed, 13 Mar 2013 15:44:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 1/9] vfs: add i_op->dentry_open()
Message-Id: <20130313154431.e39aed27efb095f9183bc123@linux-foundation.org>
In-Reply-To: <1363184193-1796-2-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-2-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:25 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new inode operation i_op->dentry_open().  This is for stacked filesystems
> that want to return a struct file from a different filesystem.
> 
> ...
>
> +/**
> + * vfs_open - open the file at the given path
> + * @path: path to open
> + * @filp: newly allocated file with f_flag initialized
> + * @cred: credentials to use
> + */
> +int vfs_open(const struct path *path, struct file *filp,
> +	     const struct cred *cred)
> +{
> +	struct inode *inode = path->dentry->d_inode;
> +
> +	if (inode->i_op->dentry_open)
> +		return inode->i_op->dentry_open(path->dentry, filp, cred);
> +	else {
> +		filp->f_path = *path;
> +		return do_dentry_open(filp, NULL, cred);
> +	}
> +}

This looks like it will add some overhead to dentry_open().  That long
walk path->dentry->d_inode->i_op->dentry_open, particularly.  Can we do
anything?  Using filp->f_inode might save a tad.

It's unfortunate and a bit ugly that ->dentry_open() and
do_dentry_open() don't have the same arguments.  One would expect and
like them to do so, and this difference raises suspicions about design
warts.

If they _did_ have the same signature then we could perhaps populate
->dentry_open with do_dentry_open by default and avoid the `if'.

The test of inode->i_op->dentry_open could do with an unlikely(), but
that won't save us :(

> +EXPORT_SYMBOL(vfs_open);

Did you consider EXPORT_SYMBOL_GPL()?


