Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaHGMR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:17:29 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:53918 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaHGMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:17:28 -0400
Message-ID: <53E36E53.3090008@gmail.com>
Date: Thu, 07 Aug 2014 15:17:23 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
        Boaz Harrosh <boaz@plexistor.com>
CC: Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 4/4] brd: Request from fdisk 4k alignment
References: <53E21125.9080308@plexistor.com>	 <53E21317.7080403@plexistor.com> <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1407362634.2869.2.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 01:03 AM, Ross Zwisler wrote:
> On Wed, 2014-08-06 at 14:35 +0300, Boaz Harrosh wrote:
>> Because of the direct_access() API which returns a PFN. partitions
>> better start on 4K boundary, else offset ZERO of a partition will
>> not be aligned and blk_direct_access() will fail the call.
>>
>> By setting blk_queue_physical_block_size(PAGE_SIZE) we can communicate
>> this to fdisk and friends.
>> Note that blk_queue_physical_block_size() also trashes io_min, but
>> we can leave this one to be 512.
>>
>> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
>> ---
>>  drivers/block/brd.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/block/brd.c b/drivers/block/brd.c
>> index 9673704..514cfe1 100644
>> --- a/drivers/block/brd.c
>> +++ b/drivers/block/brd.c
>> @@ -495,10 +495,17 @@ static struct brd_device *brd_alloc(int i)
>>  	brd->brd_queue = blk_alloc_queue(GFP_KERNEL);
>>  	if (!brd->brd_queue)
>>  		goto out_free_dev;
>> +
>>  	blk_queue_make_request(brd->brd_queue, brd_make_request);
>>  	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
>>  	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
>>  
>> +	/* This is so fdisk will align partitions on 4k, because of
>> +	 * direct_access API needing 4k alignment, returning a PFN
>> +	 */
>> +	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
>> +	brd->brd_queue->limits.io_min = 512; /* Don't use the accessor */
>> +
>>  	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
>>  	brd->brd_queue->limits.max_discard_sectors = UINT_MAX;
>>  	brd->brd_queue->limits.discard_zeroes_data = 1;
> 
> Is there an error case that this patch fixes?  I've had page alignment checks
> in my PRD direct_access code forever, and I don't know if they've ever
> tripped.  
> 

Yes! as I said above fix fdisk. You never tripped on it because partitions never
worked and you never tried them. With current code fdisk is very trigger happy
to miss-align my partitions. Depending on size maybe not the very first one but the
consecutive ones easily.
With this patch user can still do wrong, but all the default values offered
by fdisk are correct, specially for start-sector which is the one we care about
most. So yes this is an important fix. 

> Also, blk_queue_physical_block_size() seems wrong - here's the comment for
> that function:
> 
> 	/**
> 	 * blk_queue_physical_block_size - set physical block size for the queue
> 	 * @q:  the request queue for the device
> 	 * @size:  the physical block size, in bytes
> 	 *
> 	 * Description:
> 	 *   This should be set to the lowest possible sector size that the
> 	 *   hardware can operate on without reverting to read-modify-write
> 	 *   operations.
> 	 */
> 

This text is just text. But in practice all this is used for is alignment.
Actually at Kernel it is not used, it is just exported through the disk limits
sysfs info to user space.

I can see in code that there are bunch of fast flash devices like Micron that do the
same, and also like zram and others, this is the only one that gets the job done, that
I can find.

And then this is the only one that caused fdisk to jump from 34 to 40.
And with my new getgeo patch jump to 8, and align all partition starts on
8. try it for your self.

> It doesn't sound like this is what you're after?  It sounds like instead you
> want to control the alignment, not minimum natural I/O size?  It seems like if
> you did want to do this, blk_queue_alignment_offset() would be more what you
> were after?
> 

No. I tried that one. It only helps with first partition start. And not so much.
(And it is actually masked by limits->physical_block_size)

fdisk will not look at it only Kernel try's to do something with it after it
is too late and the partition table is received wrong.

With what I searched in code and what I tried with fdisk this does exactly what I
want, scares everyone to align my sectors on 8!

I would like to see some bad code doing because of this one? for me and with
DAX access it can do no harm whats so ever. What are you afraid that can happen
with this? Do you imagine applications doing extra copy because of that? That
does not make sense. The read-modify-write is faster at the device then at
application so the application should let it be as is and not do anything extra

> - Ross
> 
> 

Please play with this for a while. I have for a week now. It looks very good
and the only one that does what I want. Actually I'm very happy that I found
this, I was afraid at first that nothing will work, and fdisk will keep give
me wrong start sectors.

Thanks
Boaz

