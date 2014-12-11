Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbaLKRh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:37:29 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:33467 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaLKRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:37:27 -0500
MIME-Version: 1.0
In-Reply-To: <20141211153118.GF29747@mail.corp.redhat.com>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
 <1418302280-14794-5-git-send-email-peter@lekensteyn.nl> <20141211153118.GF29747@mail.corp.redhat.com>
From: Andrew de los Reyes <andrew-vger@gizmolabs.org>
Date: Thu, 11 Dec 2014 09:37:06 -0800
X-Google-Sender-Auth: pESyyIezvOvN8L2sDrB_56vmL9M
Message-ID: <CAG_cf+fx8Xk4t7fsGkb6bkFEPCXQg6rcAOk7arUD34B8QRShgQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] HID: logitech-hidpp: disable io in probe error path
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Dec 11 2014 at 7:31:43 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Dec 11 2014 or thereabouts, Peter Wu wrote:
> > Balance a hid_device_io_start() call with hid_device_io_stop() in the
> > error path. This avoids processing of HID reports when the probe fails
> > which possibly leads to invalid memory access in hid_device_probe() as
> > report_enum->report_id_hash might already be freed via
> > hid_close_report().
>
> Well spotted too!
>
> >
> > hid_set_drvdata() is called before wtp_allocate, be consistent and clear
> > drvdata too on the error path of wtp_allocate.
>
> This is not strictly speaking required. We will have a dangling value in
> hdev->private_data, but this should be overwritten before the next use.
>
> Anyway, it makes sense to clean up after a failure, so the patch is
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> Cheers,
> Benjamin
>
> >
> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> > ---
> > Hi Andrew,
> >
> > There are few users of hid_device_io_start/stop, this is the first one
> > to get start/stop out of sync. Should the comment of
> > hid_device_io_start() be updated to ensure that hid_device_io_stop()
> > gets called before probe() returns? Or should the hid-core be changed to
> > handle this out-of-sync issue:

I do not have a strong opinion on this, and will defer to others. The
reason I needed to communicate during probe() was to have the driver
probe the actual device for details. In this use case, I would be okay
to disable IO at the end of probe() and have it become reenabled via
the normal (default) methods.

-andrew

> >
> >               if (ret) {
> >                       if (hdev->io_started))
> >                               down(&hdev->driver_input_lock);
> >                       hid_close_report(hdev);
> >                       hdev->driver = NULL;
> >               }
> >
> > Is my observation correct or not that HID reports can arrive during
> > hid_close_report() when io_started == true?
> >
> > Kind regards,
> > Peter
> > ---
> >  drivers/hid/hid-logitech-hidpp.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > index 4292cc3..2f420c0 100644
> > --- a/drivers/hid/hid-logitech-hidpp.c
> > +++ b/drivers/hid/hid-logitech-hidpp.c
> > @@ -1121,7 +1121,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
> >       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
> >               ret = wtp_allocate(hdev, id);
> >               if (ret)
> > -                     return ret;
> > +                     goto wtp_allocate_fail;
> >       }
> >
> >       INIT_WORK(&hidpp->work, delayed_work_cb);
> > @@ -1141,6 +1141,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
> >       if (id->group != HID_GROUP_LOGITECH_DJ_DEVICE) {
> >               if (!connected) {
> >                       hid_err(hdev, "Device not connected");
> > +                     hid_device_io_stop(hdev);
> >                       goto hid_parse_fail;
> >               }
> >
> > @@ -1186,6 +1187,7 @@ hid_hw_start_fail:
> >  hid_parse_fail:
> >       cancel_work_sync(&hidpp->work);
> >       mutex_destroy(&hidpp->send_mutex);
> > +wtp_allocate_fail:
> >       hid_set_drvdata(hdev, NULL);
> >       return ret;
> >  }
> > --
> > 2.1.3
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
