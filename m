Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaFIPHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:07:55 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60334 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbaFIPHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <5395BFF2.2080402@fb.com>
References: <1402057225-7312-1-git-send-email-m@bjorling.me>
	<1402057225-7312-2-git-send-email-m@bjorling.me>
	<CACVXFVOieM2cT4FFJhD9MecfCLBtE3AwjCpOeGGRUcmWnN=B=A@mail.gmail.com>
	<5395BFF2.2080402@fb.com>
Date: Mon, 9 Jun 2014 23:07:51 +0800
Message-ID: <CACVXFVPGO9vsOv_uVa0+5AdBduu1RJ0Fmg8XPx1QgJAvnjKj_g@mail.gmail.com>
Subject: Re: [PATCH v6] NVMe: conversion to blk-mq
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@fb.com>
Cc: =?UTF-8?Q?Matias_Bj=C3=B8rling?= <m@bjorling.me>,
        Matthew Wilcox <willy@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme <linux-nvme@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 10:08 PM, Jens Axboe <axboe@fb.com> wrote:
> On 2014-06-08 22:35, Ming Lei wrote:
>>
>> On Fri, Jun 6, 2014 at 8:20 PM, Matias Bjørling <m@bjorling.me> wrote:
>>>
>>> This converts the current NVMe driver to utilize the blk-mq layer.
>>
>>
>> Looks it can't be applied cleanly against 3.15-rc8 + Jens's for-linux
>> branch, when I fix the conflict manually, below failure is triggered:
>>
>> [  487.696057] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>> [  487.699005] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>> [  487.704074] nvme 0000:00:07.0: Cancelling I/O 202 QID 1
>> [  487.717881] nvme 0000:00:07.0: Aborting I/O 202 QID 1
>> [  487.736093] end_request: I/O error, dev nvme0n1, sector 91532352
>> [  487.747378] nvme 0000:00:07.0: completed id 0 twice on queue 0
>>
>>
>> when running fio randread(libaio, iodepth:64) with more than 3 jobs.
>>
>> And looks no such failure when jobs is 1 or 2.
>
>
> It's a known issue, make sure you have this patch:
>
> http://git.kernel.dk/?p=linux-block.git;a=commit;h=f6be4fb4bcb396fc3b1c134b7863351972de081f

Looks assignment to 'rq->deadline' in blk_mq_start_request()
may be removed,  since blk_add_timer() already did that.

But that isn't the only issue.

Another one is that req->start_time isn't set without IO_STAT in
nvme, which may cause similar issue too, so req->start_time
can be set in nvme's queue_rq callback.

My real issue should be nvme specific: NVME_INTERNAL_DEV_ERROR(0x6) is
returned from device
with the conversion patch, but no such issue in current bio mode.


Thanks,
-- 
Ming Lei
