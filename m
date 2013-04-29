Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3D2Rat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:30:49 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57367 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014Ab3D2Ras (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:30:48 -0400
MIME-Version: 1.0
In-Reply-To: <32556864.ElKWl0cdN2@avalon>
References: <1366963535-15963-1-git-send-email-prabhakar.csengg@gmail.com> <32556864.ElKWl0cdN2@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 29 Apr 2013 23:00:26 +0530
Message-ID: <CA+V-a8u_YA=TJaRebboigM6z-A=R6-ZdyxZSED7H+4w+LN+cTQ@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: tvp7002: enable TVP7002 decoder for media
 controller based usage
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the review.

On Mon, Apr 29, 2013 at 7:57 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> Thank you for the patch.
>
> On Friday 26 April 2013 13:35:35 Prabhakar Lad wrote:
>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>
>> This patch enables tvp7002 decoder driver for media controller
>> based usage by adding v4l2_subdev_pad_ops  operations support
>> for enum_mbus_code, set_pad_format, get_pad_format and media_entity_init()
>> on probe and media_entity_cleanup() on remove.
>>
>> The device supports 1 output pad and no input pads.
>
> We should actually define input pads, connected to connector entities, but
> that's out of scope for this patch.
>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>>  drivers/media/i2c/tvp7002.c |  125 ++++++++++++++++++++++++++++++++++++++--
>>  include/media/tvp7002.h     |    2 +
>>  2 files changed, 122 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
>> index 027809c..b212d41 100644
>> --- a/drivers/media/i2c/tvp7002.c
>> +++ b/drivers/media/i2c/tvp7002.c
>> @@ -424,6 +424,8 @@ struct tvp7002 {
>>       int streaming;
>>
>>       const struct tvp7002_timings_definition *current_timings;
>> +     struct media_pad pad;
>> +     struct v4l2_mbus_framefmt format;
>>  };
>>
>>  /*
>> @@ -880,6 +882,93 @@ static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
>>       .s_ctrl = tvp7002_s_ctrl,
>>  };
>>
>> +/*
>> + * tvp7002_enum_mbus_code() - Enum supported digital video format on pad
>> + * @sd: pointer to standard V4L2 sub-device structure
>> + * @fh: file handle for the subdev
>> + * @code: pointer to subdev enum mbus code struct
>> + *
>> + * Enumerate supported digital video formats for pad.
>> + */
>> +static int
>> +tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>> +                    struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +     /* Check pad index is valid */
>> +     if (code->pad != 0)
>> +             return -EINVAL;
>
> That check is already performed in the subdev core, there's no need to
> duplicate it here.
>
OK

>> +
>> +     /* Check requested format index is within range */
>> +     if (code->index != 0)
>> +             return -EINVAL;
>> +
>> +     code->code = V4L2_MBUS_FMT_YUYV10_1X20;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_set_pad_format() - set video format on pad
>> + * @sd: pointer to standard V4L2 sub-device structure
>> + * @fh: file handle for the subdev
>> + * @fmt: pointer to subdev format struct
>> + *
>> + * set video format for pad.
>> +*/
>> +static int
>> +tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>> +                    struct v4l2_subdev_format *fmt)
>> +{
>> +     struct tvp7002 *tvp7002 = to_tvp7002(sd);
>> +
>> +     /* Check pad index is valid */
>> +     if (fmt->pad != 0)
>> +             return -EINVAL;
>
> Redundant check as well.
>
OK

>> +     if (fmt->format.field != tvp7002->current_timings->scanmode ||
>> +         fmt->format.code != V4L2_MBUS_FMT_YUYV10_1X20 ||
>> +         fmt->format.colorspace != tvp7002->current_timings->color_space ||
>> +         fmt->format.width != tvp7002->current_timings->timings.bt.width ||
>> +         fmt->format.height != tvp7002->current_timings->timings.bt.height)
>> +             return -EINVAL;
>
> You shouldn't return an error, but fix the input parameters according to what
> the device supports. As the format is fixed for a giving set of timings, the
> .set_pad_format() handler should just perform the same operations as
> .get_pad_format(). You could even define tvp7002_get_pad_format() only and use
> it as a handler for both .get_pad_format() and .set_pad_format().
>
OK. So its the job back in the application end to see what format was set.

>> +     tvp7002->format = fmt->format;
>> +
>> +     return 0;
>> +}
>> +
>> +/*
>> + * tvp7002_get_pad_format() - get video format on pad
>> + * @sd: pointer to standard V4L2 sub-device structure
>> + * @fh: file handle for the subdev
>> + * @fmt: pointer to subdev format struct
>> + *
>> + * get video format for pad.
>> + */
>> +static int
>> +tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>> +                    struct v4l2_subdev_format *fmt)
>> +{
>> +     struct tvp7002 *tvp7002 = to_tvp7002(sd);
>> +
>> +     /* Check pad index is valid */
>> +     if (fmt->pad != 0)
>> +             return -EINVAL;
>
> Redundant check.
>
Ok

>> +     if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
>> +             fmt->format = tvp7002->format;
>> +             return 0;
>> +     }
>> +
>> +     fmt->format.code = V4L2_MBUS_FMT_YUYV10_1X20;
>> +     fmt->format.width = tvp7002->current_timings->timings.bt.width;
>> +     fmt->format.height = tvp7002->current_timings->timings.bt.height;
>> +     fmt->format.field = tvp7002->current_timings->scanmode;
>> +     fmt->format.colorspace = tvp7002->current_timings->color_space;
>> +
>> +     return 0;
>> +}
>> +
>>  /* V4L2 core operation handlers */
>>  static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
>>       .g_chip_ident = tvp7002_g_chip_ident,
>> @@ -910,10 +999,18 @@ static const struct v4l2_subdev_video_ops
>> tvp7002_video_ops = { .enum_mbus_fmt = tvp7002_enum_mbus_fmt,
>>  };
>>
>> +/* media pad related operation handlers */
>> +static const struct v4l2_subdev_pad_ops tvp7002_pad_ops = {
>> +     .enum_mbus_code = tvp7002_enum_mbus_code,
>> +     .get_fmt = tvp7002_get_pad_format,
>> +     .set_fmt = tvp7002_set_pad_format,
>
> We will need to define pad-aware DV timings operations.
>
I didn't get you this?

Regards,
--Prabhakar Lad
