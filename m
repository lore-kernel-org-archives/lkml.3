Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3JOVg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:36:26 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45716 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933667Ab3JOVgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:36:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQGANi0XVJ5LFuj/2dsb2JhbABagwe9cIVEgSUXdIIlAQEEAScTHCMFCwgDDgoJJQ8FJQMhE4gABb4LFo80B4QlA5gDikCHQ4M4KA
Date: Wed, 16 Oct 2013 08:36:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com
Subject: Re: fs/attr.c:notify_change locking warning.
Message-ID: <20131015213618.GU4446@dastard>
References: <20131005005210.GA25773@redhat.com>
 <20131005031918.GL4446@dastard>
 <20131015201905.GA7509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015201905.GA7509@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 01:19:05PM -0700, Christoph Hellwig wrote:
> On Sat, Oct 05, 2013 at 01:19:18PM +1000, Dave Chinner wrote:
> > Yup, we don't hold the i_mutex *at all* through the fast path for
> > direct IO writes. Having to grab the i_mutex on every IO just for
> > the extremely unlikely case we need to remove a suid bit on the file
> > would add a significant serialisation point into the direct Io model
> > that XFS uses, and is the difference between 50,000 and 2+ million
> > direct IO IOPS to a single file.
> > 
> > I'm unwilling to sacrifice the concurrency of direct IO writes just
> > to shut up ths warning, especially as the actual modifications that
> > are made to remove SUID bits are correctly serialised within XFS
> > once notify_change() calls ->setattr(). If it really matters, I'll
> > just open code file_remove_suid() into XFS like ocfs2 does just so
> > we don't get that warning being emitted by trinity.
> 
> But the i_lock doesn't synchronize against the VFS modifying various
> struct inode fields.

Sure, but file_remove_suid() doesn't actually modify any VFS inode
structures until we process the flags and the modifications within
->setattr, which in XFS are all done under the XFS_ILOCK_EXCL via
xfs_setattr_mode(). i.e. both the VFS and XFS inodes S*ID bits are
removed only under XFS_ILOCK_EXCL....

Hence I see no point in adding extra serialisation via the i_mutex
to this path when we can just do something like:

	killsuid = should_remove_suid(file->f_path.dentry);
	if (killsuid) {
		struct iattr	newattr;

		newattr.ia_valid = ATTR_FORCE | killsuid;
		error = xfs_setattr_nonsize(ip, &newattr, 0);
		if (error)
			return error;
	}

and not require the i_mutex at all...

Indeed, this is exactly what do_truncate() does - the check outside
the i_mutex, then calls notify_change() with the i_mutex held. IOWs,
the i_mutex does nothing to serialise concurrent attempts to check
and remove S*ID bits....

> The right fix is to take i_mutex just in case
> we actually need to remove the suid bit.  The patch below should fix it,
> although I need to write a testcase that actually exercises it first.
> 
> Dave (J.): if you have time to try the patch below please go ahead,
> if not I'll make sure to write an isolated test ASAP to verify it and
> will then submit the change.
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4c749ab..e879f96 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -590,8 +590,22 @@ restart:
>  	 * If we're writing the file then make sure to clear the setuid and
>  	 * setgid bits if the process is not being run by root.  This keeps
>  	 * people from modifying setuid and setgid binaries.
> +	 *
> +	 * Note that file_remove_suid must be called with the i_mutex held,
> +	 * so we have to go through some hoops here to make sure we hold it.
>  	 */
> -	return file_remove_suid(file);
> +	if (!IS_NOSEC(inode) && should_remove_suid(file->f_path.dentry)) {
> +		if (*iolock == XFS_IOLOCK_SHARED) {
> +			mutex_lock(&inode->i_mutex);
> +			error = file_remove_suid(file);
> +			mutex_unlock(&inode->i_mutex);

Lock inversion - i_mutex is always outside i_iolock. i.e. this will
deadlock if someone else calls xfs_rw_ilock(XFS_ILOCK_EXCL) at the
same time because we already hold the i_iolock in shared mode. It's
the same case that this function already handles for the EOF zeroing
relocking.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
