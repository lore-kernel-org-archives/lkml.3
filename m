Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaLEMGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:06:30 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50078 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaLEMGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:06:15 -0500
Date: Fri, 5 Dec 2014 13:06:10 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: dln2: add suspend/resume functionality
Message-ID: <20141205120610.GG11445@localhost>
References: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
 <20141205101741.GD11445@localhost>
 <CAE1zotJwn6kVv8s5Dk+wxQxuGDKSjaqMqYY0M0Q0uODQypSsoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotJwn6kVv8s5Dk+wxQxuGDKSjaqMqYY0M0Q0uODQypSsoA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 01:51:17PM +0200, Octavian Purdila wrote:
> On Fri, Dec 5, 2014 at 12:17 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Thu, Nov 27, 2014 at 01:57:14PM +0200, Octavian Purdila wrote:
> >
> >> @@ -753,11 +759,42 @@ static const struct usb_device_id dln2_table[] = {
> >>
> >>  MODULE_DEVICE_TABLE(usb, dln2_table);
> >
> > Place the new callbacks above the device id table.
> >
> >> +static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
> >> +{
> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
> >> +
> >> +     dln2_stop(dln2);
> >
> > You should also stop the reads urbs here.
> 
> Do you mean usb_kill_urb()? I thought that was not necessary unless
> the device is reset. However, going throught
> Documentation/usb/power-management.txt again looks like it must be
> done in suspend.

Yes, you should kill them explicitly. Any outstanding urbs will be
killed by usb core if you fail to do this.

> >> +     return 0;
> >> +}
> >> +
> >> +static int dln2_resume(struct usb_interface *iface)
> >> +{
> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
> >> +
> >> +     dln2->disconnect = false;
> >
> > And surely you need to resubmit the read urbs in resume, or you will
> > never receive any more data.
> >
> > How did you test this patch?
> >
> 
> The resume cb is not called in my setup (kvm), only reset_resume. 

Please make sure to test your patches on proper hardware.

> But I assume since the port is not reset when resume is called the
> URBs are still queued.

No, they will have been killed by usb core even if you forget to do it,
so this would prevent any further reads.

> >> +     return 0;
> >> +}
> >> +
> >> +static int dln2_reset_resume(struct usb_interface *iface)
> >> +{
> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
> >> +     int ret;
> >> +
> >> +     dln2_free_rx_urbs(dln2);
> >> +     ret = dln2_setup_rx_urbs(dln2, iface->cur_altsetting);
> >
> > This doesn't make much sense. Why would you ever want to reallocate the
> > urbs and their buffers here?
> >
> > If the device does not lose its state as you claim, then all you need to
> > do is to resubmit the read urbs (as in resume).
> >
> The device itself does not lose state as it does not lose power and
> does not react to USB port reset AFAICS (e.g. GPIO settings are
> preserved). However the USB port is reset and I assumed I must
> reallocate the URBs.

You don't and should not.

> I just found out that usb-serial uses usb_poisoin_urb and
> usb_unpoison_urb for suspend/resume and this two looks like just what
> I need.

Why do you think so?

> Should I use that instead?

No.

Johan
