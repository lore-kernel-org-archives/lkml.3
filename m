Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3BSBzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 20:55:54 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57571 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757872Ab3BSBzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 20:55:52 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlMKAF3aIlF5LHbb/2dsb2JhbABEhWC1PIUSgQQXc4IfAQEFJxMcIxAIAxUDCSUPBSUDIROIEbFDj38VjjoiMgsHg0ADliuJWYcAgVKBSQ
Date: Tue, 19 Feb 2013 12:55:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH review 05/16] xfs: Update xfs_ioctl_setattr to handle
 projids in any user namespace
Message-ID: <20130219015550.GJ26694@dastard>
References: <87txpaph4n.fsf@xmission.com>
 <1361149870-27732-1-git-send-email-ebiederm@xmission.com>
 <1361149870-27732-5-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361149870-27732-5-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2013 at 05:10:58PM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> - Convert the userspace value in fa->fsx_projid into a kprojid and
>   store it in the variable projid.
> - Verify that xfs can store the projid after it is converted into
>   xfs's user namespace.
> - Replace uses of fa->fsx_projid with projid throughout
>   xfs_ioctl_setattr.
> 
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/xfs/xfs_ioctl.c |   26 ++++++++++++++++++--------
>  1 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 016624b..4a55f50 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -925,6 +925,7 @@ xfs_ioctl_setattr(
>  	struct xfs_dquot	*gdqp = NULL;
>  	struct xfs_dquot	*olddquot = NULL;
>  	int			code;
> +	kprojid_t		projid = INVALID_PROJID;
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> @@ -934,11 +935,20 @@ xfs_ioctl_setattr(
>  		return XFS_ERROR(EIO);
>  
>  	/*
> -	 * Disallow 32bit project ids when projid32bit feature is not enabled.
> +	 * Verify the specifid project id is valid.
>  	 */
> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
> -			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
> -		return XFS_ERROR(EINVAL);
> +	if (mask & FSX_PROJID) {
> +		projid = make_kprojid(current_user_ns(), fa->fsx_projid);
> +		if (!projid_valid(projid))
> +			return XFS_ERROR(EINVAL);
> +
> +		/*
> +		 * Disallow 32bit project ids when projid32bit feature is not enabled.
> +		 */
> +		if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&
> +		    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
> +			return XFS_ERROR(EINVAL);
> +	}

That looks busted. Why does one use current_user_ns() and the other
&init_user_ns()?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
