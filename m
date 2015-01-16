Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbbAPWVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:21:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbAPWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:21:40 -0500
Date: Fri, 16 Jan 2015 14:21:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com
Subject: Re: [PATCH] sysfs: group: allow is_visible to drop permissions
Message-ID: <20150116222139.GB512@kroah.com>
References: <1421443750-12935-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421443750-12935-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 04:29:10PM -0500, Vivien Didelot wrote:
> Using the optional is_visible function, it is actually possible to
> either hide an attribute, or add a new permission, but not remove one.

What code wants to remove attributes?

> This commit uses all the UGO bits returned by is_visible instead of
> OR'ing them with the default attribute mode.
> 
> Concretely, this allows a driver to use macros like DEVICE_ATTR_RW to
> set the attribute show and store functions and remove the S_IWUSR
> permission in is_visible if the implementation doesn't provide a setter.

What bus wants to do this?

> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  fs/sysfs/group.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index 7d2a860..a8cfe03 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -41,7 +41,7 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
>  
>  	if (grp->attrs) {
>  		for (i = 0, attr = grp->attrs; *attr && !error; i++, attr++) {
> -			umode_t mode = 0;
> +			umode_t mode = (*attr)->mode;
>  
>  			/*
>  			 * In update mode, we're changing the permissions or
> @@ -51,13 +51,15 @@ static int create_files(struct kernfs_node *parent, struct kobject *kobj,
>  			if (update)
>  				kernfs_remove_by_name(parent, (*attr)->name);
>  			if (grp->is_visible) {
> -				mode = grp->is_visible(kobj, *attr, i);
> -				if (!mode)
> +				umode_t ugo = grp->is_visible(kobj, *attr, i);
> +
> +				if (!(ugo & S_IRWXUGO))
>  					continue;
> +
> +				mode = (mode & ~S_IRWXUGO) | (ugo & S_IRWXUGO);

Please document what you are doing here in the code, it's not obvious at
first glance.

>  			}
>  			error = sysfs_add_file_mode_ns(parent, *attr, false,
> -						       (*attr)->mode | mode,
> -						       NULL);
> +						       mode, NULL);

Any chance this is going to break existing code that isn't expecting
this type of change in functionality?

thanks,

greg k-h
