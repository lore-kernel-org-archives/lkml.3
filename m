Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434Ab3IJEEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:04:43 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19507 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3IJEEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:04:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 09 Sep 2013 21:01:39 -0700
Message-ID: <522E9A85.9050803@nvidia.com>
Date: Tue, 10 Sep 2013 12:05:25 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-2-git-send-email-wni@nvidia.com> <20130909111242.GW29403@sirena.org.uk> <522DB253.6000707@roeck-us.net> <20130909135022.GZ29403@sirena.org.uk> <20130909155043.GA18975@roeck-us.net> <20130909160237.GR29403@sirena.org.uk> <20130909161735.GC18975@roeck-us.net> <20130909203910.GV29403@sirena.org.uk>
In-Reply-To: <20130909203910.GV29403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 04:39 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Mon, Sep 09, 2013 at 09:17:35AM -0700, Guenter Roeck wrote:
>> On Mon, Sep 09, 2013 at 05:02:37PM +0100, Mark Brown wrote:
> 
>>> It does, though it gets complicated trying to use it for a case like
>>> this since you can't really tell if the regulator was powered on
>>> immediately before the device got probed by another device on the bus.
> 
>> Why not ? Just keep a timestamp.
> 
> The support is a callback on state changes; we could keep a timestamp
> but there's still going to be race conditions around bootloaders.  It's
> doable though.
> 
>>>> On a higher level, I wonder if such functionality should be added in the i2c
>>>> subsystem and not in i2c client drivers. Has anyone thought about this ?
> 
>>> I'm not sure what the subsystem would do for such delays?  It's fairly
>>> common for things that need this to also want to do things like
>>> manipulate GPIOs as part of the power on sequence so the applicability
>>> is relatively limited, plus it's not even I2C specific, the same applies
>>> to other buses so it ought to be a driver core thing.
> 
>> Possibly. I just thought about i2c since it also takes care of basic
>> devicetree bindings. Something along the line of
>> 	if devicetree bindings for this device declare one or more
>> 	regulators, enable those regulators before calling the driver
>> 	probe function.
> 
> That's definitely a driver core thing, not I2C - there's nothing
> specific to I2C in there at all, needing power is pretty generic.  I
> have considered this before, something along the lines of what we have
> for pinctrl, but unfortunately the generic case isn't quite generic
> enough to make it easy.  It'd need to be an explicit list of regulators
> (partly just to make it opt in and avoid breaking things) and you'd want
> to have a way of handling the different suspend/resume behaviour that
> devices want.  There's a few patterns there.
> 
> It's definitely something I think about from time to time and it would
> be useful to factor things out, the issue is getting a good enough model
> of what's going on.
> 
>>> There was some work on a generic helper for power on sequences but it
>>> stalled since it wasn't accepted for the original purpose (LCD panel
>>> power ons IIRC).
> 
>> Too bad. I think it could be kept quite simple, though, by handling it
>> through the regulator subsystem as suggested above. A generic binding
>> for a per-regulator and per-device poweron delay should solve that
>> and possibly even make it transparent to the actual driver code.
> 
> Lots of things have a GPIO for reset too, and some want clocks too.  For
> maximum usefulness this should be cross subsystem.  I suspect the reset
> controller API may be able to handle some of it.
> 
> The regulator power on delays are already handled transparently, by the
> time regulator_enable() returns the ramp should be finished.

I think the regulator should encoded its own startup delay. Each
individual device should handle its own requirements for delay after
power is stable.
The regulator_enable() will handle the delays for the regulator device.
And adding the msleep(25) is for lm90 device. If without delay,
sometimes the device can't work properly. If read lm90 register
immediately after enabling regulator, the reading may be failed.
I'm not sure if 25ms is the right value, I read the LM90 SPEC, the max
of "SMBus Clock Low Time" is 25ms, so I supposed that it may need about
25ms to stable after power on.

Thanks.
Wei.

> 
> * Unknown Key
> * 0x7EA229BD
> 

