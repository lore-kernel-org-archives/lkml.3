Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3G2HvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:51:18 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:40160 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab3G2HvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:51:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtkUAIwd9lF5LPxH/2dsb2JhbABbgwY1qh4CjlSFMoETF3SCJAEBBAEnExwjBQsIAxUDCQwZDwUlAyETiAoFDbdcFo0Ygk8HCoMObwOXXooihyuBW4FLKg
Date: Mon, 29 Jul 2013 17:51:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
 projids in any user namespace
Message-ID: <20130729075109.GF13468@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-5-git-send-email-ebiederm@xmission.com>
 <20130219015550.GJ26694@dastard>
 <51F616F2.5040906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F616F2.5040906@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ cc xfs list ]

On Mon, Jul 29, 2013 at 03:17:06PM +0800, Gao feng wrote:
> On 02/19/2013 09:55 AM, Dave Chinner wrote:
> > On Sun, Feb 17, 2013 at 05:10:58PM -0800, Eric W. Biederman wrote:
> >> From: "Eric W. Biederman" <ebiederm@xmission.com>
> >>
> >> - Convert the userspace value in fa->fsx_projid into a kprojid and
> >>   store it in the variable projid.
> >> - Verify that xfs can store the projid after it is converted into
> >>   xfs's user namespace.
> >> - Replace uses of fa->fsx_projid with projid throughout
> >>   xfs_ioctl_setattr.
> >>
> >> Cc: Ben Myers <bpm@sgi.com>
> >> Cc: Alex Elder <elder@kernel.org>
> >> Cc: Dave Chinner <david@fromorbit.com>
> >> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >> ---
> >>  fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
> >>  1 files changed, 18 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> >> index 016624b..4a55f50 100644
> >> --- a/fs/xfs/xfs_ioctl.c
> >> +++ b/fs/xfs/xfs_ioctl.c
> >> @@ -925,6 +925,7 @@ xfs_ioctl_setattr(
> >>  	struct xfs_dquot	*gdqp = NULL;
> >>  	struct xfs_dquot	*olddquot = NULL;
> >>  	int			code;
> >> +	kprojid_t		projid = INVALID_PROJID;
> >>  
> >>  	trace_xfs_ioctl_setattr(ip);
> >>  
> >> @@ -934,11 +935,20 @@ xfs_ioctl_setattr(
> >>  		return XFS_ERROR(EIO);
> >>  
> >>  	/*
> >> -	 * Disallow 32bit project ids when projid32bit feature is not enabled.
> >> +	 * Verify the specifid project id is valid.
> >>  	 */
> >> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
> >> -			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
> >> -		return XFS_ERROR(EINVAL);
> >> +	if (mask & FSX_PROJID) {
> >> +		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
> >> +		if (!projid_valid(projid))
> >> +			return XFS_ERROR(EINVAL);
> >> +
> >> +		/*
> >> +		 * Disallow 32bit project ids when projid32bit feature is not enabled.
> >> +		 */
> >> +		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
> >> +		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
> >> +			return XFS_ERROR(EINVAL);
> >> +	}
> > 
> > That looks busted. Why does one use current_user_ns() and the other
> > &init_user_ns()?
> > 
> 
> hmm, through this thread had been stopped discussing for a long time, but I'm working on converting
> ids to kids for xfs now, and I want to remove the finial dependenciy for user namespace.

You're duplicating work that is already going on - we've been
talking about this stuff on the XFS list and reviewing patches for
the last 3-4 weeks for this.

http://oss.sgi.com/pipermail/xfs/2013-July/028467.html

Basically, the discussion we are currently having is whether project
IDs should be exposed to user namespaces at all. e.g:

http://oss.sgi.com/pipermail/xfs/2013-July/028497.html
http://oss.sgi.com/pipermail/xfs/2013-July/028551.html

"Basically, until we have worked out *if* project quotas can be used
safely within user namespaces, we need to reject any attempt to use
them from within a user namespace container."

i.e. the whole "project IDs are part of user namespaces because of
quotas" looks like a bad decision to have been made. Project IDs are
independent of users and groups and can be used to account for usage
across discontiguous directory and permission heirarchies, so trying
to contain them to a "user namespace" really matches their
functionality.

> I think maybe just modifying from_kprojid(&init_user_ns, projid) to projid.val here is easier
> to understand.

The problem is not a question of how to implement mappings - it's a
question of how to deal with fundamental impedence mismatch of
user namespaces and project IDs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
