Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaKSRxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:53:38 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35832 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755120AbaKSRxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:53:36 -0500
Message-ID: <546CD90B.8060903@iki.fi>
Date: Wed, 19 Nov 2014 19:53:15 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:33.0) Gecko/20100101 SeaMonkey/2.30
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>, Pavel Machek <pavel@ucw.cz>
CC: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd> <20141117145857.GO8907@valkosipuli.retiisi.org.uk> <546AFEA5.9020000@samsung.com> <20141118084603.GC4059@amd> <546B19C8.2090008@samsung.com> <20141118113256.GA10022@amd> <546B40FA.2070409@samsung.com> <20141118132159.GA21089@amd> <546B6D86.8090701@samsung.com> <20141118165148.GA11711@amd> <546C66A5.6060201@samsung.com>
In-Reply-To: <546C66A5.6060201@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek and Pavel,

Jacek Anaszewski wrote:
> Hi Pavel, Sakari,
> 
> On 11/18/2014 05:51 PM, Pavel Machek wrote:
>> Hi!
>>
>>>> If the hardware LED changes with one that needs different current, the
>>>> block for the adp1653 stays the same, but white LED block should be
>>>> updated with different value.
>>>
>>> I think that you are talking about sub nodes. Indeed I am leaning
>>> towards this type of design.
>>
>> I think I am :-).
>>
>>>>> I agree that flash-timeout should be per led - an array, similarly
>>>>> as in case of iout's.
>>>>
>>>> Agreed about per-led, disagreed about the array. As all the fields
>>>> would need arrays, and as LED system currently does not use arrays for
>>>> label and linux,default-trigger, I believe we should follow existing
>>>> design and model it as three devices. (It _is_ physically three
>>>> devices.)
>>>
>>> Right, I missed that the leds/common.txt describes child node.
>>>
>>> I propose following modifications to the binding:
>>>
>>> Optional properties for child nodes:
>>> - iout-mode-led :     maximum intensity in microamperes of the LED
>>>               (torch LED for flash devices)
>>> - iout-mode-flash :     initial intensity in microamperes of the
>>>             flash LED; it is required to enable support
>>>             for the flash led
>>> - iout-mode-indicator : initial intensity in microamperes of the
>>>             indicator LED; it is required to enable support
>>>             for the indicator led
>>> - max-iout-mode-led :     maximum intensity in microamperes of the LED
>>>               (torch LED for flash devices)
>>> - max-iout-mode-flash : maximum intensity in microamperes of the
>>>             flash LED
>>> - max-iout-mode-indicator : maximum intensity in microamperes of the
>>>             indicator LED
>>> - flash-timeout :    timeout in microseconds after which flash
>>>             led is turned off
>>
>> Ok, I took a look, and "iout" is notation I understand, but people may
>> have trouble with and I don't see it used anywhere else.
>>
>> Also... do we need both "current" and "max-current" properties?
>>
>> But regulators already have "regulator-max-microamp" property. So what
>> about:
>>
>> max-microamp :     maximum intensity in microamperes of the LED
>>                 (torch LED for flash devices)
>> max-flash-microamp :     initial intensity in microamperes of the
>>               flash LED; it is required to enable support
>>               for the flash led
>> flash-timeout-microseconds : timeout in microseconds after which flash
>>               led is turned off
>>
>> If you had indicator on the same led, I guess
>>
>> indicator-microamp : recommended intensity in microamperes of the LED
>>                  for indication

The value for the indicator is maximum as well, not just a recommendation.

>>
>> ...would do?
> 
> 
> Ongoing discussion allowed me for taking a look at the indicator issue
> from different perspective. This is also vital for the issue of
> whether a v4l2-flash sub-device should be created per device or
> per sub-led [1].
> 
> Currently each sub-led is represented as a separate device tree
> sub node and the led drivers create separate LED class device for the
> sub nodes. What this implies is that indicator led also must be
> represented by the separate LED class device.
> 
> This is contrary to the way how V4L2 Flash API approaches this issue,
> as it considers a flash device as a regulator chip driven through
> a bus. The API allows to set the led in torch or flash mode and
> implicitly assumes that there can be additional indicator led
> supported, which can't be turned on separately, but the drivers apply
> the indicator current to the indicator led when the torch or flash led
> is activated.

The indicator is independent of the flash LED in V4L2 flash API. At
least that's how it should be, and in adp1653 the two are independent,
but the as3645a can't use indicator with the flash AFAIR.

> I propose to create separate v4l2-flash device for the indicator led,
> and treat it as a regular sub-led similarly like it is done in the
> LED subsystem. LED Flash class driver would only add a flag
> LED_DEV_CAP_INDICATOR and basing on it the v4l2-flash sub-device
> would create only V4L2_CID_FLASH_INDICATOR_INTENSITY control for it.
> There could ba also additional control added:
> V4L2_CID_FLASH_INDICATOR_PATTERN to support the feature
> supported by some LED class drivers.

Interesting idea.

The flash controller is still a single I2C device with common set of
faults, for instance. Some devices refuse to work again in case of
faults until they are cleared (= read).

Could the indicator pattern control be present in the same sub-device?

Are there any flash LED controllers that support such functionality?

> From the media device perspective such an approach would
> be harmful, as the indicator led could be turned on right
> before strobing the flash or turning the torch on, by
> separate calls to different v4l2-flash sub-devices.
> 
> The design described above would allow for avoiding issues I touched
> in the message [1].

Let me reply this separately. Feel free to ping me if I obviously appear
to miss something.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
