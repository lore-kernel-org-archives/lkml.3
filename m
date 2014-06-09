Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaFIPLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:11:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43104 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754000AbaFIPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:11:11 -0400
Message-ID: <5395CE64.6040402@fb.com>
Date: Mon, 9 Jun 2014 09:10:28 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: =?UTF-8?B?TWF0aWFzIEJqw7hybGluZw==?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
References: <1402057225-7312-1-git-send-email-m@bjorling.me>	<1402057225-7312-2-git-send-email-m@bjorling.me>	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>	<5395BFF2.2080402@fb.com> <CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>
In-Reply-To: <CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-09_03:2014-06-09,2014-06-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=9.99200722162641e-16 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.324642340081358
 urlsuspect_oldscore=0.324642340081358 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.324642340081358 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406090196
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-06-09 09:07, Ming Lei wrote:
> On Mon, Jun 9, 2014 at 10:08 PM, Jens Axboe <axboe@fb.com> wrote:
>> On 2014-06-08 22:35, Ming Lei wrote:
>>>
>>> On Fri, Jun 6, 2014 at 8:20 PM, Matias Bjørling <m@bjorling.me> wrote:
>>>>
>>>> This converts the current NVMe driver to utilize the blk-mq layer.
>>>
>>>
>>> Looks it can't be applied cleanly against 3.15-rc8 + Jens's for-linux
>>> branch, when I fix the conflict manually, below failure is triggered:
>>>
>>> [  487.696057] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>>> [  487.699005] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>>> [  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>>> [  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>>> [  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
>>> [  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
>>>
>>>
>>> when running fio randread(libaio, iodepth:64) with more than 3 jobs.
>>>
>>> And looks no such failure when jobs is 1 or 2.
>>
>>
>> It's a known issue, make sure you have this patch:
>>
>> https://urldefense.proofpoint.com/v1/url?u=http://git.kernel.dk/?p%3Dlinux-block.git%3Ba%3Dcommit%3Bh%3Df6be4fb4bcb396fc3b1c134b7863351972de081f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=3JMVyziIyZtZ5cv9eWNLwQ%3D%3D%0A&m=04gqJgKKgVgGynQnyGFy4OmxWZ5%2FJ%2FwBiXQH3K%2BEZ4U%3D%0A&s=b137111b72079e93492763bfa23fd3458cd9b287a5eb3b68f61b69c9cda6b7a5
>
> Looks assignment to 'rq->deadline' in blk_mq_start_request()
> may be removed,  since blk_add_timer() already did that.
>
> But that isn't the only issue.
>
> Another one is that req->start_time isn't set without IO_STAT in
> nvme, which may cause similar issue too, so req->start_time
> can be set in nvme's queue_rq callback.
>
> My real issue should be nvme specific: NVME_INTERNAL_DEV_ERROR(0x6) is
> returned from device
> with the conversion patch, but no such issue in current bio mode.

You are right, I didn't get to the bottom of the thread first.
Might be better to just have ->start_time set always, regardless of io 
stats being enabled or not.

-- 
Jens Axboe

