Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab3EBN1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:27:12 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:33060 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab3EBN1L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:27:11 -0400
MIME-Version: 1.0
In-Reply-To: <1852859.1hSUrOsTsv@avalon>
References: <1367473482-18308-1-git-send-email-prabhakar.csengg@gmail.com> <1852859.1hSUrOsTsv@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 2 May 2013 18:56:49 +0530
Message-ID: <CA+V-a8vSt4frmTzUR_bKd_iCg9jarH5m3wKqe=eiuMHkhsyOow@mail.gmail.com>
Subject: Re: [PATCH v2] media: i2c: tvp7002: enable TVP7002 decoder for media
 controller based usage
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Thu, May 2, 2013 at 4:40 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Ho Prabhakar,
>
> Thank you for the patch.
>
> On Thursday 02 May 2013 11:14:42 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch enables tvp7002 decoder driver for media controller
>> based usage by adding v4l2_subdev_pad_ops  operations support
>> for enum_mbus_code, set_pad_format, get_pad_format and media_entity_init()
>> on probe and media_entity_cleanup() on remove.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  Changes for v2:
>>  1: Fixed review comment pointed by Laurent, Don’t return error for set_fmt
>>     but fix the input parameters according to current timings.
>>
>>  drivers/media/i2c/tvp7002.c |  122 ++++++++++++++++++++++++++++++++++++++--
>>  include/media/tvp7002.h     |    2 +
>>  2 files changed, 119 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
>> index 027809c..3be687e 100644
>> --- a/drivers/media/i2c/tvp7002.c
>> +++ b/drivers/media/i2c/tvp7002.c
>
> [snip]
>
>> +/*
>> + * tvp7002_set_pad_format() - set video format on pad
>> + * @sd: pointer to standard V4L2 sub-device structure
>> + * @fh: file handle for the subdev
>> + * @fmt: pointer to subdev format struct
>> + *
>> + * set video format for pad.
>> + */
>> +static int
>> +tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>> +                    struct v4l2_subdev_format *fmt)
>> +{
>> +     struct tvp7002 *tvp7002 = to_tvp7002(sd);
>> +
>> +     /* if format doesn’t match the current timings fix the input
>> +      * parameters according to what device supports.
>> +      */
>> +     if (fmt->format.field != tvp7002->current_timings->scanmode ||
>> +         fmt->format.code != V4L2_MBUS_FMT_YUYV10_1X20 ||
>> +         fmt->format.colorspace != tvp7002->current_timings->color_space ||
>> +         fmt->format.width != tvp7002->current_timings->timings.bt.width ||
>> +         fmt->format.height != tvp7002->current_timings->timings.bt.height) {
>> +             fmt->format.field = tvp7002->current_timings->scanmode;
>> +             fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
>> +             fmt->format.colorspace = tvp7002->current_timings->color_space;
>> +             fmt->format.width = tvp7002->current_timings->timings.bt.width;
>> +             fmt->format.height =
>> +                             tvp7002->current_timings->timings.bt.height;
>> +     }
>
> You can do this unconditionally.
>
>> +     tvp7002->format = fmt->format;
>
> That's not valid for TRY formats.
>
> As the format is fixed, I would get rid of the struct tvp7002 format field,
> remove the ACTIVE format check below, and just call tvp7002_get_pad_format in
> tvp7002_set_pad_format.
>
> static int
> tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>                        struct v4l2_subdev_format *fmt)
> {
>         struct tvp7002 *tvp7002 = to_tvp7002(sd);
>
>         fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
>         fmt->format.width = tvp7002->current_timings->timings.bt.width;
>         fmt->format.height = tvp7002->current_timings->timings.bt.height;
>         fmt->format.field = tvp7002->current_timings->scanmode;
>         fmt->format.colorspace = tvp7002->current_timings->color_space;
>
>         return 0;
> }
>
> static int
> tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>                        struct v4l2_subdev_format *fmt)
> {
>         return tvp7002_get_pad_format(sd, fh, fmt);
> }
>
Alright makes sense.

>> +     return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_get_pad_format() - get video format on pad
[Snip]
>>       v4l2_ctrl_handler_init(&device->hdl, 1);
>>       v4l2_ctrl_new_std(&device->hdl, &tvp7002_ctrl_ops,
>>                       V4L2_CID_GAIN, 0, 255, 1, 0);
>>       sd->ctrl_handler = &device->hdl;
>>       if (device->hdl.error) {
>> -             int err = device->hdl.error;
>> -
>> -             v4l2_ctrl_handler_free(&device->hdl);
>> -             return err;
>> +             error = device->hdl.error;
>> +             goto done;
>>       }
>>       v4l2_ctrl_handler_setup(&device->hdl);
>>
>>       return 0;
>> +
>> +done:
>
> Please rename the label to 'error', as it only handles error cases.
>
OK

Regards,
--Prabhakar Lad
