Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab3HUUD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:03:59 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55063 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3HUUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:03:57 -0400
Message-ID: <52152B3C.80704@kernel.org>
Date: Wed, 21 Aug 2013 22:03:56 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Mark Rutland <mark.rutland@arm.com>,
        Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: Add bindigs documentation for twl6030 GPADC
References: <1376911765-7821-1-git-send-email-oleksandr.kozaruk@ti.com> <20130820091228.GW3719@e106331-lin.cambridge.arm.com> <20130820153456.GA12618@roeck-us.net> <20130821091451.GA3719@e106331-lin.cambridge.arm.com> <20130821154127.GA8242@roeck-us.net> <20130821162201.GB4278@e106331-lin.cambridge.arm.com> <20130821170213.GA25161@roeck-us.net>
In-Reply-To: <20130821170213.GA25161@roeck-us.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/13 18:02, Guenter Roeck wrote:
> On Wed, Aug 21, 2013 at 05:22:01PM +0100, Mark Rutland wrote:
>> On Wed, Aug 21, 2013 at 04:41:27PM +0100, Guenter Roeck wrote:
>>> On Wed, Aug 21, 2013 at 10:14:51AM +0100, Mark Rutland wrote:
>>>> On Tue, Aug 20, 2013 at 04:34:56PM +0100, Guenter Roeck wrote:
>>>>> On Tue, Aug 20, 2013 at 10:12:28AM +0100, Mark Rutland wrote:
>>>>>> Hi Oleksandr,
>>>>>>
>>>>>> [Adding Jonathan Cameron and Guenter Roeck to Cc]
>>>>>>
>>>>>> Apologies for the delay replying to this. In attempting to verify this
>>>>>> made sense I went and read the IIO bindings documentation, and I'm
>>>>>> somewhat confused by the model.
>>>>>>
>>>>>> As far as I can see, the only consumer of IIO channels is the
>>>>>> "iio-hwmon" binding, which seems to be a binding for Linux-specific
>>>>>> infrastructure rather than any actual device. This runs counter to the
>>>>>
>>>>> In respect to "iio-hwmon", I think you may actually be correct; we should
>>>>> have found a better means to describe the system.
>>>>> The intend was to describe that a set of adc inputs is connected
>>>>> to a set of voltages or temperature sensors.
>>>>>
>>>>> Is there a better way ? I am sure there is, but I have no idea what
>>>>> it might be, nor do I have the time to find out.
>>>>
>>>> I'd imagine that a better option would be to embed that information in
>>>> subnodes of the device:
>>>>
>>>> someadc {
>>>> 	compatible = "vendor,someadc";
>>>> 	/*
>>>> 	 * Someadc has 20 independent ADCs, which may be wired
>>>> 	 * arbitrarily:
>>>> 	 */
>>>> 	adc@1 {
>>>> 		/* name from datasheet */
>>>> 		name = "temp0";
>>>> 		vendor,additional-calibration-data = <0x0 0x44>;
>>>> 	};
>>>>
>>>> 	adc@15 {
>>>> 		name = "temp1";
>>>> 	};
>>>> };
>>>>
>>>> The driver for the device then knows which inputs are actually wired,
>>>> and can export the channels as necessary to hwmon (or whatever driver we
>>>> see fit later down the line).
>>>>
>>> It doesn't tell what those channels are connected to, though. It would be
>>> important to know, for example, that an ADC channels is connected to a
>>> temperature sensor (which would also need bindings) or to a specific voltage
>>> channel. Just like the vcc pin of a chip is connected to a regulator,
>>> the adc input pins are connected to a regulator as well if the adc is used 
>>> to monitor voltages. For vcc that is well understood; for example, I have
>>>
>>> 	max1139: voltage-sensor@35 { /* PMB */
>>>         	compatible = "maxim,max1139";
>>>                 reg = <0x35>;
>>>                 vcc-supply = <&reg_3p3v>;
>>>                 vref-supply = <&reg_3p3v>;
>>>                 #io-channel-cells = <1>;
>>>         };
>>>
>>> to specify both VCC and VREF for a MAX1139. What would be needed are properties
>>> to describe what the ADC input pins are connected to in a generic way
>>> so that drivers like iio_hwmon have a chance to pick it up.
>>
>> That can easily go in properties of the subnodes, alongside other data
>> (e.g. the "vendor,addtional-calibrartion-data" property). As far as I
>> can see the current binding still doesn't tell you what the channels are
>> actually wired to.
>>
>> In the example above there are multiple channels, what do they
>> correspond to, and do all of them relate to the vcc and vref?
>>
> The example refers to the current bindings. vcc and vref specify chip supply
> and reference voltages, not voltages connected to the adc inputs. That would
> require a new set of properties.
> 
>>>
>>>>>
>>>>> However, I think that the "io-channels" property is well defined.
>>>>>
>>>>> "gpios" describes a group of gpio pins which have a common purpose.
>>>>> "io-channels" describes a group of io channels (or, ultimately, pins)
>>>>> which have a common purpose. So this is not really linux specific,
>>>>> unless other operating systems don't see the need of describing a group
>>>>> of io channels as single entity. But then the same could be claimed
>>>>> about groups of gpio pins.
>>>>
>>>> While admittedly there's some correspondence between a gpio being a pin
>>>> and a channel being a pin, I don't think that's a good comparison. When
>>>> we describe gpios viald $NAME-gpios propertiese, we do so because there
>>>> is a physical link between the gpio output and the device.
>>>>
>>>> As far as I can tell with io-channels, we describe them to say that they
>>>> are wired to something, but what they are actually wired to is not
>>>> described (at least in the case of the iio-hwmon binding). Do we have
>>>> any devices which require information from external ADCs to be used?
>>>>
>>> The problem with iio_hwmon, as I see it, can be boiled down to its compatible
>>> string. It doesn't directly describe hardware, so something like
>>> 	compatible = "iio-hwmon";
>>> looks like a bad choice, though I am not sure if the culprit is the name
>>> or what it provides.
>>
>> As far as I can see, iio-hwmon just gets passed a set of channels with
>> no other information. How does it know what's wired to the ADCs
>> providing those channels? I don't think enough information's recorded
>> for that to be useful...
>>
> That information is currently provided by the iio subsystem, which AFAIK
> gets it from the chip driver (Jonathan, any comments ?).

There is no real way of providing that information unless the wiring
is fixed - e.g. what is there is always the same for the individual part.
IIO itself tends to be low level enough that it doesn't care.  Whilst
we've talked about this in the past it was back in the pre DT days
and was 'left for another day'.

> 
>>>
>>> Question is how to express this better. For example, we have "gpio-leds" to
>>> describe LEDs connected to GPIO pins. What kind of property could we have to
>>> describe IO channels (or adc inputs, if you like) connected to voltage sensors,
>>> or any other kind of sensors ?
>>
>> I don't see that we encode this in the current bindings. I think this
>> linkage can be described per-channel realtively easily if each channel
>> is described as a subnode of the device providing the ADC channels. In
>> the example I porvided previously, the channel from "temp0" encodes
>> calibration information that might be required on a per-device basis to
>> map from a raw value to degrees celsius. It may be possible to encode
>> additional type information in a relatively standard way:
>>
>> someadc {
>> 	compatible = "vendor,someadc";
>>
>> 	adc@0
>> 		reg = <0>;
>> 		name = "temp0"; 
>> 		type = "temperature";
>> 		vendor,temp-calibration-data = <0x0004 0xfee3>;
>> 	};
>>
>> 	adc@3 {
>> 		reg = <3>;
>> 		type = "voltage";
>> 		vcc-supply = <&reg_3p3v>;
>> 		vref-supply = <&reg_3p3v>;
>> 		vendor,vref-offset = <0x300>;
>> 	};
>> };
>>
>> I believe that would better describe the device, and describe what the
>> IIO framework needs, without requiring any software level abstraction
>> (i.e. io channels) to be described in the DT.
>>
> Except that vcc-supply and vref-supply are chip properties, not adc channel
> properties. I like the general idea, but the property would need a more generic
> name (it is not necessarily vcc or vref but could be any voltage).
> 
Just to clarify on some points in my mind. I've kind of lost track of what
this discussion is focusing on.

One thing to keep in mind throughout this.  The general purpose ADC case
is, whilst interesting is only a corner of what we have to cover.

Firstly the core of IIO itself doesn't currently use any bindings whatsoever
beyond simple 'it is there' + the usual regulators etc.
Much like hwmon it provides all channels to userspace. The unconnected channel
case only really became relevant as the number of SoC ADC drivers increased.

If you are using a discrete ADC, typically you want all or very
nearly all the channels.  Also keep very much in mind that for a lot of
input / output drivers the concept of 'connectivity doesn't really apply
as the sensor is directly measuring, say, light or acceleration. Arguably the
connectivity is there but within the single package so we don't want to have
to describe in the the DT.  What we need is some way of mapping 'purpose'.
Is that accelerometer useful for input or not?  As that ADC measuring temperature
and if so is that relevant for hardware monitoring?   For voltages
some of them are useful to monitor that a level is correct, others are
useful to know about the battery voltage.  As far as I can see there is no
description of this in the above interface.  This is kind of why we ended
up with the explicity mappings to say 'this channel to this driver' as a
fairly nasty way of indicating what it was for.

Agreed what we have now is less than elegant.  Anyhow I'll be following
how this develops with interest.  My big question right now is how does
the kernel know what to use to expose a given channel to userspace?
It's far from obvious in some cases, but how does this get encoded if it
isn't in the device tree?  Take an example.  An accelerometer on an embedded
unit for measuring the vibration on a bridge vs the same chip in a mobile phone?
In the phone it is there to act primarily as a human input device though
it might have a secondary consumer using it as a free fall monitor.  In the
bridge sensor neigther of these cases make any sense (hopefully!).

If that information is not in the device tree, where should it be?  This
decision is about hardware design, just not about wiring.

Jonathan


