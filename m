Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3FXHLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 03:11:43 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3977 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3FXHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 03:11:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH] media: i2c: tvp514x: add support for asynchronous probing
Date: Mon, 24 Jun 2013 09:11:14 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.0-rc6-tschai; KDE/4.9.5; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1371896189-5475-1-git-send-email-prabhakar.csengg@gmail.com> <Pine.LNX.4.64.1306231716050.13783@axis700.grange> <CA+V-a8sFzDndeCBc=bgcvpqtvzQWVLngNc_mtXCebQcarM+w+Q@mail.gmail.com>
In-Reply-To: <CA+V-a8sFzDndeCBc=bgcvpqtvzQWVLngNc_mtXCebQcarM+w+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306240911.14288.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun June 23 2013 17:48:20 Prabhakar Lad wrote:
> Hi Guennadi,
> 
> Thanks for the review.
> 
> On Sun, Jun 23, 2013 at 8:49 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Sat, 22 Jun 2013, Prabhakar Lad wrote:
> >
> >> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> >>
> >> Both synchronous and asynchronous tvp514x subdevice probing is supported by
> >> this patch.
> >>
> >> Signed-off-by: Prabhakar Lad <prabhakar.csengg@gmail.com>
> >> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> >> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> ---
> >>  drivers/media/i2c/tvp514x.c |   22 +++++++++++++++-------
> >>  1 file changed, 15 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
> >> index 864eb14..d090caf 100644
> >> --- a/drivers/media/i2c/tvp514x.c
> >> +++ b/drivers/media/i2c/tvp514x.c
> >> @@ -36,6 +36,7 @@
> >>  #include <linux/module.h>
> >>  #include <linux/v4l2-mediabus.h>
> >>
> >> +#include <media/v4l2-async.h>
> >>  #include <media/v4l2-device.h>
> >>  #include <media/v4l2-common.h>
> >>  #include <media/v4l2-mediabus.h>
> >
> > Ok, but this one really does too many things in one patch:
> >
> >> @@ -1148,9 +1149,9 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >>       /* Register with V4L2 layer as slave device */
> >>       sd = &decoder->sd;
> >>       v4l2_i2c_subdev_init(sd, client, &tvp514x_ops);
> >> -     strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> >>
> >>  #if defined(CONFIG_MEDIA_CONTROLLER)
> >> +     strlcpy(sd->name, TVP514X_MODULE_NAME, sizeof(sd->name));
> >
> > This is unrelated
> >
> OK I'll split the patch or may be a line in a commit message can do ?

Please split it up in two patches.

Why is sd->name set anyway? And why is it moved under CONFIG_MEDIA_CONTROLLER?
It's not obvious to me.

The remainder of the patch makes sense.

Regards,

	Hans

> 
> >>       decoder->pad.flags = MEDIA_PAD_FL_SOURCE;
> >>       decoder->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> >>       decoder->sd.entity.flags |= MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> >> @@ -1176,16 +1177,22 @@ tvp514x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> >>       sd->ctrl_handler = &decoder->hdl;
> >>       if (decoder->hdl.error) {
> >>               ret = decoder->hdl.error;
> >> -
> >> -             v4l2_ctrl_handler_free(&decoder->hdl);
> >> -             return ret;
> >> +             goto done;
> >>       }
> >>       v4l2_ctrl_handler_setup(&decoder->hdl);
> >>
> >> -     v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
> >> -
> >> -     return 0;
> >> +     ret = v4l2_async_register_subdev(&decoder->sd);
> >> +     if (!ret)
> >> +             v4l2_info(sd, "%s decoder driver registered !!\n", sd->name);
> >>
> >> +done:
> >> +     if (ret < 0) {
> >> +             v4l2_ctrl_handler_free(&decoder->hdl);
> >> +#if defined(CONFIG_MEDIA_CONTROLLER)
> >> +             media_entity_cleanup(&decoder->sd.entity);
> >
> > So is this - it wasn't called before in the "if (decoder->hdl.error)" case
> > above.
> >
> Yes so fixed it up here.
> 
> Regards,
> --Prabhakar Lad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
