Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934152AbaE3Tqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:46:35 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:35849 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbaE3Tqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:46:33 -0400
Message-ID: <5388E024.30203@kernel.dk>
Date: Fri, 30 May 2014 13:46:44 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>,
        =?ISO-8859-1?Q?Matias_Bj=F8?= =?ISO-8859-1?Q?rling?= 
	<m@bjorling.me>
CC: keith.busch@intel.com, sbradshaw@micron.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH v4] NVMe: basic conversion to blk-mq
References: <1401400285-25003-1-git-send-email-m@bjorling.me> <1401400285-25003-2-git-send-email-m@bjorling.me> <20140530150050.GD5499@linux.intel.com>
In-Reply-To: <20140530150050.GD5499@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 09:00 AM, Matthew Wilcox wrote:
> On Thu, May 29, 2014 at 11:51:25PM +0200, Matias Bjørling wrote:
>> -static int nvme_map_bio(struct nvme_queue *nvmeq, struct nvme_iod *iod,
>> -		struct bio *bio, enum dma_data_direction dma_dir, int psegs)
>> +static int nvme_map_rq(struct nvme_queue *nvmeq, struct nvme_iod *iod,
>> +		struct request *req, enum dma_data_direction dma_dir,
>> +		int psegs)
>>  {
>> -	struct bio_vec bvec, bvprv;
>> -	struct bvec_iter iter;
>> -	struct scatterlist *sg = NULL;
>> -	int length = 0, nsegs = 0, split_len = bio->bi_iter.bi_size;
>> -	int first = 1;
>> -
>> -	if (nvmeq->dev->stripe_size)
>> -		split_len = nvmeq->dev->stripe_size -
>> -			((bio->bi_iter.bi_sector << 9) &
>> -			 (nvmeq->dev->stripe_size - 1));
> 
> You take out stripe_size here, but don't appear to put it back in
> anywhere else.

So I've been thinking about this one. What kind of performance impact
does it have on the device in question? Because the current logic of
adding to the congested list and waking up the thread is surely not very
fast. I'm assuming you must have seen some win, which means that the
hardware is pretty poor on requests that overlap the stripe size.

Reason I ask is trying to come up with the best strategy to make this
work. My first thought was just doing partial completions. The request
is fully mapped, but only issue the first X bytes that fit within the
stripe. On completion, simply reissue. Rinse and repeat until request is
done. But this serializes the request to the hardware, which is going to
have a performance impact as well. So the better approach would be to
simple alloc more commands and fill those in, issue them all together.
If we run out of commands, simply issue the ones we do have and continue
on completion.

Another approach would be to prevent these requests to begin with, but
that would come with some runtime overhead as well.

I guess what I'm asking (in a long winded way), is how big of an issue
is this? Is this something that the device has fixed in a firmware
update (it should), or is it something we need to care deeply about?

And finally, how big is the stripe size on device in question? That
might impact the design decision.

-- 
Jens Axboe

