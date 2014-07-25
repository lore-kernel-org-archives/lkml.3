Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaGYXPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:15:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaGYXPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:15:31 -0400
Date: Fri, 25 Jul 2014 19:15:09 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series
 2
Message-ID: <20140725231509.GA2279@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406326412.4674.22.camel@fedora-lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1406326412.4674.22.camel@fedora-lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Przemo,

On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
> [..]
> Hi Benjamin,
> I'm testing the whole series including the OLED patch that's not on the
> list yet.
> 
> Hardware: 2 x Intuos4 Wireless tested on usb and bluetooth until noted
> otherwise.
> 
> What works:
> 1. Tablet in general, pressure, tilt, buttons etc.
> 2. Battery reporting (including gnome). The double wireless tablet bug
> is gone:
> 
> $ ls /sys/class/power_supply/
> AC  BAT0  wacom_ac_2  wacom_ac_3  wacom_battery_2  wacom_battery_3
> 
> 3. Setting LED selector value
> 4. Setting LED selector brightness (default and pressed)
> 5. Rendering images to button displays works on usb ONLY.
> 
> $ i4oled -d /sys/bus/hid/drivers/wacom/0003\:056A\:00BC.0009/wacom_led/button0_rawimg -t Linux
> 
> On bluetooth writing image goes fine (no error), but there is nothing showing up,
> so I suspect the brightness of OLED displays is not set properly.
> 
> That's the code before changes:
> 
>         led = wdata->led_selector | 0x04;
>         buf = kzalloc(9, GFP_KERNEL);
>         if (buf) {
>                 buf[0] = WAC_CMD_LED_CONTROL;
>                 buf[1] = led;
>                 buf[2] = value >> 2;
>                 buf[3] = value;
>                 /* use fixed brightness for OLEDs */
>                 buf[4] = 0x08;
>                 hid_hw_raw_request(hdev, buf[0], buf, 9, HID_FEATURE_REPORT,
>                                    HID_REQ_SET_REPORT);
>                 kfree(buf);
>         }
> 
> I don't remember for sure, but I think the range of brightness might be different
> over usb and over bluetooth.

Maybe you can try setting the sysfs file "buttons_luminance" with the
value 8 to check if this will solve the bug.

The bug might also be linked to the slight difference while setting up
the transfer of the image (WAC_CMD_ICON_START) with the value of buf[1]
set to 1 in USB, while it was 0 on bluetooth.

The weird thing is that I remembered having set the OLED (though
scrambled) with these patches applied. I guess the scrambling was due to
the 4-bit vs 1-bit. But I definitively had some results.

Anyway. Przemo, Dmitry, can we consider that this *will* be fixed by
next week, and so we can apply the series for 3.17?
I will have the hardware next week and be able to figure out the
differences between the 2 communication modes.

> 
> TL;DR: the only thing that needs to be fixed is image-over-bluetooth, probably caused by not
> setting or incorrect setting of OLED brightness. 

Thanks for the extensive testings. I'll send the "OLED patch that's not
on the list yet" as a 11/10 so everybody can have a look.

Cheers,
Benjamin
