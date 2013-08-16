Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3HPOmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:42:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39928 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754536Ab3HPOmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:42:12 -0400
Date: Fri, 16 Aug 2013 10:42:10 -0400 (EDT)
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
In-Reply-To: <20130815225427.GA18597@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308161012160.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013, Mark Brown wrote:

> No, this really is something that's very much generic to the device and
> will apply to anywhere the silicon is used.  The power on process for a
> device isn't something that changes, the mapping of resources that might
> be used in that sequence is but we've got good abstractions for pretty
> much all the resources that a device might need - clocks, power, GPIOs
> and so on - which do the mapping of those resources onto the device at
> board level so neither the provider not the user need to know about it.
> That's just data and is much easier to encode in DT or equivalent than
> actual sequences.
> 
> We've got a bunch of existing drivers in the kernel which do this sort
> of stuff, they ask for resources and then know what to do with them and
> can also make use of these resources at runtime if they want.

Okay, let's see if I understand your problem.  You've got a driver that
knows how to manage its devices, including how to power them on and
off.  But the driver can't bind to one of these devices until the
device has appeared on the bus and been enumerated, and that won't
happen until the device has been powered on.  It's a chicken-and-egg
sort of thing.

You know about the existence of these devices beforehand because that
knowledge is encapsulated in platform information somewhere.  The
question is how best to use this information to solve the
chicken-and-egg problem.

Is that it?

One possible answer is to use the platform information to (partially)  
instantiate the device before it has been detected, so that the driver
can bind to it.  Another is to use the platform information to perform
an initial power-up of the device, so that it can be detected,
enumerated, and probed in the normal manner.

The difficulty with the first proposal is that subsystems aren't
designed to allow that sort of thing.  They expect to be able to
communicate with the devices they manage, during enumeration and
probing at least.  The difficulty with the second proposal is that it
requires duplicating the power-on code.

My feeling is that the second answer involves less work and less
complexity than the first.  Both proposals require additional
"run-once" code (to do the partial instantiations or the initial
power-ons), but the first proposal also requires the subsystem's 
detection and enumeration routines to be adjusted so that they can work 
even when the device is incommunicado.

(The second proposal also has the advantage that the power-on code may 
be shared between the driver and the subsystem.)

Alan Stern

