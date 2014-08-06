Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaHFR6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:58:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:22228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbaHFR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:58:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="368817576"
Date: Wed, 6 Aug 2014 11:52:40 -0600 (MDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
X-X-Sender: rzwisler@scrumpy
To: Boaz Harrosh <boaz@plexistor.com>
cc: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 2/4] brd: Add getgeo to block ops
In-Reply-To: <53E211D9.7030102@plexistor.com>
Message-ID: <alpine.OSX.2.00.1408061150120.23481@scrumpy>
References: <53E21125.9080308@plexistor.com> <53E211D9.7030102@plexistor.com>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Boaz Harrosh wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> Some programs require HDIO_GETGEO work, which requires we implement
> getgeo.  Based off of the work done to the NVMe driver in this commit:
> 
> 4cc09e2dc4cb NVMe: Add getgeo to block ops
> 
> [Boaz] Converted original work done for prd.c for here.
>        This is needed if we want to support partitions, fdisk
>        calls this.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/brd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
> index a10a0a9..3f07cb4 100644
> --- a/drivers/block/brd.c
> +++ b/drivers/block/brd.c
> @@ -19,6 +19,7 @@
>  #include <linux/radix-tree.h>
>  #include <linux/fs.h>
>  #include <linux/slab.h>
> +#include <linux/hdreg.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -424,6 +425,15 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
>  	return error;
>  }
>  
> +static int brd_getgeo(struct block_device *bd, struct hd_geometry *geo)
> +{
> +	/* some standard values */
> +	geo->heads = 1 << 6;
> +	geo->sectors = 1 << 5;
> +	geo->cylinders = get_capacity(bd->bd_disk) >> 11;
> +	return 0;
> +}
> +
>  static const struct block_device_operations brd_fops = {
>  	.owner =		THIS_MODULE,
>  	.rw_page =		brd_rw_page,
> @@ -431,6 +441,7 @@ static const struct block_device_operations brd_fops = {
>  #ifdef CONFIG_BLK_DEV_XIP
>  	.direct_access =	brd_direct_access,
>  #endif
> +	.getgeo =		brd_getgeo,
>  };
>  
>  /*
> -- 
> 1.9.3

This looks good.

- Ross
