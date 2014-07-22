Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaGVNtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:49:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaGVNto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:49:44 -0400
Date: Tue, 22 Jul 2014 09:49:23 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/5] Input - wacom: battery enhancements and unifying
 hid-wacom and wacom
Message-ID: <20140722134923.GA357@mail.corp.redhat.com>
References: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
 <1405804548.13990.7.camel@fedora-lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405804548.13990.7.camel@fedora-lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Jul 19 2014 or thereabouts, Przemo Firszt wrote:
> Dnia 2014-07-10, czw o godzinie 14:44 -0400, Benjamin Tissoires pisze:
> > Hi guys,
> > 
> > Continuing on the Wacom cleanup, here are 5 patches.
> > 
> > The first two enhance the battery reporting for the Wireless receiver by
> > adding the status of the battery (discharging, full, charging) - inspired by
> > the code found in hid-wacom.c, and also by adding notifications to the power
> > system so that upower knows when the battery changed.
> > 
> > The last three are the handling of the two Wacom Bluetooth devices in wacom.ko.
> > Some enhancements here:
> > - Intuos4 now supports other tools than just the plain stylus (mouse, artpen, ...)
> > - one less driver for Wacom (~700 lines of code less in total)
> > - unifying access to LEDs/OLEDs from Bluetooth and USB devices
> > 
> > However, I did not backport the speed attribute and the ac power device (which
> > is infered by the battery status). I don't know if there are users of those two,
> > so I let them aside for now. Przemo, any ideas if this is actually used?
> > 
> > This whole code is based on top of the previous HID conversion patches.
> > I pushed a branch with all I have queued on the list here:
> > https://github.com/bentiss/linux/commits/hid-wacom-legacy-3.16-rc4
> > 
> > Again, given that there has been no answer on how this can be merged upstream
> > (Jiri? Dmitry?), I just piled those on top of the previous.
> > I wouldn't to resplit the input and hid specific changes if this is the choice
> > that is made.
> > 
> > Cheers,
> > Benjamin
> > 
> > Benjamin Tissoires (5):
> >   Input - wacom: enhance Wireless Receiver battery reporting
> >   Input - wacom: use a specific name for the battery device
> >   Input - wacom: handle Graphire BT tablets in wacom.ko
> >   Input - wacom: handle Intuos 4 BT in wacom.ko
> >   HID: remove hid-wacom Bluetooth driver
> > 
> >  drivers/hid/Kconfig              |   8 -
> >  drivers/hid/Makefile             |   1 -
> >  drivers/hid/hid-core.c           |   2 -
> >  drivers/hid/hid-wacom.c          | 973 ---------------------------------------
> >  drivers/input/tablet/wacom.h     |   6 +
> >  drivers/input/tablet/wacom_sys.c | 114 ++++-
> >  drivers/input/tablet/wacom_wac.c | 189 +++++++-
> >  drivers/input/tablet/wacom_wac.h |   8 +
> >  8 files changed, 303 insertions(+), 998 deletions(-)
> >  delete mode 100644 drivers/hid/hid-wacom.c
> > 
> Benjamin,
> I think we might try to fix that [1] as well when making changes to the
> sysfs entries. Currently every tablet connected wirelessly will trigger
> creating new sysfs entries:
> 
> /sys/class/power_supply/wacom_ac
> /sys/class/power_supply/wacom_battery
> 
> so sysfs is not happy about attempts to create duplicates. We need to
> distinguish between devices using consecutive numbers or something else.
> 
> [1] https://sourceforge.net/p/linuxwacom/bugs/248/

Right. In this first attempt, I tried to change "wacom_" by the actual
name of the tablet. I would thought it was OK because no one will ever
try to plug the same model twice. I was wrong, and a counter seem to be
the solution for that. I'll address that in the v2.

Also note that the bug is both in the current USB driver (wacom.ko) and
the bluetooth one (hid-wacom.ko). Merging these two drivers will prevent
us to have to do this fix twice :)

Just as a head up, I will not be able to work on this patch series
before Thursday (I mean testing with actual hardware). I'd be happy if
we can manage to push that in 3.17, but this will mostly depend if
Dmitry is fine with the USB-to-HID conversion of the wacom.ko driver.

Cheers,
Benjamin
