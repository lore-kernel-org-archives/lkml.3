Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3DLQSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 12:18:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3DLQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 12:18:32 -0400
Date: Fri, 12 Apr 2013 17:18:28 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Steven Whitehouse'" <swhiteho@redhat.com>
Subject: Re: [PATCH 3.8-stable] GFS2: Fix unlock of fcntl locks during
 withdrawn state
Message-ID: <20130412161828.GA18956@hercules>
References: <000601ce3659$042adbf0$0c8093d0$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601ce3659$042adbf0$0c8093d0$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:05:18AM +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?

I believe this is also applicable to the 3.5 kernel.  Queuing it

Cheers,
--
Luis

> 
> ------------------
> 
> From: "Steven Whitehouse <swhiteho@redhat.com>"
> 
> commit c2952d202f710d326ac36a8ea6bd216b20615ec8 upstream
> 
> When withdraw occurs, we need to continue to allow unlocks of fcntl
> locks to occur, however these will only be local, since the node has
> withdrawn from the cluster. This prevents triggering a VFS level
> bug trap due to locks remaining when a file is closed.
> 
> Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  fs/gfs2/file.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
> index 991ab2d..7af426b 100644
> --- a/fs/gfs2/file.c
> +++ b/fs/gfs2/file.c
> @@ -924,8 +924,11 @@ static int gfs2_lock(struct file *file, int cmd, struct
> file_lock *fl)
>  		cmd = F_SETLK;
>  		fl->fl_type = F_UNLCK;
>  	}
> -	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags)))
> +	if (unlikely(test_bit(SDF_SHUTDOWN, &sdp->sd_flags))) {
> +		if (fl->fl_type == F_UNLCK)
> +			posix_lock_file_wait(file, fl);
>  		return -EIO;
> +	}
>  	if (IS_GETLK(cmd))
>  		return dlm_posix_get(ls->ls_dlm, ip->i_no_addr, file, fl);
>  	else if (fl->fl_type == F_UNLCK)
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
