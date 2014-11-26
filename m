Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaKZHVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:21:53 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62974 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbaKZHVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:21:51 -0500
Date: Tue, 25 Nov 2014 23:21:47 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Rodrigo Freire <rfreire@redhat.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        Felix Fietkau <nbd@openwrt.org>, dwmw2@infradead.org,
        Herton Krzesinski <hkrzesin@redhat.com>
Subject: Re: [PATCH v3 3/3] mtd: block2mtd: Removes PAGE_MASK as a index to
 partition size
Message-ID: <20141126072147.GO3212@norris-Latitude-E6410>
References: <371358190.34795877.1410204429882.JavaMail.zimbra@redhat.com>
 <1444809468.34812041.1410206680931.JavaMail.zimbra@redhat.com>
 <20140909170231.GA14429@logfs.org>
 <1807144344.40128259.1410985683342.JavaMail.zimbra@redhat.com>
 <20141105202303.GN23619@ld-irv-0074>
 <2086372266.7454667.1415535533979.JavaMail.zimbra@redhat.com>
 <1874445287.7454806.1415535792984.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1874445287.7454806.1415535792984.JavaMail.zimbra@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 07:23:12AM -0500, Rodrigo Freire wrote:
> From: Felix Fietkau <nbd@openwrt.org>
> 
> mtd: block2mtd: Removes PAGE_MASK as a index to partition size

You don't need to repeat the subject here.

> 
> PAGE_MASK is no longer needed with the new term.

This isn't too descriptive. What you probably mean is that we assume the
erase size is always larger than PAGE_SIZE.

> This patch keeps the device size aligned with the erase_size.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Rodrigo Freire <rfreire@redhat.com>
> Signed-off-by: Herton Krzesinski <herton@redhat.com>
> ---
> V3: Separated on a single patch
> --- a/drivers/mtd/devices/block2mtd.c	2014-11-07 17:40:58.688747820 -0200
> +++ b/drivers/mtd/devices/block2mtd.c	2014-11-07 17:41:28.054750893 -0200
> @@ -291,8 +291,7 @@ static struct block2mtd_dev *add_device(
>  		goto err_destroy_mutex;
>  
>  	dev->mtd.name = name;
> -
> -	dev->mtd.size = dev->blkdev->bd_inode->i_size & PAGE_MASK;
> +	dev->mtd.size = dev->blkdev->bd_inode->i_size & ~(erase_size - 1);

You never guaranteed that erase_size is a power of two, so this doesn't
necessarily mask the way you'd like...

But also, why is this even necessary? I see that we should already have
errored out if this was actually significant, since we have above:

	if ((long)dev->blkdev->bd_inode->i_size % erase_size) {
		pr_err("erasesize must be a divisor of device size\n");
		goto err_free_block2mtd;
	}

>  	dev->mtd.erasesize = erase_size;
>  	dev->mtd.writesize = 1;
>  	dev->mtd.writebufsize = PAGE_SIZE;

Brian
