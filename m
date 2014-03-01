Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaCARwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 12:52:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:58034 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbaCARwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 12:52:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="scan'208";a="484182813"
Date: Sat, 1 Mar 2014 10:52:15 -0700 (MST)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Kent Overstreet <kmo@daterainc.com>
cc: Matthew Wilcox <willy@linux.intel.com>, axboe@kernel.dk,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Minchan Kim <minchan@kernel.org>, Neil Brown <neilb@suse.de>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Peng Tao <bergwolf@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Geoff Levand <geoff@infradead.org>, dm-devel@redhat.com,
        drbd-user@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>,
        linux-fsdevel@vger.kernel.org, Jim Paris <jim@jtan.com>,
        Nitin Gupta <ngupta@vflare.org>, Sam Bradshaw <sbradshaw@micron.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Alasdair Kergon <agk@redhat.com>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Subject: Re: [PATCH 1/9] block: Make generic_make_request handle arbitrary
 sized bios
In-Reply-To: <20140228233039.GA2739@moria.home.lan>
Message-ID: <alpine.LRH.2.03.1403011038240.2885@AMR>
References: <1393457997-17618-1-git-send-email-kmo@daterainc.com> <1393457997-17618-2-git-send-email-kmo@daterainc.com> <20140227172254.GI5744@linux.intel.com> <20140228233039.GA2739@moria.home.lan>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014, Kent Overstreet wrote:
> On Thu, Feb 27, 2014 at 12:22:54PM -0500, Matthew Wilcox wrote:
>> On Wed, Feb 26, 2014 at 03:39:49PM -0800, Kent Overstreet wrote:
>>> We do this by adding calls to blk_queue_split() to the various
>>> make_request functions that need it - a few can already handle arbitrary
>>> size bios. Note that we add the call _after_ any call to blk_queue_bounce();
>>> this means that blk_queue_split() and blk_recalc_rq_segments() don't need to
>>> be concerned with bouncing affecting segment merging.
>>
>>> diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
>>> index 51824d1f23..e4376b9613 100644
>>> --- a/drivers/block/nvme-core.c
>>> +++ b/drivers/block/nvme-core.c
>>> @@ -737,6 +737,8 @@ static void nvme_make_request(struct request_queue *q, struct bio *bio)
>>>  	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
>>>  	int result = -EBUSY;
>>>
>>> +	blk_queue_split(q, &bio, q->bio_split);
>>> +
>>>  	if (!nvmeq) {
>>>  		put_nvmeq(NULL);
>>>  		bio_endio(bio, -EIO);
>>
>> I'd suggest that we do:
>>
>> -	struct nvme_queue *nvmeq = get_nvmeq(ns->dev);
>> +	struct nvme_queue *nvmeq;
>>  	int result = -EBUSY;
>>
>> +	blk_queue_split(q, &bio, q->bio_split);
>> +
>> +	nvmeq = get_nvmeq(ns->dev);
>>  	if (!nvmeq) {
>>
>> so that we're running the blk_queue_split() code outside the get_cpu()
>> call.
>>
>> Now, the NVMe driver has its own rules about when BIOs have to be split.
>> Right now, that's way down inside the nvme_map_bio() call when we're
>> walking the bio to compose the scatterlist.  Should we instead have an
>> nvme_bio_split() routine that is called instead of blk_queue_split(),
>> and we can simplify nvme_map_bio() since it'll know that it's working
>> with bios that don't have to be split.
>>
>> In fact, I think it would have little NVMe-specific in it at that point,
>> so we could name __blk_bios_map_sg() better, export it to drivers and
>> call it from nvme_map_bio(), which I think would make everybody happier.
>
> Actually, reading nvme_map_bio() (it's different since last I looked at
> it) it looks like nvme should already be able to handle arbitrary size
> bios?
>
> I do intend to rework the blk_bio_map_sg() (or add a new one?) to
> incrementally map as much of a bio as will fit in the provided
> scatterlist, but it looks like nvme has some odd restrictions where it's
> using BIOVEC_PHYS_MERGABLE()/BIOVEC_NOT_VIRT_MERGABLE() so I dunno if
> it's worth bothering to try and have it use generic code.

Is nvme the only driver that has these kinds of restrictions on segment
address offsets? If so, I guess there's no reason to make it generic.

> However we don't need an explicit split here: if the sg fills up (i.e.
> the places nvme_split_and_submit() is called), we can just mark the bio
> as partially completed (set bio->bi_iter = iter, i.e. use the iterator
> you passed to bio_for_each_segment), then increment bi_remaining (which
> just counts completions, i.e. bio_endio() calls before the bio is really
> completed) and resubmit the original bio. No need to allocate a split
> bio, or loop over the bio again in bio_split().

We used to manipulate the original bio to track partial completions,
but I changed that for reasons that haven't quite yet materialized. If we
move the bio's bi_iter, it will make it difficult to retry the original
request on intermittent failures, and it will break the integrity verify
if the device format supports protection information. It's also more
performant to submit all parts at once rather than wait for the previous
part to complete before sending the next.
