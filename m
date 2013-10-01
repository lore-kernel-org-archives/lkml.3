Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3JAOev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:34:51 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64002 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab3JAOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:34:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAC24_3uGi8B_g7Jc0myOowdw2YgXP-UZLWMOUhiWbcgewvNEEA@mail.gmail.com>
References: <CAC24_3tuw2Ejcg_TLB0kd2XumhS8UDdBd_3YAmY9hh0G8y9kKQ@mail.gmail.com>
	<CANq1E4QhpY1TdE2sXhwpY4RAHErAJs_Pek4-EKoRXCeGh_0j6A@mail.gmail.com>
	<CAC24_3uGi8B_g7Jc0myOowdw2YgXP-UZLWMOUhiWbcgewvNEEA@mail.gmail.com>
Date: Tue, 1 Oct 2013 16:34:42 +0200
Message-ID: <CANq1E4RxAnvBz6wnjcjuWndZfOFuWxjEPaUybnJJkt0-VB1pMQ@mail.gmail.com>
Subject: Re: xpad input driver: Xbox 360 Wireless Adapter
From: David Herrmann <dh.herrmann@gmail.com>
To: Zachary Lund <admin@computerquip.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Marko Friedemann <mfr@bmx-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Oct 1, 2013 at 2:11 AM, Zachary Lund <admin@computerquip.com> wrote:
> I apologize for poor assumptions and lack of general knowledge
> concerning what I'm talking about. However, I feel I can still help on
> the subject.
>
> As to what device I'm talking about, I'm talking about the more
> properly termed "Xbox 360 Wireless Gaming Reciever". More information
> and a picture can be found here:
> http://www.microsoft.com/games/en-US/Hardware/Controllers/Pages/XboxWirelessGamingReceiverforWindows.aspx

Thanks for the link. Now I understand what you meant.

> Future references will refer the above device as "wireless reciever"
> and the opposing wired controller that requires no reciever as "wired
> controller".
> When I refer to the "xpad driver", I mean the USB driver sitting here:
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/input/joystick/xpad.c
>
> To be clear, the wireless receiver connects to a USB port in the PC
> and interacts wirelessly with any Xbox 360 controller that can connect
> to the Xbox 360 console (but the driver doesn't need to know this).
> When a controller is "synced" with the wireless receiver, it sends
> events like normal over the corresponding USB interface via interrupt
> endpoints.

What exactly does the receiver provide to the host? Does it act as a
"USB Hub" and emulates USB hotplugging whenever you connect a device?
Or does it actually act as a single xbox-controller device and just
waits for a connected device to send the "connected" event? But see
below..

>>> Second, the driver acts strangely when setting the LED. It calls
>>> xpad_send_led_command during xpad_led_probe during xpad_probe but
>>> there's a chance that a controller might not even be connected if
>>> using the wireless adapter during that time!
>>
>>What? During xpad_probe() a device must be fully functional. What
>>adapter are your talking about?
>
> I apologize again for not explaining well enough. When the wireless
> receiver is connected, all 8 interfaces are probed immediately but a
> wireless controller may not actually be synced with the wireless
> receiver. Even if it were, the current method the xpad driver takes
> doesn't seem to work on the wireless receiver and leaves the
> controllers LED in a default "blinking" state.

..so to answer my question above: The device provides 8 static USB
interfaces with the VID/PID pre-configured to the host? And once a
real device connects to the hub, it simply starts the USB interaction
with the host? Sounds reasonable. But the linux driver might not have
been written to work with such a setup.

>>> The only way to seemingly
>>> tell if a controller is connected is by receiving the correct
>>> connection packets. If I use the correct packet structure (which I
>>> ripped almost directly from xboxdrv) and set the led after parsing a
>>> connection packet, the LED seemingly works fine!
>>
>>Sounds reasonable. Do all devices send the connection-packets? If yes,
>>feel free to send a patch which moves LED initialization after receipt
>>of this package.
>
> My inexperience comes into play here probably so take what I say with
> a grain of salt please. Whenever a controller is synced with the
> wireless reciever, the wireless receiver sends an interrupt packet
> containing 0x08 0x80 to the driver to say that a new controller is
> connected (which corresponds to the USB interface it was sent on,
> explained below) or 0x08 0x00 to say that it has disconnected. I
> believe there's already a patch available (not created by me) after
> further diving in the mailing list, although I cannot confirm whether
> it works or not as I've not tested it myself:
> https://lkml.org/lkml/2012/11/30/558

Yepp, this one looks good. Please test it and resend it if it fixes
your problems.

> To further explain, there are differences between the wireless
> receiver and wired controller concerning how it works. The wired
> controller seems to have only 4 USB interfaces (according to
> http://www.free60.org/GamePad) whereas the wireless receiver has 8. I
> cannot explain what the interfaces for the wired controller do but for
> the wireless receiver, all odd interfaces seem to deal with input
> events, LEDs, and anything to do with the actual controller. So
> interfaces 1, 3, 5, and 7 can represent a controller. All even
> interfaces (0, 2, 4, 6) seem to represent something else, probably a
> headset which I can't confirm or test. Either way, the driver doesn't
> support whatever these interfaces do so should xpad actually claim
> them? The patch mentioned above seems to also remove the out bulk
> endpoint sense it doesn't seem to be useful to any of the Xbox 360
> controllers including the wired ones. A lot of things I don't know
> myself. I apologize if I just confused the matter.

Sorry, but I don't have the device so I cannot really help here. You
need to reverse-engineer it yourself and patch the file. Sorry but I
don't know anyone actively working on it.
Problem is, this driver is quite old and supports a wide-range of
devices. Patches like the one mentioned above might break other
devices than yours. If you want your devices to be properly supported,
you need to either fix the drivers yourself and send patches or find
someone who does it for you, sorry..

If it's just your LED thing that broke, you might want to just
consider re-sending the SET-LED command after the configure-event.
Don't remove the old SET-LED but just resend it. This shouldn't break
other devices.

Regards
David
