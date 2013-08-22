Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab3HVIFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:05:47 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.109]:52516 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab3HVIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:05:43 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-201.messagelabs.com!1377158738!10979855!2
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.9.11; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <5215C64D.3040004@digi.com>
Date: Thu, 22 Aug 2013 10:05:33 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Pawel Moll <pawel.moll@arm.com>, Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [PATCH v3 2/5] ARM: dts: add reference voltage property for MXS
 LRADC
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com>  <1374501843-19651-3-git-send-email-hector.palacios@digi.com>  <520AA3CD.1040008@kernel.org> <1376491467.18617.41.camel@hornet> <52153B8E.7050309@free-electrons.com>
In-Reply-To: <52153B8E.7050309@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alexandre,

On 08/22/2013 12:13 AM, Alexandre Belloni wrote:
> Hi Pawel,
>
> On 14/08/2013 16:44, Pawel Moll wrote:
>> On Tue, 2013-08-13 at 22:23 +0100, Jonathan Cameron wrote:
>>> On 07/22/13 15:04, Hector Palacios wrote:
>>>> Some LRADC channels have fixed pre-dividers so they can measure
>>>> different voltages at full scale. The reference voltage allows to
>>>> expose a scaling attribute through the IIO sysfs so that a user can
>>>> compute the real voltage out of a measured sample value.
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
>>>> index 4688205..6ec485c 100644
>>>> --- a/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
>>>> +++ b/Documentation/devicetree/bindings/staging/iio/adc/mxs-lradc.txt
>>>> @@ -1,9 +1,12 @@
>>>>   * Freescale i.MX28 LRADC device driver
>>>>
>>>>   Required properties:
>>>> -- compatible: Should be "fsl,imx28-lradc"
>>>> +- compatible: "fsl,imx28-lradc", "fsl,imx23-lradc"
>>>>   - reg: Address and length of the register set for the device
>>>>   - interrupts: Should contain the LRADC interrupts
>>>> +- fsl,vref: Reference voltage (in mV) for each LRADC channel. This is the
>>>> +	    maximum voltage that can be measured at full scale in each channel
>>>> +	    considering fixed pre-dividers.
>>
>> So, let me try to rephrase what I read above.
>>
>> There's an ADC with X channels. And there's a reference voltage source
>> (one?). Now, each of the ADC channels have a (different?) voltage
>> divider, taking the voltage from the reference source and feeding it to
>> the ADC comparator. How much am I wrong?
>>
>
> You are not so wrong. There is indeed actually only one reference
> voltage (and that is 1.85V). But, before feeding the voltage to the ADC
> channels, you sometimes have a divider. Then, after the channel muxing,
> you can add a by 2 divider.
>
> Mandatory ascii art:
>
>              +-----+
>              |     |
>     +-ch1--->|     |
>              |     |
>              |     |
>              |     |     +-----+
>     +-ch2--->|     |     |     |
>              | MUX |++-->| ADC +----------->
>       ch3    |     | |   |     |
>      +----+  |     | |   +-----+
>      |    |  |     | |      |
>    +-> :4 +->|     | |  +---+--+
>      |    |  |     | |  |      |
>      +----+  |     | +->|  :2  |
>              +-----+    |      |
>                         +------+
>
>
>> If I'm not wrong at all, I'd say that the reference source could be
>> described as a standard fixed regulator
>> (Documentation/devicetree/bindings/regulator/fixed-regulator.txt) and
>> the ADC node should have some king of "reference-supply" phandle to the
>> regulator node. Now, if the dividers factors are *really* fixed, the
>> driver could know about them and calculate the effective reference
>> voltage on its own, couldn't it?
>>
>> Let me repeat the "DT standard disclaimer": the tree, in general, should
>> describe the way components are *wired up*, not much more.
>>
>
> So, from my point of view, the divider that is before the mux (the by 4
> divider on channel 3 on my drawing) is not part of the the ADC, it is
> not fixed by that IP. And indeed, that changed between the i.mx23 and
> i.mx28 while the IP is the same.

The dividers only make sense and affect the ADC, so whether they should be considered 
part of the ADC IP or not is a philosophical question.
In my opinion, the different dividers between the i.mx23 and i.mx28 channels are the 
kind of hardware differences that fit nicely in the DeviceTree, describing the hardware.

> So, the two solutions you suggest are:
> 1/ using a fixed-regulator phandle per channel

Since the dividers only affect and have meaning on the ADC channels, creating a 
regulator for each channel that has a different divider looks to me like an overworked 
solution. These are not real voltage sources. They are just indicators of the maximum 
reference voltage that an ADC channel can measure.

> 2/ hard-coding the dividers in the driver using the compatible string to
> know which divider is on which channel.
>
> I feel that solution 2 is less future proof but at the same time, I
> don't believe we will see that IP in another chip in the future.

This was what I originally submitted but it then looked like it would better fit in 
the DeviceTree. The spear-adc seemed to use a similar approach:

http://permalink.gmane.org/gmane.linux.kernel.iio/7994

Best regards,
--
Hector Palacios
