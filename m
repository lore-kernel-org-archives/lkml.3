Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375Ab3HORzW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:55:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42298 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753338Ab3HORzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:55:20 -0400
Date: Thu, 15 Aug 2013 13:55:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mark Brown <broonie@kernel.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
In-Reply-To: <20130815171048.GC30073@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308151335310.905-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013, Mark Brown wrote:

> On Thu, Aug 15, 2013 at 10:42:00AM -0400, Alan Stern wrote:
> > On Thu, 15 Aug 2013, Mark Brown wrote:
> 
> > So why not bring the device to full power as soon as possible during
> > boot, and have it registered on the bus in the usual way?  Once that's
> > done, the ordinary runtime PM mechanism will allow the device to go
> > back off-line.
> 
> That could be done, and is likely to happen anyway as a result of device
> initialisation.  I'm not sure it buys much to force it to happen
> immediately, though.

Not necessarily immediately, then.  Let's say at the time when you
would have wanted to tell the bus about the device's existence, even
though it hadn't yet been detected.

> There's a big difference between random glue outside the drivers and
> something the drivers know about themselves, it's important to be clear
> on this.  Bodges for this often involve writing a bit of board code that
> the drivers don't know anything about.

Of course.  Glue outside of drivers is very significant, whether that 
glue takes the form of code or data.

> > I imagine that teaching a subsystem to know about a device before it 
> > has been detected would require significant changes.  My suggestion -- 
> > powering up the device, detecting it, and then powering it back down -- 
> > fits in very cleanly with existing designs and would require 
> > comparatively little work.  Case B then becomes unnecessary; all the 
> > important stuff will be handled under Case C.
> 
> To be honest I don't see how that helps much if you're going to handle
> the case where platform data is required to enumerate the device.  You
> need to know about the device prior to enumeration in order to get the
> platform data to the driver when it does enumerate and you can't
> enumerate it until you do that anyway.

You're a little imprecise here.  Which driver do you mean?  The driver
that will ultimately bind to the device, or the driver that will
discover and enumerate it (which generally is bound to the device's
upstream parent)?  I'll assume the latter.

Under what circumstances is platform data required to enumerate a
device on a discoverable bus?  We're assuming the platform has already
taken care of everything required to make the device appear on the bus
in the usual manner (such as bringing it to full power).  Can you give
an example where something more is needed?

(Were you thinking of the case where the device's IRQ signal doesn't go
over the bus but uses a different platform mechanism?  I don't quite 
see how this can work.  What about devices on the bus that aren't known 
to the platform beforehand?  How do they send their IRQ signals?)

>  A bus could insist on this if it
> needed the information from enumeration for some reason but really it
> seems like an implementation detail.

It isn't an implementation detail.  The "power-up for initial
detection" scheme is a general solution to the problem of setting up a
complicated communication path between the bus and the platform.  
(I.e., it gives a simple way to avoid the need for this communication,
that can be used on any discoverable bus.)  It also is a general 
solution for avoiding the problem of registering a device on a bus 
before that device has been discovered and enumerated.

Alan Stern

