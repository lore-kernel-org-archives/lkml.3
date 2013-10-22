Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088Ab3JVTwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 15:52:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:23679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3JVTwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 15:52:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,550,1378882800"; 
   d="scan'208";a="420988133"
Date: Tue, 22 Oct 2013 13:52:25 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Matias Bjorling <m@bjorling.me>
cc: Keith Busch <keith.busch@intel.com>, axboe@kernel.dk,
        willy@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 3/3] NVMe: Convert to blk-mq
In-Reply-To: <5266CA29.2020308@bjorling.me>
Message-ID: <alpine.LRH.2.03.1310221315430.4763@AMR>
References: <1382102062-22270-1-git-send-email-m@bjorling.me> <1382102062-22270-4-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1310180837140.4763@AMR> <526186AE.3080006@bjorling.me> <alpine.LRH.2.03.1310221011570.4763@AMR> <5266CA29.2020308@bjorling.me>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1380390316-1382471549=:4763"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1380390316-1382471549=:4763
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 22 Oct 2013, Matias Bjorling wrote:
> Den 22-10-2013 18:55, Keith Busch skrev:
>> On Fri, 18 Oct 2013, Matias Bjørling wrote:
>>> On 10/18/2013 05:13 PM, Keith Busch wrote:
>>>> On Fri, 18 Oct 2013, Matias Bjorling wrote:
>>>>> The nvme driver implements itself as a bio-based driver. This primarily
>>>>> because of high lock congestion for high-performance nvm devices. To
>>>>> remove the congestion within the traditional block layer, a multi-queue
>>>>> block layer is being implemented.
>> 
>>>>> -    result = nvme_map_bio(nvmeq, iod, bio, dma_dir, psegs);
>>>>> -    if (result <= 0)
>>>>> +    if (nvme_map_rq(nvmeq, iod, rq, dma_dir))
>>>>>         goto free_cmdid;
>>>>> -    length = result;
>>>>> 
>>>>> -    cmnd->rw.command_id = cmdid;
>>>>> +    length = blk_rq_bytes(rq);
>>>>> +
>>>>> +    cmnd->rw.command_id = rq->tag;
>>>> 
>>>> The command ids have to be unique on a submission queue. Since each
>>>> namespace's blk-mq has its own 'tags' used as command ids here but share
>>>> submission queues, what's stopping the tags for commands sent to 
>>>> namespace
>>>> 1 from clashing with tags for namespace 2?
>>>> 
>>>> I think this would work better if one blk-mq was created per device
>>>> rather than namespace. It would fix the tag problem above and save a
>>>> lot of memory potentially wasted on millions of requests allocated that
>>>> can't be used.
>>> 
>>> You're right. I didn't see the connection. In v3 I'll push struct 
>>> request_queue to nvme_dev and map the queues appropriately. It will also 
>>> fix the command id issues.
>> 
>> Just anticipating a possible issue with the suggestion. Will this separate
>> the logical block size from the request_queue? Each namespace can have
>> a different format, so the block size and request_queue can't be tied
>> together like it currently is for this to work.
>
> If only a couple of different logical sizes are to be expected (1-4), we can 
> keep a list of already initialized request queues, and use the one that match 
> an already initialized?

The spec allows a namespace to have up to 16 different block formats and
they need not be the same 16 as another namespace on the same device.

>From a practical standpoint, I don't think devices will support more
than a few formats, but even if you kept it to that many request queues,
you just get back to conflicting command id tags and some wasted memory.

>
> Axboe, do you know of a better solution?

--8323328-1380390316-1382471549=:4763--
