Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaCMKms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:42:48 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44667 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaCMKmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:42:44 -0400
Message-ID: <53218B9F.7030904@gmail.com>
Date: Thu, 13 Mar 2014 11:42:39 +0100
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
References: <1392059868-8782-1-git-send-email-arend@broadcom.com> <530D1E69.7010504@wwwdotorg.org> <53218565.6080605@broadcom.com>
In-Reply-To: <53218565.6080605@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arend,

On 13.03.2014 11:16, Arend van Spriel wrote:
> On 02/25/2014 11:51 PM, Stephen Warren wrote:
>> On 02/10/2014 12:17 PM, Arend van Spriel wrote:
>>> The Broadcom bcm43xx sdio devices are fullmac devices that may be
>>> integrated in ARM platforms. Currently, the brcmfmac driver for
>>> these devices support use of platform data. This patch specifies
>>> the bindings that allow this platform data to be expressed in the
>>> devicetree.
>>
>>> diff --git a/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/staging/net/wireless/brcm,bcm43xx-fmac.txt
>>
>>> + - compatible : Should be "brcm,bcm43xx-fmac".
>>> + - wlan-supply : phandle for fixed regulator used to control power for
>>> +	the device/module.
>>
>> Ignoring the fact that perhaps this should just be a GPIO instead and
>> assuming it actually make sense for this to be a regulator:
>>
>> Why "fixed regulator" not just "the regulator". There shouldn't be any
>> requirement for the power supply to the device to be fixed; the driver
>> should (a) set the voltage (which will be a no-op for a fixed regulator
>> already providing that voltage), then (b) enable the regulator. That
>> would allow a PMIC with programmable voltage to be feeding the device.
>>
>> Now, if this property was really intended to control some enable GPIO on
>> the device, as others have said, this shouldn't be a regulator property
>> but rather a GPIO property. However, there is definitely some power
>> supply fed to the device, so you definitely need /some/ supply property
>> here.
>>
>> Aren't there other enable GPIOs required? These should be specified in DT.
>>
>> Doesn't the WiFi chip/module require a (32KHz?) clock? If so, that needs
>> to be represented in DT. Preferably write the binding to require
>> clock-names (name-based lookup) rather than just clocks (index-based
>> lookup).
>
> Hi Stephen,
>
> Thanks for these comments. While I agree with most of them, I am having
> some difficulty with the DT concept. Essentially, a DT node describes a
> part of the system.

That's correct. A DT node represents a component of a system and its 
contents should contain all resources and other device-specific data 
required for this device to operate or optional.

> My scope for this change is probably limited wearing
> my brcmfmac glasses. Am I correct in assuming that a DT node may be
> processed/used by multiple drivers.

It may be, but it is usually not. The typical use case for such scheme 
is a bus-like topology, where devices on the bus are sub-nodes of the 
bus controller node and may contain some bus-specific information, such 
as chip select (e.g. SPI), address (e.g. I2C) or maximum bus speed.

> As an example, the 32 kHz clock is
> not something brcmfmac cares about. It simple needs to be available and
> hooked up to the wlan device.

Not really. The driver should care about any resources needed for the 
device to operate. In this case, a 32 kHz clock even if wired to the 
chip, sometimes is not operational until it gets ungated. This is not an 
artificial example, as on many boards I used to work with the 32 kHz 
clock was driven by a PMIC with clock gating control through I2C, gated 
by default.

Moreover, (well, 32 kHz might not be the best example) from power saving 
reasons, it might be a good idea to let the driver control the clock and 
gate it whenever it is not necessary.

> The DT should have another node for this
> clock which a (common) clock driver picks up. So having it referenced in
> this node is purely informational, right?

You are confusing here provider with consumer. The bcm43xx chip is 
clearly a consumer of a 32 kHz clock and so its DT node should specify this.

A DT node for a clock, would be a clock provider node and that would be 
handled by common clock framework in case of Linux indeed. A clock 
provider node doesn't have to be limited to a single clock, though. In 
the case I mentioned above, PMIC node would be a clock provider and PMIC 
driver would register necessary clocks in common clock framework.

Best regards,
Tomasz
