Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbaCLRoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:44:32 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:39603 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaCLRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:44:31 -0400
MIME-Version: 1.0
X-Originating-IP: [185.25.64.249]
In-Reply-To: <53209729.9030609@kernel.dk>
References: <1394640348-9109-1-git-send-email-felipe@paradoxo.org>
	<1394640348-9109-2-git-send-email-felipe@paradoxo.org>
	<53208845.5090305@kernel.dk>
	<CANxchRSOpr63_GuktU_Y53y=vE0n+x6tqQ+=+uo_WgMGP13yRQ@mail.gmail.com>
	<532096E8.1010706@citrix.com>
	<53209729.9030609@kernel.dk>
Date: Wed, 12 Mar 2014 17:44:30 +0000
Message-ID: <CANxchRRf+JVWTOe4h+vLderSsPxW-yAjcCU6KXfXNiPxKvmAHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mtip32xx: Don't bounce IO requests
From: Felipe Franciosi <felipe@paradoxo.org>
To: Jens Axboe <axboe@kernel.dk>, David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Sam Bradshaw <sbradshaw@micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 5:19 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 03/12/2014 11:18 AM, David Vrabel wrote:
>>
>> On 12/03/14 17:08, Felipe Franciosi wrote:
>>>
>>> On Wed, Mar 12, 2014 at 4:16 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>
>>>> On 03/12/2014 10:05 AM, Felipe Franciosi wrote:
>>>>>
>>>>>
>>>>> This device support 64-bit DMA and therefore no IO requests needs
>>>>> bouncing.
>>>>> On 32-bit systems, blk_queue_bounce() will bounce all IO requests with
>>>>> high
>>>>> mem pages. This makes performance really really bad.
>>
>> [...]
>>>>>
>>>>> --- a/drivers/block/mtip32xx/mtip32xx.c
>>>>> +++ b/drivers/block/mtip32xx/mtip32xx.c
>>>>> @@ -4082,8 +4082,6 @@ static void mtip_make_request(struct
>>>>> request_queue *queue, struct bio *bio)
>>>>>
>>>>>          sg = mtip_hw_get_scatterlist(dd, &tag, unaligned);
>>>>>          if (likely(sg != NULL)) {
>>>>> -               blk_queue_bounce(queue, &bio);
>>>>> -
>>>>>                  if (unlikely((bio)->bi_vcnt > MTIP_MAX_SG)) {
>>>>>                          dev_warn(&dd->pdev->dev,
>>>>>                                  "Maximum number of SGL entries
>>>>> exceeded\n");
>>>>
>>>>
>>>>
>>>> That seems to be because the driver forgets to set the DMA
>>>> capabilities. It needs a blk_queue_bounce_limit() call when it sets up
>>>> the queue.
>>>
>>>
>>> Hmm... I see what you are saying. David, would you like to comment?
>>
>>
>> Yes, it should also call blk_queue_bounce_limit(..., BLK_BOUNCE_ANY) in
>> mtip_block_initialize() as well.
>>
>> But, only one other driver calls blk_queue_bounce() so it's difficult to
>> see why this driver would need a call here.
>
>
> That's because most other drivers hook in the appropriate place, and the
> blk_queue_bounce() is then done by the block layer.
>
> --
> Jens Axboe
>

I'll add the blk_queue_bounce_limit() on the initialisation, test it
out and submit a v2 tomorrow.

Cheers,
Felipe
