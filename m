Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3IIPut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:50:49 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:42788 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3IIPur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:50:47 -0400
Date: Mon, 9 Sep 2013 08:50:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, swarren@wwwdotorg.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
Message-ID: <20130909155043.GA18975@roeck-us.net>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909135022.GZ29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 02:50:22PM +0100, Mark Brown wrote:
> On Mon, Sep 09, 2013 at 04:34:43AM -0700, Guenter Roeck wrote:
> > On 09/09/2013 04:12 AM, Mark Brown wrote:
> > >On Mon, Sep 09, 2013 at 06:29:11PM +0800, Wei Ni wrote:
> 
> > >This doesn't look good, it is going to ignore actual errors - I *really*
> > >doubt that vcc is optional, it looks like it's the main power supply for
> > >the device.  You should use normal regulator_get(), _optional() is for
> > >supplies which could physically not be provided in a system (eg, if the
> > >device can generate them internally if required).
> 
> > Then he'll have to make sure that all devicetree files in the system
> > contain references to this regulator.
> 
> Or get the patches applied on top of the code that'll be going in this
> cycle implementing get_optional() properly - when that's done the
> default will be to provide a dummy supply for regulator_get().  If you
> ack the patch I'd be happy to carry it.
> 
Jean will have to ack it.

> > >Also do you really need 25ms after power on?
> 
> > I had not noticed, but I recommend to reject the patch because of it.
> > If we add 25ms delay to each driver, booting the system will take as
> > long as booting windows. If enabling the regulator needs time, the
> > regulator subsystem should do it.
> 
> And indeed it does this (well, it does whatever the driver says in terms
> of delay).  However it is possible that the lm90 needs this time for
> itself - if it's doing some sort of initialisation or callibration
> sequence then that'll happen after the supplies come up.  25ms did seem
> rather long, especially for such simple devices, but it's not beyond the
> bounds of possibility.

Even then it would be unreasonable to enforce such a delay for every instance
of this driver, even if the regulator is a dummy one and/or has been enabled
already. Many if not almost all users of the driver work just fine as-is,
without additional enforced delay (and, for that matter, without regulator ;).

If there is a delay, it would have to be optional: Only wait if the regulator
was really turned on by the call and not already active. I don't know if the
regulator subsystem has this capability; if not, maybe it should.

On a higher level, I wonder if such functionality should be added in the i2c
subsystem and not in i2c client drivers. Has anyone thought about this ?

Guenter
