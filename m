Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbaCSXpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:45:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46136 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755757AbaCSXp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:45:29 -0400
Date: Wed, 19 Mar 2014 20:44:59 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Richard Weinberger <richard@nod.at>
Cc: dedekind1@gmail.com, dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UBI: block: Avoid disk size integer overflow
Message-ID: <20140319234459.GA5566@arch.cereza>
References: <1395241074-15506-1-git-send-email-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395241074-15506-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

First of all, thanks a lot for tracking this down!

On Mar 19, Richard Weinberger wrote:
> This patch fixes the issue that on very large UBI volumes
> UBI block does not work correctly.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/mtd/ubi/block.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
> index 9ef7df7..8887d4b 100644
> --- a/drivers/mtd/ubi/block.c
> +++ b/drivers/mtd/ubi/block.c
> @@ -379,7 +379,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
>  {
>  	struct ubiblock *dev;
>  	struct gendisk *gd;
> -	int disk_capacity;
> +	u64 disk_capacity;
>  	int ret;
>  

Perhaps we can calculate the capacity before allocating the struct,
so the error is simpler?

>  	/* Check that the volume isn't already handled */
> @@ -413,7 +413,12 @@ int ubiblock_create(struct ubi_volume_info *vi)
>  	gd->first_minor = dev->ubi_num * UBI_MAX_VOLUMES + dev->vol_id;
>  	gd->private_data = dev;
>  	sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
> -	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
> +	disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
> +	if ((sector_t)disk_capacity != disk_capacity) {
> +		ubi_err("block: disk capacity %llu too large", disk_capacity);

Do we absolutely need to print an error to the console (not all drivers
print errors on every error condition)? Isn't it clear enough from the errno?

If we really want to print something, I suggest something like:
"block: volume too large, cannot create", "block: volume too large to create".

> +		ret = -E2BIG;

Should we use E2BIG (Parameter list too large) or EFBIG (File too large)?

I don't really like the error that's printed by ubiblock on the first case:
"Parameter list too large". Maybe "File too large" is a bit better?

> +		goto out_free_dev;
> +	}
>  	set_capacity(gd, disk_capacity);
>  	dev->gd = gd;
>  
> @@ -500,7 +505,7 @@ int ubiblock_remove(struct ubi_volume_info *vi)
>  static void ubiblock_resize(struct ubi_volume_info *vi)
>  {
>  	struct ubiblock *dev;
> -	int disk_capacity;
> +	u64 disk_capacity;
>  
>  	/*
>  	 * Need to lock the device list until we stop using the device,
> @@ -515,7 +520,13 @@ static void ubiblock_resize(struct ubi_volume_info *vi)
>  	}
>  
>  	mutex_lock(&dev->dev_mutex);
> -	disk_capacity = (vi->size * vi->usable_leb_size) >> 9;
> +	disk_capacity = ((u64)vi->size * vi->usable_leb_size) >> 9;
> +	if ((sector_t)disk_capacity != disk_capacity) {
> +		ubi_err("block: disk capacity %llu too large", disk_capacity);
> +		mutex_unlock(&dev->dev_mutex);

We can get rid of this mutex_unlock if we take it after getting the capacity.

Maybe you can clean the locks first, and then do this fix?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
