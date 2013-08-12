Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab3HLUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:50:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3HLUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:50:08 -0400
Date: Mon, 12 Aug 2013 13:50:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Non-enumerable devices on USB and other enumerable buses
Message-ID: <20130812205007.GA5822@kroah.com>
References: <20130811190826.GH6427@sirena.org.uk>
 <20130812020257.GA7028@kroah.com>
 <20130812112344.GS6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812112344.GS6427@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 12:23:44PM +0100, Mark Brown wrote:
> On Sun, Aug 11, 2013 at 07:02:57PM -0700, Greg Kroah-Hartman wrote:
> > On Sun, Aug 11, 2013 at 08:08:26PM +0100, Mark Brown wrote:
> 
> > > I know there's been some discussion of this topic but do we have any
> > > general consensus on how to handle such things both from a Linux driver
> > > model point of view and from a DT/ACPI point of view?
> 
> > As these are usually bus-specific things, and really, platform-specific
> 
> I don't think they're bus specific - the main issue with a lot of this
> is that they're outside the infrastructure that the bus standardises so
> we should have a general way of understanding this.  There will be bits
> where the bus needs to get involved but the overall pattern is generic.

The "pattern" is generic, yes, we've been dealing with that for well
over a decade now (pci hotplug controllers are "out of line" and control
when/if a PCI is device is added/removed.)

I'd argue that each bus needs special logic to handle this, just like
PCI hotplug did it with their hotplug controller logic.  Due to the
nature of this type of thing, it's all out-of-line hardware that is
custom to each device type / bus.

> > things, I'd fall back and just recommend a "platform driver" that
> > "knows" about where these gpios are, and how/when to enable them, which
> > will cause the discoverable bus logic to kick in now that it notices a
> > device is present/removed.
> 
> This doesn't work in general.  These things aren't really platform
> specific at all, they're features of the devices that apply to any
> system using them and while for some use cases (like WiFi and BT power)
> an external thing that just manually applies power will be enough in
> other cases we want to know about the device even while it's off and the
> driver might be able to do extra things at runtime if it knows about for
> example having some control over signals to the device.

No, the device isn't platform specific, but the logic needed to turn
on/off is platform specific, otherwise the device would "just work"
properly as the bus is self-discoverable.

Much like rfkill is, as you point out.  Those are all platform specific.

> For example in the Slimbus case we're normally talking about audio
> CODECs.  In order to preserve the userspace API the device has to appear
> to be present at all times, the driver will remember the settings the
> user is making to be applied when it actually powers up and indeed the
> powering up should be kicked off as a result of userspac acting on the
> apparently present device.

That's some horrible hardware, who thought of that?

> Another example here (including USB devices) is interrupt signals wired
> directly back to the processor, completely outside of the bus.

Like rfkill switches that just power on/off a USB device built onto the
laptop motherboard :)

> > Perhaps a semi-generic "platform" driver could be created, that knows
> > how to handle these settings in the DT, but odds are, that might be
> > difficult to make generic enough to cover a wide range of boards, but
> > without specifics, it's hard to tell.
> 
> There's things like the rfkill stuff already, and the reset controller
> on the way, but again this only covers a fairly small subset of the
> issues.

"small subset"?  How common is this type of thing?

thanks,

greg k-h
