Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934532AbaLKWMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:12:06 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:37082 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909AbaLKWMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:12:03 -0500
MIME-Version: 1.0
In-Reply-To: <1881826.nJFi2vHdMH@al>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
 <20141211153118.GF29747@mail.corp.redhat.com> <CAG_cf+fx8Xk4t7fsGkb6bkFEPCXQg6rcAOk7arUD34B8QRShgQ@mail.gmail.com>
 <1881826.nJFi2vHdMH@al>
From: Andrew de los Reyes <andrew-vger@gizmolabs.org>
Date: Thu, 11 Dec 2014 14:11:42 -0800
X-Google-Sender-Auth: YiLpEd_zPORMxZxMvBiafG-M4eE
Message-ID: <CAG_cf+emOG6v988b-XwE7-aCERTdcHojMvsz6rQFeVq_JVfvLQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] HID: logitech-hidpp: disable io in probe error path
To: Peter Wu <peter@lekensteyn.nl>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Linux Input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would think you'd need to call hid_device_io_stop in probe before
returning just to make sure the hid->driver_input_lock is in the right
state. You may be able to consult hid->io_started in the probe thread
after calling probe, and do the appropriate cleanup if probe returned
error. IMHO I like to keep things like lock/unlock in pairs near each
other, so it seems preferable to require that drivers handle calling
hid_device_io_stop themselves if probe will fail. I don't know in
general what the Linux stance is, tho.

-andrew

On Thu, Dec 11, 2014 at 9:53 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> On Thursday 11 December 2014 09:37:06 Andrew de los Reyes wrote:
>> On Thu Dec 11 2014 at 7:31:43 AM Benjamin Tissoires
>> <benjamin.tissoires@redhat.com> wrote:
>> >
>> > On Dec 11 2014 or thereabouts, Peter Wu wrote:
>> > > Balance a hid_device_io_start() call with hid_device_io_stop() in the
>> > > error path. This avoids processing of HID reports when the probe fails
>> > > which possibly leads to invalid memory access in hid_device_probe() as
>> > > report_enum->report_id_hash might already be freed via
>> > > hid_close_report().
>> >
>> > Well spotted too!
>> >
>> > >
>> > > hid_set_drvdata() is called before wtp_allocate, be consistent and clear
>> > > drvdata too on the error path of wtp_allocate.
>> >
>> > This is not strictly speaking required. We will have a dangling value in
>> > hdev->private_data, but this should be overwritten before the next use.
>> >
>> > Anyway, it makes sense to clean up after a failure, so the patch is
>> > Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> >
>> > Cheers,
>> > Benjamin
>> >
>> > >
>> > > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
>> > > ---
>> > > Hi Andrew,
>> > >
>> > > There are few users of hid_device_io_start/stop, this is the first one
>> > > to get start/stop out of sync. Should the comment of
>> > > hid_device_io_start() be updated to ensure that hid_device_io_stop()
>> > > gets called before probe() returns? Or should the hid-core be changed to
>> > > handle this out-of-sync issue:
>>
>> I do not have a strong opinion on this, and will defer to others. The
>> reason I needed to communicate during probe() was to have the driver
>> probe the actual device for details. In this use case, I would be okay
>> to disable IO at the end of probe() and have it become reenabled via
>> the normal (default) methods.
>>
>> -andrew
>
> Keeping the reports enabled when the probe succeeds is fine, I am
> referring to the error path. If the probe fails, then reports should
> never be accepted or a corruption may occur (if I see it correctly).
>
> Is this analysis correct?
>
>  hid_device_probe()
>    hid_device_io_start()
>    return FAILURE
>  hid_close_report(device)
>    report_enum = device
>         ->report_enum[i]
>    hid_free_report(report_enum
>         ->report_id_hash[j])    <-- NOTE: freed
>                     ... interrupt occurs ...
>                                     hid_input_report()
>                                       hid_get_report()
>                                         report = report_enum->report_id_hash[n];
>                                                  ^ NOTE: use-after-free
>                                         return report if not NULL
>                                       hdrv->raw_event(report) <--- BOOM?
>    kfree(device->rdesc)
>  device->driver = NULL
>
> Kind regards,
> Peter
>
>> > >
>> > >               if (ret) {
>> > >                       if (hdev->io_started))
>> > >                               down(&hdev->driver_input_lock);
>> > >                       hid_close_report(hdev);
>> > >                       hdev->driver = NULL;
>> > >               }
>> > >
>> > > Is my observation correct or not that HID reports can arrive during
>> > > hid_close_report() when io_started == true?
>> > >
>> > > Kind regards,
>> > > Peter
>> > > ---
>> > >  drivers/hid/hid-logitech-hidpp.c | 4 +++-
>> > >  1 file changed, 3 insertions(+), 1 deletion(-)
>> > >
>> > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
>> > > index 4292cc3..2f420c0 100644
>> > > --- a/drivers/hid/hid-logitech-hidpp.c
>> > > +++ b/drivers/hid/hid-logitech-hidpp.c
>> > > @@ -1121,7 +1121,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
>> > >       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
>> > >               ret = wtp_allocate(hdev, id);
>> > >               if (ret)
>> > > -                     return ret;
>> > > +                     goto wtp_allocate_fail;
>> > >       }
>> > >
>> > >       INIT_WORK(&hidpp->work, delayed_work_cb);
>> > > @@ -1141,6 +1141,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
>> > >       if (id->group != HID_GROUP_LOGITECH_DJ_DEVICE) {
>> > >               if (!connected) {
>> > >                       hid_err(hdev, "Device not connected");
>> > > +                     hid_device_io_stop(hdev);
>> > >                       goto hid_parse_fail;
>> > >               }
>> > >
>> > > @@ -1186,6 +1187,7 @@ hid_hw_start_fail:
>> > >  hid_parse_fail:
>> > >       cancel_work_sync(&hidpp->work);
>> > >       mutex_destroy(&hidpp->send_mutex);
>> > > +wtp_allocate_fail:
>> > >       hid_set_drvdata(hdev, NULL);
>> > >       return ret;
>> > >  }
>> > > --
>> > > 2.1.3
>> > >
>
