Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaFMTaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:30:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17193 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaFMTad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:30:33 -0400
Message-ID: <539B5124.3090302@fb.com>
Date: Fri, 13 Jun 2014 13:29:40 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com> <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR> <539B05A1.7080700@fb.com> <alpine.LRH.2.03.1406130838210.4699@AMR> <539B14A9.8010204@fb.com> <alpine.LRH.2.03.1406130914110.4699@AMR> <539B3F75.7040700@fb.com> <alpine.LRH.2.03.1406131307330.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406131307330.4699@AMR>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_07:2014-06-13,2014-06-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=4.89608353859694e-14 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406130208
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 01:22 PM, Keith Busch wrote:
> On Fri, 13 Jun 2014, Jens Axboe wrote:
>> OK, same setup as mine. The affinity hint is really screwing us over, no
>> question about it. We just need a:
>>
>> irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector,
>> hctx->cpumask);
>>
>> in the ->init_hctx() methods to fix that up.
>>
>> That brings us to roughly the same performance, except for the cases
>> where the dd is run on the thread sibling of the core handling the
>> interrupt. And granted, with the 16 queues used, that'll happen on
>> blk-mq. But since you have 32 threads and just 31 IO queues, the non
>> blk-mq driver must end up sharing for some cases, too.
>>
>> So what do we care most about here? Consistency, or using all queues at
>> all costs?
> 
> I think we want to use all h/w queues regardless of mismatched sharing. A
> 24 thread server shouldn't use more of the hardware than a 32.
> 
> You're right, the current driver shares the queues on anything with 32
> or more cpus with this NVMe controller, but we wrote an algorithm that
> allocates the most and tries to group them with their nearest neighbors.
> 
> One performance oddity we observe is that servicing the interrupt on the
> thread sibling of the core that submitted the I/O is the worst performing
> cpu you can chose; it's actually better to use a different core on the
> same node. At least that's true as long as you're not utilizing the cpus
> for other work, so YMMV.

I played around with the mappings, and stumbled upon some pretty ugly
results. The back story is that on this test box, I limit max C state to
C1 to avoid having too much of a bad time with power management. Running
the dd on a specific core, yields somewhere around 52MB/sec for me.
That's with the right CPU affinity for the irq. If I purposely put it
somewhere else, I end up at 380-390MB/sec. Or if I leave it on the right
CPU but simply do:

perf record -o /dev/null dd if= ...

and run the same thing just traced, I get the high performance as well.

Indeed... So I went to take a look at what is going on. For the slow
case, turbostat tells me I'm spending 80% in C1. For the fast case,
we're down to 20% in C1.

I then turn off C1, but low and behold, it's still slow and sucky even
if turbostat now verifies that it's spending 0% time in C1.

Now, this smells like scheduling artifacts. I'm going to turn off all
power junk and see what happens. Because at 8x differences between fast
and slow, irq mappings don't really matter at all here. In fact it shows
results contrary to what you'd like to see.

