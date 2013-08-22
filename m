Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3HVQ7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:59:03 -0400
Received: from smtp-out-251.synserver.de ([212.40.185.251]:1046 "EHLO
	smtp-out-250.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753311Ab3HVQ7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:59:00 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30638
Message-ID: <521643A4.6080802@metafoo.de>
Date: Thu, 22 Aug 2013 19:00:20 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hector Palacios <hector.palacios@digi.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>  <1374501843-19651-3-git-send-email-hector.palacios@digi.com>  <520AA3CD.1040008@kernel.org> <1376491467.18617.41.camel@hornet>  <52153B8E.7050309@free-electrons.com> <1377189662.2626.4.camel@hornet>
In-Reply-To: <1377189662.2626.4.camel@hornet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2013 06:41 PM, Pawel Moll wrote:
> 
> On Wed, 2013-08-21 at 23:13 +0100, Alexandre Belloni wrote:
>> You are not so wrong. There is indeed actually only one reference
>> voltage (and that is 1.85V). But, before feeding the voltage to the ADC
>> channels, you sometimes have a divider. Then, after the channel muxing,
>> you can add a by 2 divider.
>>
>> Mandatory ascii art:
>>
>>             +-----+
>>             |     |
>>    +-ch1--->|     |
>>             |     |
>>             |     |
>>             |     |     +-----+
>>    +-ch2--->|     |     |     |
>>             | MUX |++-->| ADC +----------->
>>      ch3    |     | |   |     |
>>     +----+  |     | |   +-----+
>>     |    |  |     | |      |
>>   +-> :4 +->|     | |  +---+--+
>>     |    |  |     | |  |      |
>>     +----+  |     | +->|  :2  |
>>             +-----+    |      |
>>                        +------+
>>
>>
>> So, from my point of view, the divider that is before the mux (the by 4
>> divider on channel 3 on my drawing) is not part of the the ADC, it is
>> not fixed by that IP. And indeed, that changed between the i.mx23 and
>> i.mx28 while the IP is the same.
> 
> Let me a couple of additional questions, hope you don't mind:
> 
> 1. Is the channel defined as: input *and* the reference voltage? Or,
> does the mux switch both of them at the same time?
> 
> 2. Is the mux controlled (so the channel selected) by a control register
> "integral" to the ADC?
> 
> 3. Is the reference voltage generated "inside" the SOC? Or does it come
> from an external source?
> 
> 4. How is the "LRADC" IP actually documented? Does the spec clearly say
> that it has 8 voltage reference inputs?

There is one internal vref always fixed to the same voltage (I think).

> 
>> So, the two solutions you suggest are:
>> 1/ using a fixed-regulator phandle per channel
>> 2/ hard-coding the dividers in the driver using the compatible string to
>> know which divider is on which channel.
>>
>> I feel that solution 2 is less future proof but at the same time, I
>> don't believe we will see that IP in another chip in the future.
> 
> If we were to follow the spirit of "how is it wired" to the letter, you
> should really use 8 supplies, but I appreciate that it can be
> troublesome (or maybe not? it's just 2 dtsi files after all ;-). So
> maybe, as the compatible values explicitly mention the SOC names, you
> just want to hardcode the voltage levels in the driver itself (probably
> as data for the match array)? This of course assume that the reference
> source is internal. Shortly speaking - I believe that you should have
> phandles to regulators or nothing at all there :-) A de-facto-constant
> list of SOC-specific numbers seems the worst option.

The table is a list of virtual reference voltages, if you will so. The
reference voltage is always the same, but some of the inputs have a voltage
divider. From a mathematical point of view you get the same result if you
either divide the input voltage, or multiply the reference voltage. That
said in my opinion the best solution is still to put that table into the
driver and not the devicetree.

- Lars
