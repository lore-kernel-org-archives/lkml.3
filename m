Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab3AXSKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:10:24 -0500
Received: from smtp-out-079.synserver.de ([212.40.185.79]:1379 "EHLO
	smtp-out-075.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751992Ab3AXSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:10:21 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30696
Message-ID: <51017937.40106@metafoo.de>
Date: Thu, 24 Jan 2013 19:11:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121122 Icedove/10.0.11
MIME-Version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
CC: Doug Anderson <dianders@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        gregkh@linuxfoundation.org, Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH] iio: adc: add exynos5 adc driver under iio framwork
References: <1358775470-21278-1-git-send-email-ch.naveen@samsung.com> <1358917086-4148-1-git-send-email-ch.naveen@samsung.com> <50FFDD2A.9040102@metafoo.de> <CAD=FV=VgrpPSLrwwrzFDFLBXTw+-t3C=UwnS6b53o41hxM_AyQ@mail.gmail.com> <510104BD.2020500@metafoo.de> <CAHfPSqC90LwqEZ2kQdWY94CQHeqvCTYmw-WkAqBBNQui7wkKZQ@mail.gmail.com>
In-Reply-To: <CAHfPSqC90LwqEZ2kQdWY94CQHeqvCTYmw-WkAqBBNQui7wkKZQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 03:20 PM, Naveen Krishna Ch wrote:
> On 24 January 2013 15:24, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>
>> On 01/24/2013 01:42 AM, Doug Anderson wrote:
>>> Lars,
>>>
>>> On Wed, Jan 23, 2013 at 4:52 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>>> Few doubts regarding the mappings and child device handling.
>>>>> Kindly, suggest me better methods.
>>>>
>>>> The patch looks mostly good now. As for the mappings, the problem is that we
>>>> currently do not have any device tree bindings for IIO. So a proper solution
>>>> would be to add dt bindings for IIO.
>>>
>>> Can you explain more how you think this would work?  It seems like
>>> just having child nodes as platform drivers would be OK (to me) and
>>> having them instantiated with of_platform_populate() seems reasonable.
>>>
>>> ...but the one thing that is missing is a way for children to get
>>> access to the channel properly.
>>>
>>> The children have access to the ADC "struct device" (it is their
>>> parent device) and have a channel number (their "reg" field), but
>>> there is no API call to map this to a "struct iio_channel".  Is that
>>> all that's needed in this case?  ...or are you envisioning something
>>> more?
>>
>> Well, the idea is that the consumer doesn't need to know the channel number.
>> That's what the mapping takes care of. It basically creates a consumer alias
>> for the channel. When requesting the channel the consumer always uses the
>> same name.
>>
>> iio_channel_get(dev_name(&pdev->dev), "voltage");
>>
>> And the mapping contains an entry which maps the tuple of device name and
>> channel name to a real IIO channel which as been registered by a IIO device.
>> Note if there is only one channel you can also just use NULL for the channel
>> name. This is similar to how clocks are managed with the clk framework.
>>
>> Now for the dt bindings I think we should stick to something similar to what
>> the clk framework does.
>>
>> E.g.
>>
>> adc: adc@12D10000 {
>>
>>         #io-channel-cells = <1>;
>>         io-channel-output-names = "adc1", "adc2", ...;
>>
>>         ncp15wb473@0 {
>>                 compatible = "ntc,ncp15wb473";
>>                 ...
>>                 io-channels = <&adc 0>; // First ADC channel
>>                 io-channel-names = "voltage";
>>         };
>>
>>         ncp15wb473@0 {
>>                 compatible = "ntc,ncp15wb473";
>>                 ...
>>                 io-channels = <&adc 1>; // Second ADC channel
>>                 io-channel-names = "voltage";
>>         }
>> };
>>
> Hello Lars,
> 
> I've a doubt here
> 
> How do i find the child dev_name for iio_map_array_register();
> 
> cause the child devices are probed during of_platform_populate();
> 
> and during the probe the child calls
> iio_channel_get(dev_name(&pdev->dev), "voltage");
> 
> The child device nodes are ncp15wb473.0 and ncp15wb473.1 in this case.
> But, this may change.


Hi,

I think we should handle the devicetree channel mapping in the IIO core and
not in the individual drivers. If we handle it in the core we do not need to
create a iio_map and won't need to know the name of the consumer.

You'd basically need to check whether the device requesting the IIO channel
has a of_node. If it has, check if it has an io-channels attribute. If it
also has an io-channels attribute lookup the IIO device by the phandle and
create a iio_channel for the nth channel of that device.

If either the device has no of_node or no io-channels attribute fallback to
using the iio_map based lookup method.

This would require one API change though, iio_channel_get would need to take
a device instead of the device name so it has access to both the device name
and the device node. Jonathan: any particular reason why you choose to let
iio_channel_get the device name instead of the device itself?

- Lars

> 
> Kindly, help.
> 
> Assume we have a device tree like this
> 
>         adc@12D10000 {
>                 #io-channel-cells = <1>;
>                 io-channel-output-names = "adc0", "adc1", "adc2",
>                                         "adc3", "adc4", "adc5",
>                                 "adc6", "adc7", "adc8", "adc9";
> 
>                 ncp15wb473@0 {
>                         compatible = "ntc,ncp15wb473";
>                         reg = <0x0>;
>                         io-channel-names = "voltage";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                 };
>                 ncp15wb473@1 {
>                         compatible = "ntc,ncp15wb473";
>                         reg = <0x1>;
>                         io-channel-names = "voltage";
>                         pullup-uV = <1800000>;
>                         pullup-ohm = <47000>;
>                         pulldown-ohm = <0>;
>                 };
> 
>       };
> 
> 
>> io-channel-output-names and io-channel-names can be optional. In the case
>> where there is only one channel it's not really necessary to use
>> io-channel-names.
>>

