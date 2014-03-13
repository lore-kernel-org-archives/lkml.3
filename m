Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaCME3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:29:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46008 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCME3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:29:40 -0400
Date: Thu, 13 Mar 2014 04:29:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        David Herrmann <dh.herrmann@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
Message-ID: <20140313042934.GM18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
 <CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
 <20140312181925.GK18016@ZenIV.linux.org.uk>
 <20140313150800.07878c80@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313150800.07878c80@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:08:00PM +1100, NeilBrown wrote:
> +		inode = mddev->bitmap_info.file->f_mapping->host;
> +		if (!S_ISREG(inode->i_mode)) {
> +			printk(KERN_ERR "%s: error: bitmap file must be a regular file\n",
> +			       mdname(mddev));
> +			fput(mddev->bitmap_info.file);
> +			mddev->bitmap_info.file = NULL;
> +			return -EBADF;
> +		}
> +		if (atomic_read(&inode->i_writecount) != 1) {

Umm...  I think you ought to check more than that.  At the very least you
want to check that you have it opened for write - you don't want e.g.
a filesystem containing that puppy remounted r/o under you.  Another thing
is, what happens if it's not a buffer cache backed one?  Hell, what happens
if it's a file on NFS?  You are relying on bmap() working, right?  So it
looks like you ought to check if ->bmap() is there.  And I really wonder
how well does it play with journalling fs...
