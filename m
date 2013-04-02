Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab3DBIZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:25:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3DBIZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:25:51 -0400
Date: Tue, 2 Apr 2013 10:25:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Marco Munderloh <munderl@tnt.uni-hannover.de>
Cc: Ilija Hadzic <ilijahadzic@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
Message-ID: <20130402082547.GA24345@dhcp22.suse.cz>
References: <20130326195601.GA5124@dhcp22.suse.cz>
 <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
 <20130331103418.GA18476@dhcp22.suse.cz>
 <Pine.GSO.4.64.1304011249370.27674@umail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1304011249370.27674@umail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 01-04-13 13:14:50, Ilija Hadzic wrote:
> 
> 
> On Sun, 31 Mar 2013, Michal Hocko wrote:
> 
> >On Sat 30-03-13 18:26:53, Ilija Hadzic wrote:
> >>This looks a bit like a hack and it doesn't look right,
> >>conceptually. If the call fails, it should restore things as if
> >>nothing has ever happened and overwriting old_mapping is not going to
> >>do the trick.
> >
> >OK, I thought this is what the patch does as it falls back to
> >&inode->i_data which is the default mapping for all inodes or it uses
> >what used to be in device mapping.
> >
> >I am obviously not familiar with the drm code but it feels a bit strange
> >that the device mapping can be different than inode's resp. file's one
> 
> The reason for this is explained in commit message associated with
> 949c4a34.
> 
> In summary, the device's mapping is that of the inode associated with the
> first opener. Before 949c4a34, subsequent openers would have to come in
> through exactly the same inode that the first opener came in
> (otherwise the open call would fail). So if a user did something
> like: start X, remove /dev/dri/cardN file, mknod the same file
> again, the applications started after such an action would stop
> working. Also, using the GPU from chroot-ed environment was not
> possible if there was another opener from different root.

Oh, I see. Thanks for the clarification.

> The 949c4a34, removed this restriction, but introduced a problem
> with VmWare GPU drivers, which fdb40a08. However, fdb40a08
> introduced the bug that you have reported.
> 
> The problem that I have with your proposed fix is that if the first
> opener fails, it can set the device's mapping to that of the inode
> that was never used and never opened (and could even be removed
> later down the road).

Makes sense.

> >and even more confusing that inode and file are saved separately.
> >
> 
> I was trying to quickly get out the patch that was safe in terms of
> introducing new breakage. So the "conservative" thing to do (without
> having to think through all possible scenarios) was to restore each
> of the three pointers from their own temporary variable. Thinking
> about it, you are probably right that file descriptor's and inode's
> mapping pointer are equal when open call is entered so we could use
> one variable. However, you still need a separate variable to store
> the device's mapping pointer because that one can be different.

Right.

> Attached is a v2 of the patch, for reference. I would appreciate if
> the original reporter or you tested it in lieu of your proposed
> patch and let me know if it fixes your issue.

OK, this is a call for Marco. I have attached this bug to our bugzilla
as well (just for reference:
https://bugzilla.novell.com/show_bug.cgi?id=807850)

> 
> -- Ilija

> From 7e3c832158e2552e5e106a588e2b9e61c35b68f2 Mon Sep 17 00:00:00 2001
> From: Ilija Hadzic <ihadzic@research.bell-labs.com>
> Date: Sat, 30 Mar 2013 18:20:35 -0400
> Subject: [PATCH] drm: correctly restore mappings if drm_open fails
> 
> If first drm_open fails, the error-handling path will
> incorrectly restore inode's mapping to NULL. This can
> cause the crash later on. Fix by separately storing
> away mapping pointers that drm_open can touch and
> restore each from its own respective variable if the
> call fails.
> 
> Reference:
> http://lists.freedesktop.org/archives/dri-devel/2013-March/036564.html
> 
> v2: use one variable to store file and inode mapping
>     since they are the same at the function entry; also
>     fix spelling mistakes in commit message.
> 
> Reported-by: Marco Munderloh <munderl@tnt.uni-hannover.de>
> Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: stable@vger.kernel.org

Feel free to add
Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks!

> Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
> ---
>  drivers/gpu/drm/drm_fops.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
> index 13fdcd1..429e07d 100644
> --- a/drivers/gpu/drm/drm_fops.c
> +++ b/drivers/gpu/drm/drm_fops.c
> @@ -123,6 +123,7 @@ int drm_open(struct inode *inode, struct file *filp)
>  	int retcode = 0;
>  	int need_setup = 0;
>  	struct address_space *old_mapping;
> +	struct address_space *old_imapping;
>  
>  	minor = idr_find(&drm_minors_idr, minor_id);
>  	if (!minor)
> @@ -137,6 +138,7 @@ int drm_open(struct inode *inode, struct file *filp)
>  	if (!dev->open_count++)
>  		need_setup = 1;
>  	mutex_lock(&dev->struct_mutex);
> +	old_imapping = inode->i_mapping;
>  	old_mapping = dev->dev_mapping;
>  	if (old_mapping == NULL)
>  		dev->dev_mapping = &inode->i_data;
> @@ -159,8 +161,8 @@ int drm_open(struct inode *inode, struct file *filp)
>  
>  err_undo:
>  	mutex_lock(&dev->struct_mutex);
> -	filp->f_mapping = old_mapping;
> -	inode->i_mapping = old_mapping;
> +	filp->f_mapping = old_imapping;
> +	inode->i_mapping = old_imapping;
>  	iput(container_of(dev->dev_mapping, struct inode, i_data));
>  	dev->dev_mapping = old_mapping;
>  	mutex_unlock(&dev->struct_mutex);
> -- 
> 1.7.4.1
> 


-- 
Michal Hocko
SUSE Labs
