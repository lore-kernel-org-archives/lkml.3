Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbaCLRSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:18:41 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:33113 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaCLRSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:18:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,639,1389744000"; 
   d="scan'208";a="109251825"
Message-ID: <532096E8.1010706@citrix.com>
Date: Wed, 12 Mar 2014 17:18:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Felipe Franciosi <felipe@paradoxo.org>
CC: Jens Axboe <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: Re: [PATCH 1/2] mtip32xx: Don't bounce IO requests
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>	<1394640348-9109-2-git-send-email-felipe@paradoxo.org>	<53208845.5090305@kernel.dk> <CANxchRSOpr63_GuktU_Y53y=vE0n+x6tqQ+=+uo_WgMGP13yRQ@mail.gmail.com>
In-Reply-To: <CANxchRSOpr63_GuktU_Y53y=vE0n+x6tqQ+=+uo_WgMGP13yRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 17:08, Felipe Franciosi wrote:
> On Wed, Mar 12, 2014 at 4:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 03/12/2014 10:05 AM, Felipe Franciosi wrote:
>>>
>>> This device support 64-bit DMA and therefore no IO requests needs bouncing.
>>> On 32-bit systems, blk_queue_bounce() will bounce all IO requests with high
>>> mem pages. This makes performance really really bad.
[...]
>>> --- a/drivers/block/mtip32xx/mtip32xx.c
>>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>>> @@ -4082,8 +4082,6 @@ static void mtip_make_request(struct request_queue *queue, struct bio *bio)
>>>
>>>         sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
>>>         if (likely(sg != NULL)) {
>>> -               blk_queue_bounce(queue, &bio);
>>> -
>>>                 if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
>>>                         dev_warn(&dd->pdev->dev,
>>>                                 "Maximum number of SGL entries exceeded\n");
>>
>>
>> That seems to be because the driver forgets to set the DMA
>> capabilities. It needs a blk_queue_bounce_limit() call when it sets up
>> the queue.
> 
> Hmm... I see what you are saying. David, would you like to comment?

Yes, it should also call blk_queue_bounce_limit(..., BLK_BOUNCE_ANY) in
mtip_block_initialize() as well.

But, only one other driver calls blk_queue_bounce() so it's difficult to
see why this driver would need a call here.

David
