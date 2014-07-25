Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaGYWNl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 18:13:41 -0400
Received: from si-002-i51.relay.mailchannels.net ([184.154.112.225]:10920 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751953AbaGYWNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 18:13:40 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406326412.4674.22.camel@fedora-lan>
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver,
 series 2
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Fri, 25 Jul 2014 23:13:32 +0100
In-Reply-To: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
[..]
Hi Benjamin,
I'm testing the whole series including the OLED patch that's not on the
list yet.

Hardware: 2 x Intuos4 Wireless tested on usb and bluetooth until noted
otherwise.

What works:
1. Tablet in general, pressure, tilt, buttons etc.
2. Battery reporting (including gnome). The double wireless tablet bug
is gone:

$ ls /sys/class/power_supply/
AC  BAT0  wacom_ac_2  wacom_ac_3  wacom_battery_2  wacom_battery_3

3. Setting LED selector value
4. Setting LED selector brightness (default and pressed)
5. Rendering images to button displays works on usb ONLY.

$ i4oled -d /sys/bus/hid/drivers/wacom/0003\:056A\:00BC.0009/wacom_led/button0_rawimg -t Linux

On bluetooth writing image goes fine (no error), but there is nothing showing up,
so I suspect the brightness of OLED displays is not set properly.

That's the code before changes:

        led = wdata->led_selector | 0x04;
        buf = kzalloc(9, GFP_KERNEL);
        if (buf) {
                buf[0] = WAC_CMD_LED_CONTROL;
                buf[1] = led;
                buf[2] = value >> 2;
                buf[3] = value;
                /* use fixed brightness for OLEDs */
                buf[4] = 0x08;
                hid_hw_raw_request(hdev, buf[0], buf, 9, HID_FEATURE_REPORT,
                                   HID_REQ_SET_REPORT);
                kfree(buf);
        }

I don't remember for sure, but I think the range of brightness might be different
over usb and over bluetooth.

TL;DR: the only thing that needs to be fixed is image-over-bluetooth, probably caused by not
setting or incorrect setting of OLED brightness. 

-- 
Kind regards,
Przemo Firszt


