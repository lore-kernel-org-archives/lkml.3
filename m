Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab3BSAgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 19:36:14 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52709 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460Ab3BSAgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 19:36:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAOXHIlF5LHbb/2dsb2JhbABEhWC1MoUSgQQXc4IfAQEEAScTHCMFCwgDFQMJJQ8FJQMhE4gMBbFFj3oVjjoiPQeCX2EDliuQWYMb
Date: Tue, 19 Feb 2013 11:36:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 02/16] xfs: Store projectid as a single variable.
Message-ID: <20130219003608.GF26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-2-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-2-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:10:55PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> xfs_get_projid is torturous to read and it will not work at all when
> project ids are stored in a kprojid_t.  So add a i_projid to
> xfs_inode, that is cheap to read and can handle future needs, and
> update all callers of xfs_get_projid to use i_projid.
> 
> Retain xfs_set_projid to handle the needed double updates, as there
> are now two places the value needs to be set.
> 
> In xfs_iread after filling in i_d drom the on-disk inode update the
> new i_projid field.
> 
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/xfs/xfs_icache.c   |    2 +-
>  fs/xfs/xfs_inode.c    |    6 +++++-
>  fs/xfs/xfs_inode.h    |    7 ++-----
>  fs/xfs/xfs_ioctl.c    |    6 +++---
>  fs/xfs/xfs_iops.c     |    2 +-
>  fs/xfs/xfs_itable.c   |    4 ++--
>  fs/xfs/xfs_qm.c       |   10 +++++-----
>  fs/xfs/xfs_qm_bhv.c   |    2 +-
>  fs/xfs/xfs_rename.c   |    2 +-
>  fs/xfs/xfs_vnodeops.c |    6 +++---
>  10 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 96e344e..4f109ca 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1210,7 +1210,7 @@ xfs_inode_match_id(
>  		return 0;
>  
>  	if (eofb->eof_flags & XFS_EOF_FLAGS_PRID &&
> -	    xfs_get_projid(ip) != eofb->eof_prid)
> +	    ip->i_projid != eofb->eof_prid)
>  		return 0;

Please retain the xfs_get_projid(ip) wrapper and do all the
necessary conversions via that wrapper. We don't need a second copy
of the project ID to support namespace aware project ID support.

>  	return 1;
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 66282dc..51c2597 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1013,6 +1013,10 @@ xfs_iread(
>  	 */
>  	if (dip->di_mode) {
>  		xfs_dinode_from_disk(&ip->i_d, dip);
> +
> +		ip->i_projid = ((projid_t)ip->i_d.di_projid_hi << 16) |
> +					  ip->i_d.di_projid_lo;
> +

This does not belong here. At minimum, it would need to be in
xfs_iformat(). Further, if there is a requirement it is initialised
correctly, it needs to be zeroed in xfs_inode_alloc() where we pull
a newly allocated inode out of the slab.

As it is, however, having read further through the patches, I can't
really see why we need even need a separate variable - the
conversions shoul dbe done at the edge of the filesystem (i.e. VFS
and ioctl interfaces, and the core of the filesystem left completely
untouched.

>  static inline void
>  xfs_set_projid(struct xfs_inode *ip,
>  		prid_t projid)
>  {
> +	ip->i_projid = projid;
>  	ip->i_d.di_projid_hi = (__uint16_t) (projid >> 16);
>  	ip->i_d.di_projid_lo = (__uint16_t) (projid & 0xffff);
>  }

As all you are doing is introduing a requirement that we keep two
variables in sync and increase the size of the struct xfs_inode
unnecessarily. History says this sort of duplication is a source of
subtle bugs....

> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 2ea7d40..cf5b1d0 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -91,8 +91,8 @@ xfs_bulkstat_one_int(
>  	 * further change.
>  	 */
>  	buf->bs_nlink = dic->di_nlink;
> -	buf->bs_projid_lo = dic->di_projid_lo;
> -	buf->bs_projid_hi = dic->di_projid_hi;
> +	buf->bs_projid_lo = (u16)(ip->i_projid & 0xffff);
> +	buf->bs_projid_hi = (u16)(ip->i_projid >> 16);

There is no need for this change at all. Even if we have a second
variable, the two are in sync and of reading from the dic is
perfectly OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
