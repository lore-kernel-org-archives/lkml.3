Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3IIQRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:17:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60508 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3IIQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:17:38 -0400
Date: Mon, 9 Sep 2013 09:17:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
Message-ID: <20130909161735.GC18975@roeck-us.net>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <20130909160237.GR29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909160237.GR29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 05:02:37PM +0100, Mark Brown wrote:
> On Mon, Sep 09, 2013 at 08:50:43AM -0700, Guenter Roeck wrote:
> > On Mon, Sep 09, 2013 at 02:50:22PM +0100, Mark Brown wrote:
> 
> > > And indeed it does this (well, it does whatever the driver says in terms
> > > of delay).  However it is possible that the lm90 needs this time for
> > > itself - if it's doing some sort of initialisation or callibration
> > > sequence then that'll happen after the supplies come up.  25ms did seem
> > > rather long, especially for such simple devices, but it's not beyond the
> > > bounds of possibility.
> 
> > Even then it would be unreasonable to enforce such a delay for every instance
> > of this driver, even if the regulator is a dummy one and/or has been enabled
> > already. Many if not almost all users of the driver work just fine as-is,
> > without additional enforced delay (and, for that matter, without regulator ;).
> 
> > If there is a delay, it would have to be optional: Only wait if the regulator
> > was really turned on by the call and not already active. I don't know if the
> > regulator subsystem has this capability; if not, maybe it should.
> 
> It does, though it gets complicated trying to use it for a case like
> this since you can't really tell if the regulator was powered on
> immediately before the device got probed by another device on the bus.
> 
Why not ? Just keep a timestamp.

> > On a higher level, I wonder if such functionality should be added in the i2c
> > subsystem and not in i2c client drivers. Has anyone thought about this ?
> 
> I'm not sure what the subsystem would do for such delays?  It's fairly
> common for things that need this to also want to do things like
> manipulate GPIOs as part of the power on sequence so the applicability
> is relatively limited, plus it's not even I2C specific, the same applies
> to other buses so it ought to be a driver core thing.
> 
Possibly. I just thought about i2c since it also takes care of basic
devicetree bindings. Something along the line of
	if devicetree bindings for this device declare one or more
	regulators, enable those regulators before calling the driver
	probe function.

That was not intended to solve the delay problem, though. The delay problem
seems to be more of a generic regulator problem and, as I suggested, should
be solved in the regulator subsystem.
	if the regulator is enabled and the device specifies a poweron delay,
	wait for the specified amount of time after (and only after) enabling
	the regulator.

> There was some work on a generic helper for power on sequences but it
> stalled since it wasn't accepted for the original purpose (LCD panel
> power ons IIRC).

Too bad. I think it could be kept quite simple, though, by handling it
through the regulator subsystem as suggested above. A generic binding
for a per-regulator and per-device poweron delay should solve that
and possibly even make it transparent to the actual driver code.

Guenter
