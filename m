Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaJFUlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:41:24 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:39544 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJFUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:41:22 -0400
MIME-Version: 1.0
In-Reply-To: <1510196.ldtLAThOeq@avalon>
References: <CACHYQ-r-+czyEBySdjNWr-3XmY1C2ErDJV0dnL=GDJOYPi1asw@mail.gmail.com>
 <1409791668-18715-1-git-send-email-vpalatin@chromium.org> <1510196.ldtLAThOeq@avalon>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Mon, 6 Oct 2014 13:41:01 -0700
X-Google-Sender-Auth: fca54jTcibAh9ZgSuwauWDFpWIk
Message-ID: <CAP_ceTz8BRQoFxkgb085_gOh29x8anvQNodAGMkgOukk02x29g@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] V4L: uvcvideo: Add support for pan/tilt speed controls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Pawel Osciak <posciak@chromium.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>, Zach Kuznia <zork@chromium.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 1:29 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Vincent,
>
> Thank you for the patch.
>
> On Wednesday 03 September 2014 17:47:48 Vincent Palatin wrote:
> > Map V4L2_CID_TILT_SPEED and V4L2_CID_PAN_SPEED to the standard UVC
> > CT_PANTILT_RELATIVE_CONTROL terminal control request.
> >
> > Tested by plugging a Logitech ConferenceCam C3000e USB camera
> > and controlling pan/tilt from the userspace using the VIDIOC_S_CTRL ioctl.
> > Verified that it can pan and tilt at the same time in both directions.
> >
> > Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
>
> Small comment here, as Pawel has reviewed the previous version, you could have
> added his Reviewed-by tag to the patch.
>
> > ---
> > Changes from v1/v2:
> > - rebased
> > Changes from v3:
> > - removed gerrit-id
> >
> >  drivers/media/usb/uvc/uvc_ctrl.c | 58 ++++++++++++++++++++++++++++++++++---
> >  1 file changed, 55 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/usb/uvc/uvc_ctrl.c
> > b/drivers/media/usb/uvc/uvc_ctrl.c index 0eb82106..d703cb0 100644
> > --- a/drivers/media/usb/uvc/uvc_ctrl.c
> > +++ b/drivers/media/usb/uvc/uvc_ctrl.c
> > @@ -309,9 +309,8 @@ static struct uvc_control_info uvc_ctrls[] = {
> >               .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> >               .index          = 12,
> >               .size           = 4,
> > -             .flags          = UVC_CTRL_FLAG_SET_CUR | UVC_CTRL_FLAG_GET_MIN
> > -                             | UVC_CTRL_FLAG_GET_MAX | UVC_CTRL_FLAG_GET_RES
> > -                             | UVC_CTRL_FLAG_GET_DEF
> > +             .flags          = UVC_CTRL_FLAG_SET_CUR
> > +                             | UVC_CTRL_FLAG_GET_RANGE
> >                               | UVC_CTRL_FLAG_AUTO_UPDATE,
> >       },
> >       {
> > @@ -391,6 +390,35 @@ static void uvc_ctrl_set_zoom(struct
> > uvc_control_mapping *mapping, data[2] = min((int)abs(value), 0xff);
> >  }
> >
> > +static __s32 uvc_ctrl_get_rel_speed(struct uvc_control_mapping *mapping,
> > +     __u8 query, const __u8 *data)
> > +{
> > +     int first = mapping->offset / 8;
>
> Nitpicking, I would use unsigned int instead of int here, as the value can't
> be negative (same comment for the next function).
>
> If you're fine with that there's no need to resubmit, I can modify this when
> applying.


Yes, I'm fine with that.


>
>
> > +     __s8 rel = (__s8)data[first];
> > +
> > +     switch (query) {
> > +     case UVC_GET_CUR:
> > +             return (rel == 0) ? 0 : (rel > 0 ? data[first+1]
> > +                                              : -data[first+1]);
> > +     case UVC_GET_MIN:
> > +             return -data[first+1];
> > +     case UVC_GET_MAX:
> > +     case UVC_GET_RES:
> > +     case UVC_GET_DEF:
> > +     default:
> > +             return data[first+1];
> > +     }
> > +}
> > +
> > +static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
> > +     __s32 value, __u8 *data)
> > +{
> > +     int first = mapping->offset / 8;
> > +
> > +     data[first] = value == 0 ? 0 : (value > 0) ? 1 : 0xff;
> > +     data[first+1] = min_t(int, abs(value), 0xff);
> > +}
> > +
> >  static struct uvc_control_mapping uvc_ctrl_mappings[] = {
> >       {
> >               .id             = V4L2_CID_BRIGHTNESS,
> > @@ -677,6 +705,30 @@ static struct uvc_control_mapping uvc_ctrl_mappings[] =
> > { .data_type  = UVC_CTRL_DATA_TYPE_SIGNED,
> >       },
> >       {
> > +             .id             = V4L2_CID_PAN_SPEED,
> > +             .name           = "Pan (Speed)",
> > +             .entity         = UVC_GUID_UVC_CAMERA,
> > +             .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> > +             .size           = 16,
> > +             .offset         = 0,
> > +             .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> > +             .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> > +             .get            = uvc_ctrl_get_rel_speed,
> > +             .set            = uvc_ctrl_set_rel_speed,
> > +     },
> > +     {
> > +             .id             = V4L2_CID_TILT_SPEED,
> > +             .name           = "Tilt (Speed)",
> > +             .entity         = UVC_GUID_UVC_CAMERA,
> > +             .selector       = UVC_CT_PANTILT_RELATIVE_CONTROL,
> > +             .size           = 16,
> > +             .offset         = 16,
> > +             .v4l2_type      = V4L2_CTRL_TYPE_INTEGER,
> > +             .data_type      = UVC_CTRL_DATA_TYPE_SIGNED,
> > +             .get            = uvc_ctrl_get_rel_speed,
> > +             .set            = uvc_ctrl_set_rel_speed,
> > +     },
> > +     {
> >               .id             = V4L2_CID_PRIVACY,
> >               .name           = "Privacy",
> >               .entity         = UVC_GUID_UVC_CAMERA,
>
> --
> Regards,
>
> Laurent Pinchart
>
