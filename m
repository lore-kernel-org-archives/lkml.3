Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3CaKeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 06:34:24 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:36257 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3CaKeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 06:34:23 -0400
Date: Sun, 31 Mar 2013 12:34:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Ilija Hadzic <ilijahadzic@gmail.com>
Cc: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Marco Munderloh <munderl@tnt.uni-hannover.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: fix i_mapping and f_mapping initialization in
 drm_open in error path
Message-ID: <20130331103418.GA18476@dhcp22.suse.cz>
References: <20130326195601.GA5124@dhcp22.suse.cz>
 <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+4h6Hnhm-Ox_5dRdBH3C9Lh_qVNac8_oL=3ruy75jBX7xp9OQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 30-03-13 18:26:53, Ilija Hadzic wrote:
> This looks a bit like a hack and it doesn't look right,
> conceptually. If the call fails, it should restore things as if
> nothing has ever happened and overwriting old_mapping is not going to
> do the trick.

OK, I thought this is what the patch does as it falls back to
&inode->i_data which is the default mapping for all inodes or it uses
what used to be in device mapping.

I am obviously not familiar with the drm code but it feels a bit strange
that the device mapping can be different than inode's resp. file's one
and even more confusing that inode and file are saved separately.

> I think the right way to fix it would be to separately store the
> original mapping for filp->f_mapping and inode->i_mapping and restore
> it from their respective temporary variables if drm_open_helper or
> drm_setup fail. Attached is a quick patch to show you
[...]
> @@ -137,6 +139,8 @@ int drm_open(struct inode *inode, struct file *filp)
>  	if (!dev->open_count++)
>  		need_setup = 1;
>  	mutex_lock(&dev->struct_mutex);
> +	old_fmapping = filp->f_mapping;
> +	old_imapping = inode->i_mapping;

How can file and inode mappings be different?

>  	old_mapping = dev->dev_mapping;
>  	if (old_mapping == NULL)
>  		dev->dev_mapping = &inode->i_data;
> @@ -159,8 +163,8 @@ int drm_open(struct inode *inode, struct file *filp)
>  
>  err_undo:
>  	mutex_lock(&dev->struct_mutex);
> -	filp->f_mapping = old_mapping;
> -	inode->i_mapping = old_mapping;
> +	filp->f_mapping = old_fmapping;
> +	inode->i_mapping = old_imapping;
>  	iput(container_of(dev->dev_mapping, struct inode, i_data));
>  	dev->dev_mapping = old_mapping;
>  	mutex_unlock(&dev->struct_mutex);
-- 
1.8.1.5

-- 
Michal Hocko
SUSE Labs
