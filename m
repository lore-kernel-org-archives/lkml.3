Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbaFKQzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 12:55:53 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63459 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932526AbaFKQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:55:50 -0400
Message-ID: <539889DC.7090704@fb.com>
Date: Wed, 11 Jun 2014 10:54:52 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>
CC: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>,
        "sbradshaw@micron.com" <sbradshaw@micron.com>,
        "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v7] NVMe: conversion to blk-mq
References: <1402392038-5268-1-git-send-email-m@bjorling.me> <1402392038-5268-2-git-send-email-m@bjorling.me> <alpine.LRH.2.03.1406100945250.4699@AMR> <A52B97CC-6D77-468B-9A9B-A5888AE63580@fb.com> <alpine.LRH.2.03.1406101140490.4699@AMR> <5397636F.9050209@fb.com> <alpine.LRH.2.03.1406101458470.4699@AMR> <5397753B.2020009@fb.com> <alpine.LRH.2.03.1406101515430.4699@AMR> <20140610213333.GA10055@linux.intel.com>
In-Reply-To: <20140610213333.GA10055@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-11_05:2014-06-11,2014-06-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.84907653580468e-08 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406110212
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 03:33 PM, Matthew Wilcox wrote:
> On Tue, Jun 10, 2014 at 03:21:18PM -0600, Keith Busch wrote:
>> Yeah, nvme_setup_prps is probably the least readable code in this driver.
>> Maybe some comments are in order here...
>>
>> There are two rules for an SGL to be mappable to a PRP:
>>
>> 1. Every element must have zero page offset, except the first.
>>
>> 2. Every element must end on a page boundary, except the last.
> 
> Or to put it another way, NVMe PRPs only support I/Os that describe a
> single range of virtual memory.

OK, so essentially any single request must be a virtually contig piece
of memory. Is there any size limitations to how big this contig segment
can be?

I think this is unique requirement, at least I haven't seen other pieces
of hardware have it. But it would be pretty trivial to add a setting to
limit merges based on virtually contig, similarly to what is done for
number of physical segments.

