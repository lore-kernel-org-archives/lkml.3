Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3HLCBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:01:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3HLCBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:01:34 -0400
Date: Sun, 11 Aug 2013 19:02:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Non-enumerable devices on USB and other enumerable buses
Message-ID: <20130812020257.GA7028@kroah.com>
References: <20130811190826.GH6427@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130811190826.GH6427@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 08:08:26PM +0100, Mark Brown wrote:
> Looking at the enumerable buses in the kernel I don't see any which have
> real support for any kind of registration of devices prior to their
> enumeration.  Similarly currently all the DT bindings in the kernel I've
> been able to notice cover only non-enumerable buses.  This generally
> makes sense where enumerable buses are used in standard fashions since
> the binding would be at best redundant and at worst inaccurate.  However
> there are often corner cases in embedded systems where hardware has been
> hooked up outside of the normal enumeration mechanisms, for example with
> software power control or extra signals wired.

Not just "embedded", the Macbooks have this same issue as well I'm
pretty sure, it's just that we don't know where those GPIOs are in order
to be able to use them...

> One example that's bugging me right now is that on the Insignal Arndale
> platform there's a USB hub connected to one of the USB ports on the SoC
> (not as a PHY, it seems we also need the internal PHY running to talk to
> the device).  The hub needs to be "plugged" into the SoC after the SoC
> USB controller has started with some GPIOs so we need to tell the system
> that the hub exists and needs to be synchronised with the USB controller.
> 
> Another case that's going to be problematic once it's in mainline is
> Slimbus - this is a bus used in some embedded audio subsystems which is
> enumerable in a similar manner to USB but where the devices on the bus
> are normally powered up only on demand (causing them to hotplug when
> used and unplug when idle) and have at least interrupt lines wired to
> the SoC using a normal interrupt outside the enumerable bus.
> 
> I know there's been some discussion of this topic but do we have any
> general consensus on how to handle such things both from a Linux driver
> model point of view and from a DT/ACPI point of view?

As these are usually bus-specific things, and really, platform-specific
things, I'd fall back and just recommend a "platform driver" that
"knows" about where these gpios are, and how/when to enable them, which
will cause the discoverable bus logic to kick in now that it notices a
device is present/removed.

Perhaps a semi-generic "platform" driver could be created, that knows
how to handle these settings in the DT, but odds are, that might be
difficult to make generic enough to cover a wide range of boards, but
without specifics, it's hard to tell.

thanks,

greg k-h
