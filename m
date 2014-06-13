Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaFMSPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 14:15:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62962 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751423AbaFMSPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 14:15:08 -0400
Message-ID: <539B3F75.7040700@fb.com>
Date: Fri, 13 Jun 2014 12:14:13 -0600
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
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com> <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR> <539B05A1.7080700@fb.com> <alpine.LRH.2.03.1406130838210.4699@AMR> <539B14A9.8010204@fb.com> <alpine.LRH.2.03.1406130914110.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406130914110.4699@AMR>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_07:2014-06-13,2014-06-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.6687211308647e-12 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406130196
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 09:16 AM, Keith Busch wrote:
> On Fri, 13 Jun 2014, Jens Axboe wrote:
>> On 06/13/2014 09:05 AM, Keith Busch wrote:
>>> Here are the performance drops observed with blk-mq with the existing
>>> driver as baseline:
>>>
>>>  CPU : Drop
>>>  ....:.....
>>>    0 : -6%
>>>    8 : -36%
>>>   16 : -12%
>>
>> We need the hints back for sure, I'll run some of the same tests and
>> verify to be sure. Out of curiousity, what is the topology like on your
>> box? Are 0/1 siblings, and 0..7 one node?
> 
> 0-7 are different cores on node 0, with 16-23 being their thread
> siblings. Similiar setup with 8-15 and 24-32 on node 1.

OK, same setup as mine. The affinity hint is really screwing us over, no
question about it. We just need a:

irq_set_affinity_hint(dev->entry[nvmeq->cq_vector].vector, hctx->cpumask);

in the ->init_hctx() methods to fix that up.

That brings us to roughly the same performance, except for the cases
where the dd is run on the thread sibling of the core handling the
interrupt. And granted, with the 16 queues used, that'll happen on
blk-mq. But since you have 32 threads and just 31 IO queues, the non
blk-mq driver must end up sharing for some cases, too.

So what do we care most about here? Consistency, or using all queues at
all costs?


