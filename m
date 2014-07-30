Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaG3QMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:12:52 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61869 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaG3QMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:12:48 -0400
Message-ID: <53D9197C.2050000@gmail.com>
Date: Wed, 30 Jul 2014 19:12:44 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
CC: willy@linux.intel.com
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
References: <cover.1406058387.git.matthew.r.wilcox@intel.com> <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com> <53D9174C.7040906@gmail.com>
In-Reply-To: <53D9174C.7040906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 07:03 PM, Boaz Harrosh wrote:
<>
>> +long bdev_direct_access(struct block_device *bdev, sector_t sector,
>> +			void **addr, unsigned long *pfn, long size)
>> +{
>> +	const struct block_device_operations *ops = bdev->bd_disk->fops;
>> +	if (!ops->direct_access)
>> +		return -EOPNOTSUPP;
> 
> You need to check alignment on PAGE_SIZE since this API requires it, do
> to pfn defined to a page_number.
> 
> (Unless you want to define another output-param like page_offset.
>  but this exercise can be left to the caller)
> 
> You also need to check against the partition boundary. so something like:
> 
> + 	if (sector & (PAGE_SECTORS-1))
> + 		return -EINVAL;
> +	if (unlikely(sector + size > part_nr_sects_read(bdev->bd_part)))

Off course I was wrong here size is in bytes not in sectors. Which points
out that maybe this API needs to be in sectors.

[Actually it needs to be in pages both size and offset, because of return of
pfn, but its your call.]

Anyway my code above needs to be fixed with
	(size + 512 -1) / 512

Thanks
Boaz

> + 		return -ERANGE;
> 
> Then perhaps you can remove that check from drivers
> 
>> +	return ops->direct_access(bdev, sector + get_start_sect(bdev), addr,
>> +					pfn, size);
>> +}
>> +EXPORT_SYMBOL_GPL(bdev_direct_access);
<>


