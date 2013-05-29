Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3E2EQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 00:16:20 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:43585 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab3E2EQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 00:16:19 -0400
MIME-Version: 1.0
In-Reply-To: <1915324.uRjOv648gy@avalon>
References: <1369569612-30915-1-git-send-email-prabhakar.csengg@gmail.com>
 <1369569612-30915-10-git-send-email-prabhakar.csengg@gmail.com> <1915324.uRjOv648gy@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 29 May 2013 09:45:57 +0530
Message-ID: <CA+V-a8u7wBxCfovwrca2-K5ksQtSWfGWyu9=V8Sd3hv+g4cpQw@mail.gmail.com>
Subject: Re: [PATCH v3 9/9] media: davinci: vpif_display: Convert to devm_* api
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

On Wed, May 29, 2013 at 9:08 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Sunday 26 May 2013 17:30:12 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> use devm_request_irq() instead of request_irq(). This ensures
>> more consistent error values and simplifies error paths.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
Thanks for the ack.

> with a small comment below.
>
>> ---
>>  drivers/media/platform/davinci/vpif_display.c |   35 ++++++----------------
>>  1 files changed, 9 insertions(+), 26 deletions(-)
>>
>> diff --git a/drivers/media/platform/davinci/vpif_display.c
>> b/drivers/media/platform/davinci/vpif_display.c index 7bcfe7d..e2f080b
>> 100644
>> --- a/drivers/media/platform/davinci/vpif_display.c
>> +++ b/drivers/media/platform/davinci/vpif_display.c
>> @@ -1718,15 +1718,14 @@ static __init int vpif_probe(struct platform_device
>> *pdev)
>>
>>       while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
>>               for (i = res->start; i <= res->end; i++) {
>> -                     if (request_irq(i, vpif_channel_isr, IRQF_SHARED,
>> -                                     "VPIF_Display", (void *)
>> -                                     (&vpif_obj.dev[res_idx]->channel_id))) {
>> -                             err = -EBUSY;
>> -                             for (j = 0; j < i; j++)
>> -                                     free_irq(j, (void *)
>> -                                     (&vpif_obj.dev[res_idx]->channel_id));
>> +                     err = devm_request_irq(&pdev->dev, i, vpif_channel_isr,
>> +                                          IRQF_SHARED, "VPIF_Display",
>> +                                          (void *)(&vpif_obj.dev[res_idx]->
>> +                                          channel_id));
>> +                     if (err) {
>> +                             err = -EINVAL;
>>                               vpif_err("VPIF IRQ request failed\n");
>> -                             goto vpif_int_err;
>> +                             goto vpif_unregister;
>>                       }
>>               }
>>               res_idx++;
>> @@ -1744,7 +1743,7 @@ static __init int vpif_probe(struct platform_device
>> *pdev) video_device_release(ch->video_dev);
>>                       }
>>                       err = -ENOMEM;
>> -                     goto vpif_int_err;
>> +                     goto vpif_unregister;
>>               }
>>
>>               /* Initialize field of video device */
>> @@ -1878,13 +1877,8 @@ vpif_sd_error:
>>               /* Note: does nothing if ch->video_dev == NULL */
>>               video_device_release(ch->video_dev);
>>       }
>> -vpif_int_err:
>> +vpif_unregister:
>>       v4l2_device_unregister(&vpif_obj.v4l2_dev);
>> -     for (i = 0; i < res_idx; i++) {
>> -             res = platform_get_resource(pdev, IORESOURCE_IRQ, i);
>> -             for (j = res->start; j <= res->end; j++)
>> -                     free_irq(j, (void *)(&vpif_obj.dev[i]->channel_id));
>> -     }
>>
>>       return err;
>>  }
>> @@ -1894,20 +1888,9 @@ vpif_int_err:
>>   */
>>  static int vpif_remove(struct platform_device *device)
>>  {
>> -     struct platform_device *pdev;
>>       struct channel_obj *ch;
>> -     struct resource *res;
>> -     int irq_num;
>>       int i = 0;
>
> There's no need to initialize i to 0 anymore (same comment for patch 6/9).
>
Ok will fix it in the next version.

Regards,
--Prabhakar Lad
