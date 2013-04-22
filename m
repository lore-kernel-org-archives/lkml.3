Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3DVKlx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:41:53 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37377 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3DVKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:41:52 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1304221235230.23906@axis700.grange>
References: <1366625848-743-1-git-send-email-prabhakar.csengg@gmail.com>
 <1366625848-743-2-git-send-email-prabhakar.csengg@gmail.com> <Pine.LNX.4.64.1304221235230.23906@axis700.grange>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 22 Apr 2013 16:11:30 +0530
Message-ID: <CA+V-a8sc08V-ZuEcDSgDW_8TkyGOgf3JV0PyD=qDGh5hon+JMQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/4] media: i2c: adv7343: add support for
 asynchronous probing
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

Thanks for the quick review.

On Mon, Apr 22, 2013 at 4:08 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> Hi Prabhakar
>
> On Mon, 22 Apr 2013, Prabhakar Lad wrote:
>
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> Both synchronous and asynchronous adv7343 subdevice probing is supported by
>> this patch.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> ---
>>  drivers/media/i2c/adv7343.c |   17 +++++++++++++----
>>  1 files changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
>> index 9fc2b98..5b1417b 100644
>> --- a/drivers/media/i2c/adv7343.c
>> +++ b/drivers/media/i2c/adv7343.c
>> @@ -27,6 +27,7 @@
>>  #include <linux/uaccess.h>
>>
>>  #include <media/adv7343.h>
>> +#include <media/v4l2-async.h>
>>  #include <media/v4l2-device.h>
>>  #include <media/v4l2-chip-ident.h>
>>  #include <media/v4l2-ctrls.h>
>> @@ -44,6 +45,7 @@ struct adv7343_state {
>>       struct v4l2_subdev sd;
>>       struct v4l2_ctrl_handler hdl;
>>       const struct adv7343_platform_data *pdata;
>> +     struct v4l2_async_subdev_list   asdl;
>
> Do you still need this? Don't think it's needed any more with the latest
> V4L2-async version.
>
Yes not required missed to remove :)

Regards,
--Prabhakar

> Thanks
> Guennadi
>
>>       u8 reg00;
>>       u8 reg01;
>>       u8 reg02;
>> @@ -455,16 +457,22 @@ static int adv7343_probe(struct i2c_client *client,
>>                                      ADV7343_GAIN_DEF);
>>       state->sd.ctrl_handler = &state->hdl;
>>       if (state->hdl.error) {
>> -             int err = state->hdl.error;
>> -
>> -             v4l2_ctrl_handler_free(&state->hdl);
>> -             return err;
>> +             err = state->hdl.error;
>> +             goto done;
>>       }
>>       v4l2_ctrl_handler_setup(&state->hdl);
>>
>>       err = adv7343_initialize(&state->sd);
>>       if (err)
>> +             goto done;
>> +
>> +     state->sd.dev = &client->dev;
>> +     err = v4l2_async_register_subdev(&state->sd);
>> +
>> +done:
>> +     if (err < 0)
>>               v4l2_ctrl_handler_free(&state->hdl);
>> +
>>       return err;
>>  }
>>
>> @@ -473,6 +481,7 @@ static int adv7343_remove(struct i2c_client *client)
>>       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>>       struct adv7343_state *state = to_state(sd);
>>
>> +     v4l2_async_unregister_subdev(&state->sd);
>>       v4l2_device_unregister_subdev(sd);
>>       v4l2_ctrl_handler_free(&state->hdl);
>>
>> --
>> 1.7.4.1
>>
>
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
