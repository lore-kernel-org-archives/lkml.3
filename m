Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501AbaFQVVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:21:44 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:51472 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964976AbaFQVVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:21:40 -0400
MIME-Version: 1.0
Date: Tue, 17 Jun 2014 14:14:55 -0700
Message-ID: <CAF8JNh+FBAAn4zM+ziUU4hLVdnJvYkDyF-iPb3zTvQsgzfcT=w@mail.gmail.com>
Subject: Re: [PATCH] Input - wacom: put a flag when the led are initialized
From: Ping Cheng <pinglinux@gmail.com>
To: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Monday, June 16, 2014, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi Ping,
>
> On Jun 13 2014 or thereabouts, Ping Cheng wrote:
> > Hi Benjamin,
> >
> > On Fri, Jun 13, 2014 at 1:29 PM, Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > > This solves a bug with the wireless receiver:
> >
> > Your patch does get rid of the crash. But, it does not fix it at the
> > root cause.
>
> True, it fixes the crash, does not get rid of the root cause, but it is
> still required. See later.
>
> >
> > > - at plug, the wireless receiver does not know which Wacom device it is
> > >   connected to, so it does not actually creates all the LEDs
> >
> > This is the root cause - LEDs are not created for wireless devices.
> > Neither here, nor later when a real device is connected.
>
> Yep
>
> >
> > > - when the tablet connects, wacom->wacom_wac.features.type is set to the
> > >   proper device so that wacom_wac can understand the packets
> >
> > LEDs are not created for any wireless devices since we don't call
> > wacom_initialize_leds() when real tablets are connected.
>
> Yep
>
> >
> > > - when the receiver is unplugged, it detects that a LED should have been
> > >   created (based on wacom->wacom_wac.features.type) and tries to remove
> > >   it: crash when removing the sysfs group.
> >
> > When receiver is unplugged, it remembers the last tablet that
> > connected to it. If that tablet supports LEDs, wacom_destroy_leds() is
> > called. But, no LEDs were initialized. That's why it crashes.
>
> Yep
>
> >
> > > Side effect, we can now safely call several times wacom_destroy_leds().
> >
> > led_initialized will never be true if we keep wacom_initialize_leds()
> > inside probe().
>
> If you are talking about wireless devices only, yes, this value will
> never be true. That's the purpose of this patch actually :)
>
> >
> > To make initialize_leds() and desctroy_leds() work for wireless
> > devices, we need to move them to wacom_wireless_work() where we know
> > what type of tablet is connected/disconnected.
>
> Unfortunately, this does not work:
> - we *can* create the LEDs sysfs in the wireless work
> - this will prevent the crash
> - the user will think it can control the LEDs
> - actually these LEDs control will do nothing because LEDs handling for
>   wireless devices goes through the WL interface, and not the PEN
>   interface of the WL receiver.
> - we need to implement a specific led_handling for the wireless receiver
>   (which will need to know which type of tablet is connected to it)
> - we still need a way to say that the pen intf which is declared as the
>   connected device does not has a LED sysfs.
>
> We could add a quirk to the wacom_wac->features saying that the
> connection is wireless, so there is no LED attached to the interface.
>
> Still, there will be some work to do to properly handle the LED
> configuration from the WL receiver. This work has to be done in the
> kernel, but also in the user space (g-s-d) because now, the led control
> will not be on the pen device, but on a plain usb device without input.
>
> If you prefer, I can add such a quirk. But my only concern is here to
> fix the kernel oops, not to add features which would require more
> testing across different hardware and development on the user space
> side.
>
> >
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > Thank you for your support. But, sorry
> >
> > NAKed-by: Ping Cheng <pingc@wacom.com>
>
> Please reconsider it or validate the quirk approach I mentioned.


I see your point. My concern was once we fixed the crash here, we
would forget to fix the actual problem.

For the time being, let's make sure we can move on. So,

Acked-by: Ping Cheng <pingc@wacom.com>.

Cheers,

Ping
