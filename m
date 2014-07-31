Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaGaP2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:28:43 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45990 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaGaP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:28:42 -0400
Message-ID: <53DA60A5.1030304@gmail.com>
Date: Thu, 31 Jul 2014 18:28:37 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
References: <cover.1406058387.git.matthew.r.wilcox@intel.com> <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com> <53D9174C.7040906@gmail.com> <20140730194503.GQ6754@linux.intel.com> <53DA165E.8040601@gmail.com> <20140731141315.GT6754@linux.intel.com>
In-Reply-To: <20140731141315.GT6754@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 05:13 PM, Matthew Wilcox wrote:
> On Thu, Jul 31, 2014 at 01:11:42PM +0300, Boaz Harrosh wrote:
>>>>> +	if (size < 0)
>>>>
>>>> 	if(size < PAGE_SIZE), No?
>>>
>>> No, absolutely not.  PAGE_SIZE is unsigned long, which (if I understand
>>> my C integer promotions correctly) means that 'size' gets promoted to
>>> an unsigned long, and we compare them unsigned, so errors will never be
>>> caught by this check.
>>
>> Good point I agree that you need a cast ie.
>>
>>  	if(size < (long)PAGE_SIZE)
>>
>> The reason I'm saying this is because of a bug I actually hit when
>> playing with partitioning and fdisk, it came out that the last partition's
>> size was not page aligned, and code that checked for (< 0) crashed because
>> prd returned the last two sectors of the partition, since your API is sector
>> based this can happen for you here, before you are memseting a PAGE_SIZE
>> you need to test there is space, No? 
> 
> Not in ext2/ext4.  It requires block size == PAGE_SIZE, so it's never
> going to request the last partial block in a partition.
> 

OK cool. then.

Matthew what is your opinion about this, do we need to push for removal
of the partition dead code which never worked for brd, or we need to push
for fixing and implementing new partition support for brd?

Also another thing I saw is that if we leave the flag 
	GENHD_FL_SUPPRESS_PARTITION_INFO

then mount -U UUID stops to work, regardless of partitions or not,
this is because Kernel will not put us on /proc/patitions.
I'll submit another patch to remove it.

BTW I hit another funny bug where the partition beginning was not
4K aligned apparently fdisk lets you do this if the total size is small
enough  (like 4096 which is default for brd) so I ended up with accessing
sec zero, the supper-block, failing because of the alignment check at
direct_access().
Do you know of any API that brd/prd can do to not let fdisk do this?
I'm looking at it right now I just thought it is worth asking.

Thanks for everything
Boaz

