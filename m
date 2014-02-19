Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaBSAsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:48:11 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60468 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaBSAsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:48:09 -0500
Date: Wed, 19 Feb 2014 00:47:36 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
 device probe
Message-ID: <20140219004736.65beeb08@alan.etchedpixels.co.uk>
In-Reply-To: <20140214001436.GA16287@kroah.com>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-3-git-send-email-tushar.behera@linaro.org>
	<20140120100415.GX15937@n2100.arm.linux.org.uk>
	<20140213181216.GB24155@kroah.com>
	<20140213181559.GB30257@n2100.arm.linux.org.uk>
	<20140213182701.GA32578@kroah.com>
	<20140213184249.GC30257@n2100.arm.linux.org.uk>
	<20140213232606.GA27372@kroah.com>
	<20140214000717.GG30257@n2100.arm.linux.org.uk>
	<20140214001436.GA16287@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The race isn't the uart code, it's the driver model.
> > 
> > Consider what happens when this happens:
> > 
> > * Two pl011 devices get registered at the same time by two different
> >   threads.
> 
> How?  What two different busses will see this same device?  The amba bus
> code should prevent that from happening, right?  If not, there's bigger
> problems in that bus code :)
> 
> That's where this problem should be fixed, if there is one, otherwise
> this same issue would be there for any type of driver that calles into
> the uart core, right?

I did some more digging into this the problem goes beyond the uart and
driver model code. Even if you serialize every bus and you serialize
every bus against every other bus (which you can't do btw as we get
recursive probes of one bus from a device probe of another) it's still
racy. We have non bus registering paths for some drivers and those could
be user triggered.

An obvious example is 8250.

If the 8250 driver is loaded on a platform where no device is
autodetected (which is true on a few wackier PC laptops with touchscreens
on an 8250) then you hae a race between say a PCMCIA card insertion of an
8250 and a user who creates the first 8250 device using setserial at the
same moment.

There are similar races between the various directly created devices on
some of the serial ports and bus probed ones where the driver mixes bus
probing with olde worlde straight forward hardcoding.

Alan
