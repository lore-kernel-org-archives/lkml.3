Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab3HUJPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:15:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48708 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382Ab3HUJPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:15:18 -0400
Date: Wed, 21 Aug 2013 10:14:51 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Message-ID: <20130821091451.GA3719@e106331-lin.cambridge.arm.com>
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
 <20130820153456.GA12618@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820153456.GA12618@roeck-us.net>
Thread-Topic: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 04:34:56PM +0100, Guenter Roeck wrote:
> On Tue, Aug 20, 2013 at 10:12:28AM +0100, Mark Rutland wrote:
> > Hi Oleksandr,
> > 
> > [Adding Jonathan Cameron and Guenter Roeck to Cc]
> > 
> > Apologies for the delay replying to this. In attempting to verify this
> > made sense I went and read the IIO bindings documentation, and I'm
> > somewhat confused by the model.
> > 
> > As far as I can see, the only consumer of IIO channels is the
> > "iio-hwmon" binding, which seems to be a binding for Linux-specific
> > infrastructure rather than any actual device. This runs counter to the
> 
> In respect to "iio-hwmon", I think you may actually be correct; we should
> have found a better means to describe the system.
> The intend was to describe that a set of adc inputs is connected
> to a set of voltages or temperature sensors.
> 
> Is there a better way ? I am sure there is, but I have no idea what
> it might be, nor do I have the time to find out.

I'd imagine that a better option would be to embed that information in
subnodes of the device:

someadc {
	compatible = "vendor,someadc";
	/*
	 * Someadc has 20 independent ADCs, which may be wired
	 * arbitrarily:
	 */
	adc@1 {
		/* name from datasheet */
		name = "temp0";
		vendor,additional-calibration-data = <0x0 0x44>;
	};

	adc@15 {
		name = "temp1";
	};
};

The driver for the device then knows which inputs are actually wired,
and can export the channels as necessary to hwmon (or whatever driver we
see fit later down the line).

> 
> However, I think that the "io-channels" property is well defined.
> 
> "gpios" describes a group of gpio pins which have a common purpose.
> "io-channels" describes a group of io channels (or, ultimately, pins)
> which have a common purpose. So this is not really linux specific,
> unless other operating systems don't see the need of describing a group
> of io channels as single entity. But then the same could be claimed
> about groups of gpio pins.

While admittedly there's some correspondence between a gpio being a pin
and a channel being a pin, I don't think that's a good comparison. When
we describe gpios viald $NAME-gpios propertiese, we do so because there
is a physical link between the gpio output and the device.

As far as I can tell with io-channels, we describe them to say that they
are wired to something, but what they are actually wired to is not
described (at least in the case of the iio-hwmon binding). Do we have
any devices which require information from external ADCs to be used?

> 
> > way DT is supposed to function (describing the hardware rather than how
> > it's used). As far as I can see, this linkage is described because only
> > a subset of the ADCs on the device are actually wired to something?
> > 
> Is that a problem ? I would think that the same is true for many chips
> with multiple inputs and/or outputs.

What I meant was that I don't think describing a hardware to software
wiring is the best way of describing this, when we can simply describe
the hardware (as in the example above), and don't have to describe an
abstract concept (iio-hwmon) which may not correspond to how we want to
use the device in future.

> 
> > I also see a couple of IIO bindings ("adi,adf435x*, and "adi,ad7303")
> > which don't describe any iio channel cells at all, so I'm somewhat
> > confused by what the IIO channels actually represent, and why they must
> > be consumed elsewhere. As far as I can see, an IIO channel represents a
> > single ADC's registers in an IIO device, so I'm not sure why this must
> > be exported via the channel concept -- it's not physically wired.
> > 
> I am sure there would be some other means to describe the same,
> so I would agree that it does not _have_ to be the way it is.
> 
> Question is if there is a better way. Again, "io-channels" describes
> a group of io channels with a common purpose. Sure, that does not _have_
> to be described as a single property, but then I could argue that the same
> is true for "gpios" and probably many other properties.

Ok, I just want to raise the issue to ensure that we've properly
considered this before its an ever-lasting ABI.

Thanks,
Mark.
