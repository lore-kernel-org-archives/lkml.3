Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760385Ab3HNSfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:35:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45613 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760365Ab3HNSfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:35:08 -0400
Date: Wed, 14 Aug 2013 14:35:07 -0400 (EDT)
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
In-Reply-To: <20130814173028.GB2401@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308141410190.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Mark Brown wrote:

> On Wed, Aug 14, 2013 at 12:14:06PM -0400, Alan Stern wrote:
> > On Wed, 14 Aug 2013, Mark Brown wrote:
> 
> > > Yes, so you'd want callbacks when the device actually appears and
> > > disappears.
> 
> > No, no -- this is exactly the point I was trying to make.  The on-board
> > hub _won't_ appear on the USB bus until the GPIOs are set.  Therefore
> > the callback to set the GPIOs needs to be at a different place, not
> > when the device appears.
> 
> What I'm proposing is that we have a way of telling buses that devices
> exist via a mechanism other than their actually being visible on the bus
> at the current time.  If you're doing that the driver can be running
> prior to the hardware being there, just like it does with all the
> non-enumerable buses.

This may work for other buses, but it isn't feasible for USB.  Not only
do many of the drivers need to communicate with their device during
their probe routine, the subsystem itself needs to communicate with the
device before many of the important data structures can be constructed.  
Without these structures, the device can't be bound to a driver.  We 
wouldn't even know which driver to bind it to!

My impression is that much of what you want could be handled by a
platform callback invoked when a particular bus -- i.e., one whose
upstream controller is a particular platform device -- is registered.  
Is that correct?  For example, in the USB case, the on-board hub's
GPIOs could be set when the USB bus is registered (or perhaps when the
bus's root hub is registered).

> It means that there are situations where a driver wants to take the
> hardware offline but still offer services to userspace which will
> require the hardware to be brought on line again.  The fact that this is
> a very generic thing is exactly why I'm raising this as a generic issue.

This is a separate issue, more or less independent of whether the
platform needs to carry out special actions for the device in question.  
If you're suggesting these off-line/on-line transitions are appropriate
places for a platform hook, then yes, that makes sense.

Alan Stern

