Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIBPI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:08:57 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:49299 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaIBPIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:08:54 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 2 Sep 2014 17:07:33 +0200
From: Johan Hovold <johan@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Johan Hovold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Subject: Re: [PATCH v2 1/3] mfd: add support for Diolan DLN-2 devices
Message-ID: <20140902150733.GX4894@localhost>
References: <20140901083744.GE7374@lee--X1>
 <CAE1zotK0cddns4f4ay-GJie8O2pjb72+-yYndZvW0hbF0D83HA@mail.gmail.com>
 <20140901095127.GK7374@lee--X1>
 <CAE1zot+T6eq0jrL6_Qh=5nihNOgGEaWe5RCDk7_1XS8ZWaWKqA@mail.gmail.com>
 <20140901113949.GP7374@lee--X1>
 <CAE1zotKNBTEMX8DDYwdwOcq0qZgqxZWazE60TUQeiOmD0a4xbA@mail.gmail.com>
 <20140901154626.GH8796@lee--X1>
 <CAE1zotL-cjHqrdymzYhZq24zx+0qGY8-4JnrVZf-TGXDf5Sm3w@mail.gmail.com>
 <20140901175453.GR4894@localhost>
 <20140902080010.GD17117@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902080010.GD17117@lee--X1>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 09:00:10AM +0100, Lee Jones wrote:
> On Mon, 01 Sep 2014, Johan Hovold wrote:

> > No, no. USB is not a function of the MFD device, it's the transport.
> > Thus there should be no USB MFD-cell. No subdriver can work without it.
> > 
> > And the USB id belongs in the MFD-driver in the same way that an
> > i2c id (address) does.
> > 
> > Just like an MFD device with i2c as a transport, this driver would
> > function as an arbiter to a shared resource (i.e. the register space).
> > The reason it seems much more USB-centric than an i2c-mfd driver is that
> > that transport API is simpler and some code have also already been
> > generalised (e.g. regmap), whereas we appear to have only two USB
> > mfd-drivers thus far.
> > 
> > The viperboard is perhaps a bad example in so far that it has pushed the
> > transport details down into the subdrivers (and thus into gpio, i2c and
> > iio subsystems) instead of handling it one place.
> 
> Thanks for your explanation.  I take your point about the USB ID and I
> did say I was guessing that the USB part should exist as a child
> device.
> 
> So after your comments I decided to do a little investigation.  It
> appears that this MFD driver is _just_ using the common API which all
> other devices utilising USB comms are forced to use.  Is that correct?

Yes, it's using the low-level USB API, but there's a lot of higher-level
interfaces in place for (fairly) standard things such as the USB class
drivers or the USB serial subsystem.

> If so, I have a question.  Is there no way to hide more of the USB
> specifics inside a better, simpler API?  It looks like the drivers
> which use USB are subjected to a lot (too much) of what might be
> considered internals.  Or is it just that the client has to tinker
> with too many dials to get anything sensible out? *shudders*

Unfortunately, anything that does not already have a driver is likely to
use some vendor-specific protocol and therefore must use the low-level
API.

> > I haven't looked at the details of the protocol for the device in
> > question, but it might even be possible to use regmap here (as I
> > mentioned in my comments on v1).
> 
> Obviously that would be preferred.

Simple register-based USB MFD devices (e.g. only using control
transfers) are conceivable though, and if we start seeing a lot of those
(which I doubt) perhaps that part could be refactored as a regmap bus.

Johan
