Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab3E2EOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:14:41 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58188 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3E2EOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:14:39 -0400
MIME-Version: 1.0
In-Reply-To: <2564718.Z6XYOtT7FL@avalon>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
 <1369569612-30915-5-git-send-email-prabhakar.csengg@gmail.com> <2564718.Z6XYOtT7FL@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 29 May 2013 09:44:17 +0530
Message-ID: <CA+V-a8tQ27Sz7fjS0SACURLbowojp=O24Czuac83LCg-dKzcBg@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] media: davinci: vpif_capture: move the freeing of
 irq and global variables to remove()
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Wed, May 29, 2013 at 8:02 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thanks for the patch.
>
> On Sunday 26 May 2013 17:30:07 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Ideally the freeing of irq's and the global variables needs to be
>> done in the remove() rather than module_exit(), this patch moves
>> the freeing up of irq's and freeing the memory allocated to channel
>> objects to remove() callback of struct platform_driver.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/platform/davinci/vpif_capture.c |   31 ++++++++++------------
>>  1 files changed, 13 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c
>> b/drivers/media/platform/davinci/vpif_capture.c index caaf4fe..f8b7304
>> 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -2225,17 +2225,29 @@ vpif_int_err:
>>   */
>>  static int vpif_remove(struct platform_device *device)
>>  {
>> -     int i;
>> +     struct platform_device *pdev;
>>       struct channel_obj *ch;
>> +     struct resource *res;
>> +     int irq_num, i = 0;
>> +
>> +     pdev = container_of(vpif_dev, struct platform_device, dev);
>
> As Sergei mentioned, the platform device is already passed to the function as
> an argument.
>
OK

>> +     while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, i))) {
>> +             for (irq_num = res->start; irq_num <= res->end; irq_num++)
>> +                     free_irq(irq_num,
>> +                              (void *)(&vpif_obj.dev[i]->channel_id));
>
> A quick look at board code shows that each IRQ resource contains a single IRQ.
> The second loop could thus be removed. You could also add another patch to
> perform similar cleanup for the probe code.
>
Any way this will code will be removed in the next patch of the same
series due to usage
of devm_* api. I'll do this change only in the probe code.

Regards,
--Prabhakar Lad
