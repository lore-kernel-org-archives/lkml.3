Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaI1ISr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:18:47 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbaI1ISn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:18:43 -0400
Message-ID: <5427C45C.2080506@nod.at>
Date: Sun, 28 Sep 2014 10:18:36 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Tanya Brokhman <tlinder@codeaurora.org>, dedeking1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya,

Am 28.09.2014 08:37, schrieb Tanya Brokhman:
> The need for performing read disturb is determined according to new
> statistics collected per eraseblock:
> - read counter: incremented at each read operation
>                 reset at each erase
> - last erase time stamp: updated at each erase



> This patch adds the infrastructure for the above statistics
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> ---
>  drivers/mtd/ubi/build.c     | 57 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/ubi/fastmap.c   | 14 +++++++----
>  drivers/mtd/ubi/ubi-media.h | 32 ++++++++++++++++++++++---
>  drivers/mtd/ubi/ubi.h       | 34 +++++++++++++++++++++++++++
>  drivers/mtd/ubi/wl.c        |  6 +++++
>  5 files changed, 135 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> index 6e30a3c..34fe23a 100644
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -1,6 +1,9 @@
>  /*
>   * Copyright (c) International Business Machines Corp., 2006
>   * Copyright (c) Nokia Corporation, 2007
> + * Copyright (c) 2014, Linux Foundation. All rights reserved.
> + * Linux Foundation chooses to take subject only to the GPLv2
> + * license terms, and distributes only under these terms.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -118,6 +121,10 @@ static struct class_attribute ubi_version =
>  static ssize_t dev_attribute_show(struct device *dev,
>  				  struct device_attribute *attr, char *buf);
>  
> +static ssize_t dev_attribute_store(struct device *dev,
> +		   struct device_attribute *attr, const char *buf,
> +		   size_t count);
> +
>  /* UBI device attributes (correspond to files in '/<sysfs>/class/ubi/ubiX') */
>  static struct device_attribute dev_eraseblock_size =
>  	__ATTR(eraseblock_size, S_IRUGO, dev_attribute_show, NULL);
> @@ -141,6 +148,12 @@ static struct device_attribute dev_bgt_enabled =
>  	__ATTR(bgt_enabled, S_IRUGO, dev_attribute_show, NULL);
>  static struct device_attribute dev_mtd_num =
>  	__ATTR(mtd_num, S_IRUGO, dev_attribute_show, NULL);
> +static struct device_attribute dev_dt_threshold =
> +	__ATTR(dt_threshold, (S_IWUSR | S_IRUGO), dev_attribute_show,
> +		   dev_attribute_store);
> +static struct device_attribute dev_rd_threshold =
> +	__ATTR(rd_threshold, (S_IWUSR | S_IRUGO), dev_attribute_show,
> +		   dev_attribute_store);
>  
>  /**
>   * ubi_volume_notify - send a volume change notification.
> @@ -378,6 +391,10 @@ static ssize_t dev_attribute_show(struct device *dev,
>  		ret = sprintf(buf, "%d\n", ubi->thread_enabled);
>  	else if (attr == &dev_mtd_num)
>  		ret = sprintf(buf, "%d\n", ubi->mtd->index);
> +	else if (attr == &dev_dt_threshold)
> +		ret = sprintf(buf, "%d\n", ubi->dt_threshold);
> +	else if (attr == &dev_rd_threshold)
> +		ret = sprintf(buf, "%d\n", ubi->rd_threshold);
>  	else
>  		ret = -EINVAL;
>  
> @@ -385,6 +402,38 @@ static ssize_t dev_attribute_show(struct device *dev,
>  	return ret;
>  }
>  
> +static ssize_t dev_attribute_store(struct device *dev,
> +			   struct device_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	int value;
> +	struct ubi_device *ubi;
> +
> +	ubi = container_of(dev, struct ubi_device, dev);
> +	ubi = ubi_get_device(ubi->ubi_num);
> +	if (!ubi)
> +		return -ENODEV;
> +
> +	if (kstrtos32(buf, 10, &value))
> +		return -EINVAL;
> +	/* Consider triggering full scan if threshods change */
> +	else if (attr == &dev_dt_threshold) {
> +		if (value < UBI_MAX_DT_THRESHOLD)
> +			ubi->dt_threshold = value;
> +		else
> +			pr_err("Max supported threshold value is %d",
> +				   UBI_MAX_DT_THRESHOLD);
> +	} else if (attr == &dev_rd_threshold) {
> +		if (value < UBI_MAX_READCOUNTER)
> +			ubi->rd_threshold = value;
> +		else
> +			pr_err("Max supported threshold value is %d",
> +				   UBI_MAX_READCOUNTER);
> +	}
> +
> +	return count;
> +}
> +
>  static void dev_release(struct device *dev)
>  {
>  	struct ubi_device *ubi = container_of(dev, struct ubi_device, dev);
> @@ -445,6 +494,12 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
>  	if (err)
>  		return err;
>  	err = device_create_file(&ubi->dev, &dev_mtd_num);
> +	if (err)
> +		return err;
> +	err = device_create_file(&ubi->dev, &dev_dt_threshold);
> +	if (err)
> +		return err;
> +	err = device_create_file(&ubi->dev, &dev_rd_threshold);
>  	return err;
>  }
>  
> @@ -455,6 +510,8 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
>  static void ubi_sysfs_close(struct ubi_device *ubi)
>  {
>  	device_remove_file(&ubi->dev, &dev_mtd_num);
> +	device_remove_file(&ubi->dev, &dev_dt_threshold);
> +	device_remove_file(&ubi->dev, &dev_rd_threshold);
>  	device_remove_file(&ubi->dev, &dev_bgt_enabled);
>  	device_remove_file(&ubi->dev, &dev_min_io_size);
>  	device_remove_file(&ubi->dev, &dev_max_vol_count);
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index 0431b46..5399aa2 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -1,5 +1,7 @@
>  /*
>   * Copyright (c) 2012 Linutronix GmbH
> + * Copyright (c) 2014, Linux Foundation. All rights reserved.
> + *

Diffstat says "drivers/mtd/ubi/fastmap.c   | 14 +++++++----", does this really justify
a new copyright line?
If so I'll have to add the new company I work for here too.

>   * Author: Richard Weinberger <richard@nod.at>
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -727,9 +729,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
>  		}
>  
>  		for (j = 0; j < be32_to_cpu(fm_eba->reserved_pebs); j++) {
> -			int pnum = be32_to_cpu(fm_eba->pnum[j]);
> +			int pnum = be32_to_cpu(fm_eba->peb_data[j].pnum);
>  
> -			if ((int)be32_to_cpu(fm_eba->pnum[j]) < 0)
> +			if ((int)be32_to_cpu(fm_eba->peb_data[j].pnum) < 0)
>  				continue;
>  
>  			aeb = NULL;
> @@ -757,7 +759,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
>  				}
>  
>  				aeb->lnum = j;
> -				aeb->pnum = be32_to_cpu(fm_eba->pnum[j]);
> +				aeb->pnum =
> +					be32_to_cpu(fm_eba->peb_data[j].pnum);
>  				aeb->ec = -1;
>  				aeb->scrub = aeb->copy_flag = aeb->sqnum = 0;
>  				list_add_tail(&aeb->u.list, &eba_orphans);
> @@ -1250,11 +1253,12 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
>  			vol->vol_type == UBI_STATIC_VOLUME);
>  
>  		feba = (struct ubi_fm_eba *)(fm_raw + fm_pos);
> -		fm_pos += sizeof(*feba) + (sizeof(__be32) * vol->reserved_pebs);
> +		fm_pos += sizeof(*feba) +
> +			2 * (sizeof(__be32) * vol->reserved_pebs);
>  		ubi_assert(fm_pos <= ubi->fm_size);
>  
>  		for (j = 0; j < vol->reserved_pebs; j++)
> -			feba->pnum[j] = cpu_to_be32(vol->eba_tbl[j]);
> +			feba->peb_data[j].pnum = cpu_to_be32(vol->eba_tbl[j]);
>  
>  		feba->reserved_pebs = cpu_to_be32(j);
>  		feba->magic = cpu_to_be32(UBI_FM_EBA_MAGIC);
> diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
> index ac2b24d..da418ad 100644
> --- a/drivers/mtd/ubi/ubi-media.h
> +++ b/drivers/mtd/ubi/ubi-media.h
> @@ -1,5 +1,8 @@
>  /*
>   * Copyright (c) International Business Machines Corp., 2006
> + * Copyright (c) 2014, Linux Foundation. All rights reserved.
> + * Linux Foundation chooses to take subject only to the GPLv2
> + * license terms, and distributes only under these terms.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -38,6 +41,15 @@
>  /* The highest erase counter value supported by this implementation */
>  #define UBI_MAX_ERASECOUNTER 0x7FFFFFFF
>  
> +/* The highest read counter value supported by this implementation */
> +#define UBI_MAX_READCOUNTER 0x7FFFFFFD /* (0x7FFFFFFF - 2)*/
> +
> +/*
> + * The highest data retention threshold value supported
> + * by this implementation
> + */
> +#define UBI_MAX_DT_THRESHOLD 0x7FFFFFFF
> +
>  /* The initial CRC32 value used when calculating CRC checksums */
>  #define UBI_CRC32_INIT 0xFFFFFFFFU
>  
> @@ -130,6 +142,7 @@ enum {
>   * @vid_hdr_offset: where the VID header starts
>   * @data_offset: where the user data start
>   * @image_seq: image sequence number
> + * @last_erase_time: time stamp of the last erase operation
>   * @padding2: reserved for future, zeroes
>   * @hdr_crc: erase counter header CRC checksum
>   *
> @@ -162,7 +175,8 @@ struct ubi_ec_hdr {
>  	__be32  vid_hdr_offset;
>  	__be32  data_offset;
>  	__be32  image_seq;
> -	__u8    padding2[32];
> +	__be64  last_erase_time; /*curr time in sec == unsigned long time_t*/
> +	__u8    padding2[24];
>  	__be32  hdr_crc;
>  } __packed;
>  
> @@ -413,6 +427,8 @@ struct ubi_vtbl_record {
>   * @used_blocks: number of PEBs used by this fastmap
>   * @block_loc: an array containing the location of all PEBs of the fastmap
>   * @block_ec: the erase counter of each used PEB
> + * @block_rc: the read counter of each used PEB
> + * @block_let: the last erase timestamp of each used PEB
>   * @sqnum: highest sequence number value at the time while taking the fastmap
>   *
>   */
> @@ -424,6 +440,8 @@ struct ubi_fm_sb {
>  	__be32 used_blocks;
>  	__be32 block_loc[UBI_FM_MAX_BLOCKS];
>  	__be32 block_ec[UBI_FM_MAX_BLOCKS];
> +	__be32 block_rc[UBI_FM_MAX_BLOCKS];
> +	__be64 block_let[UBI_FM_MAX_BLOCKS];

Doesn't this break the fastmap on-disk layout?

>  	__be64 sqnum;
>  	__u8 padding2[32];
>  } __packed;
> @@ -469,13 +487,17 @@ struct ubi_fm_scan_pool {
>  /* ubi_fm_scan_pool is followed by nfree+nused struct ubi_fm_ec records */
>  
>  /**
> - * struct ubi_fm_ec - stores the erase counter of a PEB
> + * struct ubi_fm_ec - stores the erase/read counter of a PEB
>   * @pnum: PEB number
>   * @ec: ec of this PEB
> + * @rc: rc of this PEB
> + * @last_erase_time: last erase time stamp of this PEB
>   */
>  struct ubi_fm_ec {
>  	__be32 pnum;
>  	__be32 ec;
> +	__be32 rc;
> +	__be64 last_erase_time;

Same here.

>  } __packed;
>  
>  /**
> @@ -506,10 +528,14 @@ struct ubi_fm_volhdr {
>   * @magic: EBA table magic number
>   * @reserved_pebs: number of table entries
>   * @pnum: PEB number of LEB (LEB is the index)
> + * @rc: Read counter of the LEBs PEB (LEB is the index)
>   */
>  struct ubi_fm_eba {
>  	__be32 magic;
>  	__be32 reserved_pebs;
> -	__be32 pnum[0];
> +	struct {
> +		__be32 pnum;
> +		__be32 rc;
> +	} peb_data[0];

And here.

Thanks,
//richard
