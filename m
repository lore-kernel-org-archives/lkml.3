Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbaGYOyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbaGYOyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:54:33 -0400
Date: Fri, 25 Jul 2014 10:54:00 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Input - wacom: conversion to HID driver, series
 2
Message-ID: <20140725145400.GB12268@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406292140.2664.17.camel@fedora-lan>
 <20140725125820.GA12268@mail.corp.redhat.com>
 <1406295035.2664.43.camel@fedora-lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406295035.2664.43.camel@fedora-lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> Dnia 2014-07-25, pią o godzinie 08:58 -0400, Benjamin Tissoires pisze:
> > Hi Przemo,
> Hi Benjamin,
> > On Jul 25 2014 or thereabouts, Przemo Firszt wrote:
> > > Dnia 2014-07-24, czw o godzinie 14:13 -0400, Benjamin Tissoires pisze:
> > > [..]
> > > > Hi Przemo,
> > > Hi Benjamin,
> > > > Normally, this series contains all the bits of hid-wacom (except the custom
> > > > LED/OLED API). Please tell me if I am missing anything and if you like the
> > > > change.
> > > 
> > > I can't cleanly apply your set yet to test it, so:
> > 
> > Hmm, you need to apply the first series I sent on July 15th, on top of
> > Dmitry's next branch.
> > 
> > http://www.spinics.net/lists/linux-input/msg32385.html
> > 
> OK, thnaks!
> > > Acked-by: Przemo Firszt <przemo@firszt.eu>
> > 
> > Thanks!
> > 
> > > 
> > > What's your plan about LED/OLED API? 
> > 
> > I thought I would only preserve the current, wider used, LED/OLED API and
> > just drop the one in hid-wacom. This way, g-s-d will access both
> > bluetooth and USB the same way.
> > 
> > My decision was mostly guided because the support of BT in g-s-d was
> > only added recently (3.12 and backported to gnome 3.10 IIRC). And as
> > soon as these patches hit Dmitry's tree, I'll send the g-s-d patches to
> > fix all that.
> 
> If I understand you correctly we cannot have the same entry point in
> sysfs for OLEDs unless we can tell userspace somehow if the tablet is
> conected over USB or over bluetooth. The hardware of Intuos4 Wireless
> over bluetooth allows only 1-bit images. The same hardware over USB
> allows 4-bit images. Formatting of the images is also completely

Holy crap! I missed that. I did not noticed the 1-bit vs 4-bits
difference :(

> different and it's not "plain". Check [1] for usb and exisitng
> hid-wacom.c/wacom_scramble function for bluetooth.

Maybe I overlooked it, but I thought that in case of USB, the scrambling
is done in user space, and in case of BT, the same scrambling made in the
kernel. They looks very similar so I thought the user-space scramble for
USB would have fit. However, the 4-bits/1-bits kills that assumption.

> 
> If we want to make it consistent single entry on kernel level we
> probably have to implement image conversion in the kernel. The user land
> would always use 4-bit, plain formatted images and kernel driver would
> convert them to 4-bit, wacom usb format or 1-bit wacom bluetooth format
> depending on how the tablet is connected.
> 
> The downside of this approach is that the user land wouldn't have 100%
> control over 1-bit images for bluetooth as kernel would have to create
> them from 4-bit images.

The USB interface is *very* simple:
- if incoming data != 1024 -> reject
- forward everything to the device without in kernel treatment*

How about just changing the expected size to 256 in case of a BT tablet,
and let the user-space scramble in both cases and forward proper raw
data?

This way, user space will still have control over 1-bit vs 4-bits, and
the changes required in the kernel will be small enough.

My concern is that I'd like to have this series in 3.17 and I will not
have access to the hardware until next week :/
Having all of the user-spaces breakages in the same kernel release will
I think simplify the user space work.

Cheers,
Benjamin

* speaking about that: I just noticed that hid-wacom sent the
  WAC_CMD_ICON_START_STOP message twice with 0 as the second parameter.
  However, the USB spec tells that you have to use 1 for 'start' and 0
  for 'stop'. Rather weird that this is working with both 0 in BT mode.

> 
> [1] https://lkml.org/lkml/2012/9/9/80
> -- 
> Kind regards,
> Przemo Firszt
> 
> 
