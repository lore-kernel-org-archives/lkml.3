Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaFMTW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 15:22:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:1537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbaFMTWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 15:22:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,472,1400050800"; 
   d="scan'208";a="547700090"
Date: Fri, 13 Jun 2014 13:22:54 -0600 (MDT)
From: Keith Busch <keith.busch@intel.com>
X-X-Sender: vmware@localhost.localdom
To: Jens Axboe <axboe@fb.com>
cc: Keith Busch <keith.busch@intel.com>,
        =?ISO-8859-15?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
In-Reply-To: <539B3F75.7040700@fb.com>
Message-ID: <alpine.LRH.2.03.1406131307330.4699@AMR>
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
 <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR> <539B05A1.7080700@fb.com> <alpine.LRH.2.03.1406130838210.4699@AMR> <539B14A9.8010204@fb.com>
 <alpine.LRH.2.03.1406130914110.4699@AMR> <539B3F75.7040700@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Jens Axboe wrote:
> OK, same setup as mine. The affinity hint is really screwing us over, no
> question about it. We just need a:
>
> irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector, hctx->cpumask);
>
> in the ->init_hctx() methods to fix that up.
>
> That brings us to roughly the same performance, except for the cases
> where the dd is run on the thread sibling of the core handling the
> interrupt. And granted, with the 16 queues used, that'll happen on
> blk-mq. But since you have 32 threads and just 31 IO queues, the non
> blk-mq driver must end up sharing for some cases, too.
>
> So what do we care most about here? Consistency, or using all queues at
> all costs?

I think we want to use all h/w queues regardless of mismatched sharing. A
24 thread server shouldn't use more of the hardware than a 32.

You're right, the current driver shares the queues on anything with 32
or more cpus with this NVMe controller, but we wrote an algorithm that
allocates the most and tries to group them with their nearest neighbors.

One performance oddity we observe is that servicing the interrupt on the
thread sibling of the core that submitted the I/O is the worst performing
cpu you can chose; it's actually better to use a different core on the
same node. At least that's true as long as you're not utilizing the cpus
for other work, so YMMV.
