Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab3JAAL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 20:11:26 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:39981 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3JAALY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 20:11:24 -0400
MIME-Version: 1.0
X-Originating-IP: [99.22.209.41]
In-Reply-To: <CANq1E4QhpY1TdE2sXhwpY4RAHErAJs_Pek4-EKoRXCeGh_0j6A@mail.gmail.com>
References: <CAC24_3tuw2Ejcg_TLB0kd2XumhS8UDdBd_3YAmY9hh0G8y9kKQ@mail.gmail.com>
	<CANq1E4QhpY1TdE2sXhwpY4RAHErAJs_Pek4-EKoRXCeGh_0j6A@mail.gmail.com>
Date: Mon, 30 Sep 2013 19:11:22 -0500
Message-ID: <CAC24_3uGi8B_g7Jc0myOowdw2YgXP-UZLWMOUhiWbcgewvNEEA@mail.gmail.com>
Subject: Re: xpad input driver: Xbox 360 Wireless Adapter
From: Zachary Lund <admin@computerquip.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize for poor assumptions and lack of general knowledge
concerning what I'm talking about. However, I feel I can still help on
the subject.

As to what device I'm talking about, I'm talking about the more
properly termed "Xbox 360 Wireless Gaming Reciever". More information
and a picture can be found here:
http://www.microsoft.com/games/en-US/Hardware/Controllers/Pages/XboxWirelessGamingReceiverforWindows.aspx

Future references will refer the above device as "wireless reciever"
and the opposing wired controller that requires no reciever as "wired
controller".
When I refer to the "xpad driver", I mean the USB driver sitting here:
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/input/joystick/xpad.c

To be clear, the wireless receiver connects to a USB port in the PC
and interacts wirelessly with any Xbox 360 controller that can connect
to the Xbox 360 console (but the driver doesn't need to know this).
When a controller is "synced" with the wireless receiver, it sends
events like normal over the corresponding USB interface via interrupt
endpoints.

>> Second, the driver acts strangely when setting the LED. It calls
>> xpad_send_led_command during xpad_led_probe during xpad_probe but
>> there's a chance that a controller might not even be connected if
>> using the wireless adapter during that time!
>
>What? During xpad_probe() a device must be fully functional. What
>adapter are your talking about?

I apologize again for not explaining well enough. When the wireless
receiver is connected, all 8 interfaces are probed immediately but a
wireless controller may not actually be synced with the wireless
receiver. Even if it were, the current method the xpad driver takes
doesn't seem to work on the wireless receiver and leaves the
controllers LED in a default "blinking" state.

>> The only way to seemingly
>> tell if a controller is connected is by receiving the correct
>> connection packets. If I use the correct packet structure (which I
>> ripped almost directly from xboxdrv) and set the led after parsing a
>> connection packet, the LED seemingly works fine!
>
>Sounds reasonable. Do all devices send the connection-packets? If yes,
>feel free to send a patch which moves LED initialization after receipt
>of this package.

My inexperience comes into play here probably so take what I say with
a grain of salt please. Whenever a controller is synced with the
wireless reciever, the wireless receiver sends an interrupt packet
containing 0x08 0x80 to the driver to say that a new controller is
connected (which corresponds to the USB interface it was sent on,
explained below) or 0x08 0x00 to say that it has disconnected. I
believe there's already a patch available (not created by me) after
further diving in the mailing list, although I cannot confirm whether
it works or not as I've not tested it myself:
https://lkml.org/lkml/2012/11/30/558

To further explain, there are differences between the wireless
receiver and wired controller concerning how it works. The wired
controller seems to have only 4 USB interfaces (according to
http://www.free60.org/GamePad) whereas the wireless receiver has 8. I
cannot explain what the interfaces for the wired controller do but for
the wireless receiver, all odd interfaces seem to deal with input
events, LEDs, and anything to do with the actual controller. So
interfaces 1, 3, 5, and 7 can represent a controller. All even
interfaces (0, 2, 4, 6) seem to represent something else, probably a
headset which I can't confirm or test. Either way, the driver doesn't
support whatever these interfaces do so should xpad actually claim
them? The patch mentioned above seems to also remove the out bulk
endpoint sense it doesn't seem to be useful to any of the Xbox 360
controllers including the wired ones. A lot of things I don't know
myself. I apologize if I just confused the matter.

>> Third, I'm incredibly new to really low level development. Whenever
>> loading the module, it finds my wireless adapter but then creates 4
>> devices (which seems to mean only 4 controllers are allowed per
>> wireless adapter), each of which cause a call to xpad_probe. I
>> couldn't figure out how to tell if other wireless controllers were
>> already connected to the wireless adapter so I could light up the
>> correct LED. How would I go about this properly?
>
>Ugh? Sorry, but I don't understand what kind of wireless adapter this
>is? Please give us a bit more information here. If the device is a
>Bluetooth-device, why use an adapter at all?

Please ignore... I did not properly understand how USB devices work
(rather, I'm still learning) when writing this question and its poorly
written which just confused the topic if I haven't done so more in
previous comments.

On Mon, Sep 30, 2013 at 1:49 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> I'm not very familiar with the xbox-gamepad driver, but please see
> below for some comments:
>
> On Mon, Sep 23, 2013 at 2:34 AM, Zachary Lund <admin@computerquip.com> wrote:
>> I'm apologize ahead of time if this thread isn't appropriate, I'm not
>> very familiar with mailing lists, especially lkml. I'm also very new
>> to kernel/module development (as of literally yesterday).
>
> Input-drivers are discussed on <linux-input@vger.kernel.org> (now
> CC'ed). I recommend subscribing to that list. I also put some driver
> developers on CC as they are probably more qualified to answer your
> questions.
>
> Note that LKML is a high-traffic list mostly used in CC. Please always
> CC the driver authors or maintainers.
>
>> I was looking into getting the LED working properly for the Xbox 360
>> controllers and learning about the basics of a kernel module at the
>> same time. There were a few things that confused me. I will reference
>> functions by name and all functions are from the current 3.12 branch.
>
> It might be useful to mention the driver in question (it's
> drivers/input/joystick/xpad.c I guess?).
>
>> First, xpad_send_led_command seems to be geared only towards the
>> "Microsoft X-Box 360 pad". Using xboxdrv as a reference, they use a
>> completely different packet structure to set the LED status on the
>> wireless controller which can be seen here:
>> https://github.com/Grumbel/xboxdrv/blob/master/src/controller/xbox360_wireless_controller.cpp#L66
>
> I don't think the kernel driver supports wireless pads, so it might
> have a different "wireless optimized" wire-protocol. The driver is
> USB-only, isn't it?
>
>> Second, the driver acts strangely when setting the LED. It calls
>> xpad_send_led_command during xpad_led_probe during xpad_probe but
>> there's a chance that a controller might not even be connected if
>> using the wireless adapter during that time!
>
> What? During xpad_probe() a device must be fully functional. What
> adapter are your talking about?
>
>> The only way to seemingly
>> tell if a controller is connected is by receiving the correct
>> connection packets. If I use the correct packet structure (which I
>> ripped almost directly from xboxdrv) and set the led after parsing a
>> connection packet, the LED seemingly works fine!
>
> Sounds reasonable. Do all devices send the connection-packets? If yes,
> feel free to send a patch which moves LED initialization after receipt
> of this package.
>
>> Third, I'm incredibly new to really low level development. Whenever
>> loading the module, it finds my wireless adapter but then creates 4
>> devices (which seems to mean only 4 controllers are allowed per
>> wireless adapter), each of which cause a call to xpad_probe. I
>> couldn't figure out how to tell if other wireless controllers were
>> already connected to the wireless adapter so I could light up the
>> correct LED. How would I go about this properly?
>
> Ugh? Sorry, but I don't understand what kind of wireless adapter this
> is? Please give us a bit more information here. If the device is a
> Bluetooth-device, why use an adapter at all?
>
> Cheers
> David
