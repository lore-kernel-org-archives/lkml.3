Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaIBIqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:46:01 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:60100 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaIBIp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140902080010.GD17117@lee--X1>
References: <1409349654-24841-2-git-send-email-octavian.purdila@intel.com>
	<20140901083744.GE7374@lee--X1>
	<CAE1zotK0cddns4f4ay-GJie8O2pjb72+-yYndZvW0hbF0D83HA@mail.gmail.com>
	<20140901095127.GK7374@lee--X1>
	<CAE1zot+T6eq0jrL6_Qh=5nihNOgGEaWe5RCDk7_1XS8ZWaWKqA@mail.gmail.com>
	<20140901113949.GP7374@lee--X1>
	<CAE1zotKNBTEMX8DDYwdwOcq0qZgqxZWazE60TUQeiOmD0a4xbA@mail.gmail.com>
	<20140901154626.GH8796@lee--X1>
	<CAE1zotL-cjHqrdymzYhZq24zx+0qGY8-4JnrVZf-TGXDf5Sm3w@mail.gmail.com>
	<20140901175453.GR4894@localhost>
	<20140902080010.GD17117@lee--X1>
Date: Tue, 2 Sep 2014 11:45:55 +0300
Message-ID: <CAE1zotJzFL0bZvNo4mHK3+EhURarhTPDE5n+SdNzof8Nc-CFew@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mfd: add support for Diolan DLN-2 devices
From: Octavian Purdila <octavian.purdila@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 11:00 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Mon, 01 Sep 2014, Johan Hovold wrote:
>> On Mon, Sep 01, 2014 at 07:22:39PM +0300, Octavian Purdila wrote:
>> > On Mon, Sep 1, 2014 at 6:46 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> > > On Mon, 01 Sep 2014, Octavian Purdila wrote:
>> > >
>> > >> On Mon, Sep 1, 2014 at 2:39 PM, Lee Jones <lee.jones@linaro.org> wrote:
>> > >> > On Mon, 01 Sep 2014, Octavian Purdila wrote:
>> > >> >> On Mon, Sep 1, 2014 at 12:51 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > >> >> > You should have a small MFD driver which controls resources and
>> > >> >> > registers children.  All other functionality should live in their
>> > >> >> > respective drivers/X locations i.e. USB functionallity should normally
>> > >> >> > live in drivers/usb.
>> > >> >> >
>> > >> >>
>> > >> >> OK, that sounds better. I am not sure how to handle the registration
>> > >> >> part though, since in this case we need to create the children at
>> > >> >> runtime, from the usb probe routine.
>> > >> >>
>> > >> >> The only solution I see is to move the driver completely to
>> > >> >> usb/drivers and continue to use the MFD infrastructure. Does that
>> > >> >> sound OK to you?
>> > >> >
>> > >> > I have no problem with that.  If this is an MFD driver, it _should_
>> > >> > live in drivers/mfd.  However, all of that USB specific stuff
>> > >> > defiantly should not.
>> > >> >
>> > >> > >> It is a multi-function driver which is using the USB interface, so I
>> > >> am not sure where it belongs. The only driver that calls
>> > >> mfd_add_devices and is not in drivers/mfd is the hid sensor hub
>> > >> driver.
>> > >>
>> > >> BTW, the mfd/viperboard.c driver is very similar with this driver. It
>> > >> has less USB specific stuff because the protocol is simpler, but still
>> > >> has some.
>> > >
>> > > Looking at viperboard.c, it seems to use some basic generic framework
>> > > calls to obtain some information about the device information like
>> > > version numbers.  Your driver is leaps and bounds more USB centric.
>> > >
>> > > Your MFD driver should know about things like; regmap, platform data,
>> > > memory allocation, same-chip devices (children), etc.  Your MFD driver
>> > > should not need to concern itself with; endpoints, slots, URBs, USB
>> > > device IDs and the like.  The later knowledge belongs in drivers/usb.
>> > >
>> > > You should be calling mfd_add_devices() from within the MFD driver.
>> > > At a guess, I would say that you need a new entry for the USB stuff in
>> > > your mfd_cells structure.
>> > >
>> >
>> > Makes sense, thanks for making clearing up what the MFD part of the
>> > driver should do.
>> >
>> > Here is how I think it could work:
>> >
>> >  * keep the usb probe routine in the MFD driver (and keep it a usb driver)
>> >
>> >  * add a new cell for the usb part
>> >
>> >  * pass the usb_interface via platform_data to the USB sub-driver's
>> > platform_device probe routine and continue the USB setup there
>> >
>> > Lee, USB folks, is this acceptable?
>>
>> No, no. USB is not a function of the MFD device, it's the transport.
>> Thus there should be no USB MFD-cell. No subdriver can work without it.
>>
>> And the USB id belongs in the MFD-driver in the same way that an
>> i2c id (address) does.
>>
>> Just like an MFD device with i2c as a transport, this driver would
>> function as an arbiter to a shared resource (i.e. the register space).
>> The reason it seems much more USB-centric than an i2c-mfd driver is that
>> that transport API is simpler and some code have also already been
>> generalised (e.g. regmap), whereas we appear to have only two USB
>> mfd-drivers thus far.
>>
>> The viperboard is perhaps a bad example in so far that it has pushed the
>> transport details down into the subdrivers (and thus into gpio, i2c and
>> iio subsystems) instead of handling it one place.
>
> Thanks for your explanation.  I take your point about the USB ID and I
> did say I was guessing that the USB part should exist as a child
> device.
>
> So after your comments I decided to do a little investigation.  It
> appears that this MFD driver is _just_ using the common API which all
> other devices utilising USB comms are forced to use.  Is that correct?
>
> If so, I have a question.  Is there no way to hide more of the USB
> specifics inside a better, simpler API?  It looks like the drivers
> which use USB are subjected to a lot (too much) of what might be
> considered internals.  Or is it just that the client has to tinker
> with too many dials to get anything sensible out? *shudders*
>

Yes, the driver is just using the common USB API to communicate with
the device.

It is more complicated then the average USB driver because there is a
single interface and a single receive endpoint which needs to serve
multiple drivers and requests, thus the need to multiplex the
communication.

>> I haven't looked at the details of the protocol for the device in
>> question, but it might even be possible to use regmap here (as I
>> mentioned in my comments on v1).
>
> Obviously that would be preferred.
>
> Octavian, did you look into that?
>

Yes, I did. Since this is the first time I am looking at regmap I may
be wrong but I don't see a way to use it. The dln2 i2c driver needs to
be able to send and receive arbitrary size buffers and this does not
seem possible to do with the regmap API.

(Also creating a regmap class for a particular device seems over
engineering since nobody else is going to use it)
