Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLQEYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 23:24:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaLQEX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 23:23:59 -0500
Date: Tue, 16 Dec 2014 23:23:45 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
Message-ID: <20141217042345.GC7837@mail.corp.redhat.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
 <1771836.oYfhfEolNx@al>
 <2965951.04q6IShhJ2@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2965951.04q6IShhJ2@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17 2014 or thereabouts, Peter Wu wrote:
> Sorry for the rapid mail, I forgot to mention something.
> 
> wtp_connect won't work on non-HID++ devices. What about moving it down,
> between the generic routines (reading protocol and name) and
> hidpp_allocate_input? Then the connected parameter can also be dropped.

No, this will not work. wtp_connect sets the device in the raw report
mode. If we call it after hidpp_allocate_input, this will work on the
first connect. Then, if you switch off/on the device, the connect_event
will be called, but the device will not be set in the raw mode.

We really need to unconditionally call wtp_connect at each
connect_event.

> 
> Kind regards,
> Peter
> 
> On Wednesday 17 December 2014 00:33:55 Peter Wu wrote:
> > On Tuesday 16 December 2014 17:06:01 Benjamin Tissoires wrote:
> > > If wtp_connect() fails, that means most of the time that the device has
> > > been disconnected. Subsequent attempts to contact the device will fail
> > > too, so it's simpler to bail out earlier.
> > > 
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > ---
> > >  drivers/hid/hid-logitech-hidpp.c | 15 +++++++++------
> > >  1 file changed, 9 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > index d008d71..c0fb5fe 100644
> > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > @@ -914,24 +914,24 @@ static int wtp_allocate(struct hid_device *hdev, const struct hid_device_id *id)
> > >  	return 0;
> > >  };
> > >  
> > > -static void wtp_connect(struct hid_device *hdev, bool connected)
> > > +static int wtp_connect(struct hid_device *hdev, bool connected)
> > >  {
> > >  	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
> > >  	struct wtp_data *wd = hidpp->private_data;
> > >  	int ret;
> > >  
> > >  	if (!connected)
> > > -		return;
> > > +		return 0;
> > 
> > "0" is success, what about -1 or -ENODEV here to signal an error? The
> > following line (in hidpp_connect_event) returns on !connected, but that
> > is no reason to return 0 here.

0 is fine here. Maybe I over thought the API, but the connect_event is
sent whenever the device is connected or disconnected.
This allows a subdriver to do things on connect and on disconnect. For
instance, you could delete the input node on disconnect. This is not
something we want though, so the disconnect event is just discarded.

But this disconnect event is not an error, it is just a discarded event,
so returning success is fine.

> > 
> > ("No connection" sounds like an error condition to me as "[wtp_]connect"
> > cannot do something meaningful.)
> > 
> > Whether or not you change the return value is up to you. This patch is
> > Reviewed-by: Peter Wu <peter@lekensteyn.nl>

Thanks for the review!

Cheers,
Benjamin

> > 
> > Kind regards,
> > Peter
> > 
> > >  	if (!wd->x_size) {
> > >  		ret = wtp_get_config(hidpp);
> > >  		if (ret) {
> > >  			hid_err(hdev, "Can not get wtp config: %d\n", ret);
> > > -			return;
> > > +			return ret;
> > >  		}
> > >  	}
> > >  
> > > -	hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
> > > +	return hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
> > >  			true, true);
> > >  }
> > >  
> > > @@ -1115,8 +1115,11 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
> > >  	struct input_dev *input;
> > >  	char *name, *devm_name;
> > >  
> > > -	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> > > -		wtp_connect(hdev, connected);
> > > +	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
> > > +		ret = wtp_connect(hdev, connected);
> > > +		if (ret)
> > > +			return;
> > > +	}
> > >  
> > >  	if (!connected || hidpp->delayed_input)
> > >  		return;
> > > 
> 
