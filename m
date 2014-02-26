Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaBZEwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 23:52:50 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15858 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaBZEws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 23:52:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Feb 2014 20:50:11 -0800
Message-ID: <530D731B.5050305@nvidia.com>
Date: Wed, 26 Feb 2014 13:52:43 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: add device tree for SHIELD
References: <1393237593-28121-1-git-send-email-acourbot@nvidia.com> <530B952D.2000006@wwwdotorg.org> <530BFC58.6020003@nvidia.com> <530C67F4.7010208@broadcom.com>
In-Reply-To: <530C67F4.7010208@broadcom.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 06:52 PM, Arend van Spriel wrote:
> On 02/25/2014 03:13 AM, Alexandre Courbot wrote:
>>>
>>>> +    /* Wifi */
>>>> +    sdhci@78000000 {
>>>> +        status = "okay";
>>>> +        bus-width = <4>;
>>>> +        broken-cd;
>>>> +        keep-power-in-suspend;
>>>> +        cap-sdio-irq;
>>>
>>> Is non-removable better than broken-cd, or are they entirely unrelated?
>>
>> They are unrelated actually. With non-removable the driver expects the
>> device to always be there since boot, and does not check for the card to
>> be removed/added after boot. broken-cd indicates there is no CD line and
>> the device should be polled regularly.
>>
>> For the Wifi chip, non-removable would be the correct setting
>> hardware-wise, but there is a trap: the chip has its reset line asserted
>> at boot-time, and you need to set GPIO 229 to de-assert it. Only after
>> that will the device be detected on the SDIO bus. Since it lacks a CD
>> line, it must be polled, hence the broken-cd property.
>>
>> This also raises another, redundant problem with DT bindings: AFAIK we
>> currently have no way to let the system know the device will only appear
>> after a given GPIO is set. It would also be nice to be able to give some
>> parameters to the Wifi driver through the DT (like the OOB interrupt).
>> Right now the Wifi chip is brought up by exporting the GPIO and writing
>> to it from user-space, and the OOB interrupt is not used.
>
> Hi Alexandre,
>
> I recently posted a proposal for brcmfmac DT binding [1]. I did receive
> some comments, but it would be great if you (and/or others involved) had
> a look at it as well and give me some feedback. DT work still needs to
> grow on me.

Hi Arend, (and thanks again for all the help with getting the chip to work!)

Great, I'm not subscribed to the devicetree list and so have missed this 
thread, but I'm glad to see it.

I don't think I have much to add to the comments you already received 
there. I'd need it to reference the 32K clock (which I currently 
force-enable manually), the OOB interrupt, and the reset pin as a GPIO 
(as for SHIELD the device needs to be put out of reset using an 
active-low GPIO before anything can happen). That last property could be 
optional as I suspect most designs won't use it.

Getting the device out of reset should be done before the bus probes the 
non-removable device, so I wonder how this would fit wrt. the DT 
power-on sequencing series by Olof. Something tells me this could rather 
be a property of the bus, but physically speaking the pin is connected 
to the wifi chip, so... Maybe we could get the platform driver to ask 
the bus to probe again after enabling power/getting the device out of reset?
