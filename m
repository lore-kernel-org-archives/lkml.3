Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3EGLOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:14:05 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:50582 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3EGLOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:14:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shawn Nematbakhsh <shawnn@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] uvcvideo: Retry usb_submit_urb on -EPERM return
Date: Tue, 07 May 2013 13:14:14 +0200
Message-ID: <1939487.3PSlGk3nBF@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CALaWCOM5rr7jMFuW0q4FmGuUw_VK5rwmyt4qXH9EY2SkfdkSpg@mail.gmail.com>
References: <1366764152-9797-1-git-send-email-shawnn@chromium.org> <2335654.c00h6tDv9u@avalon> <CALaWCOM5rr7jMFuW0q4FmGuUw_VK5rwmyt4qXH9EY2SkfdkSpg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Friday 03 May 2013 16:00:24 Shawn Nematbakhsh wrote:
> Hi Laurent,
> 
> Thanks for the changes! I agree that your synchronization logic is
> correct. Just two small comments:
> 
> On Mon, Apr 29, 2013 at 1:34 PM, Laurent Pinchart wrote:
> > On Tuesday 23 April 2013 17:42:32 Shawn Nematbakhsh wrote:
> >> While usb_kill_urb is in progress, calls to usb_submit_urb will fail
> >> with -EPERM (documented in Documentation/usb/URB.txt). The UVC driver
> >> does not correctly handle this case -- there is no synchronization
> >> between uvc_v4l2_open / uvc_status_start and uvc_v4l2_release /
> >> uvc_status_stop.
> > 
> > Wouldn't it be better to synchronize status operations in open/release ?
> > Something like the following patch:
> > 
> > From 9285d678ed2f823bb215f6bdec3ca1a9e1cac977 Mon Sep 17 00:00:00 2001
> > From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Date: Fri, 26 Apr 2013 03:28:51 +0200
> > Subject: [PATCH] uvcvideo: Fix open/close race condition
> > 
> > Maintaining the users count using an atomic variable makes sure that
> > access to the counter won't be racy, but doesn't serialize access to the
> > operations protected by the counter. This creates a race condition that
> > could result in the status URB being submitted multiple times.
> > 
> > Use a mutex to protect the users count and serialize access to the
> > status start and stop operations.
> > 
> > Reported-by: Shawn Nematbakhsh <shawnn@chromium.org>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/usb/uvc/uvc_driver.c | 22 ++++++++++++++++------
> >  drivers/media/usb/uvc/uvc_status.c | 21 ++-------------------
> >  drivers/media/usb/uvc/uvc_v4l2.c   | 14 ++++++++++----
> >  drivers/media/usb/uvc/uvcvideo.h   |  7 +++----
> >  4 files changed, 31 insertions(+), 33 deletions(-)
> > 
> > diff --git a/drivers/media/usb/uvc/uvc_driver.c
> > b/drivers/media/usb/uvc/uvc_driver.c index e68fa53..b638037 100644
> > --- a/drivers/media/usb/uvc/uvc_driver.c
> > +++ b/drivers/media/usb/uvc/uvc_driver.c
> > @@ -1836,8 +1836,8 @@ static int uvc_probe(struct usb_interface *intf,
> >         INIT_LIST_HEAD(&dev->chains);
> >         INIT_LIST_HEAD(&dev->streams);
> >         atomic_set(&dev->nstreams, 0);
> > -       atomic_set(&dev->users, 0);
> 
> I think dev->users is uninitialized now? Probably we should initialize
> to 0 here.

The whole dev structure is memset to 0 when allocated a couple of lines above, 
so there's no need to explicitly zero all fields.

> >         atomic_set(&dev->nmappings, 0);
> > +       mutex_init(&dev->lock);
> > 
> >         dev->udev = usb_get_dev(udev);
> >         dev->intf = usb_get_intf(intf);
> > @@ -1953,8 +1953,12 @@ static int uvc_suspend(struct usb_interface *intf,
> > pm_message_t message)> 
> >         /* Controls are cached on the fly so they don't need to be saved.
> >         */
> >         if (intf->cur_altsetting->desc.bInterfaceSubClass ==
> > -           UVC_SC_VIDEOCONTROL)
> > -               return uvc_status_suspend(dev);
> > +           UVC_SC_VIDEOCONTROL) {
> > +               mutex_lock(&dev->lock);
> > +               if (dev->users)
> > +                       uvc_status_stop(dev);
> > +               mutex_unlock(&dev->lock);
> 
> To keep the same control flow, should we return here?

Oops, my bad, I'll fix that and resubmit.

> > +       }
> >         list_for_each_entry(stream, &dev->streams, list) {
> >                 if (stream->intf == intf)

-- 
Regards,

Laurent Pinchart

