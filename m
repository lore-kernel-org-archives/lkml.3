Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3IGPBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 11:01:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42674 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3IGPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 11:01:21 -0400
Date: Sat, 7 Sep 2013 16:01:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 08/19] pramfs: file operations for dirs
Message-ID: <20130907150119.GB13318@ZenIV.linux.org.uk>
References: <522AE24C.6060903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522AE24C.6060903@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 07, 2013 at 10:22:36AM +0200, Marco Stornelli wrote:
> +int pram_add_link(struct dentry *dentry, struct inode *inode)
> +{
> +	struct inode *dir = dentry->d_parent->d_inode;
> +	struct pram_inode *pidir, *pi, *pitail = NULL;
> +	u64 tail_ino, prev_ino;
> +
> +	const char *name = dentry->d_name.name;
> +
> +	int namelen = min_t(unsigned int, dentry->d_name.len, PRAM_NAME_LEN);

Whatever the hell for?  Your ->lookup() rejects dentries with names longer
than PRAM_NAME_LEN with an error, so they won't reach this function at all.

> +int pram_remove_link(struct inode *inode)

Umm...  That's called on rename (for old one) *and* inode eviction when link
count goes to zero.  What's the point of keeping unlinked ones (unlink/rmdir/
rename victims) on those lists?  Sure, you skip them on lookups, but why
delay link removal until eviction?  You pay for that with extra locking,
BTW - if not for that, you wouldn't need your i_link_mutex at all.

> +	pi = pram_get_inode(sb, inode->i_ino);
> +
> +	switch ((u32)file->f_pos) {
> +	case 0:
> +		ret = dir_emit_dot(file, ctx);
> +		ctx->pos = 1;
> +		return ret;

Really?  So on the first call of ->iterate() you just generate one
entry and don't even try to produce more?  And it looks like the
rest is no nicer...
