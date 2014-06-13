Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726AbaFMOIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 10:08:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64957 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaFMOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 10:08:04 -0400
Message-ID: <539B05A1.7080700@fb.com>
Date: Fri, 13 Jun 2014 08:07:29 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Keith Busch <keith.busch@intel.com>
CC: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
References: <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com> <539889DC.7090704@fb.com> <20140611170917.GA12025@linux.intel.com> <CAOu_J6kocZZ1mRQeSidyqJ_Ew0F_POS30v2kgUZX2wDOOnuExg@mail.gmail.com> <alpine.LRH.2.03.1406111641180.4699@AMR> <5399BA00.7000705@bjorling.me> <alpine.LRH.2.03.1406121015130.4699@AMR> <alpine.LRH.2.03.1406121757130.4699@AMR>
In-Reply-To: <alpine.LRH.2.03.1406121757130.4699@AMR>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-13_05:2014-06-13,2014-06-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.74343317560499e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.533125042697551
 urlsuspect_oldscore=0.533125042697551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=1996008
 rbsscore=0.533125042697551 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406130158
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 06:06 PM, Keith Busch wrote:
> When cancelling IOs, we have to check if the hwctx has a valid tags
> for some reason. I have 32 cores in my system and as many queues, but

It's because unused queues are torn down, to save memory.

> blk-mq is only using half of those queues and freed the "tags" for the
> rest after they'd been initialized without telling the driver. Why is
> blk-mq not making utilizing all my queues?

You have 31 + 1 queues, so only 31 mappable queues. blk-mq symmetrically
distributes these, so you should have a core + thread sibling on 16
queues. And yes, that leaves 15 idle hardware queues for this specific
case. I like the symmetry, it makes it more predictable if things are
spread out evenly.

But it is a policy decision that could be changed. The logic is in the
50 lines of code in block/blk-mq-cpumap.c:blk_mq_update_queue_map().

Thanks for the abort and completion fixes, looks a lot better now. It
might be cleaner to have blk_mq_tag_busy_iter() just work for
!hctx->tags, since this is actually the 2nd time I've run into this now.


