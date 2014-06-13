Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaFMPGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:06:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:47966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaFMPGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:06:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,471,1400050800"; 
   d="scan'208";a="528117768"
Date: Fri, 13 Jun 2014 09:05:36 -0600 (MDT)
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
In-Reply-To: <539B05A1.7080700@fb.com>
Message-ID: <alpine.LRH.2.03.1406130838210.4699@AMR>
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR>
 <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com>
 <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR> <539B05A1.7080700@fb.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2014, Jens Axboe wrote:
> On 06/12/2014 06:06 PM, Keith Busch wrote:
>> When cancelling IOs, we have to check if the hwctx has a valid tags
>> for some reason. I have 32 cores in my system and as many queues, but
>
> It's because unused queues are torn down, to save memory.
>
>> blk-mq is only using half of those queues and freed the "tags" for the
>> rest after they'd been initialized without telling the driver. Why is
>> blk-mq not making utilizing all my queues?
>
> You have 31 + 1 queues, so only 31 mappable queues. blk-mq symmetrically
> distributes these, so you should have a core + thread sibling on 16
> queues. And yes, that leaves 15 idle hardware queues for this specific
> case. I like the symmetry, it makes it more predictable if things are
> spread out evenly.

You'll see performance differences on some workloads that depend on which
cores your process runs and which one services an interrupt. We can play
games with with cores and see what happens on my 32 cpu system. I usually
run 'irqbalance --hint=exact' for best performance, but that doesn't do
anything with blk-mq since the affinity hint is gone.

I ran the following script several times on each version of the
driver. This will pin a sequential read test to cores 0, 8, and 16. The
device is local to NUMA node on cores 0-7 and 16-23; the second test
runs on the remote node and the third on the thread sibling of 0. Results
were averaged, but very consistent anyway. The system was otherwise idle.

  # for i in $(seq 0 8 16); do
   > let "cpu=1<<$i"
   > cpu=`echo $cpu | awk '{printf "%#x\n", $1}'`
   > taskset ${cpu} dd if=/dev/nvme0n1 of=/dev/null bs=4k count=1000000 iflag=direct
   > done

Here are the performance drops observed with blk-mq with the existing
driver as baseline:

  CPU : Drop
  ....:.....
    0 : -6%
    8 : -36%
   16 : -12%

