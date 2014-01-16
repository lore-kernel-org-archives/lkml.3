Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaAPFyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:54:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47826 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaAPFyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:54:10 -0500
Date: Thu, 16 Jan 2014 05:53:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rakesh Pandit <rakesh@tuxera.com>
Cc: ebiederm@xmission.com, keescook@chromium.org, serge.hallyn@canonical.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] befs: iget_locked() doesn't return an ERR_PTR
Message-ID: <20140116055357.GW10323@ZenIV.linux.org.uk>
References: <20140115175828.GA3514@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115175828.GA3514@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:58:28PM +0200, Rakesh Pandit wrote:
> Also fix befs_iget return value if iget_locked fails.

Applied, but I really wonder if we'd made a mistake with iget{5}_locked()
API - perhaps the calling conventions returning ERR_PTR(-ENOMEM) would've
been better...  Most of the callers are immediately followed by
	if (!inode)
		return ERR_PTR(-ENOMEM);
and in fact something like
inode_is_new(inode) = !ERR_PTR(inode) && (inode->i_flags & I_NEW)
might've killed even more boilerplate in callers, so it might make
sense to introduce a new variants of iget{,5}_locked that would
return ERR_PTR(-ENOMEM) on out-of-memory and mark the original variants
obsolete after a while...

Anyway, for now your patch is obviously the right fix.

BTW, the callers of iget{,5}_locked() that do not do that return
ERR_PTR(-ENOMEM) on NULL thing are worth looking into:
	* sysfs_get_inode() - callers of _that_ do the same thing; might
as well have done it there.
	* nilfs_iget_locked() - ditto.
	* fuse_iget() - ditto.
	* btrfs_iget_locked() - ditto.
	* udf_iget() - callers galore, with very inconsistent error values
propagated on that failure (EACCES, EIO, etc.); quite a few of those would
be better off with ENOMEM (e.g. ->lookup() failing with EACCES on oom isn't
right).
	* __ecryptfs_get_inode() - EACCES instead of ENOMEM, for no good
reason I can see...
	* gfs2_iget() - ENOBUFS instead of ENOMEM.  ENOBUFS is 
"No buffer space available (POSIX.1 (XSI STREAMS option))" and since
we don't support STREAMS it's probably fair game, but... what the hell?
	* ll_iget() - this one definitely ought to return ERR_PTR(), since
it does that on other errors; callers check for both.  One of them converts
NULL to ERR_PTR(-ENOMEM), another (in mount guts) treats it as EBADF (again,
very odd return value when there's no file descriptors in sight).
	* befs_iget() - the one you'd caught.
	* hfs_iget() - one caller treats it as EACCES, another - as EINVAL.
To make things more complicated, there's another failure exit, which probably
should be EINVAL.  Overall, I'd make it return ERR_PTR()...
	* cifs_iget() - probably would be better off with ERR_PTR(); most
of the callers treat NULL as ENOMEM, but cifs_posix_mkdir() is really
odd in that respect...  No sure what's going on there.
	* hfs_btree_open() - callers end up treating that as EIO (and do that
to kmalloc() failures right in there)
	* hpfs_lookup() - treats all errors as ENOENT, that one included...
	* hpfs_fill_super() - same, but treats everything as EINVAL
	* bdget() and bdget_disk() - a bunch of callers forget to check for
allocation failures at all; some are doing that legitimately, some are
probably oopsable...
