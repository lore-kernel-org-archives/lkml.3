Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003Ab3DKIBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 04:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3DKIBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:01:49 -0400
Subject: Re: [PATCH 3.8-stable] GFS2: Fix unlock of fcntl locks during
 withdrawn state
From: Steven Whitehouse <swhiteho@redhat.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <000601ce3659$042adbf0$0c8093d0$%choi@samsung.com>
References: <000601ce3659$042adbf0$0c8093d0$%choi@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 11 Apr 2013 08:59:34 +0100
Message-ID: <1365667174.2701.12.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2013-04-11 at 11:05 +0900, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.8-stable tree, should we apply
> it?
> 
Yes, that seems reasonable to me,

Steve.

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


