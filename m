Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3HUPle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 11:41:34 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54422 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3HUPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 11:41:31 -0400
Date: Wed, 21 Aug 2013 08:41:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
Message-ID: <20130821154127.GA8242@roeck-us.net>
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com>
 <20130820091228.GW3719@e106331-lin.cambridge.arm.com>
 <20130820153456.GA12618@roeck-us.net>
 <20130821091451.GA3719@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821091451.GA3719@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:14:51AM +0100, Mark Rutland wrote:
> On Tue, Aug 20, 2013 at 04:34:56PM +0100, Guenter Roeck wrote:
> > On Tue, Aug 20, 2013 at 10:12:28AM +0100, Mark Rutland wrote:
> > > Hi Oleksandr,
> > > 
> > > [Adding Jonathan Cameron and Guenter Roeck to Cc]
> > > 
> > > Apologies for the delay replying to this. In attempting to verify this
> > > made sense I went and read the IIO bindings documentation, and I'm
> > > somewhat confused by the model.
> > > 
> > > As far as I can see, the only consumer of IIO channels is the
> > > "iio-hwmon" binding, which seems to be a binding for Linux-specific
> > > infrastructure rather than any actual device. This runs counter to the
> > 
> > In respect to "iio-hwmon", I think you may actually be correct; we should
> > have found a better means to describe the system.
> > The intend was to describe that a set of adc inputs is connected
> > to a set of voltages or temperature sensors.
> > 
> > Is there a better way ? I am sure there is, but I have no idea what
> > it might be, nor do I have the time to find out.
> 
> I'd imagine that a better option would be to embed that information in
> subnodes of the device:
> 
> someadc {
> 	compatible = "vendor,someadc";
> 	/*
> 	 * Someadc has 20 independent ADCs, which may be wired
> 	 * arbitrarily:
> 	 */
> 	adc@1 {
> 		/* name from datasheet */
> 		name = "temp0";
> 		vendor,additional-calibration-data = <0x0 0x44>;
> 	};
> 
> 	adc@15 {
> 		name = "temp1";
> 	};
> };
> 
> The driver for the device then knows which inputs are actually wired,
> and can export the channels as necessary to hwmon (or whatever driver we
> see fit later down the line).
> 
It doesn't tell what those channels are connected to, though. It would be
important to know, for example, that an ADC channels is connected to a
temperature sensor (which would also need bindings) or to a specific voltage
channel. Just like the vcc pin of a chip is connected to a regulator,
the adc input pins are connected to a regulator as well if the adc is used 
to monitor voltages. For vcc that is well understood; for example, I have

	max1139: voltage-sensor@35 { /* PMB */
        	compatible = "maxim,max1139";
                reg = <0x35>;
                vcc-supply = <&reg_3p3v>;
                vref-supply = <&reg_3p3v>;
                #io-channel-cells = <1>;
        };

to specify both VCC and VREF for a MAX1139. What would be needed are properties
to describe what the ADC input pins are connected to in a generic way
so that drivers like iio_hwmon have a chance to pick it up.

> > 
> > However, I think that the "io-channels" property is well defined.
> > 
> > "gpios" describes a group of gpio pins which have a common purpose.
> > "io-channels" describes a group of io channels (or, ultimately, pins)
> > which have a common purpose. So this is not really linux specific,
> > unless other operating systems don't see the need of describing a group
> > of io channels as single entity. But then the same could be claimed
> > about groups of gpio pins.
> 
> While admittedly there's some correspondence between a gpio being a pin
> and a channel being a pin, I don't think that's a good comparison. When
> we describe gpios viald $NAME-gpios propertiese, we do so because there
> is a physical link between the gpio output and the device.
> 
> As far as I can tell with io-channels, we describe them to say that they
> are wired to something, but what they are actually wired to is not
> described (at least in the case of the iio-hwmon binding). Do we have
> any devices which require information from external ADCs to be used?
> 
The problem with iio_hwmon, as I see it, can be boiled down to its compatible
string. It doesn't directly describe hardware, so something like
	compatible = "iio-hwmon";
looks like a bad choice, though I am not sure if the culprit is the name
or what it provides.

Question is how to express this better. For example, we have "gpio-leds" to
describe LEDs connected to GPIO pins. What kind of property could we have to
describe IO channels (or adc inputs, if you like) connected to voltage sensors,
or any other kind of sensors ?

Guenter
