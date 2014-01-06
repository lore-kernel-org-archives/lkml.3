Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaAFFrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:47:06 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:40505 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFFrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:47:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140105061413.GF18213@core.coreip.homeip.net>
References: <1388887680-942-1-git-send-email-ethan.kernel@gmail.com>
	<20140105061413.GF18213@core.coreip.homeip.net>
Date: Mon, 6 Jan 2014 13:47:03 +0800
Message-ID: <CABawtvOJ7aV=QP2SwYpPJTgJKgngiHY0Oqu=UmxH8yP9TCkuSg@mail.gmail.com>
Subject: Re: [PATCH] [media] saa7146: fix a possible NULL pointer reference in saa7146_set_position
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, mchehab@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,
   Yup,thank you point out that, need NULL pointer checking in
calculate_video_dma_grab_packed() ,  I am not familiar with saa7146
too. wouldn't paper over it, just a fix to pass code review.

Thanks,
Ethan

On Sun, Jan 5, 2014 at 2:14 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sun, Jan 05, 2014 at 10:08:00AM +0800, Ethan Zhao wrote:
>> Function saa7146_format_by_fourcc() may return NULL, reference of the returned
>> result would cause NULL pointer issue without checking.
>>
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>> ---
>>  drivers/media/common/saa7146/saa7146_hlp.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/common/saa7146/saa7146_hlp.c b/drivers/media/common/saa7146/saa7146_hlp.c
>> index be746d1..3e23eab 100644
>> --- a/drivers/media/common/saa7146/saa7146_hlp.c
>> +++ b/drivers/media/common/saa7146/saa7146_hlp.c
>> @@ -575,6 +575,7 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
>>        */
>>       u32 base = (u32)(unsigned long)vv->ov_fb.base;
>>
>> +     int which = 1;
>>       struct  saa7146_video_dma vdma1;
>>
>>       /* calculate memory offsets for picture, look if we shall top-down-flip */
>> @@ -608,10 +609,14 @@ static void saa7146_set_position(struct saa7146_dev *dev, int w_x, int w_y, int
>>               vdma1.pitch *= -1;
>>       }
>>
>> -     vdma1.base_page = sfmt->swap;
>> +     if (sfmt)
>> +             vdma1.base_page = sfmt->swap;
>> +     else
>> +             which = 0;
>> +
>>       vdma1.num_line_byte = (vv->standard->v_field<<16)+vv->standard->h_pixels;
>>
>> -     saa7146_write_out_dma(dev, 1, &vdma1);
>> +     saa7146_write_out_dma(dev, which, &vdma1);
>
> If saa7146_format_by_fourcc() returns NULL you'll crash much earlier
> when trying to do
>
>         int depth = sfmt->depth;
>
> I am not familiar with the code by it seems you are papering over the
> problem. Will we ever get here with unknown pixel format?
>
> Thanks.
>
> --
> Dmitry
