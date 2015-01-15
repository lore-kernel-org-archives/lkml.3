Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbbAOLaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:30:07 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:45954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbbAOLaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:30:05 -0500
Date: Thu, 15 Jan 2015 11:29:53 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Felipe Tonello <eu@felipetonello.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] char: Added support for u-blox 6 i2c gps driver
Message-ID: <20150115112953.27cc5934@lxorguk.ukuu.org.uk>
In-Reply-To: <CAGrhNMysmq==Y0naNki0z5usmMwUErj-FOTy=8KH0V=R7=VFwA@mail.gmail.com>
References: <1421198202-4042-1-git-send-email-eu@felipetonello.com>
	<20150114154816.58b0f9c7@lxorguk.ukuu.org.uk>
	<CAGrhNMysmq==Y0naNki0z5usmMwUErj-FOTy=8KH0V=R7=VFwA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which kernel did you see the write_room oops ? and I'll double check its
all fixed.

> >> +     ublox_gps_i2c_client = client;
> >> +     ublox_gps_filp = NULL;
> >> +     ublox_gps_tty_port = NULL;
> >> +     ublox_gps_is_open = false;
> >
> > There are some other i2c based tty drivers in the kernel - notably those
> > in drivers/tty/serial that use the uart layer to deal with most of the
> > awkward locking cases.
> >
> > You can do it by hand but it's fairly hairy (see
> > drivers/mmc/card/sdio_uart.c, so it might be simplest to tweak the driver
> > to use the uart layer. You don't really gain much from it for your driver
> > except easier locking - but the locking is rather handy.
> >
> > Alan
> 
> Ok.
> 
> The thing is that: I wrote this driver to work with only one gps
> module, because that's my configuration here. I cannot really test
> multiple i2c gps at the same time. If you guys really want a driver
> that works for multiple gps drivers, I cannot test it.

It isn't just about multiple GPS devices, it's about locking. What stops
things being unloaded or reloaded and freeing memory you are still using.
Things happen in parallel. If you have an i2c hot unplug happen as
you are running your worker thread for example this would occur

	Device still plugged in
               if (!ublox_gps_i2c_client)
	       {False so we continue}
	Device unplugged
               Use ublock_gps_i2c_client
               *Kaboom*

There are two ways to deal with that

1. Don't free the resources until the device is not being used (so while
the hardware may have walked the memory and pointers are still valid)

2. take a lock before checking, drop it after you finish using the
object. Take the same lock when destroying it.

The kernel mostly does #1, in part because the second case tends to be
hard to get right and avoid deadlocks.

I'm much less worried about the single device parts of it. The static
values you have are fairly easy to deal with I think

ublox_gps_filp isn't needed (its only used for bogus tests)
ublox_gps_is_open isn't needed (it's only used for the open test)

ublox_gps_i2c_client belongs as a pointer in your tty_data
ublox_gps_tty_port belongs as the client pointer in your i2c

