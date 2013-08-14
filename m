Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab3HNTjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:39:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45649 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760012Ab3HNTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:39:21 -0400
Date: Wed, 14 Aug 2013 15:39:20 -0400 (EDT)
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
In-Reply-To: <20130814184643.GL2401@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308141514440.1701-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Aug 2013, Mark Brown wrote:

> On Wed, Aug 14, 2013 at 02:35:07PM -0400, Alan Stern wrote:
> > On Wed, 14 Aug 2013, Mark Brown wrote:
> 
> > > What I'm proposing is that we have a way of telling buses that devices
> > > exist via a mechanism other than their actually being visible on the bus
> > > at the current time.  If you're doing that the driver can be running
> > > prior to the hardware being there, just like it does with all the
> > > non-enumerable buses.
> 
> > This may work for other buses, but it isn't feasible for USB.  Not only
> > do many of the drivers need to communicate with their device during
> > their probe routine, the subsystem itself needs to communicate with the
> > device before many of the important data structures can be constructed.  
> > Without these structures, the device can't be bound to a driver.  We 
> > wouldn't even know which driver to bind it to!
> 
> The identification information for the device would of course have to be
> provided as part of registering that the device was going to appear -
> I'd expect to provide the same information that's read out of the
> hardware during enumeration, with enumeration checking to see if it
> knows about the device already.

I don't see the point of all this.  Obviously the device can't be used
until it physically appears on the bus.  What benefit do you get from
registering it and making it available to userspace before that?

> > My impression is that much of what you want could be handled by a
> > platform callback invoked when a particular bus -- i.e., one whose
> > upstream controller is a particular platform device -- is registered.  
> > Is that correct?  For example, in the USB case, the on-board hub's
> > GPIOs could be set when the USB bus is registered (or perhaps when the
> > bus's root hub is registered).
> 
> That sort of bodge is probably adequate for basic "power this on" stuff
> but it's not going to scale to a general solution, especially where the
> driver wants to use some of the information at runtime.  Currently
> systems are doing things like bodging callbacks into controller drivers
> which is basically what you're talking about here.

Well, basic "power this on" stuff is pretty much all we have discussed 
in this thread so far.  What other sorts of things are going to be 
needed for a general solution?

> > > It means that there are situations where a driver wants to take the
> > > hardware offline but still offer services to userspace which will
> > > require the hardware to be brought on line again.  The fact that this is
> > > a very generic thing is exactly why I'm raising this as a generic issue.
> 
> > This is a separate issue, more or less independent of whether the
> > platform needs to carry out special actions for the device in question.  
> > If you're suggesting these off-line/on-line transitions are appropriate
> > places for a platform hook, then yes, that makes sense.
> 
> I think in the general case it's the same issue - grab all the resources
> and enable them at probe time is the simplest implementation but it's
> not the only one by a long stretch.

Now I'm getting confused.  It seems we're talking about at least three
very different things here:

     A: Devising a mechanism for platform code to do things involving
	devices that are dynamically registered on discoverable buses.

     B: Telling the subsystem and driver code for a discoverable bus
	that a particular device is present before it has been 
	detected.

     C: Implementing a mechanism whereby drivers can take a device
	off-line while still pretending to userspace that the device
	is still present, by bringing it back on-line as needed.

I don't see much connection between these things.  Perhaps you can
explain in more detail.

(BTW, it's worth mentioning that C has already been done, in the form
of runtime PM.  The difference may be that you propose to take the
device so far off-line that it disappears from the bus.  AFAICS, this
would be purely a private matter to be arranged between the subsystem
and the driver; it does not need to be handled at the level of the
device-model or PM core.)

Alan Stern

