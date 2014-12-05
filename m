Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaLENFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:05:48 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60014 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaLENFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <20141205120610.GG11445@localhost>
References: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
	<20141205101741.GD11445@localhost>
	<CAE1zotJwn6kVv8s5Dk+wxQxuGDKSjaqMqYY0M0Q0uODQypSsoA@mail.gmail.com>
	<20141205120610.GG11445@localhost>
Date: Fri, 5 Dec 2014 15:05:45 +0200
Message-ID: <CAE1zotKGAvd9oKz5_McihnPcpH-n4Rc4s0r=jm2wb26-dD8Dsg@mail.gmail.com>
Subject: Re: [PATCH] mfd: dln2: add suspend/resume functionality
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2014 at 2:06 PM, Johan Hovold <johan@kernel.org> wrote:
> On Fri, Dec 05, 2014 at 01:51:17PM +0200, Octavian Purdila wrote:
>> On Fri, Dec 5, 2014 at 12:17 PM, Johan Hovold <johan@kernel.org> wrote:
>> > On Thu, Nov 27, 2014 at 01:57:14PM +0200, Octavian Purdila wrote:
>> >
>> >> @@ -753,11 +759,42 @@ static const struct usb_device_id dln2_table[] = {
>> >>
>> >>  MODULE_DEVICE_TABLE(usb, dln2_table);
>> >
>> > Place the new callbacks above the device id table.
>> >
>> >> +static int dln2_suspend(struct usb_interface *iface, pm_message_t message)
>> >> +{
>> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
>> >> +
>> >> +     dln2_stop(dln2);
>> >
>> > You should also stop the reads urbs here.
>>
>> Do you mean usb_kill_urb()? I thought that was not necessary unless
>> the device is reset. However, going throught
>> Documentation/usb/power-management.txt again looks like it must be
>> done in suspend.
>
> Yes, you should kill them explicitly. Any outstanding urbs will be
> killed by usb core if you fail to do this.
>
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static int dln2_resume(struct usb_interface *iface)
>> >> +{
>> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
>> >> +
>> >> +     dln2->disconnect = false;
>> >
>> > And surely you need to resubmit the read urbs in resume, or you will
>> > never receive any more data.
>> >
>> > How did you test this patch?
>> >
>>
>> The resume cb is not called in my setup (kvm), only reset_resume.
>
> Please make sure to test your patches on proper hardware.

It was tested with the proper hardware, I was just testing it in the
setup we use, which is kvm with USB pass through.

>
>> But I assume since the port is not reset when resume is called the
>> URBs are still queued.
>
> No, they will have been killed by usb core even if you forget to do it,
> so this would prevent any further reads.
>
>> >> +     return 0;
>> >> +}
>> >> +
>> >> +static int dln2_reset_resume(struct usb_interface *iface)
>> >> +{
>> >> +     struct dln2_dev *dln2 = usb_get_intfdata(iface);
>> >> +     int ret;
>> >> +
>> >> +     dln2_free_rx_urbs(dln2);
>> >> +     ret = dln2_setup_rx_urbs(dln2, iface->cur_altsetting);
>> >
>> > This doesn't make much sense. Why would you ever want to reallocate the
>> > urbs and their buffers here?
>> >
>> > If the device does not lose its state as you claim, then all you need to
>> > do is to resubmit the read urbs (as in resume).
>> >
>> The device itself does not lose state as it does not lose power and
>> does not react to USB port reset AFAICS (e.g. GPIO settings are
>> preserved). However the USB port is reset and I assumed I must
>> reallocate the URBs.
>
> You don't and should not.
>
>> I just found out that usb-serial uses usb_poisoin_urb and
>> usb_unpoison_urb for suspend/resume and this two looks like just what
>> I need.
>
> Why do you think so?
>

Hmm, never mind, now I understand that usb_poisoin_urb is just used
defensive in usb-serial to prevent the drivers to submit the URB until
resume time.

Thanks for the review Johan, I will send v2 with usb_kill_urb in
suspend() and usb_submit_urb() in resume and resume_reset.
