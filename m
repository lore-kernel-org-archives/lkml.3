Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaFMPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:12:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45427 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbaFMPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:12:32 -0400
Message-ID: <539B14A9.8010204@fb.com>
Date: Fri, 13 Jun 2014 09:11:37 -0600
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
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com> <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR> <539B05A1.7080700@fb.com> <alpine.LRH.2.03.1406130838210.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406130838210.4699@AMR>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_06:2014-06-13,2014-06-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.08111305965986e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406130170
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 09:05 AM, Keith Busch wrote:
> On Fri, 13 Jun 2014, Jens Axboe wrote:
>> On 06/12/2014 06:06 PM, Keith Busch wrote:
>>> When cancelling IOs, we have to check if the hwctx has a valid tags
>>> for some reason. I have 32 cores in my system and as many queues, but
>>
>> It's because unused queues are torn down, to save memory.
>>
>>> blk-mq is only using half of those queues and freed the "tags" for the
>>> rest after they'd been initialized without telling the driver. Why is
>>> blk-mq not making utilizing all my queues?
>>
>> You have 31 + 1 queues, so only 31 mappable queues. blk-mq symmetrically
>> distributes these, so you should have a core + thread sibling on 16
>> queues. And yes, that leaves 15 idle hardware queues for this specific
>> case. I like the symmetry, it makes it more predictable if things are
>> spread out evenly.
> 
> You'll see performance differences on some workloads that depend on which
> cores your process runs and which one services an interrupt. We can play
> games with with cores and see what happens on my 32 cpu system. I usually
> run 'irqbalance --hint=exact' for best performance, but that doesn't do
> anything with blk-mq since the affinity hint is gone.

Huh wtf, that hint is not supposed to be gone. I'm guessing it went away
with the removal of the manual queue assignments.

> I ran the following script several times on each version of the
> driver. This will pin a sequential read test to cores 0, 8, and 16. The
> device is local to NUMA node on cores 0-7 and 16-23; the second test
> runs on the remote node and the third on the thread sibling of 0. Results
> were averaged, but very consistent anyway. The system was otherwise idle.
> 
>  # for i in $(seq 0 8 16); do
>   > let "cpu=1<<$i"
>   > cpu=`echo $cpu | awk '{printf "%#x\n", $1}'`
>   > taskset ${cpu} dd if=/dev/nvme0n1 of=/dev/null bs=4k count=1000000
> iflag=direct
>   > done
> 
> Here are the performance drops observed with blk-mq with the existing
> driver as baseline:
> 
>  CPU : Drop
>  ....:.....
>    0 : -6%
>    8 : -36%
>   16 : -12%

We need the hints back for sure, I'll run some of the same tests and
verify to be sure. Out of curiousity, what is the topology like on your
box? Are 0/1 siblings, and 0..7 one node?

