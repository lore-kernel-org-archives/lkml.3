Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaAVHBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 02:01:53 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56692 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaAVHBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 02:01:52 -0500
Message-ID: <52DF6AA1.4080708@linux.vnet.ibm.com>
Date: Wed, 22 Jan 2014 12:22:17 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V3 2/2] fs : Add sanity checks for block size > PAGE_SIZE
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1390303800-22422-3-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140121122110.4a74f04f43d2fdc0a8ae35bf@linux-foundation.org>
In-Reply-To: <20140121122110.4a74f04f43d2fdc0a8ae35bf@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012207-5816-0000-0000-00000BE26112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 01:51 AM, Andrew Morton wrote:
> On Tue, 21 Jan 2014 17:00:00 +0530 Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:
>
>> We could hit null pointer dereference error during alloc_page_buffers
>> in : (1) block size > PAGE_SIZE (2) low memory.
>> Add sanity check for that.
>>
>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>> ---
>>   fs/block_dev.c | 1 +
>>   fs/buffer.c    | 6 ++++++
>>   2 files changed, 7 insertions(+)
>>
>> diff --git a/fs/block_dev.c b/fs/block_dev.c
>> index 1e86823..2481d42 100644
>> --- a/fs/block_dev.c
>> +++ b/fs/block_dev.c
>> @@ -1027,6 +1027,7 @@ void bd_set_size(struct block_device *bdev, loff_t size)
>>   			break;
>>   		bsize <<= 1;
>>   	}
>> +	BUG_ON(bsize > PAGE_SIZE);
>>   	bdev->bd_block_size = bsize;
>>   	bdev->bd_inode->i_blkbits = blksize_bits(bsize);
>>   }
>
> alloc_page_buffers() will always return NULL if passed size >=
> PAGE_SIZE.  So if we're going to add a check, it would be better to add
> it to alloc_page_buffers() because that will catch errors from the
> widest range of callsites.

In that case how about converting BUG_ON to setting a default value of
PAGE_SIZE for bs in bd_set_size() itself (with a warning)?

>
> But alloc_page_buffers() is pretty frequently called and I'd be
> inclined to not add any check - most callers will just go oops and that
> will provide basically the same information.

Agree with this concern.

>
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1571,6 +1571,12 @@ void create_empty_buffers(struct page *page,
>>   	struct buffer_head *bh, *head, *tail;
>>
>>   	head = alloc_page_buffers(page, blocksize, 1);
>> +
>> +	/*
>> + 	 * alloc_page_buffers() could return NULL on (1) bs > PAGE_SIZE
>> + 	 * (2) low memory case. Ensure that we don't dereference null ptr
>> + 	 */
>> +	BUG_ON(!head);
>
> This is unneeded.
>
> - bs > PAGE_SIZE can be checked elsewhere in a direct fashion
>
> - low memory case can't happen - we passed retry=1
>
> - create_empty_buffers() will immediately go oops if head==NULL.
>    That oops contains the same info as is presented by a BUG().

Okay.

