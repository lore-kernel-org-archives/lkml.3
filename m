Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaAUGq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 01:46:29 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41998 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 01:46:20 -0500
Message-ID: <52DE1578.4010905@linux.vnet.ibm.com>
Date: Tue, 21 Jan 2014 12:06:40 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Matias Bjorling <m@bjorling.me>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2]  fs null_blk: Null pointer deference problem in
 alloc_page_buffers
References: <1390222730-15030-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <52DD4FA9.80900@bjorling.me>
In-Reply-To: <52DD4FA9.80900@bjorling.me>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012106-3568-0000-0000-000004D3E0B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 10:02 PM, Matias Bjorling wrote:
> On 01/20/2014 04:58 AM, Raghavendra K T wrote:
>>   If we load the null_blk module with bs=8k we get following oops:
>> [ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> [ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
>> [ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0
>> [ 3819.812640] Oops: 0000 [#1] SMP
>> [ 3819.812772] Modules linked in: null_blk(+)
>>
>>   Fix that by resetting block size to PAGE_SIZE if it is greater than PAGE_SIZE
>>   Also add sanity checks for block size > PAGE_SIZE.
>
> We should probably split the patch into two. Giving a better description
> to each of the changes.
>

Agreed.

[...]
>> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
>> index a2e69d2..bcae726 100644
>> --- a/drivers/block/null_blk.c
>> +++ b/drivers/block/null_blk.c
>> @@ -622,6 +622,10 @@ static int __init null_init(void)
>>   		irqmode = NULL_IRQ_NONE;
>>   	}
>>   #endif
>> +	if (bs > PAGE_SIZE) {
>> +		pr_warn("Invalid block size. Setting it to %lu\n", PAGE_SIZE);
>> +		bs = PAGE_SIZE;
>> +	}
>
> Could the warning say something like:
>
> pr_warn("null_blk: invalid block size\n");
> pr_warn("null_blk: defaults block size to &lu\n");
>
> then it follows the same patterns as the other errors.

Agree.

>
>>
>>   	if (queue_mode == NULL_Q_MQ && use_per_node_hctx) {
>>   		if (submit_queues < nr_online_nodes) {
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
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 6024877..8b7ada1 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1571,6 +1571,7 @@ void create_empty_buffers(struct page *page,
>>   	struct buffer_head *bh, *head, *tail;
>>
>>   	head = alloc_page_buffers(page, blocksize, 1);
>> +	BUG_ON(!head);
>>   	bh = head;
>>   	do {
>>   		bh->b_state |= b_state;
>>
>
> For the check patch, the description could mention some text on why we
> hit this error case and why we check for it.
>

Thanks for the suggestions. Will post V3 with the changes.

