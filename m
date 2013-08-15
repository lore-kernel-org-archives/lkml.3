Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3HOOmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:42:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54775 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757776Ab3HOOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:42:02 -0400
Date: Thu, 15 Aug 2013 10:42:00 -0400 (EDT)
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
In-Reply-To: <20130814235519.GS2401@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308151013350.1210-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013, Mark Brown wrote:

> On Wed, Aug 14, 2013 at 03:39:20PM -0400, Alan Stern wrote:
> 
> > I don't see the point of all this.  Obviously the device can't be used
> > until it physically appears on the bus.  What benefit do you get from
> > registering it and making it available to userspace before that?
> 
> Two things.  One is that some devices have the ability to perform useful
> functions when powered down sufficiently that they can't run a complex
> bus, providing notification when they need to wake up (or being woken up
> if the power on comes from userspace).  The other is that then userspace
> can just see the device and start using it when it needs it without
> having to have a mechanism to discover that there's something there with
> manual power control.
> 
> This can also be an issue in cases where we compose multiple physical
> devices into composite ones for userspace (embedded audio and video do
> this a lot for example).  A given bit of hardware may only be useful in
> some circumstances.
> 
> > Well, basic "power this on" stuff is pretty much all we have discussed 
> > in this thread so far.  What other sorts of things are going to be 
> > needed for a general solution?
> 
> If you look elsewhere at the stuff I've been saying about Slimbus that's
> the nastiest case I'm aware of in terms of the bus itself - that's got
> the devices with low power modes that do useful things with the device
> (and bus) mostly powered off and things like that.  Things like activity
> detection of various kinds where the device is monitoring for activity
> in a low power state.

Okay.  Previously we agreed that a device on one of these buses could
remain off-line except when the system needs to bring it to full power.  
To me, discovery and enumeration on the bus seem like a legitimate 
need.

So why not bring the device to full power as soon as possible during
boot, and have it registered on the bus in the usual way?  Once that's
done, the ordinary runtime PM mechanism will allow the device to go
back off-line.

> I've also mentioned the devices that need platform data which is a part
> of this too; one reason for knowing that the device is there before it
> appears is so that we can pass platform data/DT/whatever to it.

Can you pass this "whatever" data to the device as part of the initial 
bring-it-to-full-power procedure?

By the way, you mentioned something earlier that some of this platform
data might duplicate information that could be discovered through the
usual bus probing mechanisms (for example, USB descriptors).  IMO
that's a bad idea.  Not only is it wasteful, it also has the potential
for causing confusion if the two sets of data should disagree for any
reason.  When possible, it's always better to get info about the 
hardware from the hardware itself.

> > Now I'm getting confused.  It seems we're talking about at least three
> > very different things here:
> 
> >      A: Devising a mechanism for platform code to do things involving
> > 	devices that are dynamically registered on discoverable buses.
> 
> If we need random platform code then we're failing, half the point of
> things like DT and ACPI is to avoid writing random board code.  we do
> want to pass data to devices for their drivers to use but having to have
> random bits of per board code would be really sad.

At the level of abstraction in this discussion, there's no need to 
discriminate between code and data.  Just imagine that I simply wrote 
"platform", meaning platform code and/or data.

> >      B: Telling the subsystem and driver code for a discoverable bus
> > 	that a particular device is present before it has been 
> > 	detected.
> 
> >      C: Implementing a mechanism whereby drivers can take a device
> > 	off-line while still pretending to userspace that the device
> > 	is still present, by bringing it back on-line as needed.
> 
> > I don't see much connection between these things.  Perhaps you can
> > explain in more detail.
> 
> I think the solutions for these overlap so much they're the same thing.
> The situation we're in in in your case B is just the idle case for
> condition C - if we know about the device before it's been detected then
> if it's been removed we just go back into the situation where we know
> about it but it isn't powered.

I imagine that teaching a subsystem to know about a device before it 
has been detected would require significant changes.  My suggestion -- 
powering up the device, detecting it, and then powering it back down -- 
fits in very cleanly with existing designs and would require 
comparatively little work.  Case B then becomes unnecessary; all the 
important stuff will be handled under Case C.

> > (BTW, it's worth mentioning that C has already been done, in the form
> > of runtime PM.  The difference may be that you propose to take the
> > device so far off-line that it disappears from the bus.  AFAICS, this
> > would be purely a private matter to be arranged between the subsystem
> > and the driver; it does not need to be handled at the level of the
> > device-model or PM core.)
> 
> Actually runtime PM is actually already used for completely offlining
> devices on buses that are too blind to notice - it's only an issue on
> buses that can notice insertion and removal and want to do something
> about it.  The use cases I'm describing already happen in mainline today
> for devices on the dumber buses.

Which means eliminating case B will be all that much easier for these 
buses.

> I think if we've got something which the hardware engineers can do on
> multiple buses then they probably will so we should have at least a
> pattern for how it's going to work over multiple buses rather than
> having to handle different models for different buses.  I'll try to have
> a think about what that pattern might be at some point (in my copious
> free time).

There's one important factor to keep in mind: Are devices on the bus
physically removable?  If not, the situation is pretty straightforward.  
You just remember that the device used to be present, and reuse the old
data structures when it reappears.

If devices are removable then things are a lot more complicated.  The 
usb-storage driver used to do what you are talking about, back in the 
days of the 2.4 kernels.  When a mass-storage device was unplugged, 
the driver would remember it and reuse the data structures when the 
device was plugged back in and reprobed.  Linus himself told us this 
was a mistake, so we removed the feature.

The USB subsystem now supports this feature in a very limited form.  
If the hardware session gets dropped while the computer is suspended,
then at resume time the system will try to verify that the device
present at that bus address is the same device that was there before
the suspend.  If it is, we will continue to use it as if the connection
had never dropped.

Alan Stern

