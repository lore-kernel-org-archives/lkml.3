Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797Ab3HTPvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:51:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41204 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751474Ab3HTPvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:51:49 -0400
Date: Fri, 16 Aug 2013 15:27:58 -0400 (EDT)
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
In-Reply-To: <20130816183934.GQ30073@sirena.org.uk>
Message-ID: <Pine.LNX.4.44L0.1308161457300.1532-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013, Mark Brown wrote:

> > The difficulty with the first proposal is that subsystems aren't
> > designed to allow that sort of thing.  They expect to be able to
> > communicate with the devices they manage, during enumeration and
> > probing at least.  The difficulty with the second proposal is that it
> > requires duplicating the power-on code.
> 
> > My feeling is that the second answer involves less work and less
> > complexity than the first.  Both proposals require additional
> > "run-once" code (to do the partial instantiations or the initial
> > power-ons), but the first proposal also requires the subsystem's 
> > detection and enumeration routines to be adjusted so that they can work 
> > even when the device is incommunicado.
> 
> Right, but like I say I'm not sure that the modifications required are
> substantially different to those for handling a device powering up and
> down on the bus

I believe they are.  At the very least, a larger set of modifications
would be needed, because the subsystem's device-init and enumeration
routines would have to be changed to work with a powered-down device,
as would the driver's probe routine.  Whereas handling a device
powering up and down on the bus merely requires the subsystem's
connection-change routine to be modified.

>  or those for getting platform data to a device when it
> does enumerate.

?  I can't make any sense out of that comment.  For one thing, why do
you need to send platform data to a device?  (It's obvious that a
_driver_ would need to use platform data; it's not so clear that a
_device_ would.)

But even assuming you really do need to send platform data to the
device when it enumerates, don't the subsystem and driver already take
care of sending this data?  If they didn't then presumably the device
wouldn't be usable.  Therefore it seems that _no_ modifications should
be needed for this purpose.

>  I'd also not be so sure about the run once code, that
> is only the case for devices that can't completely idle themselves at
> runtime.
> 
> > (The second proposal also has the advantage that the power-on code may 
> > be shared between the driver and the subsystem.)
> 
> Can you explain in more detail please, I don't follow?

Let's say the subsystem powers up the device when the bus is first
registered, so that the device can be detected and enumerated.  Let's
also say that the driver wants to power-off and power-on the device
from time to time, as part of normal runtime PM.  Then instead of
having its own power-on routine (which would be code duplication), the
driver can simply call the subsystem's power-on routine.  (Of course,
this would mean that the routine would no longer be run-once.)

Alan Stern

