Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3APHON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:14:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:37057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758083Ab3APHOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:14:10 -0500
Date: Tue, 15 Jan 2013 23:15:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: yanyg <yanyg02@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: sysfs_update_group always fails and generates a
 WARNING CALL-trace
Message-ID: <20130116071509.GA865@kroah.com>
References: <20130116070425.GA3972@yvit>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116070425.GA3972@yvit>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 03:04:25PM +0800, yanyg wrote:
> @sysfs_update_group@ always fails and borns a WARNING CALL-trace
> if the group exists. BUT still now, no *reference* of this routine at all.

I don't understand.

> >From fe40df7d716658a1fbdab79768628c81d4363428 Mon Sep 17 00:00:00 2001
> From: yanyg <yanyg02@gmail.com>
> Date: Wed, 16 Jan 2013 11:25:15 +0800
> Subject: [PATCH] sysfs-fixes:
> 
> @sysfs_update_group@ always fail and generates WARNING CALL trace.
> fix @internal_create_group@ to avoid it.

Why did you embed the patch here, with the words above it?  I would have
to edit it to apply it :(

It's also not in a format I can apply (no signed-off-by: line.)

> ---
>  fs/sysfs/group.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index 2df555c..51fcf62 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -60,7 +60,7 @@ static int internal_create_group(struct kobject *kobj, int update,
>  				 const struct attribute_group *grp)
>  {
>  	struct sysfs_dirent *sd;
> -	int error;
> +	int error, do_put = 0;
>  
>  	BUG_ON(!kobj || (!update && !kobj->sd));
>  
> @@ -73,9 +73,14 @@ static int internal_create_group(struct kobject *kobj, int update,
>  		return -EINVAL;
>  	}
>  	if (grp->name) {
> -		error = sysfs_create_subdir(kobj, grp->name, &sd);
> -		if (error)
> -			return error;
> +		sd = sysfs_get_dirent(kobj->sd, NULL, grp->name);
> +		if (sd) {
> +			do_put = 1;
> +		} else {
> +			error = sysfs_create_subdir(kobj, grp->name, &sd);
> +			if (error)
> +				return error;
> +		}
>  	} else
>  		sd = kobj->sd;
>  	sysfs_get(sd);
> @@ -85,6 +90,7 @@ static int internal_create_group(struct kobject *kobj, int update,
>  			sysfs_remove_subdir(sd);
>  	}
>  	sysfs_put(sd);
> +	if (do_put) sysfs_put(sd);

Always run your patches through scripts/checkpatch.pl and fix the
problems it tells you about.

What code in the kernel is hitting this today?

thanks,

greg k-h
